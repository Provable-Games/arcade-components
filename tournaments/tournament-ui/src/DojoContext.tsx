import {
  createContext,
  ReactNode,
  useContext,
  useMemo,
  useState,
  useEffect,
} from "react";
import { DojoProvider } from "@dojoengine/core";
import { setupWorld } from "./generated/contracts.gen";
import { SDK, init } from "@dojoengine/sdk";
import { SchemaType, schema } from "./generated/models.gen";
import { DojoManifest } from "./hooks/useDojoSystem";
import { DojoAppConfig, DojoChainConfig, dojoContextConfig } from "./config";

interface DojoContextType {
  sdk: SDK<SchemaType>;
  manifest: DojoManifest;
  selectedChainConfig: DojoChainConfig;
  nameSpace: string;
  client: ReturnType<typeof setupWorld>;
}

export const DojoContext = createContext<DojoContextType | null>(null);

export const DojoContextProvider = ({
  children,
  appConfig,
}: {
  children: ReactNode;
  appConfig: DojoAppConfig;
}) => {
  const [sdk, setSdk] = useState<SDK<SchemaType> | undefined>(undefined);
  const currentValue = useContext(DojoContext);
  if (currentValue) {
    throw new Error("DojoProvider can only be used once");
  }

  const selectedChainConfig = dojoContextConfig[appConfig.initialChainId];

  const chainId = useMemo(
    () => selectedChainConfig.chainId,
    [selectedChainConfig]
  );

  const dojoProvider = new DojoProvider(
    appConfig.manifests[chainId!],
    selectedChainConfig.rpcUrl
  );

  useEffect(() => {
    init<SchemaType>(
      {
        client: {
          rpcUrl: selectedChainConfig.rpcUrl!,
          toriiUrl: selectedChainConfig.toriiUrl!,
          relayUrl: selectedChainConfig.relayUrl ?? "",
          worldAddress: appConfig.manifests[chainId!].world.address ?? "",
        },
        domain: {
          name: "WORLD_NAME",
          version: "1.0",
          chainId: "KATANA",
          revision: "1",
        },
      },
      schema
    ).then(setSdk);
  }, []);

  const isLoading = sdk === undefined;

  const manifest = useMemo(() => {
    return appConfig.manifests[chainId!] ?? null;
  }, [appConfig.manifests, chainId]);

  return isLoading ? null : (
    <DojoContext.Provider
      value={{
        sdk,
        manifest,
        selectedChainConfig,
        nameSpace: appConfig.nameSpace,
        client: setupWorld(dojoProvider),
      }}
    >
      {children}
    </DojoContext.Provider>
  );
};

export const useDojo = () => {
  const context = useContext(DojoContext);

  if (!context) {
    throw new Error("The `useDojo` hook must be used within a `DojoProvider`");
  }

  const { ...setup } = context;

  return {
    setup,
  };
};
