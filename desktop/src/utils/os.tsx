import { IconType } from "react-icons";
import { MdClose, MdDevices } from "react-icons/md";
import { OperatingSystem } from "../../types/os.types";

import { FaAndroid, FaApple, FaLinux, FaWindows } from "react-icons/fa";

export const getIconForOs = (os: OperatingSystem): IconType => {
  switch (os) {
    case OperatingSystem.linux:
      return FaLinux;
    case OperatingSystem.macos:
      return FaApple;
    case OperatingSystem.windows:
      return FaWindows;
    case OperatingSystem.android:
      return FaAndroid;
    case OperatingSystem.ios:
      return FaApple;
    default:
    case OperatingSystem.fuchsia:
      return MdDevices;
  }
};
