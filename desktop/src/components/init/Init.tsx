import { getConnectionInfo } from "@/services/connection/getConnectionInfo";
import { connection } from "@/state/connection/connection.atom";
import React, { useEffect } from "react";
import { useRecoilState } from "recoil";

interface InitProps {
  children: JSX.Element | JSX.Element[];
}
export default function Init({ children }: InitProps) {
  const [connectionInfo, setConnectionInfo] = useRecoilState(connection);

  const initApp = async () => {
    const info = await getConnectionInfo();
    setConnectionInfo(info);

    console.log(info);
  };

  useEffect(() => {
    initApp();
  }, []);
  return children;
}
