import UpcomingTable from "@/components/overview/UpcomingTable";
import LiveTable from "@/components/overview/LiveTable";
import EndTable from "@/components/overview/EndTable";
import { useDojoStore } from "@/hooks/useDojoStore";
import { ParsedEntity } from "@dojoengine/sdk";
import { SchemaType } from "@/generated/models.gen";
import { feltToString } from "@/lib/utils";

const Overview = () => {
  const state = useDojoStore((state) => state);
  const tournamentTotals = state.getEntitiesByModel(
    "tournament",
    "TournamentTotalsModel"
  );
  const tournaments = state.getEntitiesByModel("tournament", "TournamentModel");
  const tournamentCount =
    tournamentTotals[0]?.models?.tournament?.TournamentTotalsModel
      ?.total_tournaments;
  const nextTournament = tournaments.reduce(
    (earliest: ParsedEntity<SchemaType> | null, current) => {
      if (!earliest) return current;
      return earliest?.models?.tournament?.TournamentModel?.start_time! <
        current?.models?.tournament?.TournamentModel?.start_time!
        ? earliest
        : current;
    },
    null
  );
  const nextTournamentName =
    nextTournament?.models?.tournament?.TournamentModel?.name;

  return (
    <div className="flex flex-col">
      <div className="flex flex-row gap-5 justify-center">
        <div className="flex flex-row items-center border border-terminal-green p-2 gap-2 uppercase">
          <p className="text-terminal-green/75 no-text-shadow text-lg">
            Total Tournaments:
          </p>
          <p className="text-2xl">{Number(tournamentCount ?? 0).toString()}</p>
        </div>
        <div className="flex flex-row items-center border border-terminal-green p-2 gap-2 uppercase">
          <p className="text-terminal-green/75 no-text-shadow text-lg">
            Up Next:
          </p>
          <p className="text-2xl">
            {nextTournamentName
              ? feltToString(BigInt(nextTournamentName))
              : "None"}
          </p>
        </div>
      </div>
      <div className="flex flex-row gap-2 w-full py-4 uppercase h-[525px]">
        <UpcomingTable />
        <div className="w-2/5 flex flex-col gap-2">
          <LiveTable />
          <EndTable />
        </div>
      </div>
    </div>
  );
};

export default Overview;
