import Battery from "../ui/Battery/Battery";
import Signal from "../ui/Signal/Signal";
import DisconnectButton from "./DisconnectButton";

export default function DeviceCard() {
  const handleDisconnect = () => {
    // TODO: Handle disconnect
    console.log("disconnect");
  };

  return (
    <div className="flex flex-col bg-flify bg-opacity-20 p-4 rounded-xl w-72">
      <div className="flex justify-around">
        <Battery percentage={50} />
        <DisconnectButton onDisconnect={handleDisconnect} />
        <Signal latency={50} />
      </div>
    </div>
  );
}
