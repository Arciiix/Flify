import { atom } from "recoil";
import { NetworkInfo } from "types/network.types";
import { Client } from "types/socket.types";

export const sockets = atom<Client[]>({
  key: "sockets",
  default: [],
  effects: [
    ({ onSet }) => {
      onSet((newValue) => {
        console.log("Socket list updated", newValue);
      });
    },
  ],
});
