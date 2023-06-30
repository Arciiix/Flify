import Logo from "@/components/ui/Logo/Logo";
import { getQRCodeData } from "@/services/connection/getQRCodeData";
import { useEffect, useState } from "react";

import NetworkInfo from "@/components/network/NetworkInfo";
import QRCodeDisplay from "@/components/network/QRCodeDisplay";
import MadeWithHeart from "@/components/ui/MadeWithHeart/MadeWithHeart";
import { connection } from "@/state/connection/connection.atom";
import { sockets } from "@/state/connection/sockets.atom";
import { useRecoilValue } from "recoil";
import { Link, useNavigate } from "react-router-dom";

export default function HomePage() {
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
    if (deviceList.length > 0) {
      navigate("/app");
    }
  }, [deviceList]);

  return (
    <div className="flex flex-col items-center">
      <Logo isAnimated width={160} />
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
