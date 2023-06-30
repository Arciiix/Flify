interface VolumeIndicatorProps {
  percentage: number; // From 0 to 100
}

export default function VolumeIndicator({ percentage }: VolumeIndicatorProps) {
  return (
    <div className="relative flex items-center">
      <div
        className="absolute top-0 left-0 flex w-full h-6 rounded-2xl bg-gradient-to-r from-green-700 via-yellow-400 to-red-600 transition-all duration-75"
        style={{
          clipPath: `inset(0% ${100 - percentage}% 0% 0% round 10px)`,
        }}
      ></div>
      <div className="flex w-full h-6 rounded-2xl bg-gradient-to-r from-green-700 via-yellow-400 to-red-600 opacity-40"></div>
    </div>
  );
}
