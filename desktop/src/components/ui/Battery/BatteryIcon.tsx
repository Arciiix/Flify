import { interpolateValue } from "@/utils/clamp";
import { useMemo } from "react";
import { BatteryProps } from "./Battery";

type BatteryIconProps = BatteryProps & {
  calculatedColor: string;
};

export default function BatteryIcon({
  percentage,
  calculatedColor,
}: BatteryIconProps) {
  const calculatedWidth = useMemo(() => {
    // Max width of the inner bar to be fully inside the box is 1.5 rem
    return Math.round(interpolateValue(0, 1.5 * 100, percentage / 100)) / 100;
  }, [percentage]);

  return (
    <div className="flex items-center">
      <div
        className="relative p-2 border-4 rounded-lg w-10 h-4 flex justify-start"
        style={{
          borderColor: calculatedColor,
        }}
      >
        <div
          className="absolute top-1/2 -translate-y-1/2 left-1 h-2 rounded-sm"
          style={{
            backgroundColor: calculatedColor,
            // Max width of the inner bar to be fully inside the box is 1.5 rem
            width: `${calculatedWidth}rem`,
          }}
        ></div>
      </div>
      <div
        className="m-0.5 h-2 w-1
  rounded-tr-full rounded-br-full"
        style={{
          backgroundColor: calculatedColor,
        }}
      ></div>
    </div>
  );
}
