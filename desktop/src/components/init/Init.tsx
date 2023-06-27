import LoadingPage from "@/pages/Loading/LoadingPage";
import { getConnectionInfo } from "@/services/connection/getConnectionInfo";
import { connection } from "@/state/connection/connection.atom";
import { sockets } from "@/state/connection/sockets.atom";
import { useEffect, useState } from "react";
import { useRecoilState } from "recoil";
import { Client } from "types/socket.types";
const { ipcRenderer } = require("electron");

interface InitProps {
  children: JSX.Element | JSX.Element[];
}
export default function Init({ children }: InitProps) {
  const [isLoading, setIsLoading] = useState(true);
  const [connectionInfo, setConnectionInfo] = useRecoilState(connection);
  const [socketList, setSocketList] = useRecoilState(sockets);

  const initApp = async () => {
    const info = await getConnectionInfo();
    setConnectionInfo(info);

    console.log(info);

    ipcRenderer.on("socket/list", (_, newSocketList: Client[]) => {
      console.log("Socket list updated!", newSocketList);
      setSocketList(newSocketList);
    });
  };

  useEffect(() => {
    Promise.all([initApp()]).then(() => setIsLoading(false));
  }, []);
  return isLoading ? <LoadingPage /> : children;
}
