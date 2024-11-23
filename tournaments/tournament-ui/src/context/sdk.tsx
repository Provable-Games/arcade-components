import { createContext, useContext } from "react";
import { SDK } from "@dojoengine/sdk";
import { TournamentSchemaType } from "../generated/models.gen";

const SDKContext = createContext<SDK<TournamentSchemaType> | null>(null);

export const SDKProvider = SDKContext.Provider;

export function useSDK() {
  const context = useContext(SDKContext);
  if (!context) {
    throw new Error("useSDK must be used within an SDKProvider");
  }
  return context;
}
