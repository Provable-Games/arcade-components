import { feltToString } from "@/lib/utils";
import { useGetTournamentDetailsQuery } from "@/hooks/useSdkQueries";

interface LiveRowProps {
  tournament_id?: any;
  name?: any;
  start_time?: any;
  end_time?: any;
  entry_premium?: any;
}

const LiveRow = ({
  tournament_id,
  name,
  start_time,
  end_time,
  entry_premium,
}: LiveRowProps) => {
  const { entities: tournamentDetails } =
    useGetTournamentDetailsQuery(tournament_id);
  console.log(tournamentDetails);
  return (
    <tr className="h-10">
      <td className="px-2">{feltToString(BigInt(name!))}</td>
      {/* <td>{`${gamesPlayed} / ${entries}`}</td>
      <td>{topScores}</td>
      <td>{prizes}</td>
      <td>{timeLeft}</td> */}
    </tr>
  );
};

export default LiveRow;
