import { useMemo } from "react";
import {
  useSdkGetEntities,
  TournamentGetQuery,
} from "@/lib/dojo/hooks/useSdkGet";
import {
  useSdkSubscribeEntities,
  TournamentSubQuery,
} from "@/lib/dojo/hooks/useSdkSub";
import { addAddressPadding, BigNumberish } from "starknet";

//
// Getters
//

// Tournament

export const useGetTournamentCountsQuery = (contract: string) => {
  const query = useMemo<TournamentGetQuery>(
    () => ({
      tournament: {
        TournamentTotalsModel: {
          $: {
            where: {
              contract: { $is: addAddressPadding(contract) },
            },
          },
        },
      },
    }),
    []
  );
  const { entities, isLoading, refetch } = useSdkGetEntities({
    query,
  });
  const entity = useMemo(
    () => (Array.isArray(entities) ? entities[0] : entities),
    [entities]
  );
  return { entity, isLoading, refetch };
};

export const useGetAllTournamentsQuery = () => {
  const query = useMemo<TournamentGetQuery>(
    () => ({
      tournament: {
        TournamentModel: [],
        TournamentEntriesModel: [],
        TournamentPrizeKeysModel: [],
      },
    }),
    []
  );

  const { entities, isLoading, refetch } = useSdkGetEntities({
    query,
  });
  return { entities, isLoading, refetch };
};

export const useGetUpcomingTournamentsQuery = (currentTime: string) => {
  const query = useMemo<TournamentGetQuery>(
    () => ({
      tournament: {
        TournamentModel: {
          $: {
            where: {
              start_time: { $gt: addAddressPadding(currentTime) },
            },
          },
        },
      },
    }),
    []
  );

  const { entities, isLoading, refetch } = useSdkGetEntities({
    query,
  });
  return { entities, isLoading, refetch };
};

export const useGetLiveTournamentsQuery = (currentTime: string) => {
  const query = useMemo<TournamentGetQuery>(
    () => ({
      tournament: {
        TournamentModel: {
          $: {
            where: {
              And: [
                { start_time: { $lt: addAddressPadding(currentTime) } },
                { end_time: { $gt: addAddressPadding(currentTime) } },
              ],
            },
          },
        },
      },
    }),
    []
  );

  const { entities, isLoading, refetch } = useSdkGetEntities({
    query,
  });
  return { entities, isLoading, refetch };
};

export const useGetTournamentDetailsQuery = (
  tournamentId: BigNumberish,
  address: BigNumberish
) => {
  const query = useMemo<TournamentGetQuery>(
    () => ({
      tournament: {
        TournamentEntriesModel: {
          $: {
            where: {
              tournament_id: { $eq: addAddressPadding(tournamentId) },
            },
          },
        },
        TournamentPrizeKeysModel: {
          $: {
            where: {
              tournament_id: { $eq: addAddressPadding(tournamentId) },
            },
          },
        },
        TournamentModel: {
          $: {
            where: {
              tournament_id: { $eq: addAddressPadding(tournamentId) },
            },
          },
        },
        TournamentScoresModel: {
          $: {
            where: {
              tournament_id: { $eq: addAddressPadding(tournamentId) },
            },
          },
        },
        TournamentEntriesAddressModel: {
          $: {
            where: {
              tournament_id: { $eq: addAddressPadding(tournamentId) },
            },
          },
        },
        TournamentStartIdsModel: {
          $: {
            where: {
              tournament_id: { $eq: addAddressPadding(tournamentId) },
              // And: [
              //   { tournament_id: { $eq: addAddressPadding(tournamentId) } },
              //   { address: { $eq: addAddressPadding(address) } },
              // ],
            },
          },
        },
      },
    }),
    []
  );
  const { entities, isLoading, refetch } = useSdkGetEntities({
    query,
  });
  return { entities, isLoading, refetch };
};

export const useGetTokensQuery = () => {
  const query = useMemo<TournamentGetQuery>(
    () => ({
      tournament: {
        TokenModel: [],
      },
    }),
    []
  );

  const { entities, isLoading, refetch } = useSdkGetEntities({
    query,
  });
  return { entities, isLoading, refetch };
};

// Loot Survivor

export const useGetAdventurersQuery = (address: BigNumberish) => {
  const query = useMemo<TournamentGetQuery>(
    () => ({
      tournament: {
        AdventurerModel: [],
        TournamentStartIdsModel: {
          $: {
            where: {
              address: { $eq: addAddressPadding(address) },
            },
          },
        },
      },
    }),
    []
  );

  const { entities, isLoading, refetch } = useSdkGetEntities({
    query,
  });
  return { entities, isLoading, refetch };
};

//
// Subscriptions
//

