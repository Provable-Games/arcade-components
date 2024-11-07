import { useState, ChangeEvent } from "react";
import { Button } from "../components/buttons/Button";
import { useSystemCalls } from "../useSystemCalls";
import { TokenDataType } from "@/generated/models.gen";

const RegisterToken = () => {
  const [tokenType, setTokenType] = useState<TokenDataType | null>(null);
  const [tokenAddress, setTokenAddress] = useState("");
  const [tokenId, setTokenId] = useState("");

  const { registerTokens } = useSystemCalls();

  const handleChangeAddress = (e: ChangeEvent<HTMLInputElement>) => {
    const { value } = e.target;
    setTokenAddress(value.slice(0, 31));
  };

  const handleChangeTokenId = (e: ChangeEvent<HTMLInputElement>) => {
    const { value } = e.target;
    setTokenId(value.slice(0, 31));
  };

  return (
    <div className="flex flex-col gap-10 w-full p-4">
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
              if (tokenType) {
                await registerTokens([
                  {
                    token: tokenAddress,
                    token_data_type: TokenDataType.erc20,
                    data: 1,
                  },
                ]);
              }
            }}
            disabled={
              tokenAddress == "" ||
              !tokenType ||
              (tokenType == TokenDataType.erc721 && tokenId == "")
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
