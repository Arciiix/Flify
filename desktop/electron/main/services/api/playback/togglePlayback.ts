import { keyTap } from "robotjs";

export default function togglePlayback(event: Electron.IpcMainInvokeEvent) {
  keyTap("audio_pause");
}
