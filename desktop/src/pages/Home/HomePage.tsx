import Logo from "@/components/ui/Logo/Logo";
import { getQRCodeData } from "@/services/connection/getQRCodeData";
import { useEffect, useState } from "react";

import NetworkInfo from "@/components/network/NetworkInfo";
import QRCodeDisplay from "@/components/network/QRCodeDisplay";
import { connection } from "@/state/connection/connection.atom";
import { useRecoilState } from "recoil";

export default function HomePage() {
  const network = useRecoilState(connection);
  const [text, setText] = useState<string | null>(null);
  const getQRCodeText = async () => {
    const text = await getQRCodeData();
    setText(text);
  };

  useEffect(() => {
    getQRCodeText();
  }, [network]);

  return (
    <div className="flex flex-col items-center">
      <Logo isAnimated width={160} />
      <QRCodeDisplay text={text} />

      <span className="text-slate-200">or with manual connection</span>
      <NetworkInfo />

      <div className="text-4xl m-8 text-center flex gap-2 items-center">
        Scan the QR code with the <Logo isSmall width={38} />
        <b className="text-flify font-[ArialRoundedBold,Roboto]">Flify</b> app
        to start.
      </div>
    </div>
  );
}
