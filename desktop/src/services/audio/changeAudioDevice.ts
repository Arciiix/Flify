const { ipcRenderer } = require("electron");

export default async function changeAudioDevice(
  deviceId: number
): Promise<void> {
  await ipcRenderer.invoke("audio/change", deviceId);
}
