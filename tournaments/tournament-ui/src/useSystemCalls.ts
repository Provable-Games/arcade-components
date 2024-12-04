import { getEntityIdFromKeys } from "@dojoengine/utils";
import { useAccount } from "@starknet-react/core";
import { useDojoStore } from "./hooks/useDojoStore";
import { useDojo } from "./DojoContext";
import { v4 as uuidv4 } from "uuid";
import {
  Token,
  Prize,
  GatedTypeEnum,
  GatedSubmissionTypeEnum,
} from "./lib/types";
import { TournamentModel, Premium } from "@/generated/models.gen";
import { Account, BigNumberish, CairoOption, byteArray } from "starknet";
import { useDojoSystem } from "@/hooks/useDojoSystem";

export const useSystemCalls = () => {
  const state = useDojoStore((state) => state);
  const tournament_mock = useDojoSystem("tournament_mock");

  const {
    setup: { client },
  } = useDojo();
  const { account } = useAccount();

  // Tournament

  const registerTokens = async (tokens: Token[]) => {
    const entityId = getEntityIdFromKeys([
      BigInt(tournament_mock.contractAddress),
    ]);

    const transactionId = uuidv4();

    state.applyOptimisticUpdate(transactionId, (draft) => {
      if (draft.entities[entityId]?.models?.tournament_mock?.TokenModel) {
        draft.entities[entityId].models.tournament_mock.TokenModel = tokens; // Create the model from provided data
      }
    });

    try {
      const resolvedClient = await client;
      await resolvedClient.tournament_mock.registerTokens(account, tokens);

      // Wait for the entity to be updated with the new state
      await state.waitForEntityChange(entityId, (entity) => {
        return entity?.models?.tournament_mock?.TokenModel === tokens;
      });
    } catch (error) {
      state.revertOptimisticUpdate(transactionId);
      console.error("Error executing register tokens:", error);
      throw error;
    } finally {
      state.confirmTransaction(transactionId);
    }
  };

  const createTournament = async (tournament: TournamentModel) => {
    const entityId = getEntityIdFromKeys([BigInt(tournament.tournament_id)]);

    const transactionId = uuidv4();

    state.applyOptimisticUpdate(transactionId, (draft) => {
      if (!draft.entities[entityId]) {
        const newEntity = {
          entityId,
          models: {
            tournament: {
              TournamentModel: tournament,
            },
          },
        };
        draft.entities[entityId] = newEntity;
      }
    });

    console.log("here");

    try {
      const resolvedClient = await client;

      await resolvedClient.tournament_mock.createTournament(
        account as Account,
        tournament.name,
        byteArray.byteArrayFromString(tournament.description),
        tournament.start_time,
        tournament.end_time,
        tournament.submission_period,
        tournament.winners_count,
        tournament.gated_type as CairoOption<GatedTypeEnum>,
        tournament.entry_premium as CairoOption<Premium>
      );

      await state.waitForEntityChange(entityId, (entity) => {
        return (
          entity?.models?.tournament?.TournamentModel?.tournament_id ===
          tournament.tournament_id
        );
      });
    } catch (error) {
      state.revertOptimisticUpdate(transactionId);
      console.error("Error executing create tournament:", error);
      throw error;
    } finally {
      state.confirmTransaction(transactionId);
    }
  };

  const enterTournament = async (
    tournamentId: BigNumberish,
    newEntryCount: BigNumberish,
    gatedSubmissionType: CairoOption<GatedSubmissionTypeEnum>
  ) => {
    const entityId = getEntityIdFromKeys([BigInt(tournamentId)]);
    const transactionId = uuidv4();

    state.applyOptimisticUpdate(transactionId, (draft) => {
      if (!draft.entities[entityId]) {
        const newEntity = {
          entityId,
          models: {
            tournament: {
              TournamentEntriesModel: {
                tournament_id: tournamentId,
                entry_count: newEntryCount,
              },
            },
          },
        };
        draft.entities[entityId] = newEntity;
      } else if (
        !draft.entities[entityId]?.models?.tournament?.TournamentEntriesModel
      ) {
        draft.entities[entityId].models.tournament = {
          ...draft.entities[entityId].models.tournament,
          TournamentEntriesModel: {
            tournament_id: tournamentId,
            entry_count: newEntryCount,
            premiums_formatted: false,
            distribute_called: false,
          },
        };
      } else if (
        draft.entities[entityId]?.models?.tournament?.TournamentEntriesModel
      ) {
        draft.entities[
          entityId
        ].models.tournament.TournamentEntriesModel.entry_count = newEntryCount;
      }
    });

    try {
      const resolvedClient = await client;
      await resolvedClient.tournament_mock.enterTournament(
        account,
        tournamentId,
        gatedSubmissionType
      );

      await state.waitForEntityChange(entityId, (entity) => {
        return (
          entity?.models?.tournament?.TournamentEntriesModel?.entry_count ===
          newEntryCount
        );
      });
    } catch (error) {
      state.revertOptimisticUpdate(transactionId);
      console.error("Error executing create tournament:", error);
      throw error;
    } finally {
      state.confirmTransaction(transactionId);
    }
  };

  const startTournament = async (
    tournamentId: BigNumberish,
    startAll: boolean,
    startCount: CairoOption<number>
  ) => {
    const entityId = getEntityIdFromKeys([BigInt(tournamentId)]);
    const transactionId = uuidv4();

    // state.applyOptimisticUpdate(transactionId, (draft) => {
    //   draft.entities[
    //     entityId
    //   ].models.tournament_mock.TournamentModel.start_time = Date.now();
    // });

    try {
      const resolvedClient = await client;
      await resolvedClient.tournament_mock.startTournament(
        account,
        Number(tournamentId),
        startAll,
        startCount
      );
    } catch (error) {
      // Revert the optimistic update if an error occurs
      state.revertOptimisticUpdate(transactionId);
      console.error("Error executing create tournament:", error);
      throw error;
    } finally {
      // Confirm the transaction if successful
      state.confirmTransaction(transactionId);
    }
  };

  const submitScores = async (
    tournamentId: BigNumberish,
    gameIds: Array<BigNumberish>
  ) => {
    const entityId = getEntityIdFromKeys([BigInt(tournamentId)]);
    const transactionId = uuidv4();

    // state.applyOptimisticUpdate(transactionId, (draft) => {
    //   draft.entities[
    //     entityId
    //   ].models.tournament_mock.TournamentModel.start_time = Date.now();
    // });

    try {
      const resolvedClient = await client;
      await resolvedClient.tournament_mock.submitScores(
        account,
        tournamentId,
        gameIds
      );
    } catch (error) {
      // Revert the optimistic update if an error occurs
      state.revertOptimisticUpdate(transactionId);
      console.error("Error executing create tournament:", error);
      throw error;
    } finally {
      // Confirm the transaction if successful
      state.confirmTransaction(transactionId);
    }
  };

  const addPrize = async (tournamentId: BigNumberish, prize: Prize) => {
    // Generate a unique entity ID
    const entityId = getEntityIdFromKeys([BigInt(tournamentId)]);

    // Generate a unique transaction ID
    const transactionId = uuidv4();

    // Apply an optimistic update to the state
    // this uses immer drafts to update the state
    state.applyOptimisticUpdate(transactionId, (draft) => {
      if (draft.entities[entityId]?.models?.tournament_mock?.PrizeModel) {
        draft.entities[entityId].models.tournament_mock.PrizeModel = prize; // Create the model from provided data
      }
    });

    try {
      const resolvedClient = await client;
      await resolvedClient.tournament_mock.addPrize(
        account,
        tournamentId,
        prize.token,
        prize.tokenDataType,
        prize.position
      );

      await state.waitForEntityChange(entityId, (entity) => {
        return entity?.models?.tournament_mock?.PrizeModel === prize;
      });
    } catch (error) {
      state.revertOptimisticUpdate(transactionId);
      console.error("Error executing add prize:", error);
      throw error;
    } finally {
      state.confirmTransaction(transactionId);
    }
  };

  const distributePrizes = async (
    tournamentId: BigNumberish,
    prizeKeys: Array<BigNumberish>
  ) => {
    const entityId = getEntityIdFromKeys([BigInt(tournamentId)]);
    const transactionId = uuidv4();

    try {
      const resolvedClient = await client;
      await resolvedClient.tournament_mock.distributePrizes(
        account,
        tournamentId,
        prizeKeys
      );
    } catch (error) {
      state.revertOptimisticUpdate(transactionId);
      console.error("Error executing distribute prizes:", error);
      throw error;
    } finally {
      state.confirmTransaction(transactionId);
    }
  };

  // Loot Survivor

  const setAdventurer = async (adventurerId: BigNumberish, adventurer: any) => {
    const entityId = getEntityIdFromKeys([BigInt(adventurerId)]);
    const transactionId = uuidv4();

    try {
      const resolvedClient = await client;
      await resolvedClient.loot_survivor_mock.setAdventurer(
        account,
        adventurerId,
        adventurer
      );
    } catch (error) {
      state.revertOptimisticUpdate(transactionId);
      console.error("Error executing distribute prizes:", error);
      throw error;
    } finally {
      state.confirmTransaction(transactionId);
    }
  };

  const mintErc20 = async (
    recipient: string,
    amount_high: bigint,
    amount_low: bigint
  ) => {
    const resolvedClient = await client;
    await resolvedClient.erc20_mock.mint(
      account,
      recipient,
      amount_high,
      amount_low
    );
  };

  const approveErc20 = async (
    spender: string,
    amount_high: bigint,
    amount_low: bigint
  ) => {
    const resolvedClient = await client;
    await resolvedClient.erc20_mock.approve(
      account,
      spender,
      amount_high,
      amount_low
    );
  };

  const getERC20Balance = async (address: string) => {
    const resolvedClient = await client;
    return await resolvedClient.erc20_mock.balance_of(account, address);
  };

  const getERC20Allowance = async (owner: string, spender: string) => {
    const resolvedClient = await client;
    return await resolvedClient.erc20_mock.allowance(owner, spender);
  };

  const mintEth = async (
    recipient: string,
    amount_high: bigint,
    amount_low: bigint
  ) => {
    const resolvedClient = await client;
    await resolvedClient.eth_mock.mint(
      account,
      recipient,
      amount_high,
      amount_low
    );
  };

  const approveEth = async (
    spender: string,
    amount_high: BigNumberish,
    amount_low: BigNumberish
  ) => {
    const resolvedClient = await client;
    await resolvedClient.eth_mock.approve(
      account,
      spender,
      amount_high,
      amount_low
    );
  };

  const getEthBalance = async (address: string) => {
    console.log(address);
    const resolvedClient = await client;
    return await resolvedClient.eth_mock.balance_of(account, address);
  };

  const getEthAllowance = async (owner: string, spender: string) => {
    const resolvedClient = await client;
    return await resolvedClient.eth_mock.allowance(owner, spender);
  };

  const mintLords = async (
    recipient: string,
    amount_high: bigint,
    amount_low: bigint
  ) => {
    const resolvedClient = await client;
    await resolvedClient.lords_mock.mint(
      account,
      recipient,
      amount_high,
      amount_low
    );
  };

  const approveLords = async (
    spender: string,
    amount_high: BigNumberish,
    amount_low: BigNumberish
  ) => {
    const resolvedClient = await client;
    await resolvedClient.lords_mock.approve(
      account,
      spender,
      amount_high,
      amount_low
    );
  };

  const getLordsBalance = async (address: string) => {
    const resolvedClient = await client;
    return await resolvedClient.lords_mock.balance_of(address);
  };

  const getLordsAllowance = async (owner: string, spender: string) => {
    const resolvedClient = await client;
    return await resolvedClient.lords_mock.allowance(owner, spender);
  };

  const mintErc721 = async (
    recipient: string,
    tokenId_low: bigint,
    tokenId_high: bigint
  ) => {
    const resolvedClient = await client;
    await resolvedClient.erc721_mock.mint(
      account,
      recipient,
      tokenId_low,
      tokenId_high
    );
  };

  const approveErc721 = async (
    spender: string,
    tokenId_low: bigint,
    tokenId_high: bigint
  ) => {
    const resolvedClient = await client;
    await resolvedClient.erc721_mock.approve(
      account,
      spender,
      tokenId_low,
      tokenId_high
    );
  };

  const getErc721Balance = async (address: string) => {
    const resolvedClient = await client;
    return await resolvedClient.erc721_mock.balance_of(address);
  };

  const getDataMedian = async (dataType: any) => {
    const resolvedClient = await client;
    return await resolvedClient.pragma_mock.getDataMedian(dataType);
  };

  return {
    createTournament,
    enterTournament,
    startTournament,
    submitScores,
    registerTokens,
    addPrize,
    distributePrizes,
    setAdventurer,
    mintErc20,
    approveErc20,
    getERC20Balance,
    getERC20Allowance,
    getEthAllowance,
    getLordsAllowance,
    mintEth,
    approveEth,
    getEthBalance,
    mintLords,
    approveLords,
    getLordsBalance,
    mintErc721,
    approveErc721,
    getErc721Balance,
    getDataMedian,
  };
};
