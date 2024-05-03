import { useDojo } from "@/dojo/useDojo";
import { useElementStore } from "@/utils/store";
import { Client } from "@/utils/types";
import { useEntityQuery } from "@dojoengine/react";
import { Has, HasValue, getComponentValue } from "@dojoengine/recs";
import { useMemo } from "react";

export function useGetClients(): {
  clients: any[];
  clientUrls: string[];
} {
  const {
    setup: {
      clientComponents: { ClientRegistration },
    },
  } = useDojo();

  const { clientId } = useElementStore((state: any) => state);

  const clientEntities = useEntityQuery([
    Has(ClientRegistration),
    HasValue(ClientRegistration, { client_id: clientId }),
  ]);
  const clients = useMemo(
    () => clientEntities.map((id) => getComponentValue(ClientRegistration, id)),
    [clientEntities, ClientRegistration]
  );

  const clientUrl = useMemo(
    () => clients.map((client: any) => client.url).toString(),
    [clients]
  );

  const clientUrls = useMemo(() => {
    return clients.map((client: any) => client.url);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [clientUrl]);

  return {
    clients,
    clientUrls,
  };
}
