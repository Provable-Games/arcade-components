"use client";
import { cartridge } from "../lib/connectors";
import { Chain, mainnet } from "@starknet-react/chains";
import {
  jsonRpcProvider,
  StarknetConfig,
  starkscan,
  useInjectedConnectors,
} from "@starknet-react/core";
import React from "react";
import { config } from "../lib/config";

export function StarknetProvider({ children }: { children: React.ReactNode }) {
  function rpc(_chain: Chain) {
    return {
      nodeUrl: config.rpcUrl!,
    };
  }

  const { connectors } = useInjectedConnectors({
    // Randomize the order of the connectors.
    order: "random",
  });

  return (
    <StarknetConfig
      autoConnect={true}
      chains={[mainnet]}
      connectors={[
        ...connectors,
        cartridge,
        // config.gameAddress,
        // config.lordsAddress,
        // config.ethAddress,
        // config.rpcUrl
      ]}
      explorer={starkscan}
      provider={jsonRpcProvider({ rpc })}
    >
      {children}
    </StarknetConfig>
  );
}
