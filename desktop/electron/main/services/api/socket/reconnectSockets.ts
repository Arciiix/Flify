import { IpcMainInvokeEvent } from "electron";
import { connectedSockets } from "../../socket/events";

export default function reconnectSockets(_: IpcMainInvokeEvent) {
  // Reconnect all sockets to reduce latency etc.
  connectedSockets.forEach((socket) => socket.socket?.emit("reconnect"));
}
