import { Server } from "socket.io";
import { config } from "../config/env";
import handleSocketConnection from "./events";

export const io = new Server({
  cors: {
    origin: "*", // So that any client can connect
  },
});

io.on("connection", handleSocketConnection);

export default function initSocket() {
  io.listen(config.PORT);
}
