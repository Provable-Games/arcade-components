import { useState, ChangeEvent, useEffect } from "react";
import { useAccount } from "@starknet-react/core";
import { Button } from "../components/buttons/Button";
import { useSystemCalls } from "../useSystemCalls";
import { TokenDataEnum } from "@/lib/types";
import { CairoCustomEnum } from "starknet";
import { useDojoStore } from "../hooks/useDojoStore";
import {
  displayAddress,
  copyToClipboard,
  padAddress,
  formatBalance,
} from "../lib/utils";
import { useDojoSystem } from "@/hooks/useDojoSystem";
import TokenBox from "@/components/registerToken/TokenBox";
import { useSubscribeTokensQuery } from "@/hooks/useSdkQueries";

const RegisterToken = () => {
  const { account } = useAccount();
  const tournament = useDojoSystem("tournament_mock");
  const eth_mock = useDojoSystem("eth_mock");
  const lords_mock = useDojoSystem("lords_mock");
  const erc20_mock = useDojoSystem("erc20_mock");
  const erc721_mock = useDojoSystem("erc721_mock");
  const [tokenType, setTokenType] = useState<TokenDataEnum | null>(null);
  const [tokenAddress, setTokenAddress] = useState("");
  const [tokenId, setTokenId] = useState("");
  const [tokenBalance, setTokenBalance] = useState<Record<string, bigint>>({});
  const [copiedStates, setCopiedStates] = useState<Record<string, boolean>>({});

  const state = useDojoStore((state) => state);
  const tokens = state.getEntitiesByModel("tournament", "TokenModel");

  useSubscribeTokensQuery();

  const {
    registerTokens,
    mintErc20,
    mintErc721,
    getERC20Balance,
    approveErc20,
    approveErc721,
    approveEth,
    approveLords,
    mintEth,
    mintLords,
    getEthBalance,
    getLordsBalance,
    getErc721Balance,
  } = useSystemCalls();

  const handleChangeAddress = (e: ChangeEvent<HTMLInputElement>) => {
    const { value } = e.target;
    setTokenAddress(value);
  };

  const handleChangeTokenId = (e: ChangeEvent<HTMLInputElement>) => {
    const { value } = e.target;
    setTokenId(value);
  };

  const getTestETHBalance = async () => {
    const balance = await getEthBalance(account?.address!);
    if (balance !== undefined) {
      setTokenBalance((prev) => ({
        ...prev,
        eth: balance as bigint,
      }));
    }
  };

  const getTestLordsBalance = async () => {
    const balance = await getLordsBalance(account?.address!);
    if (balance !== undefined) {
      setTokenBalance((prev) => ({
        ...prev,
        lords: balance as bigint,
      }));
    }
  };

  const getTestERC20Balance = async () => {
    const balance = await getERC20Balance(account?.address!);
    if (balance !== undefined) {
      setTokenBalance((prev) => ({
        ...prev,
        erc20: balance as bigint,
      }));
    }
  };

  const getTestERC721Balance = async () => {
    const balance = await getErc721Balance(account?.address!);
    if (balance !== undefined) {
      setTokenBalance((prev) => ({
        ...prev,
        erc721: balance as bigint,
      }));
    }
  };

  useEffect(() => {
    if (account) {
      getTestERC20Balance();
      getTestERC721Balance();
      getTestETHBalance();
      getTestLordsBalance();
    }
  }, [account]);

  const handleCopyAddress = (address: string, standard: string) => {
    copyToClipboard(padAddress(address));
    setCopiedStates((prev) => ({ ...prev, [standard]: true }));
    setTimeout(() => {
      setCopiedStates((prev) => ({ ...prev, [standard]: false }));
    }, 2000);
  };

  const handleRegisterToken = async () => {
    if (tokenType !== null) {
      if (tokenType === TokenDataEnum.erc20) {
        if (tokenAddress === padAddress(eth_mock.contractAddress)) {
          await approveEth(tournament.contractAddress, 1n, 0n);
        } else if (tokenAddress === padAddress(lords_mock.contractAddress)) {
          await approveLords(tournament.contractAddress, 1n, 0n);
        } else {
          await approveErc20(tournament.contractAddress, 1n, 0n);
        }
        await new Promise((resolve) => setTimeout(resolve, 5000)); // Wait for 5 second
        await registerTokens([
          {
            token: tokenAddress,
            tokenDataType: new CairoCustomEnum({
              erc20: {
                token_amount: 1,
              },
              erc721: undefined,
            }),
          },
        ]);
      } else {
        await approveErc721(tournament.contractAddress, BigInt(tokenId), 0n);
        await registerTokens([
          {
            token: tokenAddress,
            TokenDataEnum: new CairoCustomEnum({
              erc721: {
                token_id: tokenId,
              },
            }),
          },
        ]);
      }
    }
  };

  return (
    <div className="flex flex-col gap-2 w-full p-4">
      <div className="flex flex-row gap-2 justify-center">
        <TokenBox
          title="ETH"
          contractAddress={eth_mock.contractAddress}
          standard="eth"
          balance={formatBalance(tokenBalance["eth"])}
          onMint={async () => {
            await mintEth(account?.address!, 100000000000000000000n, 0n);
          }}
          onCopy={handleCopyAddress}
          isCopied={copiedStates["eth"]}
        />
        <TokenBox
          title="Lords"
          contractAddress={lords_mock.contractAddress}
          standard="lords"
          balance={formatBalance(tokenBalance["lords"])}
          onMint={async () => {
            await mintLords(account?.address!, 100000000000000000000n, 0n);
          }}
          onCopy={handleCopyAddress}
          isCopied={copiedStates["lords"]}
        />
        <TokenBox
          title="Test ERC20"
          contractAddress={erc20_mock.contractAddress}
          standard="erc20"
          balance={formatBalance(tokenBalance["erc20"])}
          onMint={async () => {
            await mintErc20(account?.address!, 100000000000000000000n, 0n);
          }}
          onCopy={handleCopyAddress}
          isCopied={copiedStates["erc20"]}
        />

        <TokenBox
          title="Test ERC721"
          contractAddress={erc721_mock.contractAddress}
          standard="erc721"
          balance={Number(tokenBalance["erc721"])}
          onMint={async () => {
            await mintErc721(account?.address!, 1n, 0n);
          }}
          onCopy={handleCopyAddress}
          isCopied={copiedStates["erc721"]}
        />
      </div>
      <h1 className="text-4xl text-center uppercase">Registered Tokens</h1>
      {!!tokens && tokens.length > 0 ? (
        <div className="flex flex-row gap-2 justify-center">
          {tokens.map((token) => {
            const tokenModel = token.models.tournament.TokenModel;
            return (
              <Button
                key={token.entityId}
                variant="token"
                className="relative"
                size="md"
              >
                {tokenModel?.name}
                <span className="absolute top-0 text-xs uppercase text-terminal-green/75">
                  {tokenModel?.token_data_type}
                </span>
                <span className="absolute bottom-0 text-xs uppercase text-terminal-green/75">
                  {displayAddress(tokenModel?.token!)}
                </span>
              </Button>
            );
          })}
        </div>
      ) : (
        <p className="text-2xl text-center uppercase text-terminal-green/75">
          No tokens registered
        </p>
      )}
      <h1 className="text-4xl text-center uppercase">Register Tokens</h1>
      <p className="text-lg text-center">
        To register a token you must hold an amount of it. In the case of
        registering an NFT, you must also provide the token ID.
      </p>
      <div className="flex flex-col gap-2">
        <div className="flex flex-col items-center gap-2">
          <div className="flex flex-col items-center gap-2">
            <h3 className="text-xl uppercase">Select Token Type</h3>
            <div className="flex flex-row gap-10">
              <Button
                variant={
                  tokenType === TokenDataEnum.erc20 ? "default" : "token"
                }
                size="md"
                onClick={() => setTokenType(TokenDataEnum.erc20)}
              >
                ERC20
              </Button>
              <Button
                variant={
                  tokenType === TokenDataEnum.erc721 ? "default" : "token"
                }
                size="md"
                onClick={() => setTokenType(TokenDataEnum.erc721)}
              >
                ERC721
              </Button>
            </div>
          </div>
          <div className="flex flex-col items-center gap-2">
            <h3 className="text-xl uppercase">Paste Contract Address</h3>
            <input
              type="text"
              name="tokenAddress"
              onChange={handleChangeAddress}
              className="p-1 m-2 h-12 w-[700px] 2xl:text-2xl bg-terminal-black border border-terminal-green animate-pulse transform"
            />
          </div>
          {tokenType === TokenDataEnum.erc721 && (
            <div className="flex flex-col items-center gap-2">
              <h3 className="text-xl">Enter Token ID</h3>
              <input
                type="number"
                name="tokenId"
                onChange={handleChangeTokenId}
                className="p-1 m-2 h-12 w-20 2xl:text-2xl bg-terminal-black border border-terminal-green transform"
              />
            </div>
          )}
          <Button
            onClick={handleRegisterToken}
            disabled={
              tokenAddress == "" ||
              tokenType === null ||
              (tokenType === TokenDataEnum.erc721 ? tokenId === "" : false)
            }
          >
            Register Token
          </Button>
        </div>
      </div>
    </div>
  );
};

export default RegisterToken;
