import { Socket } from "socket.io";
import { Client, Metadata, WorldPayload } from "../../../../types/socket.types";
import { updateSocketList } from "../api/socket/socketEvents";
import { getHostname } from "../network/getNetworkData";

export let connectedSockets: Client[] = [];

export default function handleSocketConnection(socket: Socket) {
  console.log(
    `New socket with id ${socket.id} connected, waiting for init event...`
  );

  socket.on("hello", (metadata: Metadata) => {
    console.log(`Init event received from socket ${socket.id}!`);
    connectedSockets.push({ socket, socketId: socket.id, metadata: metadata });
    updateSocketList(connectedSockets);

    const hostname = getHostname();
    socket.emit("world", {
      hostname,
    } satisfies WorldPayload); // Reply event to the "hello" initial event
  });

  socket.on("disconnect", () => {
    console.log(`Socket ${socket.id} disconnected!`);

    // Remove the socket from connected sockets
    connectedSockets = connectedSockets.filter((e) => e.socketId !== socket.id);
    updateSocketList(connectedSockets);
  });
}
