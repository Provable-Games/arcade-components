import { StarknetDomain } from "starknet";
import { Connector } from "@starknet-react/core";
import { Chain, mainnet, NativeCurrency } from "@starknet-react/chains";
import {
  LOCAL_KATANA,
  LOCAL_RELAY,
  KATANA_CLASS_HASH,
  KATANA_ETH_CONTRACT_ADDRESS,
} from "@dojoengine/core";
import { DojoManifest } from "@/hooks/useDojoSystem";
import tournament_manifest_dev from "../../contracts/manifest_dev.json";
import tournament_manifest_slot from "../../contracts/manifest_slot.json";
import { makeControllerConnector } from "@/hooks/useController";
import { supportedConnectorIds } from "@/lib/connectors";
import {
  ApolloClient,
  InMemoryCache,
  NormalizedCacheObject,
} from "@apollo/client";
import { stringToFelt, cleanObject } from "@/lib/utils";

export interface ContractInterfaces {
  [contractName: string]: string[];
}

export interface DojoAppConfig {
  nameSpace: string;
  contractInterfaces: ContractInterfaces;
  supportedChainIds: ChainId[];
  initialChainId: ChainId;
  starknetDomain: StarknetDomain;
  manifests: { [chain_id: string]: DojoManifest | undefined };
  controllerConnector: Connector;
}

export enum ChainId {
  KATANA_LOCAL = "KATANA_LOCAL",
  WP_LS_TOURNAMENTS_KATANA = "WP_LS_TOURNAMENTS_KATANA",
  SN_MAINNET = "SN_MAINNET",
}

const supportedChainIds: ChainId[] = [
  ChainId.KATANA_LOCAL,
  // ChainId.SN_SEPOLIA,
  ChainId.WP_LS_TOURNAMENTS_KATANA,
  // ChainId.TOURNAMENT_STAGING,
  // ChainId.SN_MAINNET,
];

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
      id: BigInt(stringToFelt(result.chainId!)),
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
  // override env (default chain only)
  if (chainId == defaultChainId) {
    result = {
      ...result,
      ...cleanObject(envChainConfig),
    };
  }
  //
  // use Cartridge RPCs
  if (result.rpcUrl) {
    result.chain!.rpcUrls.default.http = [result.rpcUrl];
    result.chain!.rpcUrls.public.http = [result.rpcUrl];
  }
  // console.log(result)

  return result;
};

export const getStarknetProviderChains = (
  supportedChainIds: ChainId[]
): Chain[] => {
  return supportedChainIds.reduce<Chain[]>((acc, chainId) => {
    const dojoChainConfig = getDojoChainConfig(chainId);
    if (dojoChainConfig?.chain) {
      acc.push(dojoChainConfig.chain);
    }
    return acc;
  }, []);
};

const manifests: Record<ChainId, DojoManifest> = {
  [ChainId.KATANA_LOCAL]: tournament_manifest_dev as DojoManifest,
  [ChainId.WP_LS_TOURNAMENTS_KATANA]: tournament_manifest_slot as DojoManifest,
  [ChainId.SN_MAINNET]: null,
};

const NAMESPACE = "tournament";

let katanaContractInterfaces: ContractInterfaces = {
  tournament_mock: ["ITournamentMock"],
  erc20_mock: ["IERC20Mock"],
  erc721_mock: ["IERC721Mock"],
  eth_mock: ["IETHMock"],
  lords_mock: ["ILordsMock"],
  loot_survivor_mock: ["ILootSurvivorMock"],
  pragma_mock: ["IPragmaMock"],
};

let mainnetContractInterfaces: ContractInterfaces = {
  ls_tournament: ["ILSTournament"],
};

const CONTRACT_INTERFACES: Record<ChainId, ContractInterfaces> = {
  [ChainId.KATANA_LOCAL]: katanaContractInterfaces,
  [ChainId.WP_LS_TOURNAMENTS_KATANA]: katanaContractInterfaces,
  [ChainId.SN_MAINNET]: mainnetContractInterfaces,
};

//
// currencies
//
const ETH_KATANA: NativeCurrency = {
  address: KATANA_ETH_CONTRACT_ADDRESS,
  name: "Ether",
  symbol: "ETH",
  decimals: 18,
};

//
// explorers
//
type ChainExplorers = {
  [key: string]: string[];
};
const WORLD_EXPLORER: ChainExplorers = {
  worlds: ["https://worlds.dev"],
};

//
// chain config
//
export type DojoChainConfig = {
  chain?: Chain;
  chainId?: ChainId;
  name?: string;
  rpcUrl?: string;
  toriiUrl?: string;
  relayUrl?: string;
  masterAddress?: string;
  masterPrivateKey?: string;
  accountClassHash?: string;
  etherAddress?: string;
  connectorIds?: string[];
  // starknet Chain
  network?: string;
  testnet?: boolean;
  nativeCurrency?: NativeCurrency;
  explorers?: ChainExplorers;
};

