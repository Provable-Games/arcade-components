import { useGetEndedTournamentsQuery } from "@/hooks/useSdkQueries";
import EndRow from "@/components/overview/EndRow";

const EndTable = () => {
  // const [currentPage, setCurrentPage] = useState<number>(1);
  const hexTimestamp = (BigInt(new Date().getTime()) / 1000n).toString(16);
  const { entities: tournaments, isLoading } =
    useGetEndedTournamentsQuery(hexTimestamp);

  return (
    <div className="flex flex-col gap-4">
      <table className="w-full">
        <thead className="bg-terminal-green/75 no-text-shadow text-terminal-black text-lg h-10">
          <tr>
            <th className="px-2 text-left">Name</th>
            <th className="text-left">Games Played</th>
            <th className="text-left">Top Scores</th>
            <th className="text-left">Prizes</th>
            <th className="text-left">Time Left</th>
          </tr>
        </thead>
        <tbody>
          {tournaments && tournaments.length > 0 ? (
            tournaments.map((tournament) => {
              const tournamentModel = tournament.TournamentModel;
              return <EndRow key={tournament.entityId} {...tournamentModel} />;
            })
          ) : isLoading ? (
            <p>Loading...</p>
          ) : (
            <p>No tournaments found</p>
          )}
        </tbody>
      </table>
      {/* TODO: Add when pagination is available */}
      {/* {adventurerCount > 10 && (
        <div className="flex justify-center sm:mt-8 xl:mt-2">
          <Button
            variant={"outline"}
            onClick={() => currentPage > 1 && handleClick(currentPage - 1)}
            disabled={currentPage === 1}
          >
            back
          </Button>

          <Button
            variant={"outline"}
            key={1}
            onClick={() => handleClick(1)}
            className={currentPage === 1 ? "animate-pulse" : ""}
          >
            {1}
          </Button>

          <Button
            variant={"outline"}
            key={totalPages}
            onClick={() => handleClick(totalPages)}
            className={currentPage === totalPages ? "animate-pulse" : ""}
          >
            {totalPages}
          </Button>

          <Button
            variant={"outline"}
            onClick={() =>
              currentPage < totalPages && handleClick(currentPage + 1)
            }
            disabled={currentPage === totalPages}
          >
            next
          </Button>
        </div>
      )} */}
    </div>
  );
};

export default EndTable;
