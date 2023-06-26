import { QRCode } from "react-qrcode-logo";
import logoRaw from "../../assets/icons/Flify.png";
import { THEME_COLOR } from "@/const";

interface QRCodeDisplayProps {
  text: string | null;
}

export default function QRCodeDisplay({ text }: QRCodeDisplayProps) {
  return (
    <div className="my-4">
      {text === null ? null : (
        <QRCode
          value={text}
          logoImage={logoRaw}
          removeQrCodeBehindLogo={true}
          logoPaddingStyle="circle"
          logoPadding={1}
          qrStyle="dots"
          logoWidth={80}
          eyeRadius={150}
          eyeColor={THEME_COLOR}
          size={350}
        />
      )}
    </div>
  );
}
