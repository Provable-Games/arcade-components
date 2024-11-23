import { useState, ChangeEvent } from "react";
import { Button } from "@/components/buttons/Button";
import useUIStore from "@/hooks/useUIStore";
import { CairoCustomEnum, CairoOption, CairoOptionVariant } from "starknet";

const GatedTournament = () => {
  const { setFormData, setInputDialog, formData } = useUIStore();
  const liveRows = [
    {
      id: 1,
      name: "Genesis Tournament",
      gamesPlayed: 1000,
      entries: 1000,
      topScores: "1: Await, 2: Await, 3: Await",
    },
    {
      id: 2,
      name: "Genesis Tournament",
      gamesPlayed: 1000,
      entries: 1000,
      topScores: "1: Await, 2: Await, 3: Await",
    },
    {
      id: 3,
      name: "Genesis Tournament",
      gamesPlayed: 1000,
      entries: 1000,
      topScores: "1: Await, 2: Await, 3: Await",
    },
    {
      id: 4,
      name: "Genesis Tournament",
      gamesPlayed: 1000,
      entries: 1000,
      topScores: "1: Await, 2: Await, 3: Await",
    },
    {
      id: 5,
      name: "Genesis Tournament",
      gamesPlayed: 1000,
      entries: 1000,
      topScores: "1: Await, 2: Await, 3: Await",
    },
    {
      id: 6,
      name: "Genesis Tournament",
      gamesPlayed: 1000,
      entries: 1000,
      topScores: "1: Await, 2: Await, 3: Await",
    },
    {
      id: 7,
      name: "Genesis Tournament",
      gamesPlayed: 1000,
      entries: 1000,
      topScores: "1: Await, 2: Await, 3: Await",
    },
    {
      id: 8,
      name: "Genesis Tournament",
      gamesPlayed: 1000,
      entries: 1000,
      topScores: "1: Await, 2: Await, 3: Await",
    },
  ];

  const [tournamentID, setTournamentID] = useState<number | null>(null);

  const handleTournamentIDChange = (e: ChangeEvent<HTMLInputElement>) => {
    const { value } = e.target;
    const parsedValue = parseInt(value);
    setTournamentID(isNaN(parsedValue) ? null : parsedValue);
  };

  return (
    <div className="flex flex-col gap-5 items-center justify-center">
      <div className="flex flex-row w-full items-center bg-terminal-green text-terminal-black h-10 px-5 justify-between">
        <div className="flex flex-row items-center gap-5">
          <p className="text-2xl uppercase">Select Tournament</p>
          <p>Tournaments must already be settled</p>
        </div>
      </div>
      <div className="px-10 w-full flex flex-row items-center gap-5">
        <table className="w-full border border-terminal-green">
          <thead className="border border-terminal-green text-lg h-10">
            <tr>
              <th className="px-2 text-left">Name</th>
              <th className="text-left">Entries</th>
              <th className="text-left">Games Played</th>
              <th className="text-left">Top Scores</th>
            </tr>
          </thead>
          <tbody>
            {liveRows.map((row) => (
              <tr className="h-2 border border-terminal-green">
                <td className="px-2">{row.name}</td>
                <td>{row.entries}</td>
                <td>{row.gamesPlayed}</td>
                <td>{row.topScores}</td>
                <td>
                  <Button
                    variant="outline"
                    onClick={() => setTournamentID(row.id)}
                  >
                    Select
                  </Button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <div className="flex flex-row items-center gap-5">
        <p className="uppercase">Enter Tournament ID</p>
        <input
          type="number"
          name="ID"
          className="p-1 m-2 w-20 h-8 2xl:text-2xl bg-terminal-black border border-terminal-green"
          onChange={handleTournamentIDChange}
        />
        {tournamentID && <p>Selected token: {tournamentID}</p>}
      </div>
      <Button
        variant="token"
        size="lg"
        disabled={!tournamentID}
        onClick={() => {
          const gatedTypeEnum = new CairoCustomEnum({
            token: undefined,
            tournament: [tournamentID!], // the active variant with the tournament ID array
            address: undefined,
          });

          const someGatedType = new CairoOption(
            CairoOptionVariant.Some,
            gatedTypeEnum
          );

          setFormData({
            ...formData,
            gatedType: someGatedType,
          });
          setInputDialog(null);
        }}
      >
        Add Gated Tournaments
      </Button>
    </div>
  );
};

export default GatedTournament;
