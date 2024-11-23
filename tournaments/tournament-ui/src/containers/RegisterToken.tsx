import { useState, ChangeEvent } from "react";
import { Button } from "../components/buttons/Button";
import { useSystemCalls } from "../useSystemCalls";
import { TokenDataType } from "@/generated/models.gen";
import { CairoCustomEnum } from "starknet";
import { useDojo } from "../DojoContext";
import { dojoConfig } from "../../dojoConfig.ts";

const RegisterToken = () => {
  const { account } = useDojo();
  const [tokenType, setTokenType] = useState<TokenDataType | null>(null);
  const [tokenAddress, setTokenAddress] = useState("");
  const [tokenId, setTokenId] = useState("");

  const { registerTokens, mintErc20, approveErc20 } = useSystemCalls();

  const handleChangeAddress = (e: ChangeEvent<HTMLInputElement>) => {
    const { value } = e.target;
    setTokenAddress(value);
  };

  const handleChangeTokenId = (e: ChangeEvent<HTMLInputElement>) => {
    const { value } = e.target;
    setTokenId(value);
  };

  console.log(tokenType, tokenAddress, tokenId);

  return (
    <div className="flex flex-col gap-10 w-full p-4">
      <div className="flex flex-row justify-center">
        <Button
          onClick={async () => {
            await mintErc20(
              account.account.address,
              1000000000000000000000000n,
              0n
            );
          }}
        >
          Mint ERC20
        </Button>
      </div>
      <h1 className="2xl:text-5xl text-center uppercase">Register Token</h1>
      <p className="text-lg text-center">
        To register a token you must hold an amount of it. In the case of
        registering an NFT, you must also provide the token ID.
      </p>
      <div className="flex flex-col gap-4">
        <div className="flex flex-col items-center gap-5">
          <div className="flex flex-col items-center gap-2">
            <h3 className="text-xl uppercase">Select Token Type</h3>
            <div className="flex flex-row gap-10">
              <Button
                variant={
                  tokenType === TokenDataType.erc20 ? "default" : "token"
                }
                size="md"
                onClick={() => setTokenType(TokenDataType.erc20)}
              >
                ERC20
              </Button>
              <Button
                variant={
                  tokenType === TokenDataType.erc721 ? "default" : "token"
                }
                size="md"
                onClick={() => setTokenType(TokenDataType.erc721)}
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
          {tokenType === TokenDataType.erc721 && (
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
            onClick={async () => {
              if (tokenType !== null) {
                await approveErc20(
                  "0x1003374b58688c6249605233d33153643815f02fb187439e26180b34501cbc0",
                  1n,
                  0n
                );
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
              }
            }}
            disabled={
              tokenAddress == "" ||
              tokenType === null ||
              (tokenType === TokenDataType.erc721 ? tokenId === "" : false)
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
