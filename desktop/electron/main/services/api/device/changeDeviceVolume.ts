import { connectedSockets } from "../../socket/events";

export default function changeDeviceVolume(
  event: Electron.IpcMainInvokeEvent,
  deviceId: string,
  volume: number
) {
  const device = connectedSockets.find((e) => e.socketId === deviceId);
  if (!device) {
    console.log(
      `Tried to change device volume but there's no device with id ${deviceId}`
    );
    return;
  }
  console.log(`Change device ${deviceId} volume to ${volume}`);
  device.socket!.emit("change_volume", Math.round(volume));
}
