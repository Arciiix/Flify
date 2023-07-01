import { getIconForOs } from "@/utils/os";
import Battery from "../ui/Battery/Battery";
import Signal from "../ui/Signal/Signal";
import DisconnectButton from "../ui/CloseButton/CloseButton";

import { useMemo, useState } from "react";
import { OperatingSystem } from "../../../types/os.types";
import Slider from "../ui/Slider/Slider";
import VolumeIcon from "../ui/VolumeIcon/VolumeIcon";

export default function DeviceCard() {
  // DEV
  // TODO: Make it work
  const Icon = useMemo(() => getIconForOs(OperatingSystem.android), []);

  const [volume, setVolume] = useState(50);
  const sliderBarColor = useMemo(() => {
    return `linear-gradient(to right, #ffffff 0%, #ffffff ${volume}%, gray ${volume}%, gray 100%)`;
  }, [volume]);

  const handleVolumeChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setVolume(e.target.valueAsNumber);
  };

  const handleDisconnect = () => {
    // TODO: Handle disconnect
    console.log("disconnect");
  };

  return (
    <div className="flex flex-col bg-flify bg-opacity-20 p-4 m-6 rounded-xl min-w-[28rem] max-w-lg items-center gap-2">
      <div className="flex justify-around w-full p-2">
        <div className="flex-1 flex justify-start">
          <Battery percentage={50} />
        </div>
        <div className="flex-1 flex justify-center">
          <DisconnectButton
            onClick={handleDisconnect}
            title={"Remove device"}
          />
        </div>
        <div className="flex-1 flex justify-end">
          <Signal latency={50} />
        </div>
      </div>
      <Icon size={72} />
      <span className="text-3xl font-bold">Device name here</span>

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
        <span>00:00:02</span>
        <span>192.168.0.100</span>
      </div>
    </div>
  );
}
