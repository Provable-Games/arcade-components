import { useDojo } from "@/dojo/useDojo";
import { useEntityQuery } from "@dojoengine/react";
import { Has, HasValue, getComponentValue } from "@dojoengine/recs";
import { useMemo } from "react";

export function useGetPlayersForGame(developerId: bigint | undefined) {
  const {
    setup: {
      clientComponents: { ClientRegistration },
    },
  } = useDojo();

  const clientEntities = useEntityQuery([
    Has(ClientRegistration),
    HasValue(ClientRegistration, { developer_id: developerId }),
  ]);
  const clients = useMemo(
    () => clientEntities.map((id) => getComponentValue(ClientRegistration, id)),
    [clientEntities, ClientRegistration]
  );

  return {
    clients,
  };
}
