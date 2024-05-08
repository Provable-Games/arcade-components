import { useDojo } from "../dojo/useDojo";
import { useEntityQuery } from "@dojoengine/react";
import { Has, HasValue, getComponentValue } from "@dojoengine/recs";
import { useMemo } from "react";

export function useGetOwnersForAddress(address: bigint): {
  owners: any[];
  ownerTokens: any[];
} {
  const {
    setup: {
      clientComponents: { ERC721Owner },
    },
  } = useDojo();

  const ownerEntities = useEntityQuery([
    Has(ERC721Owner),
    HasValue(ERC721Owner, { address: address }),
  ]);
  const owners = useMemo(() => {
    return ownerEntities.map((id) => {
      const owner = getComponentValue(ERC721Owner, id);
      if (owner) {
        // Convert all bigInt properties to string using feltToString
        return {
          token: owner.token,
          tokenId: owner.token_id,
          address: owner.address,
        };
      }
    });
  }, [ownerEntities, ERC721Owner]);

  const ownerTokens = useMemo(() => {
    return owners.map((owner) => owner?.tokenId);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [owners]);

  return {
    owners,
    ownerTokens,
  };
}
