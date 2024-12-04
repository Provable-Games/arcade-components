import { useCallback, useRef } from "react";
import { Connector } from "@starknet-react/core";
import { Policy, ControllerOptions } from "@cartridge/controller";
import { ControllerConnector } from "@cartridge/connector";
import { ContractInterfaces } from "@/config";
import { DojoManifest } from "@/hooks/useDojoSystem";

// sync from here:
// https://github.com/cartridge-gg/controller/blob/main/packages/account-wasm/src/constants.rs
export const CONTROLLER_CLASS_HASH =
  "0x05f0f2ae9301e0468ca3f9218dadd43a448a71acc66b6ef1a5570bb56cf10c6f";

const exclusions = ["dojo_init"];

const _makeControllerPolicies = (
  manifest: DojoManifest,
  namespace: string,
  contractInterfaces: ContractInterfaces
): Policy[] => {
  const policies: Policy[] = [];
  // contracts
  manifest?.contracts.forEach((contract: any) => {
    // abis
    contract.systems.forEach((system: any) => {
      // interfaces
      if (!exclusions.includes(system)) {
        policies.push({
          target: contract.address,
          method: system,
          description: `${contract.tag}::${system}()`,
        });
      }
    });
  });
  return policies;
};

export const makeControllerConnector = (
  manifest: DojoManifest,
  rpcUrl: string,
  namespace: string,
  contractInterfaces: ContractInterfaces
): Connector => {
  const policies = _makeControllerPolicies(
    manifest,
    namespace,
    contractInterfaces
  );

  // tokens to display
  // const tokens: Tokens = {
  //   erc20: [
  //     // bigintToHex(lordsContractAddress),
  //     // bigintToHex(fameContractAddress),
  //   ],
  //   // erc721: [],
  // }

  // extract slot service name from rpcUrl
  // const slot = /api\.cartridge\.gg\/x\/([^/]+)\/katana/.exec(rpcUrl)?.[1];

  const options: ControllerOptions = {
    // ProviderOptions
    rpc: rpcUrl,
    // IFrameOptions
    // theme: "tournament",
    // colorMode: "dark",
    // KeychainOptions
    policies,
    // namespace,
    // slot,
    // tokens,
  };
  const connector = new ControllerConnector(options) as never as Connector;
  return connector;
};

export const useControllerConnector = (
  manifest: DojoManifest,
  rpcUrl: string,
  namespace: string,
  contractInterfaces: ContractInterfaces
) => {
  const connectorRef = useRef<any>(undefined);
  const controller = useCallback(() => {
    if (!connectorRef.current) {
      connectorRef.current = makeControllerConnector(
        manifest,
        rpcUrl,
        namespace,
        contractInterfaces
      );
    }
    return connectorRef.current;
  }, [manifest, rpcUrl, namespace, contractInterfaces]);
  return {
    controller,
  };
};

// export const useControllerAccount = (contractAddress: BigNumberish) => {
//   const { classHash, isDeployed } = useContractClassHash(contractAddress);
//   const isControllerAccount = useMemo(
//     () => classHash && bigintEquals(classHash, CONTROLLER_CLASS_HASH),
//     [classHash]
//   );
//   const isKatanaAccount = useMemo(
//     () => classHash && bigintEquals(classHash, KATANA_CLASS_HASH),
//     [classHash]
//   );
//   return {
//     classHash,
//     isDeployed,
//     isControllerAccount,
//     isKatanaAccount,
//   };
// };
