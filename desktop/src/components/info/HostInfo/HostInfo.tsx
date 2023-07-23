import { useEffect, useMemo, useState } from "react";
import { MdDevices, MdOutlineSpeaker } from "react-icons/md";

import Slider from "@/components/ui/Slider/Slider";
import styles from "./HostInfo.module.css";
import VolumeIcon from "@/components/ui/VolumeIcon/VolumeIcon";
import { connection } from "@/state/connection/connection.atom";
import { useRecoilValue } from "recoil";
import { audioDevice } from "@/state/connection/audioDevice.atom";
import { currentVolume } from "@/state/audio/currentVolume.atom";
import setAudioVolume from "@/services/audio/setAudioVolume";

interface HostInfoProps {
  onAudioDeviceChange: () => void;
}

export default function HostInfo({ onAudioDeviceChange }: HostInfoProps) {
  const networkInfo = useRecoilValue(connection);
  const currentAudioDevice = useRecoilValue(audioDevice);
  const currentVolumeValue = useRecoilValue(currentVolume);

  const [sliderValue, setSliderValue] = useState(100);
  const sliderBarColor = useMemo(
    () =>
      `linear-gradient(to right, #24def7 0%, var(--flify) ${sliderValue}%, gray ${sliderValue}%, gray 100%)`,
    [sliderValue]
  );

  const handleSliderValueInput = (e: React.ChangeEvent<HTMLInputElement>) => {
    setSliderValue(e.target.valueAsNumber);
  };

  const changeAudioDevice = () => {
    onAudioDeviceChange();
  };

  const handleToggleMute = () => {
    setAudioVolume({
      volume: currentVolumeValue?.volume ?? sliderValue,
      isMuted: !currentVolumeValue?.isMuted ?? false,
    });
  };

  useEffect(() => {
    // Add debounce - so don't change volume immediately after the slider updates
    const debounce = setTimeout(() => {
      if (sliderValue === currentVolumeValue?.volume) return;

      setAudioVolume({
        volume: sliderValue,
        isMuted: false,
      });
    }, 200);

    return () => {
      clearTimeout(debounce);
    };
  }, [sliderValue, currentVolumeValue]);

  useEffect(() => {
    setSliderValue(currentVolumeValue?.volume || 100);
  }, [currentVolumeValue]);

  if (!currentAudioDevice) return null;
  return (
    <div className="relative my-5">
      <div
        className={`w-full absolute top-0 h-full rounded-full bg-flify bg-opacity-30 blur-2xl block ${styles.bg}`}
      ></div>
      <div className={`flex flex-col p-6 rounded-xl gap-3 ${styles.wrapper}`}>
        <div className="flex w-full justify-between gap-12 items-center">
          <div className="flex flex-col gap-1">
            <span className="font-flify text-4xl font-bold">
              {currentAudioDevice.name}
            </span>
            <span className="ml-1 text-md text-slate-300">
              {currentAudioDevice.maxInputChannels} channel
              {currentAudioDevice.maxInputChannels !== 1 ? "s" : ""},{" "}
              {currentAudioDevice.defaultSampleRate} Hz,{" "}
              {currentAudioDevice.hostAPIName}
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
          <div className="w-full flex-1 flex items-center gap-2">
            <div onClick={handleToggleMute}>
              <VolumeIcon
                isMuted={currentVolumeValue?.isMuted ?? false}
                volume={sliderValue}
              />
            </div>
            <Slider
              value={sliderValue}
              onInput={handleSliderValueInput}
              barColor={sliderBarColor}
            />
          </div>

          <span className="text-md">{Math.floor(sliderValue)}%</span>
        </div>

        <div className="flex w-full justify-center gap-3 items-center text-flify">
          <MdDevices size={24} />
          {/* margin-top: -2px comes from the fact that the icon is not ideally centered - I measured it and it is around 2.5px too high above the center */}
          <span className="text-2xl mt-[-3px]">{networkInfo!.hostname}</span>
        </div>
      </div>
    </div>
  );
}
