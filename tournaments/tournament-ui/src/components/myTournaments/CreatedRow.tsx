import { Premium } from "../../lib/types";
import { getEntityIdFromKeys } from "@dojoengine/utils";
import { useNavigate } from "react-router-dom";
import { CairoOption } from "starknet";
import { feltToString } from "@/lib/utils";
import useModel from "../../useModel.ts";
import { Models, PrizesModel } from "../../generated/models.gen";
import { useGetTournamentDetailsQuery } from "@/hooks/useSdkQueries.ts";

interface CreatedRowProps {
  entityId: any;
  tournamentId?: any;
  name?: any;
  startTime?: any;
  endTime?: any;
  entryPremium?: any;
  entries?: any;
  prizeKeys?: any;
}

const CreatedRow = ({
  entityId,
  tournamentId,
  name,
  startTime,
  endTime,
  entryPremium,
  entries,
  prizeKeys,
}: CreatedRowProps) => {
  const navigate = useNavigate();
  const startTimestamp = Number(startTime) * 1000;
  const startDate = new Date(startTimestamp);
  const displayStartDate = new Intl.DateTimeFormat(undefined, {
    dateStyle: "medium",
    timeStyle: "short",
  }).format(startDate);
  const { entities: tournamentDetails } =
    useGetTournamentDetailsQuery(tournamentId);
  const entryIndex =
    tournamentDetails?.findIndex((detail) => detail.TournamentEntriesModel) ??
    -1;
  const tournamentEntries =
    tournamentDetails && entryIndex !== -1
      ? tournamentDetails[entryIndex].TournamentEntriesModel
      : { entry_count: 0 };

  const tournamentModel = useModel(entityId, Models.TournamentModel);

  // Calculate dates
  const endDate = new Date(Number(tournamentModel?.end_time) * 1000);
  const submissionEndDate = new Date(
    (Number(tournamentModel?.end_time) +
      Number(tournamentModel?.submission_period)) *
      1000
  );

  const started = Boolean(
    tournamentModel?.start_time && startDate.getTime() < Date.now()
  );
  const ended = Boolean(
    tournamentModel?.end_time && endDate.getTime() <= Date.now()
  );
  const submissionEnded = Boolean(
    tournamentModel?.submission_period &&
      submissionEndDate.getTime() <= Date.now()
  );

  const isLive = started && !ended;
  const isSubmissionLive = ended && !submissionEnded;
  const status = !started
    ? "Upcoming"
    : isLive
    ? "Live"
    : isSubmissionLive
    ? "Submission Live"
    : "Ended";
  return (
    <tr
      className="h-6 hover:bg-terminal-green/50 hover:cursor-pointer border border-terminal-green/50"
      onClick={() => {
        navigate(`/tournament/${Number(tournamentId)}`);
      }}
    >
      <td className="px-2 max-w-20">
        <p className="overflow-hidden whitespace-nowrap text-ellipsis">
          {feltToString(BigInt(name!))}
        </p>
      </td>
      <td className="text-xl">
        {BigInt(tournamentEntries?.entry_count ?? 0).toString()}
      </td>
      <td>{displayStartDate}</td>
      <td>{status}</td>
      <td>
        {entryPremium === "None"
          ? "-"
          : (entryPremium as CairoOption<Premium>).Some?.token_amount}
      </td>
      <td>
        {entryPremium === "None"
          ? "-"
          : (entryPremium as CairoOption<Premium>).Some?.creator_fee}
      </td>
      <td>
        <div className="flex flex-col gap-2">
          {prizeKeys ? (
            prizeKeys?.map((prizeKey: any) => {
              const entityId = getEntityIdFromKeys([BigInt(prizeKey)]);

              const prize: PrizesModel = useModel(entityId, Models.PrizesModel);
              // TODO: when token data type data is supported add the details
              return (
                <div key={prizeKey}>
                  {/* {prize?.token_data_type.variant.erc20?.token_amount} */}
                  {prize ? prize?.token_data_type.toString() : "-"}
                </div>
              );
            })
          ) : (
            <p>-</p>
          )}
        </div>
      </td>
    </tr>
  );
};

export default CreatedRow;
