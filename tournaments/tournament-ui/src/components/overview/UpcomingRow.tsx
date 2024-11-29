import { Premium } from "../../lib/types";
import { Button } from "../buttons/Button";
import { useNavigate } from "react-router-dom";
import { CairoOption } from "starknet";
import { feltToString, formatTime } from "../../lib/utils";
import useModel from "../../useModel.ts";
import { Models } from "../../generated/models.gen";
import { useGetTournamentDetailsQuery } from "@/hooks/useSdkQueries";

interface UpcomingRowProps {
  entityId: any;
  tournament_id?: any;
  name?: any;
  start_time?: any;
  end_time?: any;
  entry_premium?: any;
}

const UpcomingRow = ({
  entityId,
  tournament_id,
  name,
  start_time,
  end_time,
  entry_premium,
}: UpcomingRowProps) => {
  const { entities: tournamentDetails } =
    useGetTournamentDetailsQuery(tournament_id);
  const navigate = useNavigate();
  const startTimestamp = Number(start_time) * 1000;
  const startDate = new Intl.DateTimeFormat(undefined, {
    dateStyle: "medium",
    timeStyle: "short",
  }).format(new Date(startTimestamp));
  const tournamentEntries = tournamentDetails?.[0]?.TournamentEntriesModel;
  const tournamentPrizeKeys = tournamentDetails?.[0]?.TournamentPrizeKeysModel;
  return (
    <tr className="h-10">
      <td className="px-2">{feltToString(BigInt(name!))}</td>
      <td>{tournamentEntries?.entry_count ?? 0}</td>
      <td>{startDate}</td>
      <td>{formatTime(Number(end_time) - Number(start_time))}</td>
      <td>
        {entry_premium === "None"
          ? "-"
          : (entry_premium as CairoOption<Premium>).Some?.token_amount}
      </td>
      <td>
        {entry_premium === "None"
          ? "-"
          : (entry_premium as CairoOption<Premium>).Some?.creator_fee}
      </td>
      <td>
        <div className="flex flex-col gap-2">
          {tournamentPrizeKeys ? (
            tournamentPrizeKeys?.prize_keys.map((prizeKey) => {
              const prize = useModel(prizeKey.toString(), Models.PrizesModel);
              return (
                <div key={prizeKey}>
                  {prize?.token_data_type} {prize?.token}
                </div>
              );
            })
          ) : (
            <p>-</p>
          )}
        </div>
      </td>
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

export default UpcomingRow;
