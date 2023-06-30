import { useMemo, useState } from "react";
import {
  MdDeviceHub,
  MdDevices,
  MdKeyboardArrowDown,
  MdOutlineSettings,
  MdOutlineSpeaker,
  MdSettings,
  MdTune,
} from "react-icons/md";

import styles from "./HostInfo.module.css";

export default function HostInfo() {
  const [sliderValue, setSliderValue] = useState(50);
  const sliderLowerBarColor = useMemo(
    () =>
      `linear-gradient(to right, #24def7 0%, var(--flify) ${sliderValue}%, gray ${sliderValue}%, gray 100%)`,
    [sliderValue]
  );

  const handleSliderValueChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setSliderValue(e.target.valueAsNumber);
  };

  const changeAudioDevice = () => {
    // TODO: Change audio device
    console.log("Change audio device");
  };

  return (
    <div className="relative my-8">
      <div
        className={`w-full absolute top-0 h-full rounded-full bg-flify bg-opacity-30 blur-2xl block ${styles.bg}`}
      ></div>
      <div className={`flex flex-col p-6 rounded-xl gap-3 ${styles.wrapper}`}>
        <div className="flex w-full justify-between gap-12 items-center">
          <div className="flex flex-col gap-1">
            <span className="font-flify text-4xl font-bold">
              Input device name
            </span>
            <span className="ml-1 text-md text-slate-300">
              x channels, xxxxx Hz, other info...
            </span>
          </div>
          <button
            className="hover:text-flify transition-colors"
            title="Change audio device"
            aria-label="Change audio device"
            onClick={changeAudioDevice}
          >
            <MdOutlineSpeaker size={32} />
          </button>
        </div>

        <div className="mt-7 flex flex-col items-center gap-1">
          <input
            className={styles.slider}
            type="range"
            min="0"
            max="100"
            value={sliderValue}
            onInput={handleSliderValueChange}
            style={{ background: sliderLowerBarColor }}
          />

          <span className="text-md">{Math.floor(sliderValue)}%</span>
        </div>

        <div className="flex w-full justify-center gap-3 items-center text-flify">
          <MdDevices size={24} />
          {/* margin-top: -2px comes from the fact that the icon is not ideally centered - I measured it and it is around 2.5px too high above the center */}
          <span className="text-2xl mt-[-3px]">Hostname</span>
        </div>
      </div>
    </div>
  );
}
