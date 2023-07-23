import LoadingPage from "@/pages/Loading/LoadingPage";
import getAudioVolume from "@/services/audio/getAudioVolume";
import { getConnectionInfo } from "@/services/connection/getConnectionInfo";
import { currentVolume } from "@/state/audio/currentVolume.atom";
import { audioDevice } from "@/state/connection/audioDevice.atom";
import { connection } from "@/state/connection/connection.atom";
import { sockets } from "@/state/connection/sockets.atom";

import { useEffect, useState } from "react";
import { useSetRecoilState } from "recoil";
import { AudioDevice, CurrentVolumeState } from "types/audio.types";
import { Client } from "types/socket.types";
const { ipcRenderer } = require("electron");

interface InitProps {
  children: JSX.Element | JSX.Element[];
}
export default function Init({ children }: InitProps) {
  const [isLoading, setIsLoading] = useState(true);
  const setConnectionInfo = useSetRecoilState(connection);
  const setSocketList = useSetRecoilState(sockets);
  const setCurrentAudioDevice = useSetRecoilState(audioDevice);
  const setCurrentVolume = useSetRecoilState(currentVolume);

  const initApp = async () => {
    const info = await getConnectionInfo();
    setConnectionInfo(info);

    // The response will be sent as audio/volumeUpdate
    getAudioVolume();

    console.log(info);

    ipcRenderer.on("socket/list", (_, newSocketList: Client[]) => {
      console.log("Socket list updated!", newSocketList);
      setSocketList(newSocketList);
    });

    ipcRenderer.on("audio/device", (_, newDevice: AudioDevice | null) => {
      console.log("Audio device updated!", newDevice);
      setCurrentAudioDevice(newDevice);
    });

    ipcRenderer.on("device/update", (_, data: Client) => {
      setSocketList((prev) => {
        if (!prev) return prev;

        console.log(`Updated state for ${data.socketId}!`, data);
        return prev.map((element) =>
          element.socketId === data.socketId ? data : element
        ); // If the current element is the updated one, return the updated one. Instead return the old one
      });
    });

    ipcRenderer.on("audio/volumeUpdate", (_, volume: CurrentVolumeState) => {
      console.log(`Volume update: ${volume.volume} (muted: ${volume.isMuted})`);
      setCurrentVolume(volume);
    });
  };

  useEffect(() => {
    Promise.all([initApp()]).then(() => setIsLoading(false));

    // In case user changes the volume by pressing keyboard keys, make sure to update the volume value on front-end
    const updateVolume = (event: KeyboardEvent) => {
      // Any keys related to the volume, e.g. AudioVolumeUp and AudioVolumeDown
      if (event.key.toLocaleLowerCase().includes("audiovolume")) {
        getAudioVolume();
      }
    };

    document.addEventListener("keyup", updateVolume);

    return () => {
      document.removeEventListener("keyup", updateVolume);
    };
  }, []);
  return isLoading ? <LoadingPage /> : children;
}
