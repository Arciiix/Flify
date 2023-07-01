import { useMemo } from "react";
import { IconType } from "react-icons";
import {
  MdAllInclusive,
  MdVolumeDown,
  MdVolumeMute,
  MdVolumeUp,
} from "react-icons/md";

interface VolumeIconProps {
  volume: number;
}

export default function VolumeIcon({ volume }: VolumeIconProps) {
  const Icon: IconType = useMemo(() => {
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
  }, [volume]);

  return <Icon size={32} />;
}
