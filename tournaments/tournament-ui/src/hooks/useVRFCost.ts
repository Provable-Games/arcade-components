import { useState, useEffect } from "react";
import { useSystemCalls } from "@/useSystemCalls.ts";

export const DataType = {
  SpotEntry: (pairId: string) => ({
    variant: "SpotEntry",
    activeVariant: () => "SpotEntry",
    unwrap: () => pairId,
  }),
  FutureEntry: (pairId: string, expirationTimestamp: string) => ({
    variant: "FutureEntry",
    activeVariant: () => "FutureEntry",
    unwrap: () => [pairId, expirationTimestamp],
  }),
  GenericEntry: (key: string) => ({
    variant: "GenericEntry",
    activeVariant: () => "GenericEntry",
    unwrap: () => key,
  }),
};

export type PragmaPrice = {
  decimals: bigint;
  expiration_timestamp: any;
  last_updated_timestamp: bigint;
  num_sources_aggregated: bigint;
  price: bigint;
};

export const useVRFCost = () => {
  const [dollarPrice, setDollarPrice] = useState<bigint>();
  const { getDataMedian } = useSystemCalls(); // Move this inside the hook

  useEffect(() => {
    const fetchVRFCost = async () => {
      const result = await getDataMedian(
        DataType.SpotEntry("19514442401534788")
      );
      const dollarToWei = BigInt(5) * BigInt(10) ** BigInt(17);
      const ethToWei = (result as PragmaPrice).price / BigInt(10) ** BigInt(8);
      const dollarPrice = dollarToWei / ethToWei;
      setDollarPrice(dollarPrice);
    };

    fetchVRFCost();
  }, [getDataMedian]); // Add dependency

  return {
    dollarPrice,
  };
};
