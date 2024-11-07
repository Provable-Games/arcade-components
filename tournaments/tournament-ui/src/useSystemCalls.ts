import { getEntityIdFromKeys } from "@dojoengine/utils";
import { useDojoStore } from "./App";
import { useDojo } from "./DojoContext";
import { v4 as uuidv4 } from "uuid";
import { Token } from "./generated/models.gen";
import { Tournament, Prize } from "./lib/types";

export const useSystemCalls = () => {
  const state = useDojoStore((state) => state);

  const {
    setup: { client },
    account: { account },
  } = useDojo();

  const generateEntityId = () => {
    return getEntityIdFromKeys([BigInt(account?.address)]);
  };

  const createTournament = async (tournament: Tournament) => {
    // Generate a unique entity ID
    const entityId = generateEntityId();

    // Generate a unique transaction ID
    const transactionId = uuidv4();

    // Apply an optimistic update to the state
    // this uses immer drafts to update the state
    state.applyOptimisticUpdate(transactionId, (draft) => {
      if (draft.entities[entityId]?.models?.tournament_mock?.TournamentModel) {
        draft.entities[entityId].models.tournament_mock.TournamentModel =
          tournament; // Create the model from provided data
      }
    });

    try {
      // Await the client promise to get the resolved object
      const resolvedClient = await client;
      // Execute the spawn action from the client
      await resolvedClient.tournament_mock.createTournament(
        account,
        tournament.name,
        tournament.description,
        tournament.start_time,
        tournament.end_time,
        tournament.submission_period,
        tournament.winners_count,
        tournament.gated_type,
        tournament.entry_premium
      );

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
  const addPrize = async (prize: Prize) => {
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
        prize.tournamentId,
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
      state.confirmTransaction(transactionId);
    }
  };

  return {
    createTournament,
    registerTokens,
    addPrize,
  };
};
