import { getEntityIdFromKeys } from "@dojoengine/utils";
import { useAccount } from "@starknet-react/core";
import { useDojoStore } from "./hooks/useDojoStore";
import { useDojo } from "./DojoContext";
import { v4 as uuidv4 } from "uuid";
import { Token, Prize, GatedSubmissionTypeEnum } from "./lib/types";
import {
  InputTournamentModel,
  Premium,
  InputGatedTypeEnum,
} from "@/generated/models.gen";
import { Account, BigNumberish, CairoOption, byteArray } from "starknet";
import { useDojoSystem } from "@/hooks/useDojoSystem";
import { useToast } from "@/hooks/useToast";
import useUIStore from "@/hooks/useUIStore";
import { useOptimisticUpdates } from "@/hooks/useOptimisticUpdates";

export const useSystemCalls = () => {
  const state = useDojoStore((state) => state);
  const tournament_mock = useDojoSystem("tournament_mock");

  const {
    setup: { client },
  } = useDojo();
  const { account } = useAccount();
  const { toast } = useToast();
  const { resetFormData } = useUIStore();
  const {
    applyTournamentEntryUpdate,
    applyTournamentStartUpdate,
    applyTournamentPrizeUpdate,
  } = useOptimisticUpdates();

  // Tournament

  const registerTokens = async (tokens: Token[]) => {
    const entityId = getEntityIdFromKeys([
      BigInt(tournament_mock.contractAddress),
    ]);

    const transactionId = uuidv4();

    state.applyOptimisticUpdate(transactionId, (draft) => {
      if (draft.entities[entityId]?.models?.tournament_mock?.TokenModel) {
        draft.entities[entityId].models.tournament_mock.TokenModel = tokens; // Create the model from provided data
      }
    });

    try {
      const resolvedClient = await client;
      resolvedClient.tournament_mock.registerTokens(account!, tokens);

      // Wait for the entity to be updated with the new state
      await state.waitForEntityChange(entityId, (entity) => {
        return entity?.models?.tournament_mock?.TokenModel === tokens;
      });
    } catch (error) {
      state.revertOptimisticUpdate(transactionId);
      console.error("Error executing register tokens:", error);
      throw error;
    } finally {
      state.confirmTransaction(transactionId);
    }
  };

  const createTournament = async (tournament: InputTournamentModel) => {
    const transactionId = uuidv4();

    try {
      const resolvedClient = await client;

      await resolvedClient.tournament_mock.createTournament(
        account!,
        tournament.name,
        byteArray.byteArrayFromString(tournament.description),
        tournament.start_time,
        tournament.end_time,
        tournament.submission_period,
        tournament.winners_count,
        tournament.gated_type as CairoOption<InputGatedTypeEnum>,
        tournament.entry_premium as CairoOption<Premium>
      );

      toast({
        title: "Created Tournament!",
        description: `Created tournament ${tournament.name}`,
      });

      resetFormData();
    } catch (error) {
      state.revertOptimisticUpdate(transactionId);
      console.error("Error executing create tournament:", error);
      throw error;
    } finally {
      state.confirmTransaction(transactionId);
    }
  };

  const enterTournament = async (
    tournamentId: BigNumberish,
    tournamentName: string,
    newEntryCount: BigNumberish,
    newEntryAddressCount: BigNumberish,
    gatedSubmissionType: CairoOption<GatedSubmissionTypeEnum>
  ) => {
    const { wait, revert, confirm } = applyTournamentEntryUpdate(
      tournamentId,
      newEntryCount,
      newEntryAddressCount,
      account?.address
    );

    toast({
      title: "Entered Tournament!",
      description: `Entered tournament ${tournamentName}`,
    });
    try {
      const resolvedClient = await client;
      resolvedClient.tournament_mock.enterTournament(
        account as Account,
        tournamentId,
        gatedSubmissionType
      );

      await wait();
    } catch (error) {
      revert();
      console.error("Error executing enter tournament:", error);
      throw error;
    } finally {
      confirm();
    }
  };

  const startTournament = async (
    tournamentId: BigNumberish,
    tournamentName: string,
    startAll: boolean,
    startCount: CairoOption<number>,
    newAddressStartCount: BigNumberish
  ) => {
    const { wait, revert, confirm } = applyTournamentStartUpdate(
      tournamentId,
      newAddressStartCount,
      account?.address
    );

    try {
      const resolvedClient = await client;
      resolvedClient.tournament_mock.startTournament(
        account!,
        Number(tournamentId),
        startAll,
        startCount
      );

      await wait();
      toast({
        title: "Started Tournament!",
        description: `Started tournament ${tournamentName}`,
      });
    } catch (error) {
      revert();
      console.error("Error executing create tournament:", error);
      throw error;
    } finally {
      confirm();
    }
  };

  const submitScores = async (
    tournamentId: BigNumberish,
    tournamentName: string,
    gameIds: Array<BigNumberish>
  ) => {
    const entityId = getEntityIdFromKeys([BigInt(tournamentId)]);
    const transactionId = uuidv4();

    // state.applyOptimisticUpdate(transactionId, (draft) => {
    //   draft.entities[
    //     entityId
    //   ].models.tournament_mock.TournamentModel.start_time = Date.now();
    // });

    try {
      const resolvedClient = await client;
      resolvedClient.tournament_mock.submitScores(
        account!,
        tournamentId,
        gameIds
      );
      toast({
        title: "Submitted Scores!",
        description: `Submitted scores for tournament ${tournamentName}`,
      });
    } catch (error) {
      // Revert the optimistic update if an error occurs
      state.revertOptimisticUpdate(transactionId);
      console.error("Error executing create tournament:", error);
      throw error;
    } finally {
      // Confirm the transaction if successful
      state.confirmTransaction(transactionId);
    }
  };

  const addPrize = async (
    tournamentId: BigNumberish,
    tournamentName: string,
    prize: Prize,
    prizeKey: BigNumberish,
    showToast: boolean
  ) => {
    const { wait, revert, confirm } = applyTournamentPrizeUpdate(
      tournamentId,
      prizeKey
    );

    try {
      const resolvedClient = await client;
      resolvedClient.tournament_mock.addPrize(
        account!,
        tournamentId,
        prize.token,
        prize.tokenDataType,
        prize.position
      );

      await wait();

      if (showToast) {
        toast({
          title: "Added Prize!",
          description: `Added prize for tournament ${tournamentName}`,
        });
      }
    } catch (error) {
      revert();
      console.error("Error executing add prize:", error);
      throw error;
    } finally {
      confirm();
    }
  };

  const distributePrizes = async (
    tournamentId: BigNumberish,
    tournamentName: string,
    prizeKeys: Array<BigNumberish>
  ) => {
    const transactionId = uuidv4();

    try {
      const resolvedClient = await client;
      resolvedClient.tournament_mock.distributePrizes(
        account!,
        tournamentId,
        prizeKeys
      );
      toast({
        title: "Distributed Prizes!",
        description: `Distributed prizes for tournament ${tournamentName}`,
      });
    } catch (error) {
      state.revertOptimisticUpdate(transactionId);
      console.error("Error executing distribute prizes:", error);
      throw error;
    } finally {
      state.confirmTransaction(transactionId);
    }
  };

  // Loot Survivor

  const setAdventurer = async (adventurerId: BigNumberish, adventurer: any) => {
    const transactionId = uuidv4();

    try {
      const resolvedClient = await client;
      resolvedClient.loot_survivor_mock.setAdventurer(
        account!,
        adventurerId,
        adventurer
      );
    } catch (error) {
      state.revertOptimisticUpdate(transactionId);
      console.error("Error executing distribute prizes:", error);
      throw error;
    } finally {
      state.confirmTransaction(transactionId);
    }
  };

  const mintErc20 = async (
    recipient: string,
    amount_high: bigint,
    amount_low: bigint
  ) => {
    const resolvedClient = await client;
    await resolvedClient.erc20_mock.mint(
      account!,
      recipient,
      amount_high,
      amount_low
    );
  };

  const approveErc20 = async (
    spender: string,
    amount_high: bigint,
    amount_low: bigint
  ) => {
    const resolvedClient = await client;
    await resolvedClient.erc20_mock.approve(
      account!,
      spender,
      amount_high,
      amount_low
    );
  };

  const getERC20Balance = async (address: string) => {
    const resolvedClient = await client;
    return await resolvedClient.erc20_mock.balanceOf(address);
  };

  const getERC20Allowance = async (owner: string, spender: string) => {
    const resolvedClient = await client;
    return await resolvedClient.erc20_mock.allowance(owner, spender);
  };

  const mintEth = async (
    recipient: string,
    amount_high: bigint,
    amount_low: bigint
  ) => {
    const resolvedClient = await client;
    await resolvedClient.eth_mock.mint(
      account as Account,
      recipient,
      amount_high,
      amount_low
    );
  };

  const approveEth = async (
    spender: string,
    amount_high: BigNumberish,
    amount_low: BigNumberish
  ) => {
    const resolvedClient = await client;
    await resolvedClient.eth_mock.approve(
      account!,
      spender,
      amount_high,
      amount_low
    );
  };

  const getEthBalance = async (address: string) => {
    const resolvedClient = await client;
    return await resolvedClient.eth_mock.balanceOf(address);
  };

  const getEthAllowance = async (owner: string, spender: string) => {
    const resolvedClient = await client;
    return await resolvedClient.eth_mock.allowance(owner, spender);
  };

  const mintLords = async (
    recipient: string,
    amount_high: bigint,
    amount_low: bigint
  ) => {
    const resolvedClient = await client;
    await resolvedClient.lords_mock.mint(
      account!,
      recipient,
      amount_high,
      amount_low
    );
  };

  const approveLords = async (
    spender: string,
    amount_high: BigNumberish,
    amount_low: BigNumberish
  ) => {
    const resolvedClient = await client;
    await resolvedClient.lords_mock.approve(
      account!,
      spender,
      amount_high,
      amount_low
    );
  };

  const getLordsBalance = async (address: string) => {
    const resolvedClient = await client;
    return await resolvedClient.lords_mock.balanceOf(address);
  };

  const getLordsAllowance = async (owner: string, spender: string) => {
    const resolvedClient = await client;
    return await resolvedClient.lords_mock.allowance(owner, spender);
  };

  const mintErc721 = async (
    recipient: string,
    tokenId_low: bigint,
    tokenId_high: bigint
  ) => {
    const resolvedClient = await client;
    await resolvedClient.erc721_mock.mint(
      account!,
      recipient,
      tokenId_low,
      tokenId_high
    );
  };

  const approveErc721 = async (
    spender: string,
    tokenId_low: bigint,
    tokenId_high: bigint
  ) => {
    const resolvedClient = await client;
    await resolvedClient.erc721_mock.approve(
      account!,
      spender,
      tokenId_low,
      tokenId_high
    );
  };

  const getErc721Balance = async (address: string) => {
    const resolvedClient = await client;
    return await resolvedClient.erc721_mock.balanceOf(address);
  };

  const getDataMedian = async (dataType: any) => {
    const resolvedClient = await client;
    return await resolvedClient.pragma_mock.getDataMedian(dataType);
  };

  const approveERC20General = async (token: Token) => {
    (account as Account)?.execute([
      {
        contractAddress: token.token,
        entrypoint: "approve",
        calldata: [
          tournament_mock.contractAddress,
          token.tokenDataType.variant.erc20?.token_amount,
          "0",
        ],
      },
    ]);
  };

  const approveERC721General = async (token: Token) => {
    (account as Account)?.execute([
      {
        contractAddress: token.token,
        entrypoint: "approve",
        calldata: [
          tournament_mock.contractAddress,
          token.tokenDataType.variant.erc721?.token_id,
          "0",
        ],
      },
    ]);
  };

  return {
    createTournament,
    enterTournament,
    startTournament,
    submitScores,
    registerTokens,
    addPrize,
    distributePrizes,
    setAdventurer,
    mintErc20,
    approveErc20,
    getERC20Balance,
    getERC20Allowance,
    getEthAllowance,
    getLordsAllowance,
    mintEth,
    approveEth,
    getEthBalance,
    mintLords,
    approveLords,
    getLordsBalance,
    mintErc721,
    approveErc721,
    getErc721Balance,
    getDataMedian,
    approveERC20General,
    approveERC721General,
  };
};
