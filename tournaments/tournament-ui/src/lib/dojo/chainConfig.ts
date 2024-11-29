import { Chain } from "@starknet-react/chains";
import { ChainId, dojoContextConfig, DojoChainConfig } from "@/config";
import { stringToFelt } from "@/lib/utils";

export const defaultChainId = (import.meta.env.VITE_CHAIN_ID ||
  undefined) as ChainId;

export const isChainIdSupported = (chainId: ChainId): boolean => {
  return Object.keys(dojoContextConfig).includes(chainId);
};

export const getDojoChainConfig = (
  chainId: ChainId
): DojoChainConfig | null => {
  if (!isChainIdSupported(chainId)) {
    return null;
  }
  let result = { ...dojoContextConfig[chainId] };
  //
  // derive starknet Chain
  if (!result.chain) {
    result.chain = {
      id: BigInt(stringToFelt(result.chainId)),
      name: result.name,
      network: result.network ?? "katana",
      testnet: result.testnet ?? true,
      nativeCurrency: result.nativeCurrency,
      rpcUrls: {
        default: { http: [] },
        public: { http: [] },
      },
      explorers: result.explorers,
    } as Chain;
  }
  //
  // use Cartridge RPCs
  if (result.rpcUrl && result.chain) {
    result.chain.rpcUrls.default.http = [result.rpcUrl];
    result.chain.rpcUrls.public.http = [result.rpcUrl];
  }
  // console.log(result)

  return result;
};

export const getStarknetProviderChains = (
  supportedChainIds: ChainId[]
): Chain[] => {
  return supportedChainIds.reduce((acc, chainId) => {
    const dojoChainConfig = getDojoChainConfig(chainId);
    if (dojoChainConfig?.chain) {
      acc.push(dojoChainConfig.chain);
    }
    return acc;
  }, [] as Chain[]);
};
