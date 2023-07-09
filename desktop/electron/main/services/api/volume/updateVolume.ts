import { ChannelsVolume } from "types/volume.types";

import { win } from "../../../index";
import { io } from "../../socket";

export function updateChannelsVolume(data: ChannelsVolume) {
  win!.webContents.send("channels/volume", data);

  io.volatile.emit("channels_volume", data);
}
