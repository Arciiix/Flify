import { MdAdd } from "react-icons/md";
import { Link } from "react-router-dom";

export default function AddDeviceCard() {
  return (
    <Link to="/add">
      <div className="group flex flex-1 shrink-0 justify-center items-center my-6 rounded-xl aspect-square bg-flify bg-opacity-10 hover:bg-opacity-30 transition-colors cursor-pointer min-w-[450px]">
        <MdAdd
          className="group-hover:rotate-90 group-hover:scale-105 group-active:scale-150 transition-all duration-500 ease-in-out border-2 rounded-xl border-flify border-opacity-0 group-hover:border-opacity-100"
          size={72}
        />
      </div>
    </Link>
  );
}
