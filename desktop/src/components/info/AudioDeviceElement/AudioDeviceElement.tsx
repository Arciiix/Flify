import { MdVolumeUp } from "react-icons/md";

interface AudioDeviceElementsProps {
  isSelected?: boolean;
  isDisabled?: boolean;
  handleSelect: () => void; // TODO: Add audio device id
}

export default function AudioDeviceElement({
  isSelected,
  isDisabled,
  handleSelect,
}: AudioDeviceElementsProps) {
  const onSelect = () => {
    if (isDisabled || isSelected) return;
    handleSelect(); // TODO: Add audio device id
  };

  return (
    <div
      className={`p-2 rounded-xl flex justify-between w-full flex-1 items-center gap-12 cursor-pointer ${
        isDisabled ? "bg-gray-700 text-gray-500" : "bg-gray-900 hover:bg-flify"
      } transition-colors`}
      onClick={onSelect}
    >
      <div className="flex gap-3 items-center">
        <MdVolumeUp className="shrink-0" size={48} />
        <div className="flex flex-col">
          <span className="text-2xl font-bold">Name for the device</span>
          <span className="text-lg">x channels, 44100 Hz, ...</span>
          <span className="text-sm">device id</span>
        </div>
      </div>
      <div>
        <div
          className={`rounded-full w-4 h-4 ${
            isSelected ? "bg-blue-400" : "bg-gray-400"
          }`}
        ></div>
      </div>
    </div>
  );
}
