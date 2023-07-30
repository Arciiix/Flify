const { ipcRenderer } = require("electron");

export default async function nextTrack() {
  await ipcRenderer.invoke("playback/next");
}
