const { ipcRenderer } = require("electron");

export default async function reconnectDevices() {
  await ipcRenderer.invoke("device/reconnectAll");
}
