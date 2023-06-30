import clamp from "./clamp";

type RGBColor = {
  r: number;
  g: number;
  b: number;
};

/**
 * Gets a color between _fromColor_ and _toColor_. Percentage is the desired position in the color spectrum.
 * @param fromColor
 * @param toColor
 * @param percentage from 0 to 1 (decimal fraction)
 */
export const getColorBetweenRanges = (
  fromColor: string,
  toColor: string,
  percentage: number
): string => {
  percentage = clamp(percentage, 0, 1); // Make sure percentage is from 0 to 1

  const fromRGB = parseColor(fromColor);
  const toRGB = parseColor(toColor);

  const resultRGB: RGBColor = {
    r: interpolateColorValue(fromRGB.r, toRGB.r, percentage),
    g: interpolateColorValue(fromRGB.g, toRGB.g, percentage),
    b: interpolateColorValue(fromRGB.b, toRGB.b, percentage),
  };

  return rgbToHex(resultRGB.r, resultRGB.g, resultRGB.b);
};

// Helper function to parse color string into RGB values
const parseColor = (color: string): RGBColor => {
  const hex = color.replace(/^#/, "");
  const rgb = parseInt(hex, 16);
  return {
    r: (rgb >> 16) & 0xff,
    g: (rgb >> 8) & 0xff,
    b: rgb & 0xff,
  };
};

// Helper function to get the value by percent between two other values
const interpolateColorValue = (
  fromValue: number,
  toValue: number,
  percentage: number
): number => {
  return Math.round(fromValue + (toValue - fromValue) * percentage);
};

// Helper function to convert RGB color to HEX
const rgbToHex = (r: number, g: number, b: number): string => {
  const componentToHex = (c: number): string => {
    const hex = c.toString(16);
    return hex.length === 1 ? "0" + hex : hex;
  };

  return "#" + componentToHex(r) + componentToHex(g) + componentToHex(b);
};
