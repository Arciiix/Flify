const { ipcRenderer } = require("electron");

export default async function getAudioVolume(): Promise<number> {
  return (await ipcRenderer.invoke("audio/getVolume")) satisfies number;
}
