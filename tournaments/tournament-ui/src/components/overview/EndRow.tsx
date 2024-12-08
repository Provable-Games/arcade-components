import { feltToString, formatTime } from "@/lib/utils";
import { useGetTournamentDetailsQuery } from "@/hooks/useSdkQueries";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/buttons/Button";

interface EndRowProps {
  tournamentId?: any;
  name?: any;
  winnersCount?: any;
  endTime?: any;
  submissionPeriod?: any;
}

const EndRow = ({
  tournamentId,
  name,
  winnersCount,
  endTime,
  submissionPeriod,
}: EndRowProps) => {
  const { entities: tournamentDetails } =
    useGetTournamentDetailsQuery(tournamentId);
  const navigate = useNavigate();
  const tournamentEntries = tournamentDetails?.[0]?.TournamentEntriesModel;
  const tournamentPrizeKeys = tournamentDetails?.[0]?.TournamentPrizeKeysModel;
  const currentTime = BigInt(new Date().getTime()) / 1000n;

  const endTimestamp = Number(endTime) * 1000;
  const endDate = new Date(endTimestamp);
  const submissionEndDate = new Date(
    (Number(endTime) + Number(submissionPeriod)) * 1000
  );

  const ended = Boolean(endTime && endDate.getTime() <= Date.now());
  const submissionEnded = Boolean(
    submissionPeriod && submissionEndDate.getTime() <= Date.now()
  );

  const isSubmissionLive = ended && !submissionEnded;

  const status = isSubmissionLive ? "Submitting" : "Closed";

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
      <td>{status}</td>
      {/* <td>{prizes}</td> */}
      <td>0</td>
    </tr>
  );
};

export default EndRow;
