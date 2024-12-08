import { useMemo } from "react";
import { useAccount } from "@starknet-react/core";
import { addAddressPadding } from "starknet";
import {
  useGetAccountCreatedTournamentsQuery,
  useGetAccountTournamentsQuery,
} from "@/hooks/useSdkQueries";
import CreatedTable from "@/components/myTournaments/CreatedTable";
import { Button } from "@/components/ui/button";

const MyTournaments = () => {
  const { account } = useAccount();
  const address = useMemo(
    () => addAddressPadding(account?.address ?? "0x0"),
    [account]
  );
  const { entities } = useGetAccountCreatedTournamentsQuery(address);
  return (
    <div className="flex flex-col gap-5 w-full p-4 uppercase no-text-shadow">
      <div className="flex flex-row items-center border border-terminal-green p-2 gap-2 uppercase">
        <p className="text-lg">Total Tournaments:</p>
        {/* <p className="text-2xl">{Number(tournamentCount ?? 0).toString()}</p> */}
      </div>
      <div className="flex flex-row gap-2 w-full py-4 uppercase h-[525px]">
        <div className="flex flex-col gap-5 w-1/2"></div>
        <div className="flex flex-col gap-5 w-1/2">
          <CreatedTable />
          <div className="w-full flex flex-col items-center border-4 border-terminal-green/75 h-1/2">
            <p className="text-4xl">Entered Tournaments</p>
            <div className="w-full max-h-[500px]">
              {/* <UpcomingTable /> */}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default MyTournaments;
