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
import { makeControllerConnector } from "@/hooks/useController";
import { supportedConnetorIds } from "@/lib/connectors";
import { defaultChainId } from "@/lib/dojo/chainConfig";

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
  SN_MAINNET = "SN_MAINNET",
}

const supportedChainIds: ChainId[] = [
  ChainId.KATANA_LOCAL,
  // ChainId.SN_SEPOLIA,
  // ChainId.TOURNAMENT_SLOT,
  // ChainId.TOURNAMENT_STAGING,
  // ChainId.SN_MAINNET,
];

const manifests: Record<ChainId, DojoManifest> = {
  [ChainId.KATANA_LOCAL]: tournament_manifest_dev as DojoManifest,
  [ChainId.SN_MAINNET]: null,
};

const NAMESPACE = "tournament";

const CONTRACT_INTERFACES = {
  tournament: ["ITournament"],
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
  chainId: ChainId;
  name: string;
  rpcUrl: string;
  toriiUrl?: string;
  relayUrl?: string;
  masterAddress?: string;
  masterPrivateKey?: string;
  accountClassHash?: string;
  etherAddress: string;
  connectorIds: string[];
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
  connectorIds: [supportedConnetorIds.CONTROLLER],
  // starknet Chain
  nativeCurrency: ETH_KATANA,
  explorers: WORLD_EXPLORER,
} as const;

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
    supportedConnetorIds.CONTROLLER,
    // supportedConnetorIds.ARGENT,
    // supportedConnetorIds.BRAAVOS,
  ],
} as const;

export const dojoContextConfig: Record<ChainId, DojoChainConfig> = {
  [ChainId.KATANA_LOCAL]: localKatanaConfig,
  [ChainId.SN_MAINNET]: snMainnetConfig,
};

const CONTROLLER = makeControllerConnector(
  manifests[defaultChainId],
  dojoContextConfig[defaultChainId].rpcUrl,
  NAMESPACE,
  CONTRACT_INTERFACES
);
//------------------------

export const makeDojoAppConfig = (): DojoAppConfig => {
  return {
    manifests,
    supportedChainIds,
    initialChainId: defaultChainId,
    nameSpace: NAMESPACE,
    contractInterfaces: CONTRACT_INTERFACES,
    starknetDomain: {
      name: "Tournament",
      version: "0.1.0",
      chainId: defaultChainId,
      revision: "1",
    },
    controllerConnector: CONTROLLER,
  };
};
