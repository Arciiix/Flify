import { getVolume, setMute, setVolume } from "easy-volume";
import { win } from "../../../index";
import { CurrentVolumeState } from "types/audio.types";

export default async function setAudioVolume(
  event: Electron.IpcMainInvokeEvent,
  newVolume: CurrentVolumeState
): Promise<CurrentVolumeState> {
  // TODO: Add error handling
  await setVolume(newVolume.volume);
  await setMute(newVolume.isMuted);

  win!.webContents.send("audio/volumeUpdate", newVolume);
  return newVolume;
}
