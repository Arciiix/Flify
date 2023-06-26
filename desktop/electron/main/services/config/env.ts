import dotenv from "dotenv";
import { Config } from "../../../../types/config.types";

dotenv.config();

const DEFAULT_OPTIONS: Config = {
  PORT: 3400,
};

export const config: Config & unknown = {
  ...DEFAULT_OPTIONS,
  ...process.env,
};
