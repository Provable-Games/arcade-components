import { useMemo } from "react";
import { Connector } from "@starknet-react/core";
import { DojoAppConfig, DojoChainConfig } from "@/config";

export const supportedConnectorIds = {
  CONTROLLER: "controller",
};

export const checkCartridgeConnector = (connector?: Connector) => {
  return connector?.id === "controller";
};

export const getConnectorIcon = (connector: Connector): string | null => {
  if (!connector) return null;
  if (typeof connector.icon === "string") return connector.icon;
  return connector.icon?.dark ?? null;
};

export const useChainConnectors = (
  dojoAppConfig: DojoAppConfig,
  chainConfig: DojoChainConfig
) => {
  // Cartridge Controller
  const connectorIds = useMemo<Connector[]>(() => {
    const result = chainConfig?.connectorIds?.reduce((acc, id) => {
      // if (id == supportedConnetorIds.ARGENT) acc.push(argent())
      // if (id == supportedConnetorIds.BRAAVOS) acc.push(braavos())
      // if (id == supportedConnetorIds.CONTROLLER) acc.push(controller());
      if (id == supportedConnectorIds.CONTROLLER)
        acc.push(dojoAppConfig.controllerConnector);
      return acc;
    }, [] as Connector[]);
    return result;
  }, [chainConfig]);

  return connectorIds;
};
