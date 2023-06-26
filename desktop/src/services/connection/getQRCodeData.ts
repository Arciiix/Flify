const { ipcRenderer } = require("electron");

export async function getQRCodeData(): Promise<string> {
  const raw: string = await ipcRenderer.invoke("qrcode/raw");
  return raw;
}
