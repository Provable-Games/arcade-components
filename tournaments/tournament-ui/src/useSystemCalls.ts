import { getEntityIdFromKeys } from "@dojoengine/utils";
import { useAccount } from "@starknet-react/core";
import { useDojoStore } from "./hooks/useDojoStore";
import { useDojo } from "./DojoContext";
import { v4 as uuidv4 } from "uuid";
import { Token, Prize, GatedSubmissionTypeEnum } from "./lib/types";
import {
  InputTournamentModel,
  Premium,
  InputGatedTypeEnum,
} from "@/generated/models.gen";
import {
  Account,
  BigNumberish,
  CairoOption,
  CairoOptionVariant,
  byteArray,
} from "starknet";
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
      resolvedClient.tournament_mock.registerTokens(account!, tokens);

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

  const createTournament = async (tournament: InputTournamentModel) => {
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

    try {
      const resolvedClient = await client;

      resolvedClient.tournament_mock.createTournament(
        account!,
        tournament.name,
        byteArray.byteArrayFromString(tournament.description),
        tournament.start_time,
        tournament.end_time,
        tournament.submission_period,
        tournament.winners_count,
        tournament.gated_type as CairoOption<InputGatedTypeEnum>,
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
    newEntryAddressCount: BigNumberish,
    gatedSubmissionType: CairoOption<GatedSubmissionTypeEnum>
  ) => {
    const entriesEntityId = getEntityIdFromKeys([BigInt(tournamentId)]);
    const entriesAddressEntityId = getEntityIdFromKeys([
      BigInt(tournamentId),
      BigInt(account?.address ?? "0x0"),
    ]);
    const transactionId = uuidv4();

    state.applyOptimisticUpdate(transactionId, (draft) => {
      if (!draft.entities[entriesEntityId]) {
        const entriesEntity = {
          entityId: entriesEntityId,
          models: {
            tournament: {
              TournamentEntriesModel: {
                tournament_id: tournamentId,
                entry_count: newEntryCount,
              },
            },
          },
        };
        const entriesAddressEntity = {
          entityId: entriesAddressEntityId,
          models: {
            tournament: {
              TournamentEntriesAddressModel: {
                tournament_id: tournamentId,
                address: account?.address,
                entry_count: newEntryAddressCount,
              },
            },
          },
        };
        draft.entities[entriesEntityId] = entriesAddressEntity;
        draft.entities[entriesEntityId] = entriesEntity;
      } else if (!draft.entities[entriesAddressEntityId]) {
        const entriesAddressEntity = {
          entityId: entriesAddressEntityId,
          models: {
            tournament: {
              TournamentEntriesAddressModel: {
                tournament_id: tournamentId,
                address: account?.address,
                entry_count: newEntryAddressCount,
              },
            },
          },
        };
        draft.entities[entriesAddressEntityId] = entriesAddressEntity;
      } else if (
        !draft.entities[entriesEntityId]?.models?.tournament
          ?.TournamentEntriesModel
      ) {
        draft.entities[entriesEntityId].models.tournament = {
          ...draft.entities[entriesEntityId].models.tournament,
          TournamentEntriesModel: {
            tournament_id: tournamentId,
            entry_count: newEntryCount,
            premiums_formatted: false,
            distribute_called: false,
          },
        };
        draft.entities[entriesAddressEntityId].models.tournament = {
          ...draft.entities[entriesAddressEntityId].models.tournament,
          TournamentEntriesAddressModel: {
            tournament_id: tournamentId,
            address: account?.address,
            entry_count: newEntryAddressCount,
          },
        };
      } else {
        if (
          draft.entities[entriesEntityId]?.models?.tournament
            ?.TournamentEntriesModel
        ) {
          draft.entities[
            entriesEntityId
          ].models.tournament.TournamentEntriesModel.entry_count =
            newEntryCount;
        }
        if (
          draft.entities[entriesAddressEntityId]?.models?.tournament
            ?.TournamentEntriesAddressModel
        ) {
          draft.entities[
            entriesAddressEntityId
          ].models.tournament.TournamentEntriesAddressModel.entry_count =
            newEntryAddressCount;
        }
      }
    });

    try {
      const resolvedClient = await client;
      resolvedClient.tournament_mock.enterTournament(
        account as Account,
        tournamentId,
        gatedSubmissionType
      );

      await state.waitForEntityChange(entriesEntityId, (entity) => {
        return (
          entity?.models?.tournament?.TournamentEntriesModel?.entry_count ==
          newEntryCount
        );
      });
    } catch (error) {
      state.revertOptimisticUpdate(transactionId);
      console.error("Error executing enter tournament:", error);
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
      resolvedClient.tournament_mock.startTournament(
        account!,
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
      resolvedClient.tournament_mock.submitScores(
        account!,
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

  const addPrize = async (
    tournamentId: BigNumberish,
    prize: Prize,
    prizeKey: BigNumberish
  ) => {
    // Generate a unique entity ID
    const entityId = getEntityIdFromKeys([BigInt(tournamentId)]);

    // Generate a unique transaction ID
    const transactionId = uuidv4();

    // Apply an optimistic update to the state
    // this uses immer drafts to update the state
    state.applyOptimisticUpdate(transactionId, (draft) => {
      if (
        !draft.entities[entityId]?.models?.tournament?.TournamentPrizeKeysModel
      ) {
        draft.entities[entityId].models.tournament = {
          ...draft.entities[entityId].models.tournament,
          TournamentPrizeKeysModel: {
            tournament_id: tournamentId,
            prize_keys: [prizeKey],
          },
        };
      } else if (
        draft.entities[entityId]?.models?.tournament?.TournamentPrizeKeysModel
      ) {
        draft.entities[
          entityId
        ].models.tournament.TournamentPrizeKeysModel.prize_keys.push(prizeKey);
      }
    });

    try {
      const resolvedClient = await client;
      resolvedClient.tournament_mock.addPrize(
        account!,
        tournamentId,
        prize.token,
        prize.tokenDataType,
        prize.position
      );

      await state.waitForEntityChange(entityId, (entity) => {
        return entity?.models?.tournament?.TournamentPrizeKeysModel?.prize_keys.includes(
          prizeKey
        );
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
      resolvedClient.tournament_mock.distributePrizes(
        account!,
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
      resolvedClient.loot_survivor_mock.setAdventurer(
        account!,
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
      account!,
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
      account!,
      spender,
      amount_high,
      amount_low
    );
  };

  const getERC20Balance = async (address: string) => {
    const resolvedClient = await client;
    return await resolvedClient.erc20_mock.balanceOf(address);
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
      account as Account,
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
      account!,
      spender,
      amount_high,
      amount_low
    );
  };

  const getEthBalance = async (address: string) => {
    const resolvedClient = await client;
    return await resolvedClient.eth_mock.balanceOf(address);
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
      account!,
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
      account!,
      spender,
      amount_high,
      amount_low
    );
  };

  const getLordsBalance = async (address: string) => {
    const resolvedClient = await client;
    return await resolvedClient.lords_mock.balanceOf(address);
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
      account!,
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
      account!,
      spender,
      tokenId_low,
      tokenId_high
    );
  };

  const getErc721Balance = async (address: string) => {
    const resolvedClient = await client;
    return await resolvedClient.erc721_mock.balanceOf(address);
  };

  const getDataMedian = async (dataType: any) => {
    const resolvedClient = await client;
    return await resolvedClient.pragma_mock.getDataMedian(dataType);
  };

  const approveERC20General = async (token: Token) => {
    (account as Account)?.execute([
      {
        contractAddress: token.token,
        entrypoint: "approve",
        calldata: [
          tournament_mock.contractAddress,
          token.tokenDataType.variant.erc20?.token_amount,
          "0",
        ],
      },
    ]);
  };

  const approveERC721General = async (token: Token) => {
    (account as Account)?.execute([
      {
        contractAddress: token.token,
        entrypoint: "approve",
        calldata: [
          tournament_mock.contractAddress,
          token.tokenDataType.variant.erc721?.token_id,
          "0",
        ],
      },
    ]);
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
    approveERC20General,
    approveERC721General,
  };
};
