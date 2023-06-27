import { Socket } from "socket.io";

export interface Client {
  socketId: string;
  socket?: Socket;
  metadata: Metadata;
}

export interface Metadata {
  selfIp?: string;
  deviceName: string;
}

export interface WorldPayload {
  hostname: string;
}
