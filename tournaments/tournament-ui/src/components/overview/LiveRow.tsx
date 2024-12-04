import { feltToString, formatTime } from "@/lib/utils";
import { useGetTournamentDetailsQuery } from "@/hooks/useSdkQueries";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/buttons/Button";

interface LiveRowProps {
  tournament_id?: any;
  name?: any;
  end_time?: any;
  winners_count?: any;
}

const LiveRow = ({
  tournament_id,
  name,
  end_time,
  winners_count,
}: LiveRowProps) => {
  const { entities: tournamentDetails } =
    useGetTournamentDetailsQuery(tournament_id);
  const navigate = useNavigate();
  const tournamentEntries = tournamentDetails?.[0]?.TournamentEntriesModel;
  const tournamentPrizeKeys = tournamentDetails?.[0]?.TournamentPrizeKeysModel;
  const currentTime = BigInt(new Date().getTime()) / 1000n;
  return (
    <tr className="h-10">
      <td className="px-2">{feltToString(BigInt(name!))}</td>
      {/* <td>{`${gamesPlayed} / ${entries}`}</td> */}
      <td>0/0</td>
      <td>{winners_count}</td>
      {/* <td>{prizes}</td> */}
      <td>0</td>
      <td>{formatTime(Number(end_time) - Number(currentTime))}</td>
      <td>
        <Button
          variant="outline"
          onClick={() => {
            navigate(`/tournament/${Number(tournament_id)}`);
          }}
        >
          View
        </Button>
      </td>
    </tr>
  );
};

export default LiveRow;
