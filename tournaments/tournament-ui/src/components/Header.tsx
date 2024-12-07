import { useState } from "react";
import { Button } from "./buttons/Button";
import { CartridgeIcon, ETH, LORDS, LOGO } from "./Icons";
import useUIStore from "../hooks/useUIStore";
import { displayAddress, formatNumber, indexAddress } from "@/lib/utils";
import { useAccount, useConnect } from "@starknet-react/core";
import { checkCartridgeConnector } from "../lib/connectors";
import { useDojo } from "../DojoContext";
import { useConnectToSelectedChain } from "@/lib/dojo/hooks/useChain";
import { useControllerMenu } from "@/hooks/useController";

export interface HeaderProps {
  ethBalance: bigint;
  lordsBalance: bigint;
}

export default function Header({ ethBalance, lordsBalance }: HeaderProps) {
  const { account } = useAccount();
  const { connector } = useConnect();
  const { connect } = useConnectToSelectedChain();
  const { openMenu } = useControllerMenu();
  const username = useUIStore((state: any) => state.username);
  const {
    setup: { selectedChainConfig },
  } = useDojo();

  // const displayCart = useUIStore((state) => state.displayCart);
  // const setDisplayCart = useUIStore((state) => state.setDisplayCart);
  // const displayCartButtonRef = useRef<HTMLButtonElement>(null);

  const setShowProfile = useUIStore((state: any) => state.setShowProfile);

  // const calls = useTransactionCartStore((state) => state.calls);
  // const txInCart = calls.length > 0;

  // const { play: clickPlay } = useUiSounds(soundSelector.click);

  const [showLordsBuy, setShowLordsBuy] = useState(false);

  const checkCartridge = checkCartridgeConnector(connector);

  return (
    <div className="flex flex-row justify-between px-1 h-10 ">
      <div className="flex flex-row items-center gap-2 sm:gap-5 fill-current w-24 md:w-32 xl:w-40 2xl:w-60 2xl:mb-5">
        <LOGO />
      </div>
      <div className="flex flex-row items-center self-end sm:gap-1 self-center">
        <div className="hidden sm:flex flex-row">
          <Button
            size={"xs"}
            variant={"outline"}
            className="self-center xl:px-5"
          >
            <span className="flex flex-row items-center">
              <span className="flex h-5 w-5">
                <ETH />
              </span>
              <p>
                {formatNumber(
                  parseInt((ethBalance ?? 0).toString()) / 10 ** 18
                )}
              </p>
            </span>
          </Button>
          <Button
            size={"xs"}
            variant={"outline"}
            className="self-center xl:px-5 hover:bg-terminal-green"
            onClick={async () => {
              const avnuLords = `https://app.avnu.fi/en?tokenFrom=${indexAddress(
                selectedChainConfig.ethAddress ?? ""
              )}&tokenTo=${indexAddress(
                selectedChainConfig.lordsAddress ?? ""
              )}&amount=0.001`;
              window.open(avnuLords, "_blank");
            }}
            onMouseEnter={() => setShowLordsBuy(true)}
            onMouseLeave={() => setShowLordsBuy(false)}
          >
            <span className="flex flex-row gap-1 items-center">
              {!showLordsBuy ? (
                <>
                  <span className="flex h-5 w-5 fill-current">
                    <LORDS />
                  </span>
                  <p>
                    {formatNumber(
                      parseInt((lordsBalance ?? 0).toString()) / 10 ** 18
                    )}
                  </p>
                </>
              ) : (
                <p className="text-black">{"Buy Lords"}</p>
              )}
            </span>
          </Button>
        </div>
        <span className="sm:hidden flex flex-row gap-2 items-center">
          <div className="relative">
            <Button
              variant={"outline"}
              size={"sm"}
              onClick={() => {
                if (account) {
                  openMenu();
                } else {
                  connect();
                }
              }}
              className="xl:px-5 p-0"
            >
              {account ? (
                username ? (
                  <span className="text-ellipsis overflow-hidden whitespace-nowrap max-w-[100px]">
                    {username}
                  </span>
                ) : (
                  displayAddress(account.address)
                )
              ) : (
                "Connect"
              )}
            </Button>
          </div>
        </span>
        <div className="hidden sm:block sm:flex sm:flex-row sm:items-center sm:gap-1">
          <div className="relative">
            <Button
              variant={"outline"}
              size={"sm"}
              onClick={() => {
                if (account) {
                  openMenu();
                } else {
                  connect();
                }
              }}
              className="xl:px-5"
            >
              {account ? (
                username ? (
                  <span className="text-ellipsis overflow-hidden whitespace-nowrap max-w-[100px]">
                    {username}
                  </span>
                ) : (
                  displayAddress(account.address)
                )
              ) : (
                "Connect"
              )}
            </Button>
            {checkCartridge && (
              <div className="absolute top-0 right-0 w-5 h-5 fill-current">
                <CartridgeIcon />
              </div>
            )}
          </div>
          <Button variant="outline">
            {selectedChainConfig.chainId === "WP_LS_TOURNAMENTS_KATANA"
              ? "Katana"
              : "Mainnet"}
          </Button>
        </div>
      </div>
    </div>
  );
}
