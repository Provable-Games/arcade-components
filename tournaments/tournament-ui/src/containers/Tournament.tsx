import { useMemo, useState } from "react";
import { useParams } from "react-router-dom";
import { getEntityIdFromKeys } from "@dojoengine/utils";
import { useAccount } from "@starknet-react/core";
import ScoreTable from "@/components/tournament/ScoreTable";
import useModel from "../useModel.ts";
import { Models, AdventurerModel, PrizesModel } from "../generated/models.gen";
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
  useSubscribeTournamentDetailsAddressQuery,
} from "@/hooks/useSdkQueries.ts";
import { useDojoStore } from "@/hooks/useDojoStore.ts";
import { useDojoSystem } from "@/hooks/useDojoSystem.ts";
import { useVRFCost } from "@/hooks/useVRFCost";
import { useLSQuery } from "@/hooks/useLSQuery";
import { getAdventurersInList } from "@/hooks/graphql/queries.ts";
import { useDojo } from "@/DojoContext.tsx";
import { Countdown } from "@/components/Countdown.tsx";
import useUIStore from "@/hooks/useUIStore";

const Tournament = () => {
  const { id } = useParams<{ id: string }>();
  const { account } = useAccount();
  const {
    setup: { selectedChainConfig },
  } = useDojo();
  const { setInputDialog } = useUIStore();

  const isMainnet = selectedChainConfig.chainId === "SN_MAINNET";

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
  useGetTournamentDetailsQuery(addAddressPadding(bigintToHex(id!)));
  useSubscribeTournamentDetailsQuery(addAddressPadding(bigintToHex(id!)));
  useSubscribeTournamentDetailsAddressQuery(
    addAddressPadding(bigintToHex(id!)),
    addAddressPadding(account?.address ?? "0x0")
  );
  useGetAdventurersQuery(account?.address ?? "0x0");

  // Get states
  const contractEntityId = useMemo(
    () => getEntityIdFromKeys([BigInt(tournament?.contractAddress)]),
    [tournament?.contractAddress]
  );
  const tournamentEntityId = useMemo(
    () => getEntityIdFromKeys([BigInt(id!)]),
    [id]
  );
  const tournamentAddressEntityId = useMemo(
    () => getEntityIdFromKeys([BigInt(id!), BigInt(account?.address ?? "0x0")]),
    [id, account?.address]
  );
  const totalsModel = useModel(contractEntityId, Models.TournamentTotalsModel);
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
  const tournamentStartIdsModel = useModel(
    tournamentAddressEntityId,
    Models.TournamentStartIdsModel
  );
  const tournamentStartsAddressModel = useModel(
    tournamentAddressEntityId,
    Models.TournamentStartsAddressModel
  );
  const gamesData = state.getEntitiesByModel(
    "tournament",
    "TournamentGameModel"
  );
  const adventurersTestEntities = state.getEntitiesByModel(
    "tournament",
    "AdventurerModel"
  );
  const prizesData = state.getEntitiesByModel("tournament", "PrizesModel");

  // Handle get adventurer scores fir account
  const addressGameIds = tournamentStartIdsModel?.game_ids;
  const formattedGameIds = addressGameIds?.map((id: any) => Number(id));

  const adventurersListVariables = useMemo(() => {
    return {
      ids: formattedGameIds,
    };
  }, []);

  const { data: adventurersMainData } = useLSQuery(
    getAdventurersInList,
    adventurersListVariables
  );

  const adventurersData = isMainnet
    ? adventurersMainData
    : adventurersTestEntities;

  const scores =
    addressGameIds?.reduce((acc: any, id: any) => {
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

  // count calculations
  const entryCount = tournamentEntries?.entry_count ?? 0;
  const entryAddressCount = tournamentEntriesAddressModel?.entry_count ?? 0;
  const currentAddressStartCount =
    tournamentStartsAddressModel?.start_count ?? 0;

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
      feltToString(tournamentModel?.name!),
      addAddressPadding(bigintToHex(BigInt(entryCount) + 1n)),
      addAddressPadding(bigintToHex(BigInt(entryAddressCount) + 1n)),
      new CairoOption(CairoOptionVariant.None)
    );
  };

  const handleStartTournamentCustom = async (customStartCount: number) => {
    if (dollarPrice) {
      const totalVRFCost = BigInt(dollarPrice) * BigInt(entryCount);
      await approveLords(tournament?.contractAddress, totalGameCost, BigInt(0));
      await approveEth(tournament?.contractAddress, totalVRFCost, BigInt(0));
      await new Promise((resolve) => setTimeout(resolve, 5000)); // Wait for 5 second
      await startTournament(
        tournamentModel?.tournament_id!,
        feltToString(tournamentModel?.name!),
        false,
        new CairoOption(CairoOptionVariant.Some, customStartCount),
        currentAddressStartCount + customStartCount
      );
    }
  };

  const handleStartTournamentAll = async () => {
    if (dollarPrice) {
      const totalVRFCost = BigInt(dollarPrice) * BigInt(entryCount);
      await approveLords(tournament?.contractAddress, totalGameCost, BigInt(0));
      await approveEth(tournament?.contractAddress, totalVRFCost, BigInt(0));
      await new Promise((resolve) => setTimeout(resolve, 5000)); // Wait for 5 second
      await startTournament(
        tournamentModel?.tournament_id!,
        feltToString(tournamentModel?.name!),
        false,
        new CairoOption(CairoOptionVariant.None),
        entryAddressCount
      );
    }
  };

  const handleStartTournamentForEveryone = async () => {
    await startTournament(
      tournamentModel?.tournament_id!,
      feltToString(tournamentModel?.name!),
      true,
      new CairoOption(CairoOptionVariant.None),
      entryCount
    );
  };

  const handleSubmitScores = async () => {
    const submitableScores = getSubmitableScores();
    await submitScores(
      tournamentModel?.tournament_id!,
      feltToString(tournamentModel?.name!),
      submitableScores
    );
  };

  const handleDistributeAllPrizes = async () => {
    const prizeKeys = tournamentPrizeKeys?.prize_keys;
    await distributePrizes(
      tournamentModel?.tournament_id!,
      feltToString(tournamentModel?.name!),
      prizeKeys
    );
  };

  const [countDownExpired, setCountDownExpired] = useState(false);

  const [customStartCount, setCustomStartCount] = useState(0);

  const handleChangeStartCount = (e: any) => {
    setCustomStartCount(e.target.value);
  };

  const unclaimedPrizes = useMemo<PrizesModel[]>(() => {
    return (
      prizesData
        ?.filter((entity: any) => {
          const prizeModel = entity.models.tournament.PrizesModel;
          return (
            !prizeModel.claimed &&
            tournamentPrizeKeys?.prize_keys?.includes(prizeModel.prize_key)
          );
        })
        .map((entity) => entity.models.tournament.PrizesModel) ?? []
    );
  }, [prizesData, tournamentPrizeKeys?.prize_keys]);

  if (!tournamentModel?.tournament_id)
    return (
      <div className="flex flex-col gap-2 items-center w-full h-full justify-center py-2">
        <h1 className="text-5xl text-center uppercase">No Tournament Found</h1>
      </div>
    );
  return (
    <div className="flex flex-col gap-2 item-center w-full py-2">
      <div className="flex flex-row items-center justify-between">
        <div className="w-1/4"></div>
        <h1 className="w-1/2 text-5xl text-center uppercase">
          {feltToString(tournamentModel?.name!)}
        </h1>
        {isLive ? (
          <div className="w-1/4 flex flex-row gap-5 justify-end">
            <h2 className="text-4xl uppercase text-terminal-green/75 no-text-shadow">
              Ends
            </h2>
            <Countdown
              targetTime={endDate.getTime()}
              countDownExpired={() => setCountDownExpired(true)}
            />
          </div>
        ) : (
          <div className="w-1/4"></div>
        )}
      </div>
      <div className="relative flex flex-row gap-2 border-4 border-terminal-green/75 p-2">
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
        <div className="flex flex-col justify-between w-1/4">
          <div className="flex flex-col gap-2">
            <p className="text-xl uppercase">Prizes</p>
            {tournamentPrizeKeys ? (
              <p className="text-terminal-green/75 no-text-shadow text-lg uppercase">
                {tournamentPrizeKeys?.prize_keys.map((key: any) =>
                  feltToString(key)
                )}
              </p>
            ) : (
              <p className="text-terminal-green/75 no-text-shadow text-lg uppercase">
                No Prizes Added
              </p>
            )}
          </div>
          <div className="flex flex-row items-center gap-2">
            <p className="text-xl uppercase">Scoreboard Size</p>
            <p className="text-terminal-green/75 no-text-shadow text-lg uppercase">
              {tournamentModel?.winners_count}
            </p>
          </div>
        </div>
        {!started && (
          <div className="absolute top-2 right-2">
            <Button
              className="bg-terminal-green/25 text-terminal-green hover:text-terminal-black"
              onClick={() =>
                setInputDialog({
                  type: "add-prize",
                  props: {
                    tournamentId: tournamentModel?.tournament_id,
                    tournamentName: feltToString(tournamentModel?.name!),
                    currentPrizeCount: totalsModel?.total_prizes,
                  },
                })
              }
            >
              Add Prize
            </Button>
          </div>
        )}
      </div>
      <div className="flex flex-row gap-5">
        <ScoreTable
          tournamentScores={tournamentScores}
          adventurersData={adventurersData}
        />
        <div className="w-1/2 flex flex-col">
          <div className="flex flex-col justify-between border-4 border-terminal-green/75 p-2 h-[300px]">
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
            <div className="flex flex-col gap-2 h-10">
              <h3 className="text-xl uppercase">
                {!started
                  ? "My Entries"
                  : isLive
                  ? "My Games Played"
                  : "Scores Submitted"}
              </h3>
              {tournamentEntriesAddressModel ? (
                <div className="flex flex-row items-center justify-between px-5">
                  <p className="text-terminal-green/75 no-text-shadow uppercase text-2xl">
                    {!started
                      ? BigInt(
                          tournamentEntriesAddressModel?.entry_count
                        ).toString()
                      : isLive
                      ? `${BigInt(
                          currentAddressStartCount
                        ).toString()} / ${BigInt(entryAddressCount).toString()}`
                      : `${
                          tournamentScores?.top_score_ids.length ?? 0
                        } / ${currentAddressStartCount}`}
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
                      entryAddressCount === currentAddressStartCount
                    }
                    onClick={handleStartTournamentAll}
                  >
                    Start All
                  </Button>
                  <Button
                    disabled={
                      !tournamentEntriesAddressModel ||
                      entryAddressCount === currentAddressStartCount
                    }
                    onClick={handleStartTournamentForEveryone}
                  >
                    Start For Everyone
                  </Button>
                  <div className="flex flex-row items-center gap-2">
                    <p className="text-xl uppercase">Custom</p>
                    <input
                      type="number"
                      name="position"
                      onChange={handleChangeStartCount}
                      max={tournamentEntriesAddressModel?.entry_count}
                      min={1}
                      className="p-1 m-2 w-16 h-8 2xl:text-2xl bg-terminal-black border border-terminal-green"
                    />
                    <Button
                      disabled={
                        !tournamentEntriesAddressModel ||
                        entryAddressCount === currentAddressStartCount
                      }
                      onClick={() =>
                        handleStartTournamentCustom(customStartCount)
                      }
                    >
                      Start
                    </Button>
                  </div>
                </>
              )}
              {isSubmissionLive && (
                <Button
                  onClick={handleSubmitScores}
                  disabled={tournamentScores}
                >
                  Submit Scores
                </Button>
              )}
              {submissionEnded && (
                <>
                  {/* <Button
                    onClick={handleClaimPrizes}
                    disabled={!tournamentPrizeKeys}
                  >
                    Claim Prizes
                  </Button> */}
                  <Button
                    onClick={handleDistributeAllPrizes}
                    disabled={
                      !tournamentPrizeKeys || unclaimedPrizes.length === 0
                    }
                  >
                    Distribute Prizes
                  </Button>
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
