import { useMemo } from "react";
import { IconType } from "react-icons";
import {
  MdAllInclusive,
  MdVolumeDown,
  MdVolumeMute,
  MdVolumeOff,
  MdVolumeUp,
} from "react-icons/md";

interface VolumeIconProps {
  isMuted?: boolean | null;
  volume: number;
}

export default function VolumeIcon({ volume, isMuted }: VolumeIconProps) {
  const Icon: IconType = useMemo(() => {
    if (isMuted) {
      return MdVolumeOff;
    }

    // We've got 4 icons, so 4 levels
    if (volume === 0) {
      return MdVolumeMute;
    } else if (volume < 50) {
      return MdVolumeDown;
    } else if (volume === 100) {
      return MdAllInclusive;
    } else {
      return MdVolumeUp;
    }
  }, [volume, isMuted]);

  return <Icon size={32} />;
}
