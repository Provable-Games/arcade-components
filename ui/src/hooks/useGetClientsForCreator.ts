import { useDojo } from "@/dojo/useDojo";
import { useEntityQuery } from "@dojoengine/react";
import { Has, HasValue, getComponentValue } from "@dojoengine/recs";
import { useMemo } from "react";

export function useGetClientsForCreator(creatorId: bigint | undefined) {
  const {
    setup: {
      clientComponents: { ClientRegistration },
    },
  } = useDojo();

  const clientEntities = useEntityQuery([
    Has(ClientRegistration),
    HasValue(ClientRegistration, { creator_id: creatorId }),
  ]);
  const clients = useMemo(
    () =>
      clientEntities
        .map((id) => getComponentValue(ClientRegistration, id))
        .filter(
          (client): client is NonNullable<typeof client> => client !== null
        ),
    [clientEntities, ClientRegistration]
  );

  // // Sort clients by ratingTotal in descending order
  // clients.sort((a, b) => b.ratingTotal - a.ratingTotal);

  return {
    clients,
  };
}
