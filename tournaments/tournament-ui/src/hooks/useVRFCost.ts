import { CairoCustomEnum } from "starknet";
import { useState, useEffect } from "react";
import { useSystemCalls } from "@/useSystemCalls.ts";

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
        new CairoCustomEnum({
          SpotEntry: "19514442401534788",
          tournament: undefined,
          address: undefined,
        })
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
