import { useMemo } from "react";
import { useParams } from "react-router-dom";
import { getEntityIdFromKeys } from "@dojoengine/utils";
import { useAccount } from "@starknet-react/core";
import ScoreRow from "../components/tournament/ScoreRow";
import useModel from "../useModel.ts";
import { Models, AdventurerModel } from "../generated/models.gen";
import {
  feltToString,
  formatTime,
  formatNumber,
  bigintToHex,
} from "@/lib/utils";
import { Button } from "@/components/buttons/Button.tsx";
import { useSystemCalls } from "@/useSystemCalls.ts";
import { CairoOption, CairoOptionVariant, addAddressPadding } from "starknet";
import {
  useGetAdventurersQuery,
  useGetTournamentDetailsQuery,
  useSubscribeTournamentDetailsQuery,
} from "@/hooks/useSdkQueries.ts";
import { useDojoStore } from "@/hooks/useDojoStore.ts";
import { useDojoSystem } from "@/hooks/useDojoSystem.ts";
import { useVRFCost } from "@/hooks/useVRFCost";

const Tournament = () => {
  const { id } = useParams<{ id: string }>();
  const { account } = useAccount();

  const state = useDojoStore((state) => state);
  const tournament = useDojoSystem("tournament_mock");

  const {
    enterTournament,
    startTournament,
    submitScores,
    distributePrizes,
    approveLords,
    approveEth,
  } = useSystemCalls();

  const { dollarPrice } = useVRFCost();

  // Data fetching
  useGetTournamentDetailsQuery(
    addAddressPadding(bigintToHex(id!)),
    account?.address ?? "0x0"
  );
  useSubscribeTournamentDetailsQuery(addAddressPadding(bigintToHex(id!)));
  useGetAdventurersQuery(account?.address ?? "0x0");

  // Get states
  const tournamentEntityId = useMemo(
    () => getEntityIdFromKeys([BigInt(id!)]),
    [id]
  );
  const tournamentAddressEntityId = useMemo(
    () => getEntityIdFromKeys([BigInt(id!), BigInt(account?.address!)]),
    [id, account?.address]
  );
  const tournamentModel = useModel(tournamentEntityId, Models.TournamentModel);
  const tournamentEntries = useModel(
    tournamentEntityId,
    Models.TournamentEntriesModel
  );
  const tournamentPrizeKeys = useModel(
    tournamentEntityId,
    Models.TournamentPrizeKeysModel
  );
  const tournamentScores = useModel(
    tournamentEntityId,
    Models.TournamentScoresModel
  );
  const tournamentEntriesAddressModel = useModel(
    tournamentAddressEntityId,
    Models.TournamentEntriesAddressModel
  );
  const startIds = useModel(
    tournamentAddressEntityId,
    Models.TournamentStartIdsModel
  );
  // Handle get adventurer scores fir account
  const addressGameIds = startIds?.game_ids;

  const scores =
    addressGameIds?.reduce((acc: any, id) => {
      const adventurerEntityId = getEntityIdFromKeys([BigInt(id!)]);
      const adventurerModel =
        state.getEntity(adventurerEntityId)?.models?.tournament
          ?.AdventurerModel;
      if (adventurerModel) {
        acc.push(adventurerModel);
      }
      return acc;
    }, []) ?? [];

  const getSubmitableScores = () => {
    if (!tournamentScores) {
      const sortedScores = scores.sort(
        (a: AdventurerModel, b: AdventurerModel) => {
          return BigInt(a.adventurer?.xp) - BigInt(b.adventurer?.xp);
        }
      );
      const winnersCount = tournamentModel?.winners_count;
      const adventurerIds = sortedScores.map(
        (score: AdventurerModel) => score.adventurer_id
      );
      return winnersCount
        ? adventurerIds.slice(0, winnersCount)
        : adventurerIds;
    }
    // TODO: Account for already submitted scores and add to the game ids submission
    return [];
  };

  // Calculate dates
  const startDate = new Date(Number(tournamentModel?.start_time) * 1000);
  const endDate = new Date(Number(tournamentModel?.end_time) * 1000);
  const submissionEndDate = new Date(
    (Number(tournamentModel?.end_time) +
      Number(tournamentModel?.submission_period)) *
      1000
  );

  const started = Boolean(
    tournamentModel?.start_time && startDate.getTime() < Date.now()
  );
  const ended = Boolean(
    tournamentModel?.end_time && endDate.getTime() <= Date.now()
  );
  const submissionEnded = Boolean(
    tournamentModel?.submission_period &&
      submissionEndDate.getTime() <= Date.now()
  );

  const isLive = started && !ended;
  const isSubmissionLive = ended && !submissionEnded;

  const entryCount = tournamentEntries?.entry_count ?? 0;

  const getCostToPlay = () => {
    // const cost = await getCostToPlay(tournament?.tournament_id!);
    const cost = BigInt(50000000000000000000);
    return cost;
  };

  const totalGameCost = getCostToPlay() * BigInt(entryCount);

  // System call handlers

  const handleEnterTournament = async () => {
    await enterTournament(
      tournamentModel?.tournament_id!,
      addAddressPadding(bigintToHex(BigInt(entryCount) + 1n)),
      new CairoOption(CairoOptionVariant.None)
    );
  };

  const handleStartTournamentSingle = async () => {
    if (dollarPrice) {
      const totalVRFCost = BigInt(dollarPrice) * BigInt(entryCount);
      await approveLords(tournament?.contractAddress, totalGameCost, BigInt(0));
      await approveEth(tournament?.contractAddress, totalVRFCost, BigInt(0));
      await new Promise((resolve) => setTimeout(resolve, 5000)); // Wait for 5 second
      await startTournament(
        tournamentModel?.tournament_id!,
        false,
        new CairoOption(CairoOptionVariant.None)
      );
    }
  };

  const handleStartTournamentAll = async () => {
    await startTournament(
      tournamentModel?.tournament_id!,
      false,
      new CairoOption(CairoOptionVariant.None)
    );
  };

  const handleStartTournamentForEveryone = async () => {
    await startTournament(
      tournamentModel?.tournament_id!,
      true,
      new CairoOption(CairoOptionVariant.None)
    );
  };

  const handleSubmitScores = async () => {
    const submitableScores = getSubmitableScores();
    await submitScores(tournamentModel?.tournament_id!, submitableScores);
  };

  const handleClaimPrizes = async () => {
    await distributePrizes(tournamentModel?.tournament_id!, []);
  };

  const handleDistributeAllPrizes = async () => {
    await distributePrizes(tournamentModel?.tournament_id!, []);
  };

  if (!tournamentModel?.tournament_id)
    return (
      <div className="flex flex-col gap-2 items-center w-full h-full justify-center py-2">
        <h1 className="text-5xl text-center uppercase">No Tournament Found</h1>
      </div>
    );
  return (
    <div className="flex flex-col gap-2 item-center w-full py-2">
      <h1 className="text-5xl text-center uppercase">
        {feltToString(tournamentModel?.name!)}
      </h1>
      <div className="relative flex flex-row gap-2 border border-terminal-green p-2">
        <div className="flex flex-col gap-1 w-1/2">
          <div className="flex flex-col gap-1">
            <p className="text-xl uppercase">Description</p>
            <p className="text-terminal-green/75 no-text-shadow h-20">
              {tournamentModel?.description}
            </p>
          </div>
          <div className="flex flex-row items-center gap-2">
            <p className="text-xl uppercase">Entries</p>
            <p className="text-terminal-green/75 no-text-shadow text-xl">
              {BigInt(entryCount).toString()}
            </p>
          </div>
        </div>
        <div className="flex flex-col gap-1 w-1/4">
          <div className="flex flex-row items-center gap-2">
            <p className="text-xl uppercase">Status</p>
            <p
              className={`no-text-shadow text-lg uppercase ${
                !started
                  ? "text-terminal-yellow"
                  : isLive
                  ? "text-terminal-green/75"
                  : isSubmissionLive
                  ? "text-terminal-green/75"
                  : "text-red-600"
              }`}
            >
              {!started
                ? "Upcoming"
                : isLive
                ? "Live"
                : isSubmissionLive
                ? "Submission Live"
                : "Ended"}
            </p>
          </div>
          <div className="flex flex-row items-center gap-2">
            <p className="text-xl uppercase">Starts</p>
            <p className="text-terminal-green/75 no-text-shadow text-lg">
              {startDate.toLocaleString()}
            </p>
          </div>
          <div className="flex flex-row items-center gap-2">
            <p className="text-xl uppercase">Ends</p>
            <p className="text-terminal-green/75 no-text-shadow text-lg">
              {endDate.toLocaleString()}
            </p>
          </div>
          <div className="flex flex-row items-center gap-2">
            <p className="text-xl uppercase">Duration</p>
            <p className="text-terminal-green/75 no-text-shadow text-lg uppercase">
              {formatTime(
                Number(tournamentModel?.end_time) -
                  Number(tournamentModel?.start_time)
              )}
            </p>
          </div>
          <div className="flex flex-row items-center gap-2">
            <p className="text-xl uppercase">Submission Period</p>
            <p className="text-terminal-green/75 no-text-shadow text-lg uppercase">
              {formatTime(Number(tournamentModel?.submission_period))}
            </p>
          </div>
        </div>
        <div className="flex flex-col gap-2 w-1/4">
          <p className="text-xl uppercase">Prizes</p>
          {tournamentPrizeKeys ? (
            <p className="text-terminal-green/75 no-text-shadow text-lg uppercase">
              {tournamentPrizeKeys?.prize_keys.map((key) => feltToString(key))}
            </p>
          ) : (
            <p className="text-terminal-green/75 no-text-shadow text-lg uppercase">
              No Prizes Added
            </p>
          )}
        </div>
        <div className="absolute top-2 right-2">
          <Button className="bg-terminal-green/25 text-terminal-green hover:text-terminal-black">
            Add Prize
          </Button>
        </div>
      </div>
      <div className="flex flex-row gap-5">
        <div className="w-1/2 flex flex-col">
          <h2 className="text-2xl uppercase">Scores</h2>
          <table className="w-full border border-terminal-green">
            <thead className="border border-terminal-green text-lg h-10">
              <tr>
                <th className="text-center">Name</th>
                <th className="text-left">Address</th>
                <th className="text-left">ID</th>
                <th className="text-left">Level</th>
                <th className="text-left">XP</th>
                <th className="text-left">Death Time</th>
                <th className="text-left">Prizes</th>
              </tr>
            </thead>
            <tbody>
              {tournamentScores ? (
                tournamentScores?.top_score_ids.map((row, index) => (
                  <ScoreRow key={index} />
                ))
              ) : (
                <p className="text-center">No Scores Submitted</p>
              )}
            </tbody>
          </table>
        </div>
        <div className="w-1/2 flex flex-col">
          <h2 className="text-2xl uppercase">Enter</h2>
          <div className="flex flex-col gap-5 border border-terminal-green p-2 h-[360px]">
            <div className="flex flex-row">
              <div className="flex flex-col w-1/2">
                <div className="flex flex-row items-center gap-2">
                  <p className="whitespace-nowrap uppercase text-xl">
                    Entry Fee
                  </p>
                  <p className="text-terminal-green/75 no-text-shadow">
                    100 LORDS
                  </p>
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
                      Number(getCostToPlay() / BigInt(10) ** BigInt(18))
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
            <h3 className="text-xl uppercase">
              {!started
                ? "My Entries"
                : isLive
                ? "My Games Played"
                : "Scores Submitted"}
            </h3>
            <div className="flex flex-col gap-2 h-20">
              {tournamentEntriesAddressModel ? (
                <div className="flex flex-row items-center justify-between px-5">
                  <p className="text-terminal-green/75 no-text-shadow uppercase text-2xl">
                    {!started
                      ? BigInt(
                          tournamentEntriesAddressModel?.entry_count
                        ).toString()
                      : isLive
                      ? startIds?.game_ids?.length
                      : `${tournamentScores?.top_score_ids.length ?? 0} / ${
                          startIds?.game_ids?.length ?? 0
                        }`}
                  </p>
                  {(!started || isLive) && (
                    <div className="flex flex-row items-center gap-2">
                      <p className="text-xl uppercase">Total Games Cost:</p>
                      <p className="text-terminal-green/75 no-text-shadow uppercase text-2xl">
                        {`${
                          Number(getCostToPlay() / BigInt(10) ** BigInt(18)) *
                          Number(tournamentEntriesAddressModel?.entry_count)
                        } LORDS + $${
                          Number(0.5) *
                          Number(tournamentEntriesAddressModel?.entry_count)
                        }`}
                      </p>
                    </div>
                  )}
                </div>
              ) : (
                <p className="text-terminal-green/75 no-text-shadow uppercase">
                  You have no entries
                </p>
              )}
            </div>
            <div className="flex flex-row gap-5">
              {!started && (
                <Button onClick={handleEnterTournament}>Enter</Button>
              )}
              {isLive && (
                <>
                  <Button
                    disabled={
                      !tournamentEntriesAddressModel ||
                      tournamentEntriesAddressModel?.entry_count === 0
                    }
                    onClick={handleStartTournamentSingle}
                  >
                    Start
                  </Button>
                  <Button
                    disabled={
                      !tournamentEntriesAddressModel ||
                      tournamentEntriesAddressModel?.entry_count === 0
                    }
                    onClick={handleStartTournamentAll}
                  >
                    Start All
                  </Button>
                  <Button
                    disabled={!tournamentEntriesAddressModel}
                    onClick={handleStartTournamentForEveryone}
                  >
                    Start For Everyone
                  </Button>
                </>
              )}
              {isSubmissionLive && <Button>Submit Scores</Button>}
              {submissionEnded && (
                <>
                  <Button>Claim Prizes</Button>
                  <Button>Distribute All Prizes</Button>
                </>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Tournament;
