import { MdClose } from "react-icons/md";

interface CloseButtonProps {
  onClick: () => void;
  title?: string;
}

export default function CloseButton({ title, onClick }: CloseButtonProps) {
  return (
    <button
      className="border-gray-800 border-4 w-14 h-14 p-2 rounded-xl hover:bg-gray-800 hover:bg-opacity-50 active:bg-opacity-100 bg-transparent flex items-center justify-center transition-all"
      title={title}
      aria-label={title}
      onClick={onClick}
    >
      <MdClose size={32} />
    </button>
  );
}
