const { ipcRenderer } = require("electron");

export async function changeVolume(
  deviceId: string,
  volumePercent: number
): Promise<void> {
  await ipcRenderer.invoke("device/volumeChange", deviceId, volumePercent);
}
