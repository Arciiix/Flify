import React from "react";

// Linter throws an error, but it works (using svgr plugin in Vite)
// @ts-ignore
import { ReactComponent as LogoSvg } from "../../../assets/icons/Flify.svg";

import "../../../styles/logo.css";

interface LogoProps {
  isSmall?: boolean;
  isAnimated?: boolean;
  width?: number;
}

export default function Logo({
  isSmall = false,
  isAnimated = false,
  width = 100,
}: LogoProps) {
  return (
    <div
      className={`${
        isAnimated ? "logo-animated" : ""
      } logo-wrapper flex [&>*]:flex-shrink-0`}
    >
      {isSmall ? (
        <LogoSvg width={width} />
      ) : (
        <div className="flex gap-2">
          <span
            className="text-flify"
            style={{
              fontSize: `${width}px`,
            }}
          >
            Fl
          </span>
          <LogoSvg width={width} />
          <span
            className="text-flify"
            style={{
              fontSize: `${width}px`,
            }}
          >
            fy
          </span>
        </div>
      )}
    </div>
  );
}
