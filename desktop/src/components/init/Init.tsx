import LoadingPage from "@/pages/Loading/LoadingPage";
import { getConnectionInfo } from "@/services/connection/getConnectionInfo";
import { audioDevice } from "@/state/connection/audioDevice.atom";
import { connection } from "@/state/connection/connection.atom";
import { sockets } from "@/state/connection/sockets.atom";
import { useEffect, useState } from "react";
import { useRecoilState } from "recoil";
import { AudioDevice } from "types/audio.types";
import { Client, DeviceState } from "types/socket.types";
const { ipcRenderer } = require("electron");

interface InitProps {
  children: JSX.Element | JSX.Element[];
}
export default function Init({ children }: InitProps) {
  const [isLoading, setIsLoading] = useState(true);
  const [connectionInfo, setConnectionInfo] = useRecoilState(connection);
  const [socketList, setSocketList] = useRecoilState(sockets);
  const [currentAudioDevice, setCurrentAudioDevice] =
    useRecoilState(audioDevice);

  const initApp = async () => {
    const info = await getConnectionInfo();
    setConnectionInfo(info);

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
  };

  useEffect(() => {
    Promise.all([initApp()]).then(() => setIsLoading(false));
  }, []);
  return isLoading ? <LoadingPage /> : children;
}
