import { useDojo } from "../dojo/useDojo";
import { useEntityQuery } from "@dojoengine/react";
import { Has, getComponentValue } from "@dojoengine/recs";
import { useMemo } from "react";
import { feltToString } from "../utils";

export function useGetClients(): {
  clients: any[];
} {
  const {
    setup: {
      clientComponents: {
        ClientRegistration,
        ClientPlayTotal,
        ClientRatingTotalModel,
      },
    },
  } = useDojo();

  const clientEntities = useEntityQuery([Has(ClientRegistration)]);
  const playEntities = useEntityQuery([Has(ClientPlayTotal)]);
  const ratingEntities = useEntityQuery([Has(ClientRatingTotalModel)]);

  const clients = useMemo(() => {
    // First, create a map of play totals keyed by client_id
    const playTotalsMap = new Map();
    playEntities.forEach((playId) => {
      const playTotal = getComponentValue(ClientPlayTotal, playId);
      if (playTotal) {
        playTotalsMap.set(
          playTotal.client_id.toString(),
          playTotal.play_count.toString()
        );
      }
    });

    // Next, we do the same for ratings
    const ratingTotalsMap = new Map();
    ratingEntities.forEach((ratingId) => {
      const ratingTotal = getComponentValue(ClientRatingTotalModel, ratingId);
      if (ratingTotal) {
        ratingTotalsMap.set(ratingTotal.client_id.toString(), {
          ratingTotal: ratingTotal.rating,
          voteCount: ratingTotal.vote_count,
        });
      }
    });

    // Now map over clientEntities and append the play totals if available or default to 0
    const clients = clientEntities
      .map((id) => {
        const client = getComponentValue(ClientRegistration, id);
        if (!client) return null;

        // Look up the play total or default to 0
        const playTotal = playTotalsMap.get(client.client_id.toString()) || 0;
        const rating = ratingTotalsMap.get(client.client_id.toString()) || {
          ratingTotal: 0,
          voteCount: 0,
        };

        return {
          clientId: client.client_id,
          creatorId: client.creator_id.toString(),
          gameId: client.game_id.toString(),
          name: feltToString(client.name.toString()),
          url: feltToString(client.url.toString()),
          playTotal: playTotal,
          ratingTotal: rating.ratingTotal,
          voteCount: rating.voteCount,
        };
      })
      .filter(
        (client): client is NonNullable<typeof client> => client !== null
      );

    // Sort clients by ratingTotal in descending order
    clients.sort((a, b) => b.ratingTotal - a.ratingTotal);

    return clients;
  }, [clientEntities, playEntities, ClientRegistration, ClientPlayTotal]);

  return {
    clients,
  };
}
