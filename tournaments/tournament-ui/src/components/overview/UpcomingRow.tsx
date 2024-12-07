import { Premium } from "../../lib/types";
import { getEntityIdFromKeys } from "@dojoengine/utils";
import { useNavigate } from "react-router-dom";
import { CairoOption } from "starknet";
import { feltToString, formatTime } from "../../lib/utils";
import useModel from "../../useModel.ts";
import { Models, PrizesModel } from "../../generated/models.gen";

interface UpcomingRowProps {
  tournamentId?: any;
  name?: any;
  startTime?: any;
  endTime?: any;
  entryPremium?: any;
  entries?: any;
  prizeKeys?: any;
}

const UpcomingRow = ({
  tournamentId,
  name,
  startTime,
  endTime,
  entryPremium,
  entries,
  prizeKeys,
}: UpcomingRowProps) => {
  const navigate = useNavigate();
  const startTimestamp = Number(startTime) * 1000;
  const startDate = new Intl.DateTimeFormat(undefined, {
    dateStyle: "medium",
    timeStyle: "short",
  }).format(new Date(startTimestamp));
  console.log(prizeKeys);
  return (
    <tr
      className="h-10 hover:bg-terminal-green/50 hover:cursor-pointer border border-terminal-green/50"
      onClick={() => {
        navigate(`/tournament/${Number(tournamentId)}`);
      }}
    >
      <td className="px-2 max-w-20">
        <p className="overflow-hidden whitespace-nowrap text-ellipsis">
          {feltToString(BigInt(name!))}
        </p>
      </td>
      <td className="text-xl">{BigInt(entries ?? 0).toString()}</td>
      <td>{startDate}</td>
      <td>{formatTime(Number(endTime) - Number(startTime))}</td>
      <td>
        {entryPremium === "None"
          ? "-"
          : (entryPremium as CairoOption<Premium>).Some?.token_amount}
      </td>
      <td>
        {entryPremium === "None"
          ? "-"
          : (entryPremium as CairoOption<Premium>).Some?.creator_fee}
      </td>
      <td>
        <div className="flex flex-col gap-2">
          {prizeKeys ? (
            prizeKeys?.map((prizeKey: any) => {
              const entityId = getEntityIdFromKeys([BigInt(prizeKey)]);

              const prize: PrizesModel = useModel(entityId, Models.PrizesModel);
              // TODO: when token data type data is supported add the details
              return (
                <div key={prizeKey}>
                  {/* {prize?.token_data_type.variant.erc20?.token_amount} */}
                  {prize ? prize?.token_data_type.toString() : "-"}
                </div>
              );
            })
          ) : (
            <p>-</p>
          )}
        </div>
      </td>
    </tr>
  );
};

export default UpcomingRow;
