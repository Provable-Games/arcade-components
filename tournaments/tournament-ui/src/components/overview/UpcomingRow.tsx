import { Token } from "../../lib/types";
import { Button } from "../buttons/Button";
import { useNavigate } from "react-router-dom";

// First, define the props interface
interface UpcomingRowProps {
  id: string;
  name: string;
  entries: number;
  start: string;
  duration: string;
  entryFee: Token;
  creatorFee: number;
  prizes: Token[];
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
  const navigate = useNavigate();
  return (
    <tr className="h-10">
      <td className="px-2">{name}</td>
      <td>{entries}</td>
      <td>{start}</td>
      <td>{duration}</td>
      <td>{entryFee.amount}</td>
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
