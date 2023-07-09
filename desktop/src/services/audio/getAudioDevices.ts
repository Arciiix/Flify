import { AudioDevice } from "types/audio.types";

const { ipcRenderer } = require("electron");

export default async function getAudioDevices(): Promise<AudioDevice[]> {
  return (await ipcRenderer.invoke("audio/all")) satisfies AudioDevice[];
}
