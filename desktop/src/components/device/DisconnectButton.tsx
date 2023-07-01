import { MdClose } from "react-icons/md";

interface DisconnetButtonProps {
  onDisconnect: () => void;
}

export default function DisconnectButton({
  onDisconnect,
}: DisconnetButtonProps) {
  return (
    <button
      className="bg-gray-800 border-gray-800 border-4 w-14 h-14 p-2 rounded-xl hover:bg-opacity-50 active:bg-transparent flex items-center justify-center transition-all"
      title="Remove device"
      aria-label="Remove device"
      onClick={onDisconnect}
    >
      <MdClose size={32} />
    </button>
  );
}
