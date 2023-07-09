import { initPortaudio, stopPortaudio } from "../../audio/audio";

export default async function changeAudioDevice(
  event: Electron.IpcMainInvokeEvent,
  deviceId: number
) {
  await stopPortaudio();
  await initPortaudio(deviceId);
}
