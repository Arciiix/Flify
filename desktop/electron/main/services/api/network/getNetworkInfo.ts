import { config } from "../../config/env";
import getNetworkIP, { getHostname } from "../../network/getNetworkData";
import { NetworkInfo } from "../../../../../types/network.types";

export default function getNetworkInfo(): NetworkInfo {
  return {
    hostname: getHostname(),
    ip: getNetworkIP(),
    port: config.PORT,
  };
}
