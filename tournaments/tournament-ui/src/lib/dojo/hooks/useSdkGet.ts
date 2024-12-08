import { useCallback, useEffect, useState } from "react";
import { BigNumberish } from "starknet";
import { QueryType } from "@dojoengine/sdk";
import { useDojo } from "@/DojoContext";
import { SchemaType } from "@/generated/models.gen";
import { useDojoStore } from "@/hooks/useDojoStore";

export type TournamentGetQuery = QueryType<SchemaType>;

export type EntityResult = {
  entityId: BigNumberish;
} & Partial<SchemaType["tournament"]>;

export type UseSdkGetEntitiesResult = {
  entities: EntityResult[] | null;
  isLoading: boolean;
  refetch: () => void;
};
export type UseSdkGetEntityResult = {
  isLoading: boolean;
  refetch: () => void;
};

export type UseSdkGetEntitiesProps = {
  query: TournamentGetQuery;
  limit?: number;
  offset?: number;
  enabled?: boolean;
};

export const useSdkGetEntities = ({
  query,
  limit = 100,
  offset = 0,
  enabled = true,
}: UseSdkGetEntitiesProps): UseSdkGetEntitiesResult => {
  const {
    setup: { sdk },
  } = useDojo();

  const [isLoading, setIsLoading] = useState(false);
  const [entities, setEntities] = useState<EntityResult[] | null>(null);
  const { setEntities: setStoreEntities } = useDojoStore((state) => state);

  const fetchEntities = useCallback(async () => {
    try {
      setIsLoading(true);
      await sdk.getEntities({
        query,
        callback: (resp) => {
          if (resp.error) {
            console.error("useSdkGetEntities() error:", resp.error.message);
            return;
          }
          if (resp.data) {
            setStoreEntities(resp.data);
            setEntities(
              resp.data.map(
                (e: any) =>
                  ({
                    entityId: e.entityId,
                    ...e.models.tournament,
                  } as EntityResult)
              )
            );
          }
        },
        limit,
        offset,
      });
    } catch (error) {
      console.error("useSdkGetEntities() exception:", error);
    } finally {
      setIsLoading(false);
    }
  }, [enabled, sdk, query, limit, offset]);

  useEffect(() => {
    if (enabled) {
      fetchEntities();
    } else {
      setIsLoading(false);
    }
  }, [enabled, fetchEntities]);

  return {
    entities,
    isLoading,
    refetch: fetchEntities,
  };
};

//
// Single Entity fetch
// (use only when fetching with a keys)
export const useSdkGetEntity = (
  props: UseSdkGetEntitiesProps
): UseSdkGetEntityResult => {
  const { isLoading, refetch } = useSdkGetEntities({
    ...props,
    limit: 1,
  });
  return {
    isLoading,
    refetch,
  };
};
