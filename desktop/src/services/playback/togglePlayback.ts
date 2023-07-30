const { ipcRenderer } = require("electron");

export default async function togglePlayback() {
  await ipcRenderer.invoke("playback/toggle");
}
