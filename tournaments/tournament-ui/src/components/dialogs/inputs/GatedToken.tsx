import { Button } from "@/components/buttons/Button";
import { PlusIcon } from "@/components/Icons";

const GatedToken = () => {
  return (
    <div className="flex flex-col items-center justify-center">
      <div className="flex flex-row w-full items-center bg-terminal-green text-terminal-black h-10 px-5 justify-between">
        <div className="flex flex-row items-center gap-5">
          <p className="text-2xl uppercase">Select Token</p>
          <p>Gated Token can only be ERC721</p>
        </div>
        <div className="flex flex-row items-center gap-5">
          <p>Token not displaying?</p>
          <Button variant="token" className="hover:text-terminal-black">
            <p>Register Token</p>
          </Button>
        </div>
      </div>
      <div className="h-28 px-10 w-full flex flex-row items-center gap-5">
        <Button variant="token">Blobert</Button>
        <Button variant="token">Survivor</Button>
      </div>
      <div className="flex flex-row w-full items-center bg-terminal-green text-terminal-black h-10 px-5 justify-between">
        <p className="text-2xl uppercase">Entry Type</p>
      </div>
      <div className="h-20 px-10 w-full flex flex-row items-center justify-center gap-5">
        <Button variant="token" size="lg">
          Uniform
        </Button>
        <Button variant="token" size="lg">
          Entry Criteria
        </Button>
      </div>
      <div className="flex flex-row w-full items-center bg-terminal-green text-terminal-black h-10 px-5 justify-between">
        <p className="text-2xl uppercase">Add Entry Criteria</p>
      </div>
      <div className="h-40 px-10 py-5 w-full flex flex-col justify-center items-center">
        <div className="flex flex-row gap-20">
          <div className="flex flex-row items-center gap-5">
            <p className="uppercase">Token ID</p>
            <input
              type="number"
              name="position"
              className="p-1 m-2 w-20 h-8 2xl:text-2xl bg-terminal-black border border-terminal-green"
            />
          </div>
          <div className="flex flex-row items-center gap-5">
            <p className="uppercase">Number of Entries</p>
            <input
              type="number"
              name="share"
              className="p-1 m-2 w-20 h-8 2xl:text-2xl bg-terminal-black border border-terminal-green"
            />
          </div>
        </div>
        <Button className="m-5 w-20" variant="token" onClick={() => {}}>
          <span className="w-4 h-4">
            <PlusIcon />
          </span>
        </Button>
      </div>
      <Button variant="token" size="lg">
        Add Entry Criteria
      </Button>
    </div>
  );
};

export default GatedToken;
