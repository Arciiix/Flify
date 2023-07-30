const { ipcRenderer } = require("electron");

export default async function previousTrack() {
  await ipcRenderer.invoke("playback/previous");
}
