import { ipcMain } from "electron";
import getNetworkInfo from "./network/getNetworkInfo";

export default function handleInternalAPI() {
  ipcMain.handle("network/info", getNetworkInfo);
}
