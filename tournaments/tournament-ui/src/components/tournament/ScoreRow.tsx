import { FirstIcon, SecondIcon, ThirdIcon } from "../Icons";

// First, define the props interface
interface ScoreRowProps {
  rank: number;
  address: string;
  id: number;
  level: number;
  xp: number;
  deathTime: string;
  prizes: number;
}

const ScoreRow = ({
  rank,
  address,
  id,
  level,
  xp,
  deathTime,
  prizes,
}: ScoreRowProps) => {
  return (
    <tr className="h-10">
      <td className="px-2">
        <div className="flex items-center justify-center">
          {rank === 1 ? (
            <span className="flex w-5 h-10">
              <FirstIcon />
            </span>
          ) : rank === 2 ? (
            <span className="flex w-5 h-10">
              <SecondIcon />
            </span>
          ) : rank === 3 ? (
            <span className="flex w-5 h-10">
              <ThirdIcon />
            </span>
          ) : (
            rank
          )}
        </div>
      </td>
      <td>{address}</td>
      <td>{id}</td>
      <td>{level}</td>
      <td>{xp}</td>
      <td>{deathTime}</td>
      <td>{prizes}</td>
    </tr>
  );
};

export default ScoreRow;
