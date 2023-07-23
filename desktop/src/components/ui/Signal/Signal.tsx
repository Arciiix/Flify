import { useMemo } from "react";
// Linter throws an error, but it works (using svgr plugin in Vite)
// @ts-ignore
import { ReactComponent as SignalSvg } from "../../../assets/icons/signal.svg";
import "./Signal.css";

interface SignalProps {
  latency: number;
}

type SignalStrength = 4 | 3 | 2 | 1;

export default function Signal({ latency }: SignalProps) {
  const signalStrength: SignalStrength = useMemo(() => {
    if (latency < 20) {
      return 4;
    } else if (latency < 40) {
      return 3;
    } else if (latency < 80) {
      return 2;
    } else {
      return 1;
    }
  }, [latency]);

  return (
    <div
      className={`signal-strength-${signalStrength} fill-blue-400 flex flex-col items-center`}
    >
      <SignalSvg width={36} height={36} />
      <span className="text-blue-400 font-bold text-xl">
        {latency === -1 ? "-" : latency} ms
      </span>
    </div>
  );
}
