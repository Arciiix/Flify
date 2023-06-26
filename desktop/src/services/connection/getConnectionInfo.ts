import { NetworkInfo } from "types/network.types";
const { ipcRenderer } = require("electron");

export async function getConnectionInfo(): Promise<NetworkInfo> {
  const info: NetworkInfo = await ipcRenderer.invoke("network/info");
  return info;
}
