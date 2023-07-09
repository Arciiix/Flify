import { useEffect, useMemo, useState } from "react";
import AudioDeviceElement from "../AudioDeviceElement/AudioDeviceElement";
import Logo from "@/components/ui/Logo/Logo";
import { AudioDevice } from "types/audio.types";
import getAudioDevices from "@/services/audio/getAudioDevices";
import { useRecoilValue } from "recoil";
import { audioDevice } from "@/state/connection/audioDevice.atom";
import changeAudioDevice from "@/services/audio/changeAudioDevice";

interface SelectAudioDeviceProps {
  onClose: () => void;
}

export default function SelectAudioDevice({ onClose }: SelectAudioDeviceProps) {
  const [isLoading, setIsLoading] = useState(true);

  const [audioDevices, setAudioDevices] = useState<AudioDevice[] | null>(null);
  const currentAudioDevice = useRecoilValue(audioDevice);

  const fetchDevices = async () => {
    const devices = await getAudioDevices();
    setAudioDevices(devices);
  };

  const handleSelect = async (deviceId: number) => {
    setIsLoading(true);
    await changeAudioDevice(deviceId);
    setIsLoading(false);
    onClose();
  };

  const renderAudioDevices = useMemo(() => {
    if (!audioDevices) return null;
    return audioDevices.map((device) => {
      return (
        <AudioDeviceElement
          key={device.id}
          handleSelect={() => handleSelect(device.id)}
          isSelected={device.id === currentAudioDevice?.id}
          device={device}
        />
      );
    });
  }, [audioDevices, currentAudioDevice]);

  useEffect(() => {
    if (audioDevices === null) {
      fetchDevices().then(() => setIsLoading(false));
    } else {
      setIsLoading(false);
    }
  }, [audioDevices]);

  return (
    <div className="flex flex-col gap-2 absolute left-1/2 -translate-x-1/2 top-5 max-h-[90vh] overflow-auto">
      {isLoading ? (
        <>
          <Logo isAnimated isSmall />
        </>
      ) : (
        renderAudioDevices
      )}
    </div>
  );
}
