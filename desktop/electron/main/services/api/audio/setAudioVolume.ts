import { getVolume, setMute, setVolume } from "easy-volume";
import { win } from "../../../index";
import { CurrentVolumeState } from "types/audio.types";
import { dialog } from "electron";
import getAudioVolume from "./getAudioVolume";

export default async function setAudioVolume(
  event: Electron.IpcMainInvokeEvent | null,
  newVolume: CurrentVolumeState
): Promise<CurrentVolumeState | null> {
  try {
    await setVolume(newVolume.volume);
    await setMute(newVolume.isMuted);

    win!.webContents.send("audio/volumeUpdate", newVolume);

    getAudioVolume(); // Also send the update message to the sockets

    return newVolume;
  } catch (err) {
    dialog.showMessageBox(win!, {
      type: "error",
      title: "Flify",
      message: "Couldn't set volume. Oh no!",
    });
    return null;
  }
}
