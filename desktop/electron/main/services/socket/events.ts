import { Socket } from "socket.io";
import { Client, Metadata } from "../../../../types/socket.types";
import { updateSocketList } from "../api/socket/socketEvents";

export let connectedSockets: Client[] = [];

export default function handleSocketConnection(socket: Socket) {
  console.log(
    `New socket with id ${socket.id} connected, waiting for init event...`
  );

  socket.on("hello", (metadata: Metadata) => {
    console.log(`Init event received from socket ${socket.id}!`);
    connectedSockets.push({ socket, socketId: socket.id, metadata: metadata });
    socket.emit("world"); // Reply event to the "hello" initial event

    updateSocketList(connectedSockets);
  });

  socket.on("disconect", () => {
    console.log(`Socket ${socket.id} disconnected!`);

    // Remove the socket from connected sockets
    connectedSockets = connectedSockets.filter((e) => e.socketId !== socket.id);
    updateSocketList(connectedSockets);
  });
}
