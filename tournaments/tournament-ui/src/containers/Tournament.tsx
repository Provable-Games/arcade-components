import ScoreRow from "../components/tournament/ScoreRow";

const Tournament = () => {
  const tournamentData = {
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
  };

  const scoreRows = [
    {
      rank: 1,
      address: "distracteddev",
      id: 6,
      level: 15,
      xp: 1000,
      deathTime: "10/10/2024 16:00",
      prizes: 1000,
    },
    {
      rank: 2,
      address: "distracteddev",
      id: 6,
      level: 15,
      xp: 1000,
      deathTime: "10/10/2024 16:00",
      prizes: 1000,
    },
    {
      rank: 3,
      address: "distracteddev",
      id: 6,
      level: 15,
      xp: 1000,
      deathTime: "10/10/2024 16:00",
      prizes: 1000,
    },
    {
      rank: 4,
      address: "distracteddev",
      id: 6,
      level: 15,
      xp: 1000,
      deathTime: "10/10/2024 16:00",
      prizes: 1000,
    },
    {
      rank: 5,
      address: "distracteddev",
      id: 6,
      level: 15,
      xp: 1000,
      deathTime: "10/10/2024 16:00",
      prizes: 1000,
    },
    {
      rank: 6,
      address: "distracteddev",
      id: 6,
      level: 15,
      xp: 1000,
      deathTime: "10/10/2024 16:00",
      prizes: 1000,
    },
    {
      rank: 7,
      address: "distracteddev",
      id: 6,
      level: 15,
      xp: 1000,
      deathTime: "10/10/2024 16:00",
      prizes: 1000,
    },
    {
      rank: 8,
      address: "distracteddev",
      id: 6,
      level: 15,
      xp: 1000,
      deathTime: "10/10/2024 16:00",
      prizes: 1000,
    },
  ];
  return (
    <div className="flex flex-col item-center w-full p-4 uppercase">
      <h1 className="text-5xl text-center">{tournamentData.name}</h1>
      <p className="text-4xl text-center text-red-500">Ended</p>
      <p className="text-center">
        This is the genesis tournament where players are competing for the
        Genesis Adventurer NFT. To qualify for the tournament you must hold an
        adventurer that at one point has come in the top 3 scores on the
        leaderboard.
      </p>
      <div className="flex flex-row gap-5">
        <div className="w-1/2 flex flex-col">
          <h2 className="text-4xl text-center">Scores</h2>
          <table className="w-full border border-terminal-green">
            <thead className="border border-terminal-green text-lg h-10">
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
              {scoreRows.map((row) => (
                <ScoreRow key={row.id} {...row} />
              ))}
            </tbody>
          </table>
        </div>
        <div className="w-1/2 flex flex-col">
          <div className="flex flex-row justify-between text-2xl">
            <p className="whitespace-nowrap">Entry Requirements</p>
            <p>SRVR</p>
          </div>
          <div className="flex flex-row justify-between text-2xl">
            <p className="whitespace-nowrap">Entry Fee</p>
            <p>100 LORDS</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Tournament;
