import { Connector } from "@starknet-react/core";
import { config } from "./config";
import CartridgeConnector from "@cartridge/connector";

export const checkCartridgeConnector = (connector?: Connector) => {
  return connector?.id === "controller";
};

export const cartridge = new CartridgeConnector({
  policies: [],
  rpc: config.rpcUrl,
  theme: "loot-survivor",
}) as never as Connector;
