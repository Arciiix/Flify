import HostInfo from "@/components/info/HostInfo/HostInfo";
import Logo from "@/components/ui/Logo/Logo";
import { sockets } from "@/state/connection/sockets.atom";
import React, { useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { useRecoilValue } from "recoil";

export default function AppPage() {
  const navigate = useNavigate();

  const deviceList = useRecoilValue(sockets);

  useEffect(() => {
    // If every device disconnected
    if (!deviceList.length) {
      // TODO: Display a toast or something like that indicating that every device has disconnected
      navigate("/");
    }
  }, [deviceList]);
  return (
    <div className="flex flex-col items-center gap-3">
      <Logo isAnimated />
      <HostInfo />
      {/* TODO: Display it nicely */}
      {deviceList.map((e) => {
        return <span>{JSON.stringify(e.metadata)}</span>;
      })}
    </div>
  );
}
