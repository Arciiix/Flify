import Battery from "../ui/Battery/Battery";
import Signal from "../ui/Signal/Signal";

export default function DeviceCard() {
  return (
    <div className="flex flex-col bg-flify bg-opacity-20 p-4 rounded-xl w-72">
      <div className="flex justify-around">
        <Battery percentage={50} />

        <Signal latency={50} />
      </div>
    </div>
  );
}
