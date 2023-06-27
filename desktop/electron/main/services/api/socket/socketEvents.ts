import { Client } from "types/socket.types";

import { win } from "../../../index";

export function updateSocketList(sockets: Client[]) {
  sockets = sockets.map(({ socket, ...data }) => data); // Remove the "socket" property from the object
  win!.webContents.send("socket/list", sockets);
}
