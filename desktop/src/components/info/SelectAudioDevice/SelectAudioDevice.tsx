import { useState } from "react";
import AudioDeviceElement from "../AudioDeviceElement/AudioDeviceElement";
import Logo from "@/components/ui/Logo/Logo";

export default function SelectAudioDevice() {
  const [isLoading, setIsLoading] = useState(false);

  const handleSelect = () => {
    // TODO: Add audio device id
    setIsLoading(true);
  };

  return (
    <div className="flex flex-col gap-2">
      {isLoading ? (
        <>
          <Logo isAnimated isSmall />
        </>
      ) : (
        // TODO: Render list
        <>
          <AudioDeviceElement handleSelect={handleSelect} />
          <AudioDeviceElement handleSelect={handleSelect} isSelected />
        </>
      )}
    </div>
  );
}
