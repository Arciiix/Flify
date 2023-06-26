import os from "os";
import { address } from "ip";

export function getHostname(): string {
  return os.hostname();
}

export default function getNetworkIP(): string {
  const ipAddress = address();
  return ipAddress;
}
