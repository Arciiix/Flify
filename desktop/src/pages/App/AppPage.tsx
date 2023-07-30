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
import { MdRefresh } from "react-icons/md";
import reconnectDevices from "@/services/connection/reconnectDevices";
import togglePlayback from "@/services/playback/togglePlayback";
import previousTrack from "@/services/playback/previousTrack";
import nextTrack from "@/services/playback/nextTrack";
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
    // Update the indicator with the channel volumes
    const handleChannelsVolume = (
      _event: Electron.IpcRendererEvent,
      value: ChannelsVolume
    ) => {
      setCurrentChannelsVolume(value);
    };
    ipcRenderer.on("channels/volume", handleChannelsVolume);

    // Add a keystroke to toggle the playback state (puase/play)
    const handleTogglePlayback = (event: KeyboardEvent) => {
      switch (event.code.toLowerCase()) {
        case "space":
          event.preventDefault();
          togglePlayback();
          break;
        case "arrowleft":
          event.preventDefault();
          previousTrack();
          break;
        case "arrowright":
          event.preventDefault();
          nextTrack();
          break;
      }
    };
    document.addEventListener("keyup", handleTogglePlayback);

    return () => {
      // Clear after listeners
      ipcRenderer.removeListener("channels/volume", handleChannelsVolume);
      document.removeEventListener("keyup", handleTogglePlayback);
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
        <div className="flex w-max mx-auto justify-center items-center">
          <span className="font-flify text-4xl">Devices</span>
          <span className="mb-auto">{deviceList.length}</span>
          <div
            className="flex flex-1 items-center justify-center ml-2 transition-all hover:rotate-45 active:rotate-90 hover:text-blue-100 active:text-blue-200 cursor-pointer"
            title="Reconnect devices to fix latency issues"
            onClick={reconnectDevices}
          >
            <MdRefresh size={32} />
          </div>
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
