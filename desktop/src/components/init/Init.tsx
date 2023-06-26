import LoadingPage from "@/pages/Loading/LoadingPage";
import { getConnectionInfo } from "@/services/connection/getConnectionInfo";
import { connection } from "@/state/connection/connection.atom";
import { useEffect, useState } from "react";
import { useRecoilState } from "recoil";

interface InitProps {
  children: JSX.Element | JSX.Element[];
}
export default function Init({ children }: InitProps) {
  const [isLoading, setIsLoading] = useState(true);
  const [connectionInfo, setConnectionInfo] = useRecoilState(connection);

  const initApp = async () => {
    const info = await getConnectionInfo();
    setConnectionInfo(info);

    console.log(info);
  };

  useEffect(() => {
    Promise.all([initApp()]).then(() => setIsLoading(false));
  }, []);
  return isLoading ? <LoadingPage /> : children;
}
