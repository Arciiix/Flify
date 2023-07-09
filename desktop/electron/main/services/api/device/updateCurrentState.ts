import { DeviceState, DeviceStateUpdate } from "types/socket.types";
import { connectedSockets } from "../../socket/events";
import { win } from "../../../index";
export function updateCurrentState(
  socketId: string,
  newState: DeviceStateUpdate
): DeviceState {
  const device = connectedSockets.find((e) => e.socketId === socketId);
  if (!device) {
    console.log(`Didn't find device ${socketId} when updating state!`);
  }

  device!.state = { ...device!.state, ...(newState as DeviceState) };

  // Send updated device with the 'socket' property
  const { socket, ...updatedDevice } = device!;
  win!.webContents.send("device/update", updatedDevice);
  return device!.state;
}