export const useSubscribeTournamentsQuery = () => {
  const query = useMemo<TournamentSubQuery>(
    () => ({
      tournament: {
        TournamentModel: [],
      },
    }),
    []
  );
  const { entities, isSubscribed } = useSdkSubscribeEntities({
    query,
  });
  return { entities, isSubscribed };
};

export const useSubscribeTournamentDetailsQuery = (
  tournamentId: BigNumberish
) => {
  const query = useMemo<TournamentSubQuery>(
    () => ({
      tournament: {
        TournamentEntriesModel: {
          $: {
            where: {
              tournament_id: { $is: addAddressPadding(tournamentId) },
            },
          },
        },
        TournamentPrizeKeysModel: {
          $: {
            where: {
              tournament_id: { $is: addAddressPadding(tournamentId) },
            },
          },
        },
        TournamentModel: {
          $: {
            where: {
              tournament_id: { $is: addAddressPadding(tournamentId) },
            },
          },
        },
        TournamentScoresModel: {
          $: {
            where: {
              tournament_id: { $is: addAddressPadding(tournamentId) },
            },
          },
        },
        TournamentEntriesAddressModel: {
          $: {
            where: {
              tournament_id: { $is: addAddressPadding(tournamentId) },
            },
          },
        },
        // TournamentStartIdsModel: {
        //   $: {
        //     where: {
        //       And: [
        //         { tournament_id: { $eq: addAddressPadding(tournamentId) } },
        //         { address: { $eq: addAddressPadding(address) } },
        //       ],
        //     },
        //   },
        // },
      },
    }),
    []
  );
  const { entities, isSubscribed } = useSdkSubscribeEntities({
    query,
  });
  return { entities, isSubscribed };
};

export const useSubscribeTournamentCountsQuery = (contract: string) => {
  const query = useMemo<TournamentSubQuery>(
    () => ({
      tournament: {
        TournamentTotalsModel: {
          $: {
            where: {
              contract: { $is: addAddressPadding(contract) },
            },
          },
        },
      },
    }),
    []
  );
  const { entities, isSubscribed } = useSdkSubscribeEntities({
    query,
  });
  const entity = useMemo(
    () => (Array.isArray(entities) ? entities[0] : entities),
    [entities]
  );
  return { entity, isSubscribed };
};

export const useSubscribeTokensQuery = () => {
  const query = useMemo<TournamentSubQuery>(
    () => ({
      tournament: {
        TokenModel: [],
      },
    }),
    []
  );
  const { entities, isSubscribed } = useSdkSubscribeEntities({
    query,
  });
  return { entities, isSubscribed };
};

// TODO: Add when pagination is available

// interface PageTracker {
//   pageSize: number;
//   fetchedPages: Set<number>;
// }

// interface useGetPaginatedTournamentsQueryProps {
//   limit?: number;
//   offset?: number;
// }

// export const useGetPaginatedTournamentsQuery = ({
//   limit = 10,
//   offset = 0,
// }: useGetPaginatedTournamentsQueryProps) => {
//   const state = useDojoStore((state) => state);
//   // Track fetched pages using a ref to persist between renders
//   const pageTracker = useRef<PageTracker>({
//     pageSize: limit,
//     fetchedPages: new Set(),
//   });

//   const getCurrentPage = useCallback(() => {
//     return Math.floor(offset / limit);
//   }, [offset, limit]);

//   const isPageFetched = useCallback((page: number) => {
//     return pageTracker.current.fetchedPages.has(page);
//   }, []);

//   const currentPage = getCurrentPage();

//   // If we've already fetched this page, just get from state
//   if (isPageFetched(currentPage)) {
//     if (logging) {
//       console.log(`Page ${currentPage} already fetched, using state data`);
//     }

//     const stateEntities = state.getEntities((entity) =>
//       matchesQuery(entity, query)
//     );

//     // Apply pagination to state entities
//     const paginatedEntities = stateEntities.slice(offset, offset + limit);
//     state.setEntities(paginatedEntities);
//     return;
//   }

//   const query = useMemo<TournamentGetQuery>(
//     () => ({
//       tournament: {
//         TournamentModel: [],
//       },
//     }),
//     []
//   );
//   const { entities, isLoading, refetch } = useSdkGetEntities({
//     query,
//     limit,
//     offset,
//   });
//   const tournaments = useMemo(
//     () =>
//       _filterEntitiesByModel<models.TournamentModel>(
//         entities,
//         "TournamentModel"
//       ),
//     [entities]
//   );
//   useEffect(
//     () => console.log(`useGetTournamentsQuery()`, tournaments),
//     [tournaments]
//   );
//   return { tournaments, isLoading, refetch };
// };
