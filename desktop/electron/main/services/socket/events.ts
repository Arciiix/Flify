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
import { CurrentVolumeState } from "types/audio.types";
import setAudioVolume from "../api/audio/setAudioVolume";
import getAudioVolume from "../api/audio/getAudioVolume";
import togglePlayback from "../api/playback/togglePlayback";
import previousTrack from "../api/playback/previousTrack";
import nextTrack from "../api/playback/nextTrack";
import { join } from "path";

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
      icon: join(process.env.PUBLIC, "icons", "android-chrome-192x192.png"),
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

    // Send the current volume
    getAudioVolume();

    // If there's an audio session, send init event
    if (session) {
      socket.emit("init", session);
    }
  });

  socket.on("change_host_volume", (newVolume: CurrentVolumeState) => {
    setAudioVolume(null, newVolume);
  });

  socket.on("playback_toggle", togglePlayback);
  socket.on("playback_previous", previousTrack);
  socket.on("playback_next", nextTrack);

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
      volume: volume,
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
      icon: join(process.env.PUBLIC, "icons", "android-chrome-192x192.png"),
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
