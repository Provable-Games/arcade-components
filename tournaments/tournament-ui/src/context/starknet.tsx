"use client";
import { useMemo } from "react";
import { Chain, mainnet } from "@starknet-react/chains";
import { jsonRpcProvider, StarknetConfig } from "@starknet-react/core";
import React from "react";
import { useChainConnectors } from "../lib/connectors";
import { DojoAppConfig, dojoContextConfig } from "../config";
import { getStarknetProviderChains } from "@/config";

export function StarknetProvider({
  children,
  dojoAppConfig,
}: {
  children: React.ReactNode;
  dojoAppConfig: DojoAppConfig;
}) {
  function rpc(_chain: Chain) {
    return {
      nodeUrl: _chain.rpcUrls.default.http[0],
    };
  }

  const chains: Chain[] = useMemo(
    () => getStarknetProviderChains(dojoAppConfig.supportedChainIds),
    [dojoAppConfig]
  );

  const selectedChainId = useMemo(
    () => dojoAppConfig.initialChainId,
    [dojoAppConfig]
  );

  const selectedChainConfig = useMemo(
    () => dojoContextConfig[selectedChainId],
    [dojoContextConfig, selectedChainId]
  );

  const chainConnectors = useChainConnectors(
    dojoAppConfig,
    selectedChainConfig
  );

  return (
    <StarknetConfig
      // autoConnect={true}
      chains={chains}
      connectors={chainConnectors}
      provider={jsonRpcProvider({ rpc })}
    >
      {children}
    </StarknetConfig>
  );
}
