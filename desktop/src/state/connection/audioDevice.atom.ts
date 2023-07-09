import { atom } from "recoil";
import { AudioDevice } from "types/audio.types";

export const audioDevice = atom<AudioDevice | null>({
  key: "audioDevice",
  default: null,
});
