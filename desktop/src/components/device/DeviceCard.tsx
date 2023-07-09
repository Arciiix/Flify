import { getIconForOs } from "@/utils/os";
import Battery from "../ui/Battery/Battery";
import DisconnectButton from "../ui/CloseButton/CloseButton";
import Signal from "../ui/Signal/Signal";

import { secondsToFormattedTime } from "@/utils/time";
import { useEffect, useMemo, useState } from "react";
import { Client } from "types/socket.types";
import Modal from "../ui/Modal/Modal";
import Slider from "../ui/Slider/Slider";
import VolumeIcon from "../ui/VolumeIcon/VolumeIcon";
import ConfirmDisconnect from "./ConfirmDisconnect";
import { changeVolume } from "@/services/device/changeVolume";

interface DeviceCardProps {
  device: Client;
}

export default function DeviceCard({ device }: DeviceCardProps) {
  const Icon = useMemo(
    () => getIconForOs(device.metadata.os),
    [device.metadata]
  );

  const [volume, setVolume] = useState(0);

  const [uptime, setUptime] = useState(0);
  const [isConfirmingDisconnect, setIsConfirmingDisconnect] = useState(false);

  const uptimeString = useMemo(() => {
    return secondsToFormattedTime(uptime);
  }, [uptime]);

  const sliderBarColor = useMemo(() => {
    return `linear-gradient(to right, #ffffff 0%, #ffffff ${volume}%, gray ${volume}%, gray 100%)`;
  }, [volume]);

  const handleVolumeChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setVolume(e.target.valueAsNumber);
  };

  const handleDisconnect = () => setIsConfirmingDisconnect(true);
  const closeDisconnectConfirmation = () => setIsConfirmingDisconnect(false);

  useEffect(() => {
    setUptime(0);

    const interval = setInterval(() => {
      setUptime((old) => old + 1);
    }, 1000);

    return () => {
      clearInterval(interval);
    };
  }, [device.socketId]);

  useEffect(() => {
    if (!device.state) return;
    setVolume(device.state!.volume ?? 0);
  }, [device.state]);

  useEffect(() => {
    const debounce = setTimeout(() => {
      if (volume !== device.state?.volume) {
        changeVolume(device.socketId, Math.round(volume));
      }
    }, 200);

    return () => {
      clearTimeout(debounce);
    };
  }, [device.state, volume]);

  return (
    <div className="flex flex-col bg-flify bg-opacity-20 p-4 m-6 rounded-xl min-w-[28rem] max-w-lg items-center gap-2">
      <Modal
        isOpen={isConfirmingDisconnect}
        onClose={closeDisconnectConfirmation}
      >
        <ConfirmDisconnect
          device={device}
          onCancel={closeDisconnectConfirmation}
        />
      </Modal>
      <div className="flex justify-around w-full p-2">
        <div className="flex-1 flex justify-start">
          <Battery percentage={device.state?.batteryLevel ?? 0} />
        </div>
        <div className="flex-1 flex justify-center">
          <DisconnectButton
            onClick={handleDisconnect}
            title={"Remove device"}
          />
        </div>
        <div className="flex-1 flex justify-end">
          <Signal latency={device.state?.ping ?? -1} />
        </div>
      </div>
      <Icon size={72} />
      <span className="text-3xl font-bold">{device.metadata.deviceName}</span>

      <div className="flex-1 w-full flex flex-col m-5 gap-3 items-center">
        <div className="w-full flex-1 flex items-center gap-2">
          <VolumeIcon volume={volume} />
          <Slider
            value={volume}
            onInput={handleVolumeChange}
            barColor={sliderBarColor}
          />
        </div>
        <span className="text-xl">{Math.round(volume)}%</span>
      </div>

      <div className="w-full flex justify-between p-1 text-lg text-slate-400">
        <span>{uptimeString}</span>
        <span>{device.metadata.selfIp ?? "somewhere 👀"}</span>
      </div>
    </div>
  );
}
