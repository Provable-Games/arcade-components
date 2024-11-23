import { useEffect } from "react";
import UpcomingRow from "../components/overview/UpcomingRow";
import LiveRow from "../components/overview/LiveRow";
import { useSDK } from "../context/sdk";
import { useDojoStore } from "../hooks/useDojoStore";

const Overview = () => {
  const sdk = useSDK();

  const state = useDojoStore((state) => state);
  const entities = useDojoStore((state) => state.entities);

  useEffect(() => {
    const fetchEntities = async () => {
      try {
        await sdk.getEntities(
          {
            tournament: {
              TournamentModel: {
                $: {
                  where: {
                    tournament_id: {
                      $gt: BigInt(0),
                    },
                  },
                },
              },
            },
          },
          (resp) => {
            console.log(resp);
            if (resp.error) {
              console.error("resp.error.message:", resp.error.message);
              return;
            }
            if (resp.data) {
              state.setEntities(resp.data);
            }
          }
        );
      } catch (error) {
        console.error("Error querying entities:", error);
      }
    };

    fetchEntities();
  }, [sdk]);

  console.log(entities);

  const upcomingRows = [
    {
      id: "1",
      name: "Genesis Tournament",
      entries: 1000,
      start: "10/10/2024",
      duration: "10 days",
      entryFee: {
        token: "LORDS",
        amount: 1000,
      },
      creatorFee: 1000,
      prizes: [
        {
          token: "LORDS",
          amount: 1000,
        },
      ],
    },
    {
      id: "1",
      name: "Genesis Tournament",
      entries: 1000,
      start: "10/10/2024",
      duration: "10 days",
      entryFee: {
        token: "LORDS",
        amount: 1000,
      },
      creatorFee: 1000,
      prizes: [
        {
          token: "LORDS",
          amount: 1000,
        },
      ],
    },
    {
      id: "1",
      name: "Genesis Tournament",
      entries: 1000,
      start: "10/10/2024",
      duration: "10 days",
      entryFee: {
        token: "LORDS",
        amount: 1000,
      },
      creatorFee: 1000,
      prizes: [
        {
          token: "LORDS",
          amount: 1000,
        },
      ],
    },
    {
      id: "1",
      name: "Genesis Tournament",
      entries: 1000,
      start: "10/10/2024",
      duration: "10 days",
      entryFee: {
        token: "LORDS",
        amount: 1000,
      },
      creatorFee: 1000,
      prizes: [
        {
          token: "LORDS",
          amount: 1000,
        },
      ],
    },
    {
      id: "1",
      name: "Genesis Tournament",
      entries: 1000,
      start: "10/10/2024",
      duration: "10 days",
      entryFee: {
        token: "LORDS",
        amount: 1000,
      },
      creatorFee: 1000,
      prizes: [
        {
          token: "LORDS",
          amount: 1000,
        },
      ],
    },
    {
      id: "1",
      name: "Genesis Tournament",
      entries: 1000,
      start: "10/10/2024",
      duration: "10 days",
      entryFee: {
        token: "LORDS",
        amount: 1000,
      },
      creatorFee: 1000,
      prizes: [
        {
          token: "LORDS",
          amount: 1000,
        },
      ],
    },
    {
      id: "1",
      name: "Genesis Tournament",
      entries: 1000,
      start: "10/10/2024",
      duration: "10 days",
      entryFee: {
        token: "LORDS",
        amount: 1000,
      },
      creatorFee: 1000,
      prizes: [
        {
          token: "LORDS",
          amount: 1000,
        },
      ],
    },
    {
      id: "1",
      name: "Genesis Tournament",
      entries: 1000,
      start: "10/10/2024",
      duration: "10 days",
      entryFee: {
        token: "LORDS",
        amount: 1000,
      },
      creatorFee: 1000,
      prizes: [
        {
          token: "LORDS",
          amount: 1000,
        },
      ],
    },
    {
      id: "1",
      name: "Genesis Tournament",
      entries: 1000,
      start: "10/10/2024",
      duration: "10 days",
      entryFee: {
        token: "LORDS",
        amount: 1000,
      },
      creatorFee: 1000,
      prizes: [
        {
          token: "LORDS",
          amount: 1000,
        },
      ],
    },
    {
      id: "1",
      name: "Genesis Tournament",
      entries: 1000,
      start: "10/10/2024",
      duration: "10 days",
      entryFee: {
        token: "LORDS",
        amount: 1000,
      },
      creatorFee: 1000,
      prizes: [
        {
          token: "LORDS",
          amount: 1000,
        },
      ],
    },
    {
      id: "1",
      name: "Genesis Tournament",
      entries: 1000,
      start: "10/10/2024",
      duration: "10 days",
      entryFee: {
        token: "LORDS",
        amount: 1000,
      },
      creatorFee: 1000,
      prizes: [
        {
          token: "LORDS",
          amount: 1000,
        },
      ],
    },
    {
      id: "1",
      name: "Genesis Tournament",
      entries: 1000,
      start: "10/10/2024",
      duration: "10 days",
      entryFee: {
        token: "LORDS",
        amount: 1000,
      },
      creatorFee: 1000,
      prizes: [
        {
          token: "LORDS",
          amount: 1000,
        },
      ],
    },
    {
      id: "1",
      name: "Genesis Tournament",
      entries: 1000,
      start: "10/10/2024",
      duration: "10 days",
      entryFee: {
        token: "LORDS",
        amount: 1000,
      },
      creatorFee: 1000,
      prizes: [
        {
          token: "LORDS",
          amount: 1000,
        },
      ],
    },
    {
      id: "1",
      name: "Genesis Tournament",
      entries: 1000,
      start: "10/10/2024",
      duration: "10 days",
      entryFee: {
        token: "LORDS",
        amount: 1000,
      },
      creatorFee: 1000,
      prizes: [
        {
          token: "LORDS",
          amount: 1000,
        },
      ],
    },
  ];

  const liveRows = [
    {
      id: "1",
      name: "Genesis Tournament",
      gamesPlayed: 1000,
      entries: 1000,
      topScores: 1000,
      prizes: 1000,
      timeLeft: "10 days",
    },
    {
      id: "1",
      name: "Genesis Tournament",
      gamesPlayed: 1000,
      entries: 1000,
      topScores: 1000,
      prizes: 1000,
      timeLeft: "10 days",
    },
    {
      id: "1",
      name: "Genesis Tournament",
      gamesPlayed: 1000,
      entries: 1000,
      topScores: 1000,
      prizes: 1000,
      timeLeft: "10 days",
    },
    {
      id: "1",
      name: "Genesis Tournament",
      gamesPlayed: 1000,
      entries: 1000,
      topScores: 1000,
      prizes: 1000,
      timeLeft: "10 days",
    },
    {
      id: "1",
      name: "Genesis Tournament",
      gamesPlayed: 1000,
      entries: 1000,
      topScores: 1000,
      prizes: 1000,
      timeLeft: "10 days",
    },
    {
      id: "1",
      name: "Genesis Tournament",
      gamesPlayed: 1000,
      entries: 1000,
      topScores: 1000,
      prizes: 1000,
      timeLeft: "10 days",
    },
    {
      id: "1",
      name: "Genesis Tournament",
      gamesPlayed: 1000,
      entries: 1000,
      topScores: 1000,
      prizes: 1000,
      timeLeft: "10 days",
    },
    {
      id: "1",
      name: "Genesis Tournament",
      gamesPlayed: 1000,
      entries: 1000,
      topScores: 1000,
      prizes: 1000,
      timeLeft: "10 days",
    },
    {
      id: "1",
      name: "Genesis Tournament",
      gamesPlayed: 1000,
      entries: 1000,
      topScores: 1000,
      prizes: 1000,
      timeLeft: "10 days",
    },
    {
      id: "1",
      name: "Genesis Tournament",
      gamesPlayed: 1000,
      entries: 1000,
      topScores: 1000,
      prizes: 1000,
      timeLeft: "10 days",
    },
    {
      id: "1",
      name: "Genesis Tournament",
      gamesPlayed: 1000,
      entries: 1000,
      topScores: 1000,
      prizes: 1000,
      timeLeft: "10 days",
    },
  ];

  return (
    <div className="flex flex-row gap-5 w-full py-4 uppercase">
      <div className="w-3/5 flex flex-col items-center gap-5">
        <p className="text-4xl">Upcoming</p>
        <div className="w-full max-h-[500px]">
          <table className="w-full border border-terminal-green">
            <thead className="border border-terminal-green text-lg h-10">
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
              {Object.entries(entities).map(([entityId, entity]) => {
                const tournament = entity.models.tournament.TournamentModel;
                console.log(tournament);
                return (
                  <UpcomingRow
                    key={entityId}
                    id={tournament?.tournament_id!}
                    name={tournament?.name!}
                    duration={
                      parseInt(tournament?.start_time?.toString()!) -
                      parseInt(tournament?.end_time?.toString()!)
                    }
                    entryFee={tournament?.entry_premium!}
                  />
                );
              })}
            </tbody>
          </table>
        </div>
      </div>
      <div className="w-2/5 flex flex-col items-center gap-5">
        <p className="text-4xl">Live</p>
        <table className="w-full border border-terminal-green">
          <thead className="border border-terminal-green text-lg h-10">
            <tr>
              <th className="px-2 text-left">Name</th>
              <th className="text-left">Games Played</th>
              <th className="text-left">Top Scores</th>
              <th className="text-left">Prizes</th>
              <th className="text-left">Time Left</th>
            </tr>
          </thead>
          <tbody>
            {liveRows.map((row) => (
              <LiveRow key={row.name} {...row} />
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default Overview;
