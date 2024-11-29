import { TrophyIcon, CloseIcon } from "../Icons";
import useUIStore from "@/hooks/useUIStore";
import { Prize } from "@/lib/types";
import { useDojoStore } from "@/hooks/useDojoStore";

interface PrizeBoxProps {
  token: string;
  variant: "erc20" | "erc721";
  prizes: Prize[];
  totalAmount: number | null;
}

export default function PrizeBox({
  token,
  variant,
  prizes,
  totalAmount,
}: PrizeBoxProps) {
  const { formData, setFormData } = useUIStore();
  const state = useDojoStore((state) => state);
  const tokens = state.getEntitiesByModel("tournament", "TokenModel");
  const tokenModel = tokens.find(
    (t) => t.models.tournament.TokenModel?.token === token
  )?.models.tournament.TokenModel;

  return (
    <>
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
            <span>{tokenModel?.name}</span>
          </span>
          <span className="text-terminal-green/50 text-md uppercase">
            {variant}
          </span>
        </span>
        <span className="flex flex-col">
          <span className="uppercase">Player Split</span>
          <div className="flex flex-row gap-2">
            {prizes.map((prize) => {
              const isERC20 = variant === "erc20";
              const tokenValue = Number(
                isERC20
                  ? prize.tokenDataType.variant.erc20?.token_amount
                  : prize.tokenDataType.variant.erc721?.token_id
              );
              let value = "";
              if (isERC20) {
                value = `${((tokenValue / totalAmount!) * 100).toFixed(0)}%`;
              } else {
                value = tokenValue.toString();
              }

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
                  <span className="text-terminal-bronze">{value}</span>
                </span>
              );
            })}
          </div>
        </span>
      </div>
    </>
  );
}
