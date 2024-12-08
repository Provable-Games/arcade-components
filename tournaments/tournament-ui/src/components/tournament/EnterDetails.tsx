import { BigNumberish } from "starknet";
import { formatNumber } from "@/lib/utils";

interface EnterDetailsProps {
  lordsCost: BigNumberish;
}

const EnterDetails = ({ lordsCost }: EnterDetailsProps) => {
  return (
    <div className="flex flex-col gap-2">
      <p className="w-1/2 text-4xl text-center uppercase">Enter</p>
      <div className="flex flex-row">
        <div className="flex flex-col w-1/2">
          <div className="flex flex-row items-center gap-2">
            <p className="whitespace-nowrap uppercase text-xl">Entry Fee</p>
            <p className="text-terminal-green/75 no-text-shadow">100 LORDS</p>
          </div>
          <div className="flex flex-row items-center gap-2">
            <p className="whitespace-nowrap uppercase text-xl">
              Entry Requirements
            </p>
            <p className="text-terminal-green/75 no-text-shadow">
              Hold any SRVR
            </p>
          </div>
        </div>
        <div className="flex flex-col w-1/2">
          <div className="flex flex-row items-center gap-2">
            <p className="text-xl uppercase">Game Cost</p>
            <p className="text-terminal-green/75 no-text-shadow">
              {formatNumber(
                Number(BigInt(lordsCost) / BigInt(10) ** BigInt(18))
              )}{" "}
              LORDS
            </p>
          </div>
          <div className="flex flex-row items-center gap-2">
            <p className="text-xl uppercase">VRF Cost</p>
            <p className="text-terminal-green/75 no-text-shadow">$0.50</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default EnterDetails;
