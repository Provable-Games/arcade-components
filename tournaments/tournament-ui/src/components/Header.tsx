import { useRef, useState } from "react";
import { Button } from "./buttons/Button";
import { CartIcon, CartridgeIcon, GithubIcon, ETH, LORDS, LOGO } from "./Icons";
// import TransactionCart from "@/app/components/navigation/TransactionCart";
// import useTransactionCartStore from "@/app/hooks/useTransactionCartStore";
import useUIStore from "../hooks/useUIStore";
import { soundSelector, useUiSounds } from "../hooks/useUiSound";
import { checkCartridgeConnector } from "../lib/connectors";
import { config } from "../lib/config";
import { displayAddress, formatNumber, indexAddress } from "@/lib/utils";
import { useAccount, useConnect } from "@starknet-react/core";

export interface HeaderProps {
  ethBalance: bigint;
  lordsBalance: bigint;
}

export default function Header({ ethBalance, lordsBalance }: HeaderProps) {
  const { account } = useAccount();
  const { connector } = useConnect();
  const username = useUIStore((state: any) => state.username);

  // const displayCart = useUIStore((state) => state.displayCart);
  // const setDisplayCart = useUIStore((state) => state.setDisplayCart);
  const setShowProfile = useUIStore((state: any) => state.setShowProfile);

  // const calls = useTransactionCartStore((state) => state.calls);
  // const txInCart = calls.length > 0;

  // const { play: clickPlay } = useUiSounds(soundSelector.click);

  // const displayCartButtonRef = useRef<HTMLButtonElement>(null);

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
            <span className="flex flex-row items-center justify-between w-full self-center sm:w-5 sm:h-5  h-3 w-3 fill-current mr-1">
              <ETH />
              <p>{formatNumber(parseInt(ethBalance.toString()) / 10 ** 18)}</p>
            </span>
          </Button>
          <Button
            size={"xs"}
            variant={"outline"}
            className="self-center xl:px-5 hover:bg-terminal-green"
            onClick={async () => {
              const avnuLords = `https://app.avnu.fi/en?tokenFrom=${indexAddress(
                config.ethAddress ?? ""
              )}&tokenTo=${indexAddress(
                config.lordsAddress ?? ""
              )}&amount=0.001`;
              window.open(avnuLords, "_blank");
            }}
            onMouseEnter={() => setShowLordsBuy(true)}
            onMouseLeave={() => setShowLordsBuy(false)}
          >
            <span className="flex flex-row items-center justify-between w-full self-center sm:w-5 sm:h-5  h-3 w-3 fill-current mr-1">
              {!showLordsBuy ? (
                <>
                  <LORDS />
                  <p>
                    {formatNumber(parseInt(lordsBalance.toString()) / 10 ** 18)}
                  </p>
                </>
              ) : (
                <p className="text-black">{"Buy Lords"}</p>
              )}
            </span>
          </Button>
        </div>
        {/* {account && (
          <>
            <span className="sm:hidden w-5 h-5 mx-2">
              <Button
                variant={"outline"}
                size={"fill"}
                ref={displayCartButtonRef}
                onClick={() => {
                  // setDisplayCart(!displayCart);
                  clickPlay();
                }}
                className={`xl:px-5 w-5 h-5 fill-current ${
                  txInCart ? "animate-pulse" : ""
                }`}
              >
                <CartIcon />
              </Button>
            </span>
            <Button
              variant={"outline"}
              size={"xs"}
              ref={displayCartButtonRef}
              onClick={() => {
                // setDisplayCart(!displayCart);
                clickPlay();
              }}
              className={`hidden sm:block xl:px-5 w-5 h-5 fill-current ${
                txInCart
                  ? "animate-pulse bg-terminal-green-50 text-terminal-black"
                  : ""
              }`}
            >
              <CartIcon />
            </Button>
          </>
        )} */}
        {/* {displayCart && (
          <TransactionCart
            buttonRef={displayCartButtonRef}
            handleSubmitMulticall={handleSubmitMulticall}
            handleAddUpgradeTx={handleAddUpgradeTx}
            handleResetCalls={handleResetCalls}
          />
        )} */}
        <span className="sm:hidden flex flex-row gap-2 items-center">
          <div className="relative">
            <Button
              variant={"outline"}
              size={"sm"}
              onClick={() => {
                setShowProfile(true);
              }}
              className="xl:px-5 p-0 hover:bg-terminal-green hover:text-terminal-black"
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
                setShowProfile(true);
              }}
              className="xl:px-5 hover:bg-terminal-green hover:text-terminal-black"
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

          {/* <Button
            variant={"outline"}
            size={"sm"}
            href="https://github.com/BibliothecaDAO/loot-survivor"
            className="xl:px-5 w-6 fill-current"
          >
            <GithubIcon />
          </Button> */}
        </div>
      </div>
    </div>
  );
}
