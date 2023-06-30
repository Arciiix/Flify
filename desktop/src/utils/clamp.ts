export const clamp = (num: number, min: number, max: number): number => {
  return Math.min(Math.max(num, min), max);
};

/**
  Helper function to get the value by percent between two other values 
  * e.g. fromValue = 0, toValue = 10, percentage = 0.5 => output = 5
*/
export const interpolateValue = (
  fromValue: number,
  toValue: number,
  percentage: number
): number => {
  return Math.round(fromValue + (toValue - fromValue) * percentage);
};
