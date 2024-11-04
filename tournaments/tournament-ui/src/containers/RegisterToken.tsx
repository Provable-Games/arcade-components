import { useState, ChangeEvent } from "react";
import { Button } from "../components/buttons/Button";

const RegisterToken = () => {
  const [tokenAddress, setTokenAddress] = useState("");
  const [tokenId, setTokenId] = useState("");

  const handleChangeAddress = (e: ChangeEvent<HTMLInputElement>) => {
    const { value } = e.target;
    setTokenAddress(value.slice(0, 31));
  };

  const handleChangeTokenId = (e: ChangeEvent<HTMLInputElement>) => {
    const { value } = e.target;
    setTokenId(value.slice(0, 31));
  };

  return (
    <div className="flex flex-col gap-10 w-full p-4 uppercase">
      <h1 className="2xl:text-5xl text-center">Register Token</h1>
      <p className="text-lg text-center">
        To register a token you must hold an amount of it. In the case of
        registering an NFT, you must also provide the token ID.
      </p>
      <div className="flex flex-col gap-4">
        <div className="flex flex-col items-center gap-2">
          <h3 className="text-xl">Paste Contract Address</h3>
          <input
            type="text"
            name="tokenAddress"
            onChange={handleChangeAddress}
            className="p-1 m-2 h-12 w-[700px] 2xl:text-2xl bg-terminal-black border border-terminal-green animate-pulse transform"
          />
          <h3 className="text-xl">Enter Token ID</h3>
          <input
            type="number"
            name="tokenId"
            onChange={handleChangeTokenId}
            className="p-1 m-2 h-12 w-20 2xl:text-2xl bg-terminal-black border border-terminal-green transform"
          />
          <Button>Register Token</Button>
        </div>
      </div>
    </div>
  );
};

export default RegisterToken;
