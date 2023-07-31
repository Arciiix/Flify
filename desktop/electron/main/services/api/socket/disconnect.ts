import { IpcMainInvokeEvent } from "electron";
import { connectedSockets } from "../../socket/events";

export type DisconnectSocketParams = { socketId: string };

export default function disconnectSocket(
  _: IpcMainInvokeEvent,
  { socketId }: DisconnectSocketParams
): boolean {
  let potentialSocket = connectedSockets.find((e) => e.socketId === socketId);

  potentialSocket?.socket?.emit("you_will_disconnect");
  setTimeout(() => {
    potentialSocket?.socket?.disconnect();
  }, 1000);

  return !!potentialSocket; // Returns true if socket was found, otherwise false
}
