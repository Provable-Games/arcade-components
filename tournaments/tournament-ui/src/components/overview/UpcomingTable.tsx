import { useMemo, useState } from "react";
import { Button } from "@/components/buttons/Button";
import { useGetUpcomingTournamentsQuery } from "@/hooks/useSdkQueries";
import UpcomingRow from "@/components/overview/UpcomingRow";
import Pagination from "@/components/table/Pagination";

const UpcomingTable = () => {
  const [currentPage, setCurrentPage] = useState<number>(1);
  const hexTimestamp = useMemo(
    () => (BigInt(new Date().getTime()) / 1000n).toString(16),
    []
  );
  const { entities: tournaments, isLoading } =
    useGetUpcomingTournamentsQuery(hexTimestamp);

  // TODO: Remove handling of pagination within client for paginated queries
  // (get totalPages from the totals model)

  const totalPages = useMemo(() => {
    if (!tournaments) return 0;
    return Math.ceil(tournaments.length / 10);
  }, [tournaments]);

  const pagedTournaments = useMemo(() => {
    if (!tournaments) return [];
    return tournaments.slice((currentPage - 1) * 10, currentPage * 10);
  }, [tournaments, currentPage]);

  return (
    <div className="w-3/5 flex flex-col items-center border-4 border-terminal-green/75 h-full">
      <div className="flex flex-row items-center justify-between w-full">
        <div className="w-1/4"></div>
        <p className="w-1/2 text-4xl text-center">Upcoming</p>
        <div className="w-1/4 flex justify-end">
          {tournaments && tournaments.length > 10 && (
            <Pagination
              currentPage={currentPage}
              setCurrentPage={setCurrentPage}
              totalPages={totalPages}
            />
          )}
        </div>
      </div>
      <div className="w-full max-h-[500px]">
        <div className="flex flex-col gap-4">
          <table className="relative w-full">
            <thead className="bg-terminal-green/75 no-text-shadow text-terminal-black text-lg h-10">
              <tr>
                <th className="px-2 text-left">Name</th>
                <th className="text-left">Entries</th>
                <th className="text-left">Start</th>
                <th className="text-left">Duration</th>
                <th className="text-left">Entry Fee</th>
                <th className="text-left">Creator Fee</th>
                <th className="text-left">Prizes</th>
              </tr>
            </thead>
            <tbody>
              {tournaments && tournaments.length > 0 ? (
                pagedTournaments.map((tournament) => {
                  const tournamentModel = tournament.TournamentModel;
                  const tournamentEntries = tournament.TournamentEntriesModel;
                  const tournamentPrizeKeys =
                    tournament.TournamentPrizeKeysModel;
                  return (
                    <UpcomingRow
                      key={tournament.entityId}
                      tournamentId={tournamentModel?.tournament_id}
                      name={tournamentModel?.name}
                      startTime={tournamentModel?.start_time}
                      endTime={tournamentModel?.end_time}
                      entryPremium={tournamentModel?.entry_premium}
                      entries={tournamentEntries?.entry_count}
                      prizeKeys={tournamentPrizeKeys?.prize_keys}
                    />
                  );
                })
              ) : isLoading ? (
                <div className="absolute flex items-center justify-center w-full h-full">
                  <p className="text-2xl text-center">Loading...</p>
                </div>
              ) : (
                <div className="absolute flex items-center justify-center w-full h-full">
                  <p className="text-2xl text-center">
                    No Upcoming Tournaments
                  </p>
                </div>
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default UpcomingTable;
