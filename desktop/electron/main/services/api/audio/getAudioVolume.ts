import { getMute, getVolume } from "easy-volume";
import { win } from "../../../index";
import { CurrentVolumeState } from "types/audio.types";

export default async function getAudioVolume(): Promise<CurrentVolumeState> {
  // TODO: Add error handling
  const volume = await getVolume();
  const muteStatus = await getMute();

  const newState = {
    volume,
    isMuted: muteStatus,
  } satisfies CurrentVolumeState;

  win!.webContents.send("audio/volumeUpdate", newState);

  return newState;
}
