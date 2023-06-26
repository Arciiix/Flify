import React from "react";
import Logo from "../Logo/Logo";

export interface LoadingProps {
  text?: string;
}

export default function Loading({ text }: LoadingProps) {
  return (
    <div className="flex flex-col gap-2 items-center justify-center">
      <Logo isSmall isAnimated width={150} />
      <span className="text-3xl text-center">{text ?? "Loading..."}</span>
    </div>
  );
}
