import { Button } from "../buttons/Button";
import { PlusIcon, TrophyIcon, CloseIcon } from "../Icons";
import useUIStore from "@/hooks/useUIStore";
import { TokenDataType } from "@/generated/models.gen";
import { ERC20Data, ERC721Data } from "@/generated/models.gen";
import { Prize } from "@/lib/types";

interface PrizeBoxProps {
  prizes: Prize[];
}

export default function PrizeBox({ prizes }: PrizeBoxProps) {
  const { formData, setFormData } = useUIStore();
  return (
    <>
      {Object.entries(
        prizes.reduce((acc, prize) => {
          const key = prize.token;
          if (!acc[key]) acc[key] = [];
          acc[key].push(prize);
          return acc;
        }, {} as Record<string, typeof prizes>)
      ).map(([token, prizes]) => {
        const totalAmount = prizes.reduce(
          (sum, prize) =>
            sum +
            Number(
              prize.tokenDataType.kind === TokenDataType.erc20
                ? (prize.tokenDataType.value as ERC20Data).token_amount
                : (prize.tokenDataType.value as ERC721Data).token_id
            ),
          0
        );

        return (
          <div className="relative flex flex-row gap-5 p-2 text-terminal-green border border-terminal-green px-5">
            <span
              className="absolute top-1 right-1 w-4 h-4 cursor-pointer"
              onClick={() =>
                setFormData({
                  ...formData,
                  prizes: formData.prizes.filter((p) => p.token !== token),
                })
              }
            >
              <CloseIcon />
            </span>
            <span className="flex flex-col items-center">
              <span className="flex flex-row gap-1 text-xl">
                <span>{totalAmount}</span>
                <span>{token}</span>
              </span>
              <span className="text-terminal-green/50 text-md">
                {prizes[0].tokenDataType.kind === TokenDataType.erc20
                  ? "ERC20"
                  : "ERC721"}
              </span>
            </span>
            <span className="flex flex-col">
              <span className="uppercase">Player Split</span>
              <div className="flex flex-row gap-2">
                {prizes.map((prize) => {
                  const percentage = (
                    ((prize.tokenDataType.kind === TokenDataType.erc20
                      ? Number(
                          (prize.tokenDataType.value as ERC20Data).token_amount
                        )
                      : Number(
                          (prize.tokenDataType.value as ERC721Data).token_id
                        )) /
                      totalAmount) *
                    100
                  ).toFixed(0);

                  return (
                    <span className="flex flex-row items-center gap-1">
                      {prize.position <= 3 ? (
                        <span
                          className={`w-4 h-4 ${
                            prize.position === 1
                              ? "text-terminal-gold"
                              : prize.position === 2
                              ? "text-terminal-silver"
                              : "text-terminal-bronze"
                          }`}
                        >
                          <TrophyIcon />
                        </span>
                      ) : (
                        <span className="text-terminal-green/50 text-md">
                          {prize.position}
                        </span>
                      )}
                      <span className="text-terminal-bronze">
                        {percentage}%
                      </span>
                    </span>
                  );
                })}
              </div>
            </span>
          </div>
        );
      })}
    </>
  );
}
