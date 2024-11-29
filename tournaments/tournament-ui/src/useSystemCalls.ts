import { getEntityIdFromKeys } from "@dojoengine/utils";
import { useDojoStore } from "./hooks/useDojoStore";
import { useDojo } from "./DojoContext";
import { v4 as uuidv4 } from "uuid";
import { Token, Tournament, Prize, GatedTypeEnum } from "./lib/types";
import { TournamentModel, Premium } from "@/generated/models.gen";
import { CairoOption } from "starknet";

export const useSystemCalls = () => {
  const state = useDojoStore((state) => state);

  const {
    setup: { client },
    account: { account },
  } = useDojo();

  const createTournament = async (
    tournamentCount: bigint,
    tournament: TournamentModel
  ) => {
    // Generate a unique entity ID
    const entityId = getEntityIdFromKeys([tournamentCount + 1n]); // add 1 to the tournament count for the new id
    console.log(entityId);

    // Generate a unique transaction ID
    const transactionId = uuidv4();

    // Apply an optimistic update to the state
    // this uses immer drafts to update the state
    state.applyOptimisticUpdate(transactionId, (draft) => {
      console.log(draft);
      // Initialize the path if it doesn't exist
      if (!draft.entities[entityId]) {
        draft.entities[entityId] = {
          entityId,
          models: {
            tournament: {
              TournamentModel: tournament,
            },
          },
        };
      } else {
        draft.entities[entityId].models.tournament_mock.TournamentModel =
          tournament;
      }
    });

    console.log(state);

    try {
      // Await the client promise to get the resolved object
      const resolvedClient = await client;
      // Execute the spawn action from the client
      await resolvedClient.tournament_mock.createTournament(
        account,
        Number(tournament.name),
        tournament.description,
        tournament.start_time,
        tournament.end_time,
        tournament.submission_period,
        tournament.winners_count,
        tournament.gated_type as CairoOption<GatedTypeEnum>,
        tournament.entry_premium as CairoOption<Premium>
      );

      console.log(entityId);

      // Wait for the entity to be updated with the new state
      await state.waitForEntityChange(entityId, (entity) => {
        return entity?.models?.tournament_mock?.TournamentModel === tournament;
      });
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

  const registerTokens = async (tokens: Token[]) => {
    // Generate a unique entity ID
    const entityId = generateEntityId();

    // Generate a unique transaction ID
    const transactionId = uuidv4();

    // Apply an optimistic update to the state
    // this uses immer drafts to update the state
    state.applyOptimisticUpdate(transactionId, (draft) => {
      if (draft.entities[entityId]?.models?.tournament_mock?.TokenModel) {
        draft.entities[entityId].models.tournament_mock.TokenModel = tokens; // Create the model from provided data
      }
    });

    try {
      // Await the client promise to get the resolved object
      const resolvedClient = await client;
      // Execute the spawn action from the client
      await resolvedClient.tournament_mock.registerTokens(account, tokens);

      // Wait for the entity to be updated with the new state
      await state.waitForEntityChange(entityId, (entity) => {
        return entity?.models?.tournament_mock?.TokenModel === tokens;
      });
    } catch (error) {
      // Revert the optimistic update if an error occurs
      state.revertOptimisticUpdate(transactionId);
      console.error("Error executing register tokens:", error);
      throw error;
    } finally {
      // Confirm the transaction if successful
      state.confirmTransaction(transactionId);
    }
  };

  const addPrize = async (tournamentId: bigint, prize: Prize) => {
    // Generate a unique entity ID
    const entityId = generateEntityId();

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
      // Await the client promise to get the resolved object
      const resolvedClient = await client;
      // Execute the spawn action from the client
      await resolvedClient.tournament_mock.addPrize(
        account,
        Number(tournamentId),
        prize.token,
        prize.tokenDataType,
        prize.position
      );

      // Wait for the entity to be updated with the new state
      await state.waitForEntityChange(entityId, (entity) => {
        return entity?.models?.tournament_mock?.PrizeModel === prize;
      });
    } catch (error) {
      // Revert the optimistic update if an error occurs
      state.revertOptimisticUpdate(transactionId);
      console.error("Error executing add prize:", error);
      throw error;
    } finally {
      // Confirm the transaction if successful
      console.log("here");
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
    amount_high: bigint,
    amount_low: bigint
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
    amount_high: bigint,
    amount_low: bigint
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

  return {
    createTournament,
    registerTokens,
    addPrize,
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
  };
};
