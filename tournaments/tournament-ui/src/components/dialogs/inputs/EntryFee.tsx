import { Button } from "@/components/buttons/Button";
import { PlusIcon } from "@/components/Icons";

const EntryFee = () => {
  return (
    <div className="flex flex-col items-center justify-center">
      <div className="flex flex-row w-full items-center bg-terminal-green text-terminal-black h-10 px-5 justify-between">
        <div className="flex flex-row items-center gap-5">
          <p className="text-2xl uppercase">Select Token</p>
          <p>Gated Token can only be ERC20</p>
        </div>
        <div className="flex flex-row items-center gap-5">
          <p>Token not displaying?</p>
          <Button variant="token" className="hover:text-terminal-black">
            <p>Register Token</p>
          </Button>
        </div>
      </div>
      <div className="h-20 px-10 w-full flex flex-row items-center gap-5">
        <Button variant="token">Lords</Button>
        <Button variant="token">Eth</Button>
      </div>
      <div className="flex flex-row w-full items-center bg-terminal-green text-terminal-black h-10 px-5 justify-between">
        <p className="text-2xl uppercase">Add Amount</p>
      </div>
      <div className="h-20 px-10 w-full flex flex-row items-center justify-center gap-5">
        <div className="flex flex-row items-center gap-5">
          <Button variant="token">1</Button>
          <Button variant="token">5</Button>
          <Button variant="token">10</Button>
          <Button variant="token">100</Button>
          <div className="flex flex-row items-center gap-2">
            <p className="uppercase">Custom:</p>
            <input
              type="number"
              name="position"
              className="p-1 m-2 w-20 h-8 2xl:text-2xl bg-terminal-black border border-terminal-green"
            />
            <Button className="m-5 w-14" variant="token" onClick={() => {}}>
              <span className="w-4 h-4">
                <PlusIcon />
              </span>
            </Button>
          </div>
        </div>
      </div>
      <div className="flex flex-row w-full items-center bg-terminal-green text-terminal-black h-10 px-5 justify-between">
        <p className="text-2xl uppercase">Add Creator Fee</p>
      </div>
      <div className="h-20 px-10 w-full flex flex-row items-center justify-center gap-5">
        <div className="flex flex-row items-center gap-5">
          <Button variant="token">1%</Button>
          <Button variant="token">5%</Button>
          <Button variant="token">10%</Button>
          <Button variant="token">100%</Button>
          <div className="flex flex-row items-center gap-2">
            <p className="uppercase">Custom:</p>
            <input
              type="number"
              name="position"
              className="p-1 m-2 w-20 h-8 2xl:text-2xl bg-terminal-black border border-terminal-green"
            />
            <Button className="m-5 w-14" variant="token" onClick={() => {}}>
              <span className="w-4 h-4">
                <PlusIcon />
              </span>
            </Button>
          </div>
        </div>
      </div>
      <div className="flex flex-row w-full items-center bg-terminal-green text-terminal-black h-10 px-5 justify-between">
        <p className="text-2xl uppercase">Add Entry Criteria</p>
      </div>
      <div className="h-40 px-10 py-5 w-full flex flex-col justify-center items-center">
        <div className="flex flex-row gap-20">
          <div className="flex flex-col w-1/2">
            <p className="uppercase">Position</p>
            <div className="flex flex-row items-center gap-5">
              <Button variant="token">1st</Button>
              <Button variant="token">2nd</Button>
              <Button variant="token">3rd</Button>
              <input
                type="number"
                name="position"
                className="p-1 m-2 w-20 h-8 2xl:text-2xl bg-terminal-black border border-terminal-green"
                placeholder="POS"
              />
            </div>
          </div>
          <div className="flex flex-col w-1/2">
            <p className="uppercase">Share %</p>
            <div className="flex flex-row items-center gap-5">
              <Button variant="token">1%</Button>
              <Button variant="token">5%</Button>
              <Button variant="token">10%</Button>
              <input
                type="number"
                name="share"
                className="p-1 m-2 w-20 h-8 2xl:text-2xl bg-terminal-black border border-terminal-green"
                placeholder="SHARE"
              />
            </div>
          </div>
        </div>
        <Button className="m-5 w-20" variant="token" onClick={() => {}}>
          <span className="w-4 h-4">
            <PlusIcon />
          </span>
        </Button>
      </div>
      <Button variant="token" size="lg">
        Add Entry Fee
      </Button>
    </div>
  );
};

export default EntryFee;
