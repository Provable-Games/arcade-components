import { useDojo } from "../dojo/useDojo";
import { useEntityQuery } from "@dojoengine/react";
import { Has, HasValue, getComponentValue } from "@dojoengine/recs";
import { useMemo } from "react";
import { feltToString } from "../utils";

export function useGetCreatorsForOwner(tokenIds: bigint[]) {
  const {
    setup: {
      clientComponents: { ClientCreator },
    },
  } = useDojo();

  const creatorEntities = useEntityQuery([Has(ClientCreator)]);
  const creators = useMemo(() => {
    return creatorEntities.reduce((acc: any[], id) => {
      const creator = getComponentValue(ClientCreator, id);
      if (creator && tokenIds.includes(creator.creator_id)) {
        const creatorDetails = {
          creatorId: creator.creator_id,
          name: feltToString(creator.name.toString()),
          githubUsername: feltToString(creator.github_username.toString()),
          telegramHandle: feltToString(creator.telegram_handle.toString()),
          xHandle: feltToString(creator.x_handle.toString()),
        };
        acc.push(creatorDetails);
      }
      return acc;
    }, []);
  }, [creatorEntities, ClientCreator, tokenIds]);

  return {
    creators,
  };
}
