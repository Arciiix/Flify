import AddDeviceCard from "@/components/device/AddDeviceCard";
import DeviceCard from "@/components/device/DeviceCard";
import HostInfo from "@/components/info/HostInfo/HostInfo";
import SelectAudioDevice from "@/components/info/SelectAudioDevice/SelectAudioDevice";
import VolumeIndicator from "@/components/info/VolumeIndicator/VolumeIndicator";
import Logo from "@/components/ui/Logo/Logo";
import Modal from "@/components/ui/Modal/Modal";
import { sockets } from "@/state/connection/sockets.atom";
import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { useRecoilState, useRecoilValue } from "recoil";
import { channelsVolume } from "@/state/volume/channels.atom";

import "../../styles/scrollbar.css";
import { ChannelsVolume } from "types/volume.types";
const { ipcRenderer } = require("electron");

export default function AppPage() {
  const navigate = useNavigate();

  const deviceList = useRecoilValue(sockets);

  const [currentChannelsVolume, setCurrentChannelsVolume] =
    useRecoilState(channelsVolume);

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

  useEffect(() => {
    const handleChannelsVolume = (
      _event: Electron.IpcRendererEvent,
      value: ChannelsVolume
    ) => {
      console.log(value);
      setCurrentChannelsVolume(value);
    };
    ipcRenderer.on("channels/volume", handleChannelsVolume);

    return () => {
      ipcRenderer.removeListener("channels/volume", handleChannelsVolume);
    };
  }, []);
  return (
    <div className="flex flex-col items-center gap-3">
      <Modal isOpen={isDeviceSelectModalVisible} onClose={toggleModal}>
        <SelectAudioDevice onClose={toggleModal} />
      </Modal>

      <Logo isAnimated />
      <HostInfo onAudioDeviceChange={toggleModal} />

      <div className="flex flex-col w-5/12 gap-1">
        <VolumeIndicator percentage={currentChannelsVolume.leftChannel * 100} />
        <VolumeIndicator
          percentage={currentChannelsVolume.rightChannel * 100}
        />
      </div>

      <div>
        <div className="flex w-full justify-center">
          <span className="font-flify text-4xl">Devices</span>
          <span>{deviceList.length}</span>
        </div>
        <div className="flex w-[calc(100vw-20px)] px-2 overflow-x-auto">
          {deviceList.map((e) => {
            return <DeviceCard key={e.socketId} device={e} />;
          })}
          <AddDeviceCard />
        </div>
      </div>
    </div>
  );
}
