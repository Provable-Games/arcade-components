import { feltToString, formatTime } from "@/lib/utils";
import { useGetTournamentDetailsQuery } from "@/hooks/useSdkQueries";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/buttons/Button";

interface LiveRowProps {
  tournamentId?: any;
  name?: any;
  endTime?: any;
  winnersCount?: any;
}

const LiveRow = ({
  tournamentId,
  name,
  endTime,
  winnersCount,
}: LiveRowProps) => {
  const { entities: tournamentDetails } =
    useGetTournamentDetailsQuery(tournamentId);
  const navigate = useNavigate();
  const tournamentEntries = tournamentDetails?.[0]?.TournamentEntriesModel;
  const tournamentPrizeKeys = tournamentDetails?.[0]?.TournamentPrizeKeysModel;
  const currentTime = BigInt(new Date().getTime()) / 1000n;
  return (
    <tr
      className="h-8 hover:bg-terminal-green/50 hover:cursor-pointer border border-terminal-green/50"
      onClick={() => {
        navigate(`/tournament/${Number(tournamentId)}`);
      }}
    >
      <td className="px-2 max-w-20">
        <p className="overflow-hidden whitespace-nowrap text-ellipsis">
          {feltToString(BigInt(name!))}
        </p>
      </td>
      {/* <td>{`${gamesPlayed} / ${entries}`}</td> */}
      <td>0/0</td>
      <td>{winnersCount}</td>
      {/* <td>{prizes}</td> */}
      <td>0</td>
      <td>{formatTime(Number(endTime) - Number(currentTime))}</td>
    </tr>
  );
};

export default LiveRow;
