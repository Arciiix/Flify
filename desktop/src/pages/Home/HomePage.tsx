import Logo from "@/components/ui/Logo/Logo";
import { getQRCodeData } from "@/services/connection/getQRCodeData";
import { useEffect, useState } from "react";

import NetworkInfo from "@/components/network/NetworkInfo";
import QRCodeDisplay from "@/components/network/QRCodeDisplay";
import MadeWithHeart from "@/components/ui/MadeWithHeart/MadeWithHeart";
import { connection } from "@/state/connection/connection.atom";
import { sockets } from "@/state/connection/sockets.atom";
import { Link, useNavigate } from "react-router-dom";
import { useRecoilValue } from "recoil";
import { MdOutlineSpeaker } from "react-icons/md";

interface HomePageProps {
  alreadyConnected?: boolean;
}

export default function HomePage({ alreadyConnected }: HomePageProps) {
  const navigate = useNavigate();

  const network = useRecoilValue(connection);
  const [text, setText] = useState<string | null>(null);
  const deviceList = useRecoilValue(sockets);

  const getQRCodeText = async () => {
    const text = await getQRCodeData();
    setText(text);
  };

  useEffect(() => {
    getQRCodeText();
  }, [network]);

  useEffect(() => {
    // If any device has connected
    if (deviceList.length > 0 && !alreadyConnected) {
      navigate("/app");
    }
  }, [deviceList]);

  return (
    <div className="flex flex-col items-center">
      {alreadyConnected ? (
        <Link
          className="group bg-flify bg-opacity-20 rounded-xl p-4 m-3 flex flex-col items-center gap-3 border-flify border-2 w-1/2 hover:bg-opacity-30 transition-colors cursor-pointer"
          to="/app"
        >
          <Logo isAnimated width={80} />
          <span className="text-2xl font-flify">
            In a connection with{" "}
            <span className="font-bold">
              {deviceList.length} device
              {deviceList.length === 1 ? "" : "s"}
            </span>
          </span>
          <span className="bg-left-bottom bg-gradient-to-r from-flify pb-1 to-blue-400 bg-[length:0%_2px] bg-no-repeat group-hover:bg-[length:100%_2px] transition-all duration-500 ease-out">
            Click here to go back to the connection view
          </span>
          {/* TODO: Display audio info */}
          <div className="flex gap-1 items-center">
            <MdOutlineSpeaker size={16} />
            <span className="text-sm">
              Audio Device Name, x channels, 44100 Hz
            </span>
          </div>
          {/* TODO: Maybe volume? */}
        </Link>
      ) : (
        <Logo isAnimated width={160} />
      )}

      <QRCodeDisplay text={text} />

      <span className="text-slate-200">or with manual connection</span>
      <NetworkInfo />

      <div className="text-4xl m-8 text-center flex flex-col lg:flex-row gap-2 items-center">
        Scan the QR code with the{" "}
        <div className="flex gap-2 items-center justify-center">
          <Logo isSmall width={38} />
          <b className="text-flify font-[ArialRoundedBold,Roboto]">Flify</b>
        </div>{" "}
        app to start.
      </div>

      <MadeWithHeart />
    </div>
  );
}
