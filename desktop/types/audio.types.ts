import { DeviceInfo } from "naudiodon";

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
