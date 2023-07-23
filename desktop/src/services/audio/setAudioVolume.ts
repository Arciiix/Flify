import { CurrentVolumeState } from "types/audio.types";

const { ipcRenderer } = require("electron");

export default async function setAudioVolume(
  newState: CurrentVolumeState
): Promise<CurrentVolumeState> {
  return (await ipcRenderer.invoke(
    "audio/setVolume",
    newState
  )) satisfies CurrentVolumeState;
}
