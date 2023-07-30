import { keyTap } from "robotjs";

export default function previousTrack(event: Electron.IpcMainInvokeEvent) {
  keyTap("audio_prev");
}
