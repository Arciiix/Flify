import { atom } from "recoil";
import { NetworkInfo } from "types/network.types";

export const connection = atom<NetworkInfo | null>({
  key: "connection",
  default: null,
});
