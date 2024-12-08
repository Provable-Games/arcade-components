import { BigNumberish } from "starknet";
import { getEntityIdFromKeys } from "@dojoengine/utils";
import { useDojoStore } from "@/hooks/useDojoStore";
import { v4 as uuidv4 } from "uuid";

export const useOptimisticUpdates = () => {
  const state = useDojoStore((state) => state);

  const applyTournamentEntryUpdate = (
    tournamentId: BigNumberish,
    newEntryCount: BigNumberish,
    newEntryAddressCount: BigNumberish,
    accountAddress?: string
  ) => {
    const entriesEntityId = getEntityIdFromKeys([BigInt(tournamentId)]);
    const entriesAddressEntityId = getEntityIdFromKeys([
      BigInt(tournamentId),
      BigInt(accountAddress ?? "0x0"),
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
                address: accountAddress,
                entry_count: newEntryAddressCount,
              },
            },
          },
        };
        draft.entities[entriesEntityId] = entriesAddressEntity;
        draft.entities[entriesEntityId] = entriesEntity;
      } else if (!draft.entities[entriesAddressEntityId]) {
        draft.entities[entriesEntityId].models.tournament = {
          ...draft.entities[entriesEntityId].models.tournament,
          TournamentEntriesModel: {
            tournament_id: tournamentId,
            entry_count: newEntryCount,
            premiums_formatted: false,
            distribute_called: false,
          },
        };
        const entriesAddressEntity = {
          entityId: entriesAddressEntityId,
          models: {
            tournament: {
              TournamentEntriesAddressModel: {
                tournament_id: tournamentId,
                address: accountAddress,
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
            address: accountAddress,
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

    const waitForEntriesEntityChange = async () => {
      return await state.waitForEntityChange(entriesEntityId, (entity) => {
        return (
          entity?.models?.tournament?.TournamentEntriesModel?.entry_count ==
          newEntryCount
        );
      });
    };

    return {
      transactionId,
      wait: () => waitForEntriesEntityChange(),
      revert: () => state.revertOptimisticUpdate(transactionId),
      confirm: () => state.confirmTransaction(transactionId),
    };
  };

  const applyTournamentStartUpdate = (
    tournamentId: BigNumberish,
    newAddressStartCount: BigNumberish,
    accountAddress?: string
  ) => {
    const startsAddressEntityId = getEntityIdFromKeys([
      BigInt(tournamentId),
      BigInt(accountAddress ?? "0x0"),
    ]);
    const transactionId = uuidv4();

    state.applyOptimisticUpdate(transactionId, (draft) => {
      if (
        !draft.entities[startsAddressEntityId].models.tournament
          .TournamentStartsAddressModel
      ) {
        draft.entities[startsAddressEntityId].models.tournament = {
          ...draft.entities[startsAddressEntityId].models.tournament,
          TournamentStartsAddressModel: {
            tournament_id: tournamentId,
            address: accountAddress,
            start_count: newAddressStartCount,
          },
        };
      } else if (
        draft.entities[startsAddressEntityId].models.tournament
          .TournamentStartsAddressModel
      ) {
        draft.entities[
          startsAddressEntityId
        ].models.tournament.TournamentStartsAddressModel.start_count =
          newAddressStartCount;
      }
    });

    const waitForStartsEntityChange = async () => {
      return await state.waitForEntityChange(
        startsAddressEntityId,
        (entity) => {
          return (
            entity?.models?.tournament?.TournamentStartsAddressModel
              ?.start_count == newAddressStartCount
          );
        }
      );
    };

    return {
      transactionId,
      wait: () => waitForStartsEntityChange(),
      revert: () => state.revertOptimisticUpdate(transactionId),
      confirm: () => state.confirmTransaction(transactionId),
    };
  };

  const applyTournamentPrizeUpdate = (
    tournamentId: BigNumberish,
    prizeKey: BigNumberish
  ) => {
    const entityId = getEntityIdFromKeys([BigInt(tournamentId)]);
    const transactionId = uuidv4();

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
          ?.prize_keys
      ) {
        draft.entities[
          entityId
        ].models.tournament.TournamentPrizeKeysModel.prize_keys.push(prizeKey);
      }
    });

    const waitForPrizeEntityChange = async () => {
      return await state.waitForEntityChange(entityId, (entity) => {
        return entity?.models?.tournament?.TournamentPrizeKeysModel?.prize_keys.includes(
          prizeKey
        );
      });
    };

    return {
      transactionId,
      wait: () => waitForPrizeEntityChange(),
      revert: () => state.revertOptimisticUpdate(transactionId),
      confirm: () => state.confirmTransaction(transactionId),
    };
  };

  return {
    applyTournamentEntryUpdate,
    applyTournamentStartUpdate,
    applyTournamentPrizeUpdate,
  };
};
