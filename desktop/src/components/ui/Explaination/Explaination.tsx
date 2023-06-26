import React, { CSSProperties } from "react";

import styles from "./Explaination.module.css";

export interface ExplainationCSS extends CSSProperties {
  "--explaination-color": string;
}

type ExplainationProps = React.DetailedHTMLProps<
  React.HTMLAttributes<HTMLSpanElement>,
  HTMLSpanElement
> & { explaination: string; explainationColor: string };
export default function Explaination(props: ExplainationProps) {
  return (
    <span
      {...props}
      className={`${styles.explaination} ${props.className}`}
      data-explaination={props.explaination}
      style={
        {
          "--explaination-color": props.explainationColor,
        } as ExplainationCSS
      }
    >
      {props.children}
    </span>
  );
}
