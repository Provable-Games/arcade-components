import {
  createContext,
  ReactNode,
  useContext,
  useMemo,
  useState,
  useEffect,
} from "react";
import {
  BurnerAccount,
  BurnerManager,
  useBurnerManager,
} from "@dojoengine/create-burner";
import { DojoProvider } from "@dojoengine/core";
import { Account } from "starknet";
import { setupWorld } from "./generated/contracts.gen";
import { SDK, init } from "@dojoengine/sdk";
import { TournamentSchemaType, schema } from "./generated/models.gen";
import { DojoManifest } from "./hooks/useDojoSystem";
import { DojoAppConfig, DojoChainConfig, dojoContextConfig } from "./config";

interface DojoContextType {
  masterAccount: Account;
  sdk: SDK<TournamentSchemaType>;
  manifest: DojoManifest;
  selectedChainConfig: DojoChainConfig;
  nameSpace: string;
  client: ReturnType<typeof setupWorld>;
  account: BurnerAccount;
}

export const DojoContext = createContext<DojoContextType | null>(null);

export const DojoContextProvider = ({
  children,
  burnerManager,
  appConfig,
}: {
  children: ReactNode;
  burnerManager: BurnerManager;
  appConfig: DojoAppConfig;
}) => {
  const [sdk, setSdk] = useState<SDK<TournamentSchemaType> | undefined>(
    undefined
  );
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
    appConfig.manifests[chainId],
    selectedChainConfig.rpcUrl
  );

  const masterAccount = useMemo(
    () =>
      new Account(
        dojoProvider.provider,
        selectedChainConfig.masterAddress!,
        selectedChainConfig.masterPrivateKey!,
        "1"
      ),
    []
  );

  const burnerManagerData = useBurnerManager({ burnerManager });

  useEffect(() => {
    init<TournamentSchemaType>(
      {
        client: {
          rpcUrl: selectedChainConfig.rpcUrl,
          toriiUrl: selectedChainConfig.toriiUrl!,
          relayUrl: selectedChainConfig.relayUrl!,
          worldAddress: appConfig.manifests[chainId].world.address,
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
    return appConfig.manifests[chainId] ?? null;
  }, [appConfig.manifests, chainId]);

  return isLoading ? null : (
    <DojoContext.Provider
      value={{
        masterAccount,
        sdk,
        manifest,
        selectedChainConfig,
        nameSpace: appConfig.nameSpace,
        client: setupWorld(dojoProvider),
        account: {
          ...burnerManagerData,
          account: burnerManagerData.account || masterAccount,
        },
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

  const { account, ...setup } = context;

  return {
    setup,
    account,
  };
};
