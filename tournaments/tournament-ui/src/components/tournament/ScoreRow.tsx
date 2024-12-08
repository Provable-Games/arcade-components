import { BigNumberish } from "starknet";
import { useDojo } from "@/DojoContext";
import { FirstIcon, SecondIcon, ThirdIcon } from "../Icons";

// First, define the props interface
interface ScoreRowProps {
  gameId: BigNumberish;
  rank: number;
  adventurer: any;
}

const ScoreRow = ({ gameId, rank, adventurer }: ScoreRowProps) => {
  const {
    setup: { selectedChainConfig },
  } = useDojo();

  if (!adventurer) return null;
  const isMainnet = selectedChainConfig.chainId === "SN_MAINNET";
  const formattedAdventurer = isMainnet
    ? adventurer
    : adventurer.models.tournament.AdventurerModel.adventurer;
  return (
    <tr className="h-10">
      <td className="px-2">
        <div className="flex items-center justify-center">
          {rank === 1 ? (
            <span className="flex w-4 h-8">
              <FirstIcon />
            </span>
          ) : rank === 2 ? (
            <span className="flex w-4 h-8">
              <SecondIcon />
            </span>
          ) : rank === 3 ? (
            <span className="flex w-4 h-8">
              <ThirdIcon />
            </span>
          ) : (
            rank
          )}
        </div>
      </td>
      <td>{formattedAdventurer.address ?? "-"}</td>
      <td>{formattedAdventurer.id ?? "-"}</td>
      <td>{formattedAdventurer.level ?? "-"}</td>
      <td>{formattedAdventurer.xp ?? "-"}</td>
      <td>{formattedAdventurer.deathTime ?? "-"}</td>
      <td>{formattedAdventurer.prizes ?? "-"}</td>
    </tr>
  );
};

export default ScoreRow;
