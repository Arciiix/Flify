import Battery from "../ui/Battery/Battery";

export default function DeviceCard() {
  return (
    <div className="flex flex-col bg-flify bg-opacity-20 p-4 rounded-xl">
      <div>
        <Battery percentage={50} />
      </div>
    </div>
  );
}
