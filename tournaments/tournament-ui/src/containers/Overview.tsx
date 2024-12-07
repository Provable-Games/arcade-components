import UpcomingTable from "@/components/overview/UpcomingTable";
import LiveTable from "@/components/overview/LiveTable";
import { useDojoStore } from "@/hooks/useDojoStore";
import { useGetAllTournamentsQuery } from "@/hooks/useSdkQueries";

const Overview = () => {
  const state = useDojoStore((state) => state);
  const tournamentTotals = state.getEntitiesByModel(
    "tournament",
    "TournamentTotalsModel"
  );
  const tournamentCount =
    tournamentTotals[0]?.models?.tournament?.TournamentTotalsModel
      ?.total_tournaments;
  return (
    <div className="flex flex-col">
      <div className="flex flex-row justify-center">
        <div className="flex flex-row items-center border border-terminal-green p-2 gap-2 uppercase">
          <p className="text-lg">Total Tournaments:</p>
          <p className="text-2xl">{Number(tournamentCount ?? 0).toString()}</p>
        </div>
      </div>
      <div className="flex flex-row gap-2 w-full py-4 uppercase h-[525px]">
        <div className="w-3/5 flex flex-col items-center border-4 border-terminal-green/75 h-full">
          <p className="text-4xl">Upcoming</p>
          <div className="w-full max-h-[500px]">
            <UpcomingTable />
          </div>
        </div>
        {/* <div className="w-2/5 flex flex-col gap-2">
          <div className="flex flex-col items-center border-4 border-terminal-green/75 h-1/2">
            <p className="text-4xl">Live</p>
            <div className="w-full max-h-[500px]">
              <LiveTable />
            </div>
          </div>
          <div className="flex flex-col items-center border-4 border-terminal-green/75 h-1/2">
            <p className="text-4xl">Ended</p>
            <div className="w-full max-h-[500px]">
              <LiveTable />
            </div>
          </div>
        </div> */}
      </div>
    </div>
  );
};

export default Overview;
