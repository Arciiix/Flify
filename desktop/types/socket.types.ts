import { Socket } from "socket.io";
import { OperatingSystem } from "./os.types";

export interface Client {
  socketId: string;
  socket?: Socket;
  metadata: Metadata;
  state?: DeviceState;
}

export interface DeviceState {
  batteryLevel: number;
  ping: number;
}

export interface Metadata {
  selfIp?: string;
  deviceName: string;
  os: OperatingSystem;
}

export interface WorldPayload {
  hostname: string;
}

export interface DataHeartbeat {
  initialDataTimestamp: Date | null;
  timestamp: Date | null;
}
