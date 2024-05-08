import { useDojo } from "../dojo/useDojo";
import { useEntityQuery } from "@dojoengine/react";
import { useComponentValue } from "@dojoengine/react";
import { Has, getComponentValue } from "@dojoengine/recs";
import { useMemo } from "react";
import { feltToString, feltToHex } from "../utils";

export function useGetCreators(): {
  creators: any[];
} {
  const {
    setup: {
      clientComponents: { ClientCreator, ERC721Owner },
    },
  } = useDojo();

  const creatorEntities = useEntityQuery([Has(ClientCreator)]);
  const ownerEntities = useEntityQuery([Has(ERC721Owner)]);

  const creators = useMemo(() => {
    const ownerMap = new Map();
    ownerEntities.forEach((tokenId) => {
      const owner = getComponentValue(ERC721Owner, tokenId);
      if (owner) {
        ownerMap.set(owner.token_id.toString(), feltToHex(owner.address));
      }
    });

    return creatorEntities.map((id) => {
      const creator = getComponentValue(ClientCreator, id);

      const owner = ownerMap.get(creator?.creator_id.toString()) || "";

      if (creator) {
        // Convert all bigInt properties to string using feltToString
        return {
          creator_id: creator.creator_id.toString(),
          github_username: feltToString(creator.github_username.toString()),
          telegram_handle: feltToString(creator.telegram_handle.toString()),
          x_handle: feltToString(creator.x_handle.toString()),
          ownerAddress: owner,
        };
      }
    });
  }, [creatorEntities, ClientCreator]);

  return {
    creators,
  };
}
