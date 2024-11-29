import { TrophyIcon, CloseIcon } from "../Icons";
import useUIStore from "@/hooks/useUIStore";
import { Premium } from "@/lib/types";
import { CairoOption, CairoOptionVariant } from "starknet";
import { useDojoStore } from "@/hooks/useDojoStore";

interface EntryFeeBoxProps {
  premium: Premium;
}

export default function EntryFeeBox({ premium }: EntryFeeBoxProps) {
  const { formData, setFormData } = useUIStore();
  const state = useDojoStore((state) => state);
  const tokens = state.getEntitiesByModel("tournament", "TokenModel");
  const token = tokens.find(
    (token) => token.models.tournament.TokenModel?.token === premium.token
  )?.models.tournament.TokenModel;
  return (
    <div className="relative flex flex-row gap-5 p-2 text-terminal-green border border-terminal-green px-5">
      <span
        className="absolute top-1 right-1 w-4 h-4 cursor-pointer"
        onClick={() =>
          setFormData({
            ...formData,
            entryFee: new CairoOption(CairoOptionVariant.None),
          })
        }
      >
        <CloseIcon />
      </span>
      <span className="flex flex-col items-center">
        <span className="flex flex-row gap-1 text-xl">
          <span>{premium.token_amount}</span>
          <span className="text-terminal-green/75">{token?.name}</span>
        </span>
        <span className="text-terminal-green/50 lowercase">per entry</span>
      </span>
      <span className="flex flex-col">
        <span className="uppercase">Creator Fee</span>
        <span className="text-terminal-yellow">{premium.creator_fee}%</span>
      </span>
      <span className="flex flex-col">
        <span className="uppercase">Player Split</span>
        <div className="flex flex-row gap-2">
          {premium.token_distribution.map((distribution, index) => (
            <span className="flex flex-row items-center gap-1">
              {index <= 3 ? (
                <span
                  className={`w-4 h-4 ${
                    index === 0
                      ? "text-terminal-gold"
                      : index === 1
                      ? "text-terminal-silver"
                      : "text-terminal-bronze"
                  }`}
                >
                  <TrophyIcon />
                </span>
              ) : (
                <span className="text-terminal-green/50 text-md">
                  {index + 1}
                </span>
              )}
              <span className="text-terminal-bronze">{distribution}%</span>
            </span>
          ))}
        </div>
      </span>
    </div>
  );
}
