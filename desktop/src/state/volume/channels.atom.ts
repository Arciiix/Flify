import { atom } from "recoil";
import { ChannelsVolume } from "types/volume.types";

export const channelsVolume = atom<ChannelsVolume>({
  key: "channelsVolume",
  default: {
    leftChannel: 0,
    rightChannel: 0,
  } satisfies ChannelsVolume,
});
