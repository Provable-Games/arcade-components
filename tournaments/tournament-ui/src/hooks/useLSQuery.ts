import { useDojo } from "@/DojoContext";
import { useQuery, DocumentNode } from "@apollo/client";

type Variables = Record<
  string,
  string | number | number[] | boolean | null | undefined | Date
>;

// Custom hook that safely handles both mainnet and non-mainnet cases
export const useLSQuery = (query: DocumentNode, variables?: Variables) => {
  const {
    setup: { selectedChainConfig },
  } = useDojo();
  const isMainnet = selectedChainConfig.chainId === "SN_MAINNET";

  // Always call useQuery, but skip it when not on mainnet
  const { data, loading, error } = useQuery(query, {
    variables,
    // skip: !isMainnet,
  });

  // Return consistent shape regardless of chain
  return {
    // data: isMainnet ? data : null,
    data,
    loading,
    error,
    isMainnet,
  };
};
