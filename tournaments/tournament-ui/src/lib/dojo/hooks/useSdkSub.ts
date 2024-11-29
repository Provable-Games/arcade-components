import { useEffect, useState } from "react";
import { BigNumberish } from "starknet";
import { SubscriptionQueryType } from "@dojoengine/sdk";
import { useDojo } from "@/DojoContext";
import { TournamentSchemaType } from "@/generated/models.gen";
import { useDojoStore } from "@/hooks/useDojoStore";

export type TournamentSubQuery = SubscriptionQueryType<TournamentSchemaType>;

export type EntityResult = {
  entityId: BigNumberish;
} & Partial<TournamentSchemaType["tournament"]>;

export type UseSdkSubEntitiesResult = {
  entities: EntityResult[] | null;
  isSubscribed: boolean;
};

export type UseSdkSubEntitiesProps = {
  query: TournamentSubQuery;
  logging?: boolean;
  enabled?: boolean;
};

export const useSdkSubscribeEntities = ({
  query,
  enabled = true,
}: UseSdkSubEntitiesProps): UseSdkSubEntitiesResult => {
  const {
    setup: { sdk },
  } = useDojo();
  const [isSubscribed, setIsSubscribed] = useState(false);
  const [entities, setEntities] = useState<EntityResult[] | null>(null);
  const state = useDojoStore((state) => state);

  useEffect(() => {
    let _unsubscribe: (() => void) | undefined;

    const _subscribe = async () => {
      await sdk.subscribeEntityQuery({
        query,
        callback: (response) => {
          if (response.error) {
            console.error(
              "useSdkSubscribeEntities() error:",
              response.error.message
            );
          } else if (response.data && response.data[0].entityId !== "0x0") {
            state.setEntities(response.data);
            setEntities(
              response.data.map(
                (e: any) =>
                  ({
                    entityId: e.entityId,
                    ...e.models.tournament,
                  } as EntityResult)
              )
            );
          }
        },
      });
      setIsSubscribed(true);
    };

    // mount
    setIsSubscribed(false);
    if (enabled) {
      _subscribe();
    }

    // umnount
    return () => {
      setIsSubscribed(false);
      _unsubscribe?.();
      _unsubscribe = undefined;
    };
  }, [sdk, query, enabled]);

  return {
    entities,
    isSubscribed,
  };
};
