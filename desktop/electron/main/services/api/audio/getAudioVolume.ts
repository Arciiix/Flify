import { getMute, getVolume } from "easy-volume";
import { win } from "../../../index";
import { CurrentVolumeState } from "types/audio.types";
import { dialog } from "electron";
import { connectedSockets } from "../../socket/events";

let alreadyShowedWarning = false;

export default async function getAudioVolume(): Promise<CurrentVolumeState | null> {
  try {
    const volume = await getVolume();
    const muteStatus = await getMute();

    const newState = {
      volume,
      isMuted: muteStatus,
    } satisfies CurrentVolumeState;

    win!.webContents.send("audio/volumeUpdate", newState);

    // Also send update to all sockets
    connectedSockets.forEach((e) =>
      e.socket?.emit("host_volume_update", newState)
    );

    return newState;
  } catch (err) {
    if (!alreadyShowedWarning) {
      dialog.showMessageBox(win!, {
        type: "error",
        title: "Flify",
        message:
          "Oh no! Couldn't get current volume. Those warnings won't appear anymore so that you can use the app, just without the control of the host volume.",
      });
      alreadyShowedWarning = true;
    }
    return null;
  }
}
