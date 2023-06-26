import { connection } from "@/state/connection/connection.atom";
import { useRecoilValue } from "recoil";
import Explaination from "../ui/Explaination/Explaination";

import { MdComputer } from "react-icons/md";

export default function NetworkInfo() {
  const networkInfo = useRecoilValue(connection);

  if (!networkInfo) {
    return <span>Network info unknown!</span>;
  }
  return (
    <div>
      <div className="text-4xl text-center my-2 flex justify-center gap-3">
        <Explaination explaination="IP address" explainationColor="#A5C40C">
          {networkInfo.ip}
        </Explaination>
        <span>:</span>
        <Explaination explaination="port" explainationColor="#C44033">
          {networkInfo.port}
        </Explaination>
      </div>
      <div className="flex gap-2 items-center justify-center text-3xl">
        <MdComputer />
        <span>{networkInfo.hostname}</span>
      </div>
    </div>
  );
}
