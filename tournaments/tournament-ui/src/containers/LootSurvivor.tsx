import { Button } from "@/components/buttons/Button";
import { useGetAdventurersQuery } from "@/hooks/useSdkQueries";
import { useDojoStore } from "@/hooks/useDojoStore";
import AdventurerCard from "@/components/lootSurvivor/AdventurerCard";

const LootSurvivor = () => {
  const { isLoading } = useGetAdventurersQuery();
  const state = useDojoStore((state) => state);
  const adventurers = state.getEntitiesByModel("tournament", "AdventurerModel");
  return (
    <div className="flex flex-col gap-5 w-full p-4 uppercase text-terminal-green/75 no-text-shadow">
      <h1 className="2xl:text-5xl text-center">Loot Survivor</h1>
      <div className="flex flex-col items-center gap-5">
        <p className="text-2xl">Adventurers</p>
        <div className="flex flex-row gap-2">
          {adventurers.length > 0 ? (
            adventurers.map((adventurer) => <AdventurerCard />)
          ) : (
            <p>No adventurers</p>
          )}
        </div>
        <div className="flex flex-row gap-10 w-full justify-center">
          <div className="flex flex-row items-center gap-5">
            <p className="text-2xl">Adventurer ID:</p>
            <input
              type="number"
              className="px-2 h-8 w-14 2xl:text-2xl bg-terminal-black border border-terminal-green transform"
            />
          </div>
          <div className="flex flex-row items-center gap-5">
            <p className="text-2xl">Score (XP):</p>
            <input
              type="number"
              className="px-2 h-8 w-20 2xl:text-2xl bg-terminal-black border border-terminal-green transform"
            />
          </div>
          <Button>Play</Button>
        </div>
      </div>
    </div>
  );
};

export default LootSurvivor;
