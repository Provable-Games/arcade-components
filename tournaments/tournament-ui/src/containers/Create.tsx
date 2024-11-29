import { useState, ChangeEvent } from "react";
import { Button } from "../components/buttons/Button";
import { Tournament } from "../lib/types";
import { DateTimePicker } from "../components/ui/datetime-picker";
import { PlusIcon, TrophyIcon, CloseIcon, InfoIcon } from "../components/Icons";
import useUIStore from "../hooks/useUIStore";
import { useSystemCalls } from "@/useSystemCalls";
import { stringToFelt, byteArrayFromString, formatTime } from "../lib/utils";
import EntryCriteriaDialog from "../components/dialogs/EntryCriteria";
import EntryFeeBox from "../components/create/EntryFeeBox";
import PrizeBoxes from "@/components/create/PrizeBoxes";
import { CairoOption, CairoOptionVariant } from "starknet";
import { useDojoStore } from "@/hooks/useDojoStore";

const Create = () => {
  const { formData, setFormData, setInputDialog } = useUIStore();
  const [showEntryCriteria, setShowEntryCriteria] = useState(false);

  const state = useDojoStore((state) => state);
  const { createTournament, addPrize } = useSystemCalls();

  const [isMaxLength, setIsMaxLength] = useState(false);
  const [overMaxSubmission, setOverMaxSubmission] = useState(false);

  const handleChangeName = (e: ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: value,
    });
    if (name === "tournamentName" && value.length >= 31) {
      setIsMaxLength(true);
    } else {
      setIsMaxLength(false);
    }
  };

  const handleChangeDescription = (e: ChangeEvent<HTMLTextAreaElement>) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: value,
    });
  };

  const handleChangeSubmissionPeriod = (e: ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    const submissionPeriodSeconds = parseInt(value) * 60 * 60;
    setFormData({
      ...formData,
      [name]: submissionPeriodSeconds,
    });
    if (parseInt(value) > 336) {
      setOverMaxSubmission(true);
    } else {
      setOverMaxSubmission(false);
    }
  };

  const handleChangeScoreboardSize = (e: ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: value,
    });
  };

  const handleCreateTournament = async () => {
    const tournament: Tournament = {
      name: parseInt(stringToFelt(formData.tournamentName).toString()),
      description: byteArrayFromString(formData.tournamentDescription),
      start_time: formData.startTime
        ? Math.floor(
            formData.startTime.getTime() / 1000 -
              formData.startTime.getTimezoneOffset() * 60
          )
        : 0,
      end_time: formData.endTime
        ? Math.floor(
            formData.endTime.getTime() / 1000 -
              formData.endTime.getTimezoneOffset() * 60
          )
        : 0,
      submission_period: formData.submissionPeriod,
      winners_count: formData.scoreboardSize,
      gated_type: formData.gatedType,
      entry_premium: formData.entryFee,
    };
    await createTournament(tournament);
    const tournamentCountModel = state.getEntitiesByModel(
      "tournament",
      "TournamentTotalsModel"
    );
    const tournamentCount = BigInt(
      tournamentCountModel[0]?.models?.tournament?.TournamentTotalsModel
        ?.total_tournaments!
    );
    console.log(tournamentCount);
    // Add prizes sequentially
    for (const prize of formData.prizes) {
      await addPrize(tournamentCount, prize);
    }
  };

  const renderGatedTokenValue = () => {
    let gatedEntryToken = formData.gatedType.Some?.variant.token?.token;
    let uniformEntries =
      formData.gatedType.Some?.variant.token?.entry_type.variant.uniform;
    let entryCriteria =
      formData.gatedType.Some?.variant.token?.entry_type.variant.criteria;
    let uniformActive =
      formData.gatedType.Some?.variant.token?.entry_type.activeVariant();
    return (
      <span className="flex flex-row items-center gap-2 w-20">
        <p>{gatedEntryToken}</p>
        <span className="absolute bottom-0 text-sm">
          {uniformActive === "uniform" ? (
            `${uniformEntries} entries`
          ) : (
            <span className="flex flex-row items-center gap-2 ">
              <p className="whitespace-nowrap">
                {entryCriteria!.length} criteria
              </p>
              <span
                className="w-4 h-4 cursor-pointer"
                onClick={() => setShowEntryCriteria(!showEntryCriteria)}
              >
                <InfoIcon />
              </span>
            </span>
          )}
        </span>
      </span>
    );
  };

  return (
    <div className="flex flex-col gap-5 w-full p-4 uppercase text-terminal-green/75 no-text-shadow">
      {showEntryCriteria && (
        <EntryCriteriaDialog
          setShowEntryCriteria={setShowEntryCriteria}
          entryCriteria={
            formData.gatedType.Some?.variant.token?.entry_type.variant.criteria!
          }
        />
      )}
      <h3 className="2xl:text-5xl text-center">Create Tournament</h3>
      <div className="flex flex-row gap-5">
        <div className="w-1/2 flex flex-col gap-2">
          <div className="relative flex flex-col gap-2">
            <p className="2xl:text-4xl">Name</p>
            <input
              type="text"
              name="tournamentName"
              onChange={handleChangeName}
              className="ml-16 mt-2 px-2 2xl:h-8 2xl:w-96 2xl:text-2xl bg-terminal-black border border-terminal-green animate-pulse transform"
              maxLength={31}
            />
            {isMaxLength && (
              <p className="absolute top-10 sm:top-20">MAX LENGTH!</p>
            )}
          </div>
          <div className="relative flex flex-col gap-2">
            <p className="2xl:text-4xl">Description</p>
            <textarea
              name="tournamentDescription"
              onChange={handleChangeDescription}
              className="ml-16 mt-2 px-2 h-40 max-h-40 w-[500px] 2xl:text-2xl bg-terminal-black border border-terminal-green transform"
            />
          </div>
          <div className="flex flex-col gap-2">
            <div className="flex flex-row items-center gap-5">
              <p className="2xl:text-4xl">Duration</p>
              {formData.startTime && formData.endTime && (
                <p className="text-2xl">
                  {formatTime(
                    (formData.endTime.getTime() -
                      formData.startTime.getTime()) /
                      1000
                  )}
                </p>
              )}
            </div>
            <div className="flex flex-row">
              <div className="flex flex-col w-1/2">
                <p className="text-xl">Start</p>
                <DateTimePicker
                  className="w-3/4 bg-terminal-black border border-terminal-green rounded-none hover:bg-terminal-green animate-none uppercase"
                  granularity="minute"
                  value={formData.startTime}
                  showOutsideDays={false}
                  onChange={(value) =>
                    setFormData({ ...formData, startTime: value })
                  }
                />
              </div>
              <div className="flex flex-col w-1/2">
                <p className="text-xl">End</p>
                <DateTimePicker
                  className="w-3/4 bg-terminal-black border border-terminal-green rounded-none hover:bg-terminal-green animate-none uppercase"
                  granularity="minute"
                  value={formData.endTime}
                  showOutsideDays={false}
                  onChange={(value) =>
                    setFormData({ ...formData, endTime: value })
                  }
                />
              </div>
            </div>
            <div className="relative flex flex-row items-center justify-between">
              <div className="flex flex-row items-center gap-2">
                <p className="text-xl">Submission Period</p>
                <div className="flex flex-row items-center gap-2">
                  <Button
                    variant={
                      formData.submissionPeriod === 3600 ? "default" : "token"
                    }
                    onClick={() =>
                      setFormData({ ...formData, submissionPeriod: 3600 })
                    }
                  >
                    <p>1 HR</p>
                  </Button>
                  <Button
                    variant={
                      formData.submissionPeriod === 21600 ? "default" : "token"
                    }
                    onClick={() =>
                      setFormData({ ...formData, submissionPeriod: 21600 })
                    }
                  >
                    <p>6 HRS</p>
                  </Button>
                  <Button
                    variant={
                      formData.submissionPeriod === 86400 ? "default" : "token"
                    }
                    onClick={() =>
                      setFormData({ ...formData, submissionPeriod: 86400 })
                    }
                  >
                    <p>1 day</p>
                  </Button>
                  <div className="flex flex-row items-center gap-2">
                    <p>Custom:</p>
                    <input
                      type="number"
                      name="submissionPeriod"
                      onChange={handleChangeSubmissionPeriod}
                      className="text-lg p-1 w-10 h-8 bg-terminal-black border border-terminal-green"
                    />
                  </div>
                  {overMaxSubmission && (
                    <p className="absolute top-14 right-10">
                      OVER MAX SUBMISSION PERIOD!
                    </p>
                  )}
                </div>
              </div>
              {!isNaN(formData.submissionPeriod) &&
                formData.submissionPeriod > 0 && (
                  <span className="w-10 h-5 whitespace-nowrap text-xl">
                    {formData.submissionPeriod / (60 * 60)} HRS
                  </span>
                )}
            </div>
          </div>
        </div>
        <div className="w-1/2 flex flex-col gap-2">
          <div className="flex flex-col w-full">
            <p className="2xl:text-4xl">Top Scores</p>
            <div className="flex flex-row items-center justify-between">
              <div className="flex flex-row w-full items-center gap-2">
                <Button
                  variant={formData.scoreboardSize === 1 ? "default" : "token"}
                  onClick={() =>
                    setFormData({ ...formData, scoreboardSize: 1 })
                  }
                >
                  1
                </Button>
                <Button
                  variant={formData.scoreboardSize === 3 ? "default" : "token"}
                  onClick={() =>
                    setFormData({ ...formData, scoreboardSize: 3 })
                  }
                >
                  3
                </Button>
                <Button
                  variant={formData.scoreboardSize === 10 ? "default" : "token"}
                  onClick={() =>
                    setFormData({ ...formData, scoreboardSize: 10 })
                  }
                >
                  10
                </Button>
                <div className="flex flex-row items-center gap-2">
                  <p>Custom:</p>
                  <input
                    name="scoreboardSize"
                    className="text-lg p-1 w-10 h-8 bg-terminal-black border border-terminal-green"
                    onChange={handleChangeScoreboardSize}
                  />
                </div>
              </div>
              {formData.scoreboardSize > 0 && (
                <span className="flex flex-row items-center gap-2">
                  <span className="w-5 h-5 text-terminal-green">
                    <TrophyIcon />
                  </span>
                  <p className="text-2xl">{formData.scoreboardSize}</p>
                </span>
              )}
            </div>
          </div>
          <div className="flex flex-col w-full gap-2">
            <p className="2xl:text-4xl">Gating</p>
            <div className="flex flex-row w-full justify-between">
              <div className="flex flex-row gap-2">
                <Button
                  variant={
                    formData.gatedType.Some?.activeVariant() === "token"
                      ? "default"
                      : "token"
                  }
                  size="md"
                  onClick={() => setInputDialog("gated token")}
                >
                  <p>Token</p>
                </Button>
                <Button
                  variant={
                    formData.gatedType.Some?.activeVariant() === "tournament"
                      ? "default"
                      : "token"
                  }
                  size="md"
                  onClick={() => setInputDialog("gated tournaments")}
                >
                  <p>Tournament</p>
                </Button>
                <Button
                  variant={
                    formData.gatedType.Some?.activeVariant() === "address"
                      ? "default"
                      : "token"
                  }
                  size="md"
                  onClick={() => setInputDialog("gated addresses")}
                >
                  <p>Addresses</p>
                </Button>
              </div>
              <div className="flex flex-row gap-2">
                {formData.gatedType.Some?.activeVariant() === "token" && (
                  <span className="relative flex flex-row items-center gap-2 border border-terminal-green px-5">
                    <span
                      className="absolute top-1 right-1 w-4 h-4 cursor-pointer"
                      onClick={() =>
                        setFormData({
                          ...formData,
                          gatedType: new CairoOption(CairoOptionVariant.None),
                        })
                      }
                    >
                      <CloseIcon />
                    </span>
                    <p>{renderGatedTokenValue()}</p>
                  </span>
                )}
                {formData.gatedType.Some?.activeVariant() === "tournament" && (
                  <span className="flex flex-row items-center gap-2">
                    <span className="w-5 h-5 text-terminal-green">
                      <TrophyIcon />
                    </span>
                    <p>10</p>
                  </span>
                )}
                {formData.gatedType.Some?.activeVariant() === "address" && (
                  <span className="flex flex-row items-center gap-2">
                    <p>
                      {Array.isArray(formData.gatedType.Some?.variant.address)
                        ? formData.gatedType.Some?.variant.address.length
                        : 0}{" "}
                      addresses
                    </p>
                  </span>
                )}
              </div>
            </div>
          </div>
          <div className="flex flex-col">
            <p className="2xl:text-4xl">Entry Fee</p>
            <div className="flex flex-row gap-2">
              {formData.entryFee.isSome() && (
                <EntryFeeBox premium={formData.entryFee.unwrap()!} />
              )}
              {formData.entryFee.isNone() && (
                <Button
                  variant="token"
                  onClick={() => setInputDialog("entry fee")}
                >
                  <span className="w-4 h-4">
                    <PlusIcon />
                  </span>
                </Button>
              )}
            </div>
          </div>
          <div className="flex flex-col gap-2">
            <p className="2xl:text-4xl">Prizes</p>
            <div className="flex flex-row gap-2">
              <PrizeBoxes prizes={formData.prizes} />
              <Button variant="token" onClick={() => setInputDialog("prize")}>
                <span className="w-4 h-4">
                  <PlusIcon />
                </span>
              </Button>
            </div>
          </div>
        </div>
      </div>
      <div className="hidden sm:flex items-center justify-center">
        <Button size={"lg"} onClick={() => handleCreateTournament()}>
          Create
        </Button>
      </div>
    </div>
  );
};

export default Create;
