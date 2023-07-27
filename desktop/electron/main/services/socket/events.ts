import { Socket } from "socket.io";
import {
  Client,
  DataHeartbeat,
  Metadata,
  WorldPayload,
} from "../../../../types/socket.types";
import { updateSocketList } from "../api/socket/socketEvents";
import { getHostname } from "../network/getNetworkData";
import { session, startWithDefault, stopPortaudio } from "../audio/audio";
import { updateCurrentState } from "../api/device/updateCurrentState";
import { Notification } from "electron";

export let connectedSockets: Client[] = [];

export const MAX_SOCKET_DEAD_TIME = 30_000; // 30 seconds

export default function handleSocketConnection(socket: Socket) {
  // If the device doesn't send the heartbeat in a long while, disconnect it
  let heartbeatDisconnectTimeout: ReturnType<typeof setTimeout> | null = null;

  const createDisconnectTimeout = () => {
    if (heartbeatDisconnectTimeout) clearTimeout(heartbeatDisconnectTimeout);

    heartbeatDisconnectTimeout = setTimeout(() => {
      socket.disconnect();
    }, MAX_SOCKET_DEAD_TIME);
  };
  createDisconnectTimeout();

  console.log(
    `New socket with id ${socket.id} connected, waiting for init event...`
  );

  socket.on("hello", (metadata: Metadata) => {
    console.log(`Init event received from socket ${socket.id}!`);

    new Notification({
      title: "Device connected",
      body: `The device ${metadata.deviceName} has connected!`,
    }).show();

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

    // If there's an audio session, send init event
    if (session) {
      socket.emit("init", session);
    }
  });

  socket.on("data_heartbeat", (dataHeartbeat: DataHeartbeat) => {
    // Used to measure the latency and whether the device is still connected
    console.log("heartbeat", dataHeartbeat);
    const ping =
      new Date().getTime() -
      new Date(
        dataHeartbeat?.initialDataTimestamp ??
          dataHeartbeat?.timestamp ??
          new Date()
      )?.getTime();
    updateCurrentState(socket.id, {
      ping,
    });

    createDisconnectTimeout();
  });

  socket.on("update_volume", (volume: number) => {
    updateCurrentState(socket.id, {
      volume: Math.round(volume * 100),
    });
  });
  socket.on("update_battery", (batteryLevel: number) => {
    updateCurrentState(socket.id, {
      batteryLevel,
    });
  });

  socket.on("disconnect", () => {
    console.log(`Socket ${socket.id} disconnected!`);

    const client = connectedSockets.find((e) => e.socketId === socket.id);
    new Notification({
      title: "Device disconnected",
      body: `The device ${client?.metadata.deviceName} has disconnected!`,
    }).show();

    // Remove the socket from connected sockets
    connectedSockets = connectedSockets.filter((e) => e.socketId !== socket.id);

    if (!connectedSockets.length) {
      // If every socket disconnected, destroy the stream
      stopPortaudio();
    }
    updateSocketList(connectedSockets);
  });
}
