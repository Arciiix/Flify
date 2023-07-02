const { ipcRenderer } = require("electron");

export default async function disconnectDevice(socketId: string) {
  await ipcRenderer.invoke("device/disconnect", { socketId });
}
