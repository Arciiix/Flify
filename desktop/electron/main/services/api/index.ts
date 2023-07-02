import { ipcMain } from "electron";
import getNetworkInfo from "./network/getNetworkInfo";
import getQRCodeText from "./network/getQRCodeText";
import disconnectSocket from "./socket/disconnect";

export default function handleInternalAPI() {
  ipcMain.handle("network/info", getNetworkInfo);
  ipcMain.handle("qrcode/raw", getQRCodeText);
  ipcMain.handle("device/disconnect", disconnectSocket);
}
