import { useDojo } from "@/dojo/useDojo";
import { useEntityQuery } from "@dojoengine/react";
import { Has, HasValue, getComponentValue } from "@dojoengine/recs";
import { useMemo } from "react";

export function useGetClientsForCreator(creatorId: bigint | undefined) {
  const {
    setup: {
      clientComponents: { ClientCreator },
    },
  } = useDojo();

  const clientEntities = useEntityQuery([
    Has(ClientCreator),
    HasValue(ClientCreator, { creator_id: creatorId }),
  ]);
  const clients = useMemo(
    () => clientEntities.map((id) => getComponentValue(ClientCreator, id)),
    [clientEntities, ClientCreator]
  );

  return {
    clients,
  };
}
