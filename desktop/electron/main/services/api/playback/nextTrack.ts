import { keyTap } from "robotjs";

export default function nextTrack(event: Electron.IpcMainInvokeEvent) {
  keyTap("audio_next");
}
