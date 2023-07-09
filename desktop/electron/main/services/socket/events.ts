import { Socket } from "socket.io";
import {
  Client,
  DataHeartbeat,
  Metadata,
  WorldPayload,
} from "../../../../types/socket.types";
import { updateSocketList } from "../api/socket/socketEvents";
import { getHostname } from "../network/getNetworkData";
import { startWithDefault, stopPortaudio } from "../audio/audio";

export let connectedSockets: Client[] = [];

export default function handleSocketConnection(socket: Socket) {
  console.log(
    `New socket with id ${socket.id} connected, waiting for init event...`
  );

  socket.on("hello", (metadata: Metadata) => {
    console.log(`Init event received from socket ${socket.id}!`);
    if (!connectedSockets.length) {
      // If it's the first socket, then init the connection
      startWithDefault();
    }
    connectedSockets.push({ socket, socketId: socket.id, metadata: metadata });
    updateSocketList(connectedSockets);

    const hostname = getHostname();
    socket.emit("world", {
      hostname,
    } satisfies WorldPayload); // Reply event to the "hello" initial event
  });

  socket.on("data_heartbeat", (dataHeartbeat: DataHeartbeat) => {
    console.log("heartbeat", dataHeartbeat);
  });

  socket.on("disconnect", () => {
    console.log(`Socket ${socket.id} disconnected!`);

    // Remove the socket from connected sockets
    connectedSockets = connectedSockets.filter((e) => e.socketId !== socket.id);

    if (!connectedSockets.length) {
      // If every socket disconnected, destroy the stream
      stopPortaudio();
    }
    updateSocketList(connectedSockets);
  });
}
