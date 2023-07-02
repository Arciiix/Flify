import { useState } from "react";
import { Client } from "types/socket.types";
import Logo from "../ui/Logo/Logo";
import disconnectDevice from "@/services/connection/disconnectDevice";

interface ConfirmDisconnectProps {
  device: Client;
  onCancel: () => void;
}

export default function ConfirmDisconnect({
  device,
  onCancel,
}: ConfirmDisconnectProps) {
  const [isLoading, setIsLoading] = useState(false);

  const handleDisconnect = async () => {
    setIsLoading(true);
    await disconnectDevice(device.socketId);
    setIsLoading(false);
  };

  return (
    <div className="flex flex-col gap-3">
      <span className="text-2xl font-bold font-flify">Disconnect device</span>
      <hr />
      <span className="text-lg">
        Are you sure you want to disconnect device "{device.metadata.deviceName}
        "{device.metadata.selfIp ? ` with ip ${device.metadata.selfIp}` : ""}?
      </span>
      <div className="flex justify-around">
        <button
          className="bg-transparent border-2 rounded-xl font-bold text-white border-white p-3 text-lg hover:bg-white hover:text-black active:scale-105 transition-all"
          onClick={onCancel}
        >
          Cancel
        </button>
        <button
          onClick={handleDisconnect}
          className={`bg-transparent border-2 rounded-xl font-bold ${
            isLoading
              ? "text-flify border-flify"
              : "text-red-400 border-red-400 hover:bg-red-400 hover:text-white active:scale-105"
          }  p-3 text-lg transition-all`}
        >
          {isLoading ? (
            <div className="flex gap-2 items-center">
              <Logo isSmall isAnimated width={32} />
              <span>Loading...</span>
            </div>
          ) : (
            "Disconnect"
          )}
        </button>
      </div>
    </div>
  );
}
