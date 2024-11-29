import UpcomingTable from "@/components/overview/UpcomingTable";
import LiveTable from "@/components/overview/LiveTable";
import { useDojoStore } from "@/hooks/useDojoStore";

const Overview = () => {
  const state = useDojoStore((state) => state);
  const tournamentTotals = state.getEntitiesByModel(
    "tournament",
    "TournamentTotalsModel"
  );
  const tournamentCount =
    tournamentTotals[0].models.tournament.TournamentTotalsModel
      ?.total_tournaments;
  console.log(tournamentCount);
  return (
    <div className="flex flex-col">
      <div className="flex flex-row justify-center">
        <div className="flex flex-row border border-terminal-green p-2 gap-2 uppercase">
          <p>Total Tournaments:</p>
          <p>{Number(tournamentCount).toString()}</p>
        </div>
      </div>
      <div className="flex flex-row gap-5 w-full py-4 uppercase">
        <div className="w-3/5 flex flex-col items-center gap-5">
          <p className="text-4xl">Upcoming</p>
          <div className="w-full max-h-[500px]">
            <UpcomingTable />
          </div>
        </div>
        <div className="w-2/5 flex flex-col items-center gap-5">
          <p className="text-4xl">Live</p>
          <div className="w-full max-h-[500px]">
            <LiveTable />
          </div>
        </div>
      </div>
    </div>
  );
};

export default Overview;
