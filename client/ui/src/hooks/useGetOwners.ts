import { useDojo } from "../dojo/useDojo";
import { useEntityQuery } from "@dojoengine/react";
import { Has, getComponentValue } from "@dojoengine/recs";
import { useMemo } from "react";
import { feltToString } from "../utils";

export function useGetOwners(): {
  owners: any[];
} {
  const {
    setup: {
      clientComponents: { ERC721Owner },
    },
  } = useDojo();

  const ownerEntities = useEntityQuery([Has(ERC721Owner)]);
  const owners = useMemo(() => {
    return ownerEntities.map((id) => {
      const owner = getComponentValue(ERC721Owner, id);
      if (owner) {
        // Convert all bigInt properties to string using feltToString
        return {
          token: owner.token,
          tokenId: owner.token_id.toString(),
          address: owner.address,
        };
      }
    });
  }, [ownerEntities, ERC721Owner]);

  return {
    owners,
  };
}