const localKatanaConfig: DojoChainConfig = {
  chain: undefined, // derive from this
  chainId: ChainId.KATANA_LOCAL,
  name: "Katana Local",
  rpcUrl: LOCAL_KATANA,
  toriiUrl: "http://0.0.0.0:8080", //LOCAL_TORII,
  relayUrl: LOCAL_RELAY,
  // masterAddress: KATANA_PREFUNDED_ADDRESS,
  // masterPrivateKey: KATANA_PREFUNDED_PRIVATE_KEY,
  masterAddress:
    "0x127fd5f1fe78a71f8bcd1fec63e3fe2f0486b6ecd5c86a0466c3a21fa5cfcec",
  masterPrivateKey:
    "0xc5b2fcab997346f3ea1c00b002ecf6f382c5f9c9659a3894eb783c5320f912",
  accountClassHash: KATANA_CLASS_HASH,
  etherAddress: KATANA_ETH_CONTRACT_ADDRESS,
  connectorIds: [supportedConnectorIds.CONTROLLER],
  // starknet Chain
  nativeCurrency: ETH_KATANA,
  explorers: WORLD_EXPLORER,
} as const;

const slotKatanaConfig: DojoChainConfig = {
  chain: undefined, // derive from this
  chainId: ChainId.WP_LS_TOURNAMENTS_KATANA,
  name: "Katana Slot",
  rpcUrl: "https://api.cartridge.gg/x/ls-tournaments-katana/katana",
  toriiUrl: "https://api.cartridge.gg/x/ls-tournaments-katana/torii",
  relayUrl: undefined,
  // masterAddress: KATANA_PREFUNDED_ADDRESS,
  // masterPrivateKey: KATANA_PREFUNDED_PRIVATE_KEY,
  masterAddress:
    "0x6677fe62ee39c7b07401f754138502bab7fac99d2d3c5d37df7d1c6fab10819",
  masterPrivateKey:
    "0x3e3979c1ed728490308054fe357a9f49cf67f80f9721f44cc57235129e090f4",
  accountClassHash: KATANA_CLASS_HASH,
  etherAddress: KATANA_ETH_CONTRACT_ADDRESS,
  connectorIds: [supportedConnectorIds.CONTROLLER],
  // starknet Chain
  nativeCurrency: ETH_KATANA,
  explorers: WORLD_EXPLORER,
};

const snMainnetConfig: DojoChainConfig = {
  chain: { ...mainnet },
  chainId: ChainId.SN_MAINNET,
  name: "Mainnet",
  // rpcUrl: 'https://api.cartridge.gg/rpc/starknet',
  rpcUrl: "https://api.cartridge.gg/x/starknet/mainnet",
  toriiUrl: undefined,
  relayUrl: undefined,
  masterAddress: undefined,
  masterPrivateKey: undefined,
  accountClassHash: undefined,
  etherAddress: mainnet.nativeCurrency.address,
  connectorIds: [
    supportedConnectorIds.CONTROLLER,
    // supportedConnectorIds.ARGENT,
    // supportedConnectorIds.BRAAVOS,
  ],
} as const;

// environment overrides, will be applied over default chain only
export const envChainConfig: DojoChainConfig = {
  chain: undefined,
  chainId: undefined,
  name: undefined,
  rpcUrl: import.meta.env.VITE_NODE_URL || undefined,
  toriiUrl: import.meta.env.VITE_TORII || undefined,
  relayUrl: import.meta.env.VITE_RELAY_URL || undefined,
  masterAddress: import.meta.env.VITE_MASTER_ADDRESS || undefined,
  masterPrivateKey: import.meta.env.VITE_MASTER_PRIVATE_KEY || undefined,
  accountClassHash: undefined,
  etherAddress: undefined,
  connectorIds: undefined,
};

export const dojoContextConfig: Record<ChainId, DojoChainConfig> = {
  [ChainId.KATANA_LOCAL]: localKatanaConfig,
  [ChainId.WP_LS_TOURNAMENTS_KATANA]: slotKatanaConfig,
  [ChainId.SN_MAINNET]: snMainnetConfig,
};

const CONTROLLER = makeControllerConnector(
  manifests[defaultChainId],
  dojoContextConfig[defaultChainId]?.rpcUrl!
);
//------------------------

export const makeDojoAppConfig = (): DojoAppConfig => {
  return {
    manifests,
    supportedChainIds,
    initialChainId: defaultChainId,
    nameSpace: NAMESPACE,
    contractInterfaces: CONTRACT_INTERFACES[defaultChainId],
    starknetDomain: {
      name: "Tournament",
      version: "0.1.0",
      chainId: defaultChainId,
      revision: "1",
    },
    controllerConnector: CONTROLLER,
  };
};

export type LSClientConfig = {
  gameClient: ApolloClient<NormalizedCacheObject>;
};

export const createClient = (GQLUrl: string) => {
  return new ApolloClient({
    uri: GQLUrl,
    defaultOptions: {
      watchQuery: {
        fetchPolicy: "no-cache",
        nextFetchPolicy: "no-cache",
      },
      query: {
        fetchPolicy: "no-cache",
      },
      mutate: {
        fetchPolicy: "no-cache",
      },
    },
    cache: new InMemoryCache({
      addTypename: false,
    }),
  });
};

const snMainnetLSClientConfig: LSClientConfig = {
  gameClient: createClient("https://ls-indexer-sepolia.provable.games/graphql"),
};

export const lsClientsConfig = {
  [ChainId.KATANA_LOCAL]: snMainnetLSClientConfig,
  [ChainId.WP_LS_TOURNAMENTS_KATANA]: snMainnetLSClientConfig,
  [ChainId.SN_MAINNET]: snMainnetLSClientConfig,
};
