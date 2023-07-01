import DeviceCard from "@/components/device/DeviceCard";
import HostInfo from "@/components/info/HostInfo/HostInfo";
import SelectAudioDevice from "@/components/info/SelectAudioDevice/SelectAudioDevice";
import VolumeIndicator from "@/components/info/VolumeIndicator/VolumeIndicator";
import Logo from "@/components/ui/Logo/Logo";
import Modal from "@/components/ui/Modal/Modal";
import { sockets } from "@/state/connection/sockets.atom";
import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { useRecoilValue } from "recoil";

export default function AppPage() {
  const navigate = useNavigate();

  const deviceList = useRecoilValue(sockets);

  const [isDeviceSelectModalVisible, setIsDeviceSelectModalVisible] =
    useState(false);

  const toggleModal = () => setIsDeviceSelectModalVisible((prev) => !prev);

  useEffect(() => {
    // If every device disconnected
    if (!deviceList.length) {
      // TODO: Display a toast or something like that indicating that every device has disconnected
      navigate("/");
    }
  }, [deviceList]);
  return (
    <div className="flex flex-col items-center gap-3">
      <Modal isOpen={isDeviceSelectModalVisible} onClose={toggleModal}>
        <SelectAudioDevice />
      </Modal>

      <Logo isAnimated />
      <HostInfo onAudioDeviceChange={toggleModal} />

      <div className="flex flex-col w-5/12 gap-1">
        <VolumeIndicator percentage={50} />
        <VolumeIndicator percentage={50} />
      </div>
      {/* TODO: Display it nicely */}
      {deviceList.map((e) => {
        // return <span>{JSON.stringify(e.metadata)}</span>;
        return <DeviceCard />;
      })}
    </div>
  );
}
