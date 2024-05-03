import { useDojo } from "../dojo/useDojo";
import { useEntityQuery } from "@dojoengine/react";
import { Has, getComponentValue } from "@dojoengine/recs";
import { useMemo } from "react";

export function useGetDevelopers(): {
  developers: any[];
} {
  const {
    setup: {
      clientComponents: { ClientDeveloper },
    },
  } = useDojo();

  const developerEntities = useEntityQuery([Has(ClientDeveloper)]);
  const developers = useMemo(
    () => developerEntities.map((id) => getComponentValue(ClientDeveloper, id)),
    [developerEntities, ClientDeveloper]
  );

  return {
    developers,
  };
}
