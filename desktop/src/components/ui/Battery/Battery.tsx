import { useMemo } from "react";
import BatteryIcon from "./BatteryIcon";
import { getColorBetweenRanges } from "@/utils/color";

export interface BatteryProps {
  percentage: number; // from 0 to 100
  dontCalculateColor?: boolean;
}

export const BATTERY_LOW = "#bdd106";
export const BATTERY_HIGH = "#4ade80";

export default function Battery({
  percentage,
  dontCalculateColor,
}: BatteryProps) {
  const calculatedColor = useMemo(() => {
    return dontCalculateColor
      ? BATTERY_HIGH
      : getColorBetweenRanges(BATTERY_LOW, BATTERY_HIGH, percentage / 100);
  }, [percentage, dontCalculateColor]);

  return (
    <div className="flex flex-col justify-center items-center gap-2">
      <BatteryIcon percentage={percentage} calculatedColor={calculatedColor} />
      <span
        className="font-bold text-xl"
        style={{
          color: calculatedColor,
        }}
      >
        {Math.round(percentage)}%
      </span>
    </div>
  );
}
