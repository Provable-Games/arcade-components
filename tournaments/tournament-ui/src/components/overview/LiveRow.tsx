// First, define the props interface
interface LiveRowProps {
  id: string;
  name: string;
  gamesPlayed: number;
  entries: number;
  topScores: number;
  prizes: number;
  timeLeft: string;
}

const LiveRow = ({
  id,
  name,
  gamesPlayed,
  entries,
  topScores,
  prizes,
  timeLeft,
}: LiveRowProps) => {
  return (
    <tr className="h-10">
      <td className="px-2">{name}</td>
      <td>{`${gamesPlayed} / ${entries}`}</td>
      <td>{topScores}</td>
      <td>{prizes}</td>
      <td>{timeLeft}</td>
    </tr>
  );
};

export default LiveRow;
