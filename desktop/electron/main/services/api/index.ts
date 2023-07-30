import { ipcMain } from "electron";
import changeAudioDevice from "./audio/changeAudioDevice";
import getAllAudioDevices from "./audio/getAllAudioDevices";
import getAudioVolume from "./audio/getAudioVolume";
import setAudioVolume from "./audio/setAudioVolume";
import changeDeviceVolume from "./device/changeDeviceVolume";
import getNetworkInfo from "./network/getNetworkInfo";
import getQRCodeText from "./network/getQRCodeText";
import nextTrack from "./playback/nextTrack";
import previousTrack from "./playback/previousTrack";
import togglePlayback from "./playback/togglePlayback";
import disconnectSocket from "./socket/disconnect";
import reconnectSockets from "./socket/reconnectSockets";

export default function handleInternalAPI() {
  ipcMain.handle("network/info", getNetworkInfo);
  ipcMain.handle("qrcode/raw", getQRCodeText);
  ipcMain.handle("device/disconnect", disconnectSocket);
  ipcMain.handle("device/reconnectAll", reconnectSockets);
  ipcMain.handle("audio/all", getAllAudioDevices);
  ipcMain.handle("audio/change", changeAudioDevice);
  ipcMain.handle("audio/getVolume", getAudioVolume);
  ipcMain.handle("audio/setVolume", setAudioVolume);
  ipcMain.handle("device/volumeChange", changeDeviceVolume);
  ipcMain.handle("playback/toggle", togglePlayback);
  ipcMain.handle("playback/previous", previousTrack);
  ipcMain.handle("playback/next", nextTrack);
}
