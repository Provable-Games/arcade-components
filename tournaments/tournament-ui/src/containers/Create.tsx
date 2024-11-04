import { useState, ChangeEvent } from "react";
import { Button } from "../components/buttons/Button";
import { FormData } from "../lib/types";
import { DateTimePicker } from "../components/ui/datetime-picker";
import { PlusIcon } from "../components/Icons";
import useUIStore from "../hooks/useUIStore";

const Create = () => {
  const { setInputDialog } = useUIStore();
  const [formData, setFormData] = useState<FormData>({
    tournamentName: "",
    tournamentDescription: "",
    startTime: undefined,
    endTime: undefined,
    submissionPeriod: 0,
    scoreboardSize: 0,
    gatedToken: "",
    entryFree: "",
    prizes: [],
  });
  const [isMaxLength, setIsMaxLength] = useState(false);

  const handleChange = (
    e: ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>
  ) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: value.slice(0, 31),
    });
    if (name === "tournamentName" && value.length >= 31) {
      setIsMaxLength(true);
    } else {
      setIsMaxLength(false);
    }
  };

  const handleNameEntry = (name: string) => {
    setFormData({ ...formData, tournamentName: name });
  };

  return (
    <div className="flex flex-col gap-10 w-full p-4 uppercase">
      <h3 className="2xl:text-5xl text-center">Create Tournament</h3>
      <div className="flex flex-row gap-5">
        <div className="w-1/2 flex flex-col gap-5">
          <div className="relative items-center flex flex-row gap-2">
            <p className="2xl:text-4xl">Name</p>
            <input
              type="text"
              name="name"
              onChange={handleChange}
              className="p-1 m-2 2xl:h-8 2xl:w-96 2xl:text-2xl bg-terminal-black border border-terminal-green animate-pulse transform"
              maxLength={31}
            />
            {isMaxLength && (
              <p className="absolute top-10 sm:top-20">MAX LENGTH!</p>
            )}
          </div>
          <div className="relative flex flex-col gap-2">
            <p className="2xl:text-4xl">Description</p>
            <textarea
              name="description"
              onChange={handleChange}
              className="p-1 h-40 max-h-40 w-full 2xl:text-2xl bg-terminal-black border border-terminal-green transform"
            />
          </div>
          <div className="relative items-center flex flex-row gap-2">
            <span className="w-1/4">
              <p className="2xl:text-4xl">Start Time</p>
            </span>
            <DateTimePicker
              className="w-1/2 bg-terminal-black border border-terminal-green rounded-none hover:bg-terminal-green animate-none uppercase"
              granularity="minute"
              value={formData.startTime}
              onChange={(value) =>
                setFormData({ ...formData, startTime: value })
              }
            />
          </div>
          <div className="relative items-center flex flex-row gap-2">
            <span className="w-1/4">
              <p className="2xl:text-4xl">End Time</p>
            </span>
            <DateTimePicker
              className="w-1/2 bg-terminal-black border border-terminal-green rounded-none hover:bg-terminal-green animate-none uppercase"
              granularity="minute"
              value={formData.endTime}
              onChange={(value) => setFormData({ ...formData, endTime: value })}
            />
          </div>
        </div>
        <div className="w-1/2 flex flex-col gap-10">
          <div className="flex flex-row items-center gap-2">
            <p className="2xl:text-4xl">Submission Period</p>
            <Button variant="token">
              <p>1 HR</p>
            </Button>
            <Button variant="token">
              <p>6 HRS</p>
            </Button>
            <Button variant="token">
              <p>1 day</p>
            </Button>
            <input
              type="text"
              name="name"
              onChange={handleChange}
              className="p-1 m-2 w-20 h-8 2xl:text-2xl bg-terminal-black border border-terminal-green"
              maxLength={31}
              placeholder="Hours"
            />
            <Button variant="token">
              <span className="w-4 h-4">
                <PlusIcon />
              </span>
            </Button>
            {isMaxLength && (
              <p className="absolute top-10 sm:top-20">MAX LENGTH!</p>
            )}
          </div>
          <div className="flex flex-row items-center h-20 gap-10">
            <p className="2xl:text-4xl">Add Gating</p>
            <div className="flex flex-row gap-2">
              <Button
                variant="token"
                size="lg"
                onClick={() => setInputDialog("gated token")}
              >
                <p>Token</p>
              </Button>
              <Button
                variant="token"
                size="lg"
                onClick={() => setInputDialog("gated tournaments")}
              >
                <p>Tournament</p>
              </Button>
            </div>
          </div>
          <div className="flex flex-row items-center h-20 gap-2">
            <p className="2xl:text-4xl">Entry Fee</p>
            <Button
              className="m-5"
              variant="token"
              onClick={() => setInputDialog("entry fee")}
            >
              <span className="w-4 h-4">
                <PlusIcon />
              </span>
            </Button>
          </div>
          <div className="flex flex-row items-center gap-2">
            <p className="2xl:text-4xl">Prizes</p>
            <Button
              className="m-5"
              variant="token"
              onClick={() => setInputDialog("prize")}
            >
              <span className="w-4 h-4">
                <PlusIcon />
              </span>
            </Button>
          </div>
        </div>
      </div>
      <div className="hidden sm:flex items-center justify-center">
        <Button
          size={"lg"}
          disabled={!formData.tournamentName || formData.tournamentName === ""}
          onClick={() => handleNameEntry(formData.tournamentName)}
        >
          Create
        </Button>
      </div>
    </div>
  );
};

export default Create;
