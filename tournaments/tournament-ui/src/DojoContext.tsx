import { createContext, ReactNode, useContext, useMemo } from "react";
import {
  BurnerAccount,
  BurnerManager,
  useBurnerManager,
} from "@dojoengine/create-burner";
import { DojoProvider } from "@dojoengine/core";
import { Account } from "starknet";
import { setupWorld } from "./generated/contracts.gen";
import { dojoConfig } from "../dojoConfig";

interface DojoContextType {
  masterAccount: Account;
  client: ReturnType<typeof setupWorld>;
  account: BurnerAccount;
}

export const DojoContext = createContext<DojoContextType | null>(null);

export const DojoContextProvider = ({
  children,
  burnerManager,
}: {
  children: ReactNode;
  burnerManager: BurnerManager;
}) => {
  const currentValue = useContext(DojoContext);
  if (currentValue) {
    throw new Error("DojoProvider can only be used once");
  }

  const dojoProvider = new DojoProvider(dojoConfig.manifest, dojoConfig.rpcUrl);

  const masterAccount = useMemo(
    () =>
      new Account(
        dojoProvider.provider,
        dojoConfig.masterAddress,
        dojoConfig.masterPrivateKey,
        "1"
      ),
    []
  );

  const burnerManagerData = useBurnerManager({ burnerManager });

  return (
    <DojoContext.Provider
      value={{
        masterAccount,
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
