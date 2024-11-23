import { Premium, Prize } from "../../lib/types";
import { Button } from "../buttons/Button";
import { useNavigate } from "react-router-dom";
import { CairoOption } from "starknet";
import { feltToString } from "../../lib/utils";

// First, define the props interface
interface UpcomingRowProps {
  id: bigint;
  name: bigint;
  entries: number;
  start: string;
  duration: number;
  entryFee: CairoOption<Premium> | string;
  creatorFee: number;
  prizes: Prize[];
}

const UpcomingRow = ({
  id,
  name,
  entries,
  start,
  duration,
  entryFee,
  creatorFee,
  prizes,
}: UpcomingRowProps) => {
  console.log(id);
  const navigate = useNavigate();
  return (
    <tr className="h-10">
      <td className="px-2">{feltToString(name)}</td>
      <td>{entries}</td>
      <td>{start}</td>
      <td>{duration}</td>
      <td>{(entryFee as CairoOption<Premium>).Some?.token_amount}</td>
      <td>{creatorFee}</td>
      <td>
        <div className="flex flex-col gap-2">
          {prizes.map((prize) => {
            return (
              <div key={prize.token}>
                {prize.amount} {prize.token}
              </div>
            );
          })}
        </div>
      </td>
      <td>
        <Button
          variant="outline"
          onClick={() => {
            navigate(`/tournament/${id}`);
          }}
        >
          View
        </Button>
      </td>
    </tr>
  );
};

export default UpcomingRow;
