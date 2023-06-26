import getNetworkInfo from "./getNetworkInfo";

export default async function getQRCodeText(): Promise<string> {
  const info = await getNetworkInfo();
  return `Flify/${info.ip}:${info.port}/${info.hostname}`;
}
