import { AccountInterface } from "starknet";
import { Entity } from "@dojoengine/recs";
import { uuid } from "@latticexyz/utils";
import { ClientComponents } from "./createClientComponents";
import { CreatorDetails, ClientDetails } from "../utils";
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
  { ClientCreator }: ClientComponents
) {
  const registerCreator = async (
    account: AccountInterface,
    creatorDetails: CreatorDetails
  ) => {
    try {
      const { transaction_hash } = await client.clientCreator.registerCreator({
        account,
        creatorDetails,
      });

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
      // ClientCreator.removeOverride(clientcreatorId);
    } finally {
      // ClientCreator.removeOverride(clientcreatorId);
    }
  };

  const registerClient = async (
    account: AccountInterface,
    clientDetails: ClientDetails
  ) => {
    try {
      const { transaction_hash } =
        await client.clientRegistration.registerClient({
          account,
          clientDetails,
        });

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
      // ClientCreator.removeOverride(clientcreatorId);
    } finally {
      // ClientCreator.removeOverride(clientcreatorId);
    }
  };

  const changeUrl = async (
    account: AccountInterface,
    clientId: bigint,
    url: bigint
  ) => {
    try {
      const { transaction_hash } = await client.clientRegistration.changeUrl({
        account,
        clientId,
        url,
      });

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
      // ClientCreator.removeOverride(clientcreatorId);
    } finally {
      // ClientCreator.removeOverride(clientcreatorId);
    }
  };

  const playClient = async (account: AccountInterface, clientId: bigint) => {
    try {
      const { transaction_hash } = await client.clientPlay.play({
        account,
        clientId,
      });

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
      // ClientCreator.removeOverride(clientcreatorId);
    } finally {
      // ClientCreator.removeOverride(clientcreatorId);
    }
  };

  const rateClient = async (
    account: AccountInterface,
    clientId: bigint,
    rating: bigint
  ) => {
    try {
      const { transaction_hash } = await client.clientRating.rate({
        account,
        clientId,
        rating,
      });

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
      // ClientCreator.removeOverride(clientcreatorId);
    } finally {
      // ClientCreator.removeOverride(clientcreatorId);
    }
  };

  return {
    registerCreator,
    registerClient,
    changeUrl,
    playClient,
    rateClient,
  };
}
