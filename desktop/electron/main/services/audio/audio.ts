import portAudio, { DeviceInfo } from "naudiodon";
import { io } from "../socket";
import cuid from "cuid";
import { updateChannelsVolume } from "../api/volume/updateVolume";

export type Session = {
  id: string;
  params: AudioParams;
  selectedAudioDevice: AudioDevice;
};
export type AudioDevice = DeviceInfo;

export type AudioParams = {
  channelCount: number;
  sampleRate: number;
};

export type AudioPayload = {
  d: any; // Data
  i: string; // Id
  t: Date; // Timestamp
};

export let ai: portAudio.IoStreamRead | null = null;
export let session: Session | null = null;
export let MAX_VOLUME_RECORDED = 1;

function calculateVolume(samples: Int16Array) {
  let sumOfSquares = 0;
  for (let i = 0; i < samples.length; i++) {
    sumOfSquares += Math.pow(samples[i], 2);
  }
  const meanSquare = sumOfSquares / samples.length;
  const rms = Math.sqrt(meanSquare);

  // Get the maximum possible value for the sample format
  //   const sampleFormatMaxValue = Math.pow(2, 16) - 1; // Assuming 16-bit sample format

  // Normalize the volume range to 0-1
  //   const volume = rms / sampleFormatMaxValue;

  //   return volume;

  return rms;
}

async function processData(data: any) {
  // Volume per channel
  const bytesPerSample = 2; // 16-bit PCM
  const samplesPerChannel = data.length / bytesPerSample / 2; // 2 channels (stereo)
  const leftChannel = new Int16Array(samplesPerChannel);
  const rightChannel = new Int16Array(samplesPerChannel);

  for (let i = 0; i < samplesPerChannel; i++) {
    const offset = i * bytesPerSample * 2;
    leftChannel[i] = data.readInt16LE(offset);
    rightChannel[i] = data.readInt16LE(offset + bytesPerSample);
  }

  const leftChannelVolume = calculateVolume(leftChannel);
  const rightChannelVolume = calculateVolume(rightChannel);

  // Update the max volume recorded if needed
  MAX_VOLUME_RECORDED = Math.max(
    MAX_VOLUME_RECORDED,
    leftChannelVolume,
    rightChannelVolume
  );

  updateChannelsVolume({
    // It should be in percentages, so it's the fraction of the highest volume recorded
    leftChannel: leftChannelVolume / MAX_VOLUME_RECORDED,
    rightChannel: rightChannelVolume / MAX_VOLUME_RECORDED,
  });
}

export async function initPortaudio(deviceId: number) {
  if (ai || session) {
    console.log("Tried to start a session when there's existing one");
    return;
  }
  const device = portAudio.getDevices().find((e) => e.id === deviceId);

  if (!device) {
    console.error("Device not found on init, using default...");
  }

  ai = portAudio.AudioIO({
    inOptions: {
      channelCount: device!.maxInputChannels,
      sampleFormat: portAudio.SampleFormat16Bit,
      sampleRate: device!.defaultSampleRate,
      deviceId: deviceId ?? -1,
      closeOnError: false, // Close the stream if an audio error is detected, if set false then just log the error
    },
  });

  // Create a unique id that will represent the given params (sample rate etc.), so that we don't have to send it in every request
  session = {
    id: cuid(),
    params: {
      channelCount: device!.maxInputChannels,
      sampleRate: device!.defaultSampleRate,
    },
    selectedAudioDevice: device!,
  };

  io.emit("init", session);

  ai.on("data", (data) => {
    // Volatile = something like UDP (non-blocking)
    io.volatile.emit("data", {
      d: data,
      i: session!.id,
      t: new Date(),
    } satisfies AudioPayload);

    // Asynchronously process the chunk of data
    processData(data);
  });

  ai.start();
}

export function stopPortaudio() {
  if (!ai || !session) {
    console.log("Tried to stop a session that doesn't exist");
    return;
  }

  io.emit("stop", session);
  ai.quit();

  session = null;
  ai = null;
}

export function startWithDefault() {
  if (ai || session) {
    console.log("Tried to start a session when there's existing one");
    return;
  }
  // Default device is loopback - stereo mix
  // To make it universal for different languages, its name usually consists of the word "stereo"
  let loopback = portAudio
    .getDevices()
    .find((e) => e.name.toLowerCase().includes("stereo"));

  // If didn't find, just use the default audio device
  return initPortaudio(loopback?.id ?? -1);
}

// From time to time, clear the max volume so that the app can adjust
setInterval(
  () => {
    MAX_VOLUME_RECORDED = 1;
  },
  10 * 1000 // 10 seconds
);
