import { AccountInterface } from "starknet";
import { Entity } from "@dojoengine/recs";
import { uuid } from "@latticexyz/utils";
import { ClientComponents } from "./createClientComponents";
import { DeveloperDetails } from "../utils";
import {
  getEntityIdFromKeys,
  getEvents,
  setComponentsFromEvents,
} from "@dojoengine/utils";
import { ContractComponents } from "./generated/contractComponents";
import type { IWorld } from "./generated/generated";

export type SystemCalls = ReturnType<typeof createSystemCalls>;

export function createSystemCalls(
  { client }: { client: IWorld },
  contractComponents: ContractComponents,
  { ClientDeveloper, ClientRegistration }: ClientComponents
) {
  const registerDeveloper = async (
    account: AccountInterface,
    developerDetails: DeveloperDetails
  ) => {
    const entityId = getEntityIdFromKeys([BigInt(account.address)]) as Entity;

    // const clientDeveloperId = uuid();
    // ClientDeveloper.addOverride(clientDeveloperId, {
    //   entity: entityId,
    //   value: { player: BigInt(entityId), vec: { x: 10, y: 10 } },
    // });

    // const movesId = uuid();
    // ClientRegistration.addOverride(movesId, {
    //   entity: entityId,
    //   value: {
    //     player: BigInt(entityId),
    //     remaining: 100,
    //     last_direction: 0,
    //   },
    // });

    try {
      const { transaction_hash } =
        await client.clientDeveloper.registerDeveloper({
          account,
          developerDetails,
        });

      console.log(
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        })
      );

      setComponentsFromEvents(
        contractComponents,
        getEvents(
          await account.waitForTransaction(transaction_hash, {
            retryInterval: 100,
          })
        )
      );
    } catch (e) {
      console.log(e);
      // ClientDeveloper.removeOverride(clientDeveloperId);
    } finally {
      // ClientDeveloper.removeOverride(clientDeveloperId);
    }
  };

  return {
    registerDeveloper,
  };
}
