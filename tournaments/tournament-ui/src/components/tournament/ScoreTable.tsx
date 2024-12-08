import { useMemo, useState } from "react";
import Pagination from "@/components/table/Pagination";
import ScoreRow from "@/components/tournament/ScoreRow";
import { useDojo } from "@/DojoContext";

interface ScoreTableProps {
  tournamentScores: any;
  adventurersData: any;
}

const ScoreTable = ({ tournamentScores, adventurersData }: ScoreTableProps) => {
  const {
    setup: { selectedChainConfig },
  } = useDojo();
  const isMainnet = selectedChainConfig.chainId === "SN_MAINNET";
  const [currentPage, setCurrentPage] = useState(1);
  const totalPages = useMemo(() => {
    if (!tournamentScores) return 0;
    return Math.ceil(tournamentScores.top_score_ids.length / 10);
  }, [tournamentScores]);

  const pagedScores = useMemo(() => {
    if (!tournamentScores) return [];
    return tournamentScores.top_score_ids.slice(
      (currentPage - 1) * 10,
      currentPage * 10
    );
  }, [tournamentScores, currentPage]);

  return (
    <div className="w-1/2 flex flex-col border-4 border-terminal-green/75">
      <div className="flex flex-row items-center justify-between w-full">
        <div className="w-1/4"></div>
        <p className="w-1/2 text-4xl text-center uppercase">Upcoming</p>
        <div className="w-1/4 flex justify-end">
          {tournamentScores && tournamentScores.length > 10 && (
            <Pagination
              currentPage={currentPage}
              setCurrentPage={setCurrentPage}
              totalPages={totalPages}
            />
          )}
        </div>
      </div>
      <table className="w-full">
        <thead className="bg-terminal-green/75 text-terminal-black text-lg h-10 uppercase">
          <tr>
            <th className="text-center">Name</th>
            <th className="text-left">Address</th>
            <th className="text-left">ID</th>
            <th className="text-left">Level</th>
            <th className="text-left">XP</th>
            <th className="text-left">Death Time</th>
            <th className="text-left">Prizes</th>
          </tr>
        </thead>
        <tbody>
          {tournamentScores && tournamentScores.top_score_ids.length > 0 ? (
            pagedScores.map((gameId: any, index: any) => {
              const adventurer = isMainnet
                ? adventurersData.find(
                    (adventurer: any) => adventurer.adventurer_id === gameId
                  )
                : adventurersData.find(
                    (entity: any) =>
                      entity.models.tournament.AdventurerModel.adventurer_id ===
                      gameId
                  );
              return (
                <ScoreRow
                  key={index}
                  gameId={gameId}
                  rank={index + 1}
                  adventurer={adventurer}
                />
              );
            })
          ) : (
            <p className="text-center">No Scores Submitted</p>
          )}
        </tbody>
      </table>
    </div>
  );
};

export default ScoreTable;
