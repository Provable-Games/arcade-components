import { useEffect, useState } from "react";

const formatTime = (totalSeconds: number) => {
  const days = Math.floor(totalSeconds / 86400);
  const hours = Math.floor(totalSeconds / 3600);
  const minutes = Math.floor((totalSeconds - hours * 3600) / 60);
  const seconds = totalSeconds % 60;
  return (
    <div className="flex flex-row no-text-shadow">
      <div className="relative flex flex-col ">
        <span className="absolute top-[-20px] text-terminal-green/75 no-text-shadow text-2xl">
          D
        </span>
        <span>{`${days.toString().padStart(2, "0")}:`}</span>
      </div>
      <div className="relative flex flex-col">
        <span className="absolute top-[-20px] text-terminal-green/75 no-text-shadow text-2xl">
          H
        </span>
        <span>{`${hours.toString().padStart(2, "0")}:`}</span>
      </div>
      <div className="relative flex flex-col">
        <span className="absolute top-[-20px] text-terminal-green/75 no-text-shadow text-2xl">
          M
        </span>
        <span>{`${minutes.toString().padStart(2, "0")}:`}</span>
      </div>
      <div className="relative flex flex-col">
        <span className="absolute top-[-20px] text-terminal-green/75 no-text-shadow text-2xl">
          S
        </span>
        <span>{`${seconds.toString().padStart(2, "0")}`}</span>
      </div>
    </div>
  );
};

export interface CountdownProps {
  targetTime: number | null;
  countDownExpired: () => void;
}

export const Countdown = ({ targetTime, countDownExpired }: CountdownProps) => {
  const [seconds, setSeconds] = useState(0);
  useEffect(() => {
    if (targetTime) {
      const updateCountdown = () => {
        const currentTime = new Date().getTime();
        const timeRemaining = targetTime - currentTime;
        setSeconds(Math.floor(timeRemaining / 1000));

        if (timeRemaining <= 0) {
          countDownExpired(); // Call the countDownExpired function when countdown expires
        } else {
          setSeconds(Math.floor(timeRemaining / 1000));
        }
      };

      updateCountdown();
      const interval = setInterval(updateCountdown, 1000);

      return () => {
        clearInterval(interval);
      };
    }
  }, [targetTime]);
  return (
    <div className="h-1/4 flex items-center justify-center">
      <span className="flex flex-col gap-1 items-center justify-center">
        {targetTime ? (
          <>
            <p
              className={`text-4xl ${
                seconds < 10
                  ? "animate-pulse text-terminal-green"
                  : "text-terminal-green"
              }`}
            >
              {formatTime(seconds)}
            </p>
          </>
        ) : (
          <p className="text-6xl animate-pulse text-terminal-yellow">Loading</p>
        )}
      </span>
    </div>
  );
};
