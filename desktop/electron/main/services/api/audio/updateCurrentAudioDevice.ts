import { AudioDevice } from "types/audio.types";
import { win } from "../../../index";
import { io } from "../../socket";

export function updateCurrentAudioDevice(data: AudioDevice | null) {
  win!.webContents.send("audio/device", data);

  io.volatile.emit("audio_device", data);
}
