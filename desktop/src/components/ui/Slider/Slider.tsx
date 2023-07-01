import { THEME_COLOR } from "@/const";

import styles from "./Slider.module.css";

interface SliderProps {
  value: number;
  onInput: (e: React.ChangeEvent<HTMLInputElement>) => void;
  barColor?: string;
}

export default function Slider({
  value,
  onInput,
  barColor = THEME_COLOR,
}: SliderProps) {
  return (
    <input
      className={styles.slider}
      type="range"
      min="0"
      max="100"
      value={value}
      onInput={onInput}
      style={{ background: barColor }}
    />
  );
}
