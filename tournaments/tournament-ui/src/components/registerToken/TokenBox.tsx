import { Button } from "@/components/buttons/Button";
import { displayAddress } from "@/lib/utils";

interface TokenBoxProps {
  title: string;
  contractAddress: string;
  standard: string;
  balance: number;
  onMint: () => Promise<void>;
  onCopy: (address: string, standard: string) => void;
  isCopied: boolean;
}

const TokenBox = ({
  title,
  contractAddress,
  standard,
  balance,
  onMint,
  onCopy,
  isCopied,
}: TokenBoxProps) => {
  return (
    <div className="flex flex-col gap-2 items-center justify-center border border-terminal-green p-2">
      <p className="text-lg">{title}</p>
      <div className="relative flex flex-row items-center gap-2">
        <p className="text-lg">Address: {displayAddress(contractAddress)}</p>
        {isCopied && (
          <span className="absolute top-[-20px] right-0 uppercase">
            Copied!
          </span>
        )}
        <Button size="xxs" onClick={() => onCopy(contractAddress, standard)}>
          Copy
        </Button>
      </div>
      <p className="text-lg">Balance: {balance}</p>
      <Button onClick={onMint}>Mint</Button>
    </div>
  );
};

export default TokenBox;
