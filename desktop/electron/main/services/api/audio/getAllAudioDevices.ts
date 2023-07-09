import { AudioDevice } from "types/audio.types";

import portAudio from "naudiodon";

export default function getAllAudioDevices(): AudioDevice[] {
  return portAudio.getDevices().filter((e) => e.maxInputChannels > 0);
}
