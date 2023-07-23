import { atom } from "recoil";
import { CurrentVolumeState } from "types/audio.types";

export const currentVolume = atom<CurrentVolumeState | null>({
  key: "currentVolume",
  default: null,
});
