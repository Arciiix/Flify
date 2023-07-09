import { ipcMain } from "electron";
import getNetworkInfo from "./network/getNetworkInfo";
import getQRCodeText from "./network/getQRCodeText";
import disconnectSocket from "./socket/disconnect";
import getAllAudioDevices from "./audio/getAllAudioDevices";
import changeAudioDevice from "./audio/changeAudioDevice";
import changeDeviceVolume from "./device/changeDeviceVolume";

export default function handleInternalAPI() {
  ipcMain.handle("network/info", getNetworkInfo);
  ipcMain.handle("qrcode/raw", getQRCodeText);
  ipcMain.handle("device/disconnect", disconnectSocket);
  ipcMain.handle("audio/all", getAllAudioDevices);
  ipcMain.handle("audio/change", changeAudioDevice);
  ipcMain.handle("device/volumeChange", changeDeviceVolume);
}
