import { Button } from "@/components/buttons/Button";
import { PlusIcon } from "@/components/Icons";
import { useState } from "react";
import { Distribution, Token } from "@/lib/types";
import { TokenDataType } from "@/generated/models.gen";
import useUIStore from "@/hooks/useUIStore";
import { CairoCustomEnum, CairoOption, CairoOptionVariant } from "starknet";

const EntryFee = () => {
  const { formData, setFormData, setInputDialog } = useUIStore();
  const [selectedToken, setSelectedToken] = useState<string | null>(null);
  const [amount, setAmount] = useState<number>(0);
  const [creatorFee, setCreatorFee] = useState<number>(0);
  const [distributions, setDistributions] = useState<Distribution[]>([
    { position: 0, percentage: 0 },
  ]);

  const updatePosition = (index: number, newPosition: number) => {
    const newDistributions = [...distributions];
    newDistributions[index].position = newPosition;
    setDistributions(newDistributions);
  };

  const updatePercentage = (index: number, newPercentage: number) => {
    const newDistributions = [...distributions];
    newDistributions[index].percentage = newPercentage;
    setDistributions(newDistributions);
  };

  const handleChangeAmout = (e: React.ChangeEvent<HTMLInputElement>) => {
    setAmount(parseInt(e.target.value));
  };

  const totalPercentage = distributions
    .filter((dist) => dist.position !== 0 && dist.percentage !== 0)
    .reduce((sum, dist) => sum + dist.percentage, 0);

  const tokens: Token[] = [
    {
      token: "Lords",
      tokenDataType: new CairoCustomEnum({
        erc20: {
          token_amount: 1,
        },
        erc721: undefined,
      }),
    },
    {
      token: "Eth",
      tokenDataType: new CairoCustomEnum({
        erc20: {
          token_amount: 1,
        },
        erc721: undefined,
      }),
    },
  ];

  const percentageArray = distributions
    .filter((dist) => dist.position !== 0 && dist.percentage !== 0)
    .sort((a, b) => a.position - b.position)
    .map((dist) => dist.percentage);

  return (
    <div className="flex flex-col items-center justify-center">
      <div className="flex flex-row w-full items-center bg-terminal-green text-terminal-black h-10 px-5 justify-between">
        <div className="flex flex-row items-center gap-5">
          <p className="text-2xl uppercase">Select Token</p>
          <p>Gated Token can only be ERC20</p>
        </div>
        <div className="flex flex-row items-center gap-5">
          <p>Token not displaying?</p>
          <Button variant="token" className="hover:text-terminal-black">
            <p>Register Token</p>
          </Button>
        </div>
      </div>
      <div className="h-20 px-10 w-full flex flex-row items-center gap-5">
        {tokens.map((token) => (
          <Button
            variant={selectedToken === token.token ? "default" : "token"}
            onClick={() => setSelectedToken(token.token)}
            className="relative"
            size="md"
          >
            {token.token}
            <span className="absolute bottom-0 text-xs">ERC20</span>
          </Button>
        ))}
      </div>
      <div className="flex flex-row w-full items-center bg-terminal-green text-terminal-black h-10 px-5 justify-between">
        <p className="text-2xl uppercase">Add Amount</p>
        <p className="text-2xl font-bold">{isNaN(amount) ? "" : amount}</p>
      </div>
      <div className="h-20 px-10 w-full flex flex-row items-center justify-center gap-5">
        <div className="flex flex-row items-center gap-5">
          <Button
            variant={amount === 1 ? "default" : "token"}
            onClick={() => setAmount(1)}
          >
            1
          </Button>
          <Button
            variant={amount === 5 ? "default" : "token"}
            onClick={() => setAmount(5)}
          >
            5
          </Button>
          <Button
            variant={amount === 10 ? "default" : "token"}
            onClick={() => setAmount(10)}
          >
            10
          </Button>
          <Button
            variant={amount === 100 ? "default" : "token"}
            onClick={() => setAmount(100)}
          >
            100
          </Button>
          <div className="flex flex-row items-center gap-2">
            <p className="uppercase">Custom:</p>
            <input
              type="number"
              name="amount"
              className="p-1 m-2 w-20 h-8 2xl:text-2xl bg-terminal-black border border-terminal-green"
              onChange={handleChangeAmout}
            />
          </div>
        </div>
      </div>
      <div className="flex flex-row w-full items-center bg-terminal-green text-terminal-black h-10 px-5 justify-between">
        <p className="text-2xl uppercase">Add Creator Fee</p>
        <p className="text-2xl font-bold">
          {isNaN(creatorFee) ? "" : `${creatorFee}%`}
        </p>
      </div>
      <div className="h-20 px-10 w-full flex flex-row items-center justify-center gap-5">
        <div className="flex flex-row items-center gap-5">
          <Button
            variant={creatorFee === 1 ? "default" : "token"}
            onClick={() => setCreatorFee(1)}
          >
            1%
          </Button>
          <Button
            variant={creatorFee === 5 ? "default" : "token"}
            onClick={() => setCreatorFee(5)}
          >
            5%
          </Button>
          <Button
            variant={creatorFee === 10 ? "default" : "token"}
            onClick={() => setCreatorFee(10)}
          >
            10%
          </Button>
          <Button
            variant={creatorFee === 100 ? "default" : "token"}
            onClick={() => setCreatorFee(100)}
          >
            100%
          </Button>
          <div className="flex flex-row items-center gap-2">
            <p className="uppercase">Custom:</p>
            <input
              type="number"
              name="position"
              className="p-1 m-2 w-20 h-8 2xl:text-2xl bg-terminal-black border border-terminal-green"
            />
          </div>
        </div>
      </div>
      <div className="flex flex-row w-full items-center bg-terminal-green text-terminal-black h-10 px-5 justify-between">
        <p className="text-2xl uppercase">Add Entry Criteria</p>
        <div className="flex flex-row gap-2">
          {distributions
            .filter((dist) => dist.position !== 0 && dist.percentage !== 0)
            .sort((a, b) => a.position - b.position) // Add this line to sort by position
            .map((distribution, index) => {
              const getOrdinalSuffix = (position: number) => {
                const formatPosition = isNaN(position) ? 0 : position;
                if (formatPosition % 10 === 1 && formatPosition !== 11)
                  return "st";
                if (formatPosition % 10 === 2 && formatPosition !== 12)
                  return "nd";
                if (position % 10 === 3 && position !== 13) return "rd";
                return "th";
              };

              return (
                <p key={index} className="text-lg uppercase font-bold">
                  {isNaN(distribution.percentage)
                    ? ""
                    : `${distribution.position}${getOrdinalSuffix(
                        distribution.position
                      )}: ${distribution.percentage}%,`}
                </p>
              );
            })}
          <p className="text-lg uppercase font-bold">{`Total: ${totalPercentage}%`}</p>
        </div>
      </div>
      <div className="py-5 w-full flex flex-col items-center h-[200px] overflow-y-scroll">
        {distributions.map((distribution, index) => (
          <div className="flex flex-row gap-20">
            <div className="flex flex-col w-1/2">
              <p className="uppercase">Position</p>
              <div key={index} className="flex flex-row items-center gap-5">
                <Button
                  variant={distribution.position === 1 ? "default" : "token"}
                  onClick={() => {
                    updatePosition(index, 1);
                  }}
                >
                  1st
                </Button>
                <Button
                  variant={distribution.position === 2 ? "default" : "token"}
                  onClick={() => {
                    updatePosition(index, 2);
                  }}
                >
                  2nd
                </Button>
                <Button
                  variant={distribution.position === 3 ? "default" : "token"}
                  onClick={() => {
                    updatePosition(index, 3);
                  }}
                >
                  3rd
                </Button>
                <input
                  type="number"
                  name="position"
                  className="p-1 m-2 w-20 h-8 2xl:text-2xl bg-terminal-black border border-terminal-green"
                  value={distribution.position}
                  onChange={(e) => {
                    updatePosition(index, parseInt(e.target.value));
                  }}
                  placeholder="POS"
                />
              </div>
            </div>
            <div className="flex flex-col w-1/2">
              <p className="uppercase">Share %</p>
              <div className="flex flex-row items-center gap-5">
                <Button
                  variant={
                    distribution.position
                      ? distribution.percentage === 1
                        ? "default"
                        : "token"
                      : "disabled"
                  }
                  onClick={() => {
                    if (distribution.position !== 0) {
                      updatePercentage(index, 1);
                    }
                  }}
                >
                  1%
                </Button>
                <Button
                  variant={
                    distribution.position
                      ? distribution.percentage === 5
                        ? "default"
                        : "token"
                      : "disabled"
                  }
                  onClick={() => {
                    if (distribution.position !== 0) {
                      updatePercentage(index, 5);
                    }
                  }}
                >
                  5%
                </Button>
                <Button
                  variant={
                    distribution.position
                      ? distribution.percentage === 10
                        ? "default"
                        : "token"
                      : "disabled"
                  }
                  onClick={() => {
                    if (distribution.position !== 0) {
                      updatePercentage(index, 10);
                    }
                  }}
                >
                  10%
                </Button>
                <input
                  type="number"
                  name="share"
                  onChange={(e) => {
                    if (distribution.position !== 0) {
                      updatePercentage(index, parseInt(e.target.value));
                    }
                  }}
                  className={`p-1 m-2 w-20 h-8 2xl:text-2xl bg-terminal-black ${
                    distribution.position === 0
                      ? "border border-gray-500"
                      : "border border-terminal-green"
                  }`}
                  placeholder="SHARE"
                  disabled={distribution.position === 0}
                />
              </div>
            </div>
          </div>
        ))}
        <Button
          className="m-5 w-20"
          variant="token"
          onClick={() => {
            setDistributions([
              ...distributions,
              { position: 0, percentage: 0 },
            ]);
          }}
        >
          <span className="w-4 h-4">
            <PlusIcon />
          </span>
        </Button>
      </div>
      <Button
        variant="token"
        size="lg"
        onClick={() => {
          if (totalPercentage !== 100) {
            alert("Premium distribution must total 100%");
            return;
          }
          const entryFeeValue = new CairoOption(CairoOptionVariant.Some, {
            token: selectedToken!,
            token_amount: amount,
            token_distribution: percentageArray,
            creator_fee: creatorFee,
          });

          setFormData({
            ...formData,
            entryFee: entryFeeValue,
          });
          setInputDialog(null);
        }}
        disabled={totalPercentage !== 100}
      >
        Add Entry Fee
      </Button>
    </div>
  );
};

export default EntryFee;
