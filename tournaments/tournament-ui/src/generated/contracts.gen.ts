import { DojoProvider } from "@dojoengine/core";
import { Account, ByteArray, CairoOption, BigNumberish } from "starknet";
import * as models from "./models.gen";
import * as constants from "./constants";
import {
  GatedTypeEnum,
  GatedSubmissionTypeEnum,
  Token,
  TokenDataTypeEnum,
} from "@/lib/types";

export async function setupWorld(provider: DojoProvider) {
  const tournament_mock_initializer = async (
    account: Account,
    ethAddress: string,
    lordsAddress: string,
    lootSurvivorAddress: string,
    oracleAddress: string
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "tournament_mock",
          entrypoint: "initializer",
          calldata: [
            ethAddress,
            lordsAddress,
            lootSurvivorAddress,
            oracleAddress,
          ],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const tournament_mock_totalTournaments = async (account: Account) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "tournament_mock",
          entrypoint: "total_tournaments",
          calldata: [],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const tournament_mock_tournament = async (
    account: Account,
    tournamentId: number
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "tournament_mock",
          entrypoint: "tournament",
          calldata: [tournamentId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const tournament_mock_tournamentEntries = async (
    account: Account,
    tournamentId: number
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "tournament_mock",
          entrypoint: "tournament_entries",
          calldata: [tournamentId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const tournament_mock_tournamentPrizeKeys = async (
    account: Account,
    tournamentId: number
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "tournament_mock",
          entrypoint: "tournament_prize_keys",
          calldata: [tournamentId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const tournament_mock_topScores = async (
    account: Account,
    tournamentId: number
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "tournament_mock",
          entrypoint: "top_scores",
          calldata: [tournamentId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const tournament_mock_isTokenRegistered = async (
    account: Account,
    token: string
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "tournament_mock",
          entrypoint: "is_token_registered",
          calldata: [token],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const tournament_mock_createTournament = async (
    account: Account,
    name: BigNumberish,
    description: ByteArray,
    startTime: BigNumberish,
    endTime: BigNumberish,
    submissionPeriod: BigNumberish,
    winnersCount: BigNumberish,
    gatedType: CairoOption<GatedTypeEnum>,
    entryPremium: CairoOption<models.Premium>
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "tournament_mock",
          entrypoint: "create_tournament",
          calldata: [
            name,
            description,
            startTime,
            endTime,
            submissionPeriod,
            winnersCount,
            gatedType,
            entryPremium,
          ],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const tournament_mock_registerTokens = async (
    account: Account,
    tokens: Array<Token>
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "tournament_mock",
          entrypoint: "register_tokens",
          calldata: [tokens],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const tournament_mock_enterTournament = async (
    account: Account,
    tournamentId: BigNumberish,
    gatedSubmissionType: CairoOption<GatedSubmissionTypeEnum>
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "tournament_mock",
          entrypoint: "enter_tournament",
          calldata: [tournamentId, gatedSubmissionType],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const tournament_mock_startTournament = async (
    account: Account,
    tournamentId: number,
    startAll: boolean,
    startCount: CairoOption<number>
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "tournament_mock",
          entrypoint: "start_tournament",
          calldata: [tournamentId, startAll, startCount],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const tournament_mock_submitScores = async (
    account: Account,
    tournamentId: BigNumberish,
    gameIds: Array<BigNumberish>
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "tournament_mock",
          entrypoint: "submit_scores",
          calldata: [tournamentId, gameIds],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const tournament_mock_addPrize = async (
    account: Account,
    tournamentId: BigNumberish,
    token: BigNumberish,
    tokenDataType: TokenDataTypeEnum,
    position: BigNumberish
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "tournament_mock",
          entrypoint: "add_prize",
          calldata: [tournamentId, token, tokenDataType, position],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const tournament_mock_distributePrizes = async (
    account: Account,
    tournamentId: BigNumberish,
    prizeKeys: Array<BigNumberish>
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "tournament_mock",
          entrypoint: "distribute_prizes",
          calldata: [tournamentId, prizeKeys],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc721_mock_balance_of = async (address: string) => {
    try {
      return await provider.call("tournament", {
        contractName: "erc721_mock",
        entrypoint: "balance_of",
        calldata: [address],
      });
    } catch (error) {
      console.error(error);
    }
  };

  const erc721_mock_owner_of = async (account: Account, tokenId: number) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc721_mock",
          entrypoint: "owner_of",
          calldata: [tokenId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc721_mock_safe_transfer_from = async (
    account: Account,
    from: string,
    to: string,
    tokenId: number,
    data: Array<number>
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc721_mock",
          entrypoint: "safe_transfer_from",
          calldata: [from, to, tokenId, data],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc721_mock_transfer_from = async (
    account: Account,
    from: string,
    to: string,
    tokenId: number
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc721_mock",
          entrypoint: "transfer_from",
          calldata: [from, to, tokenId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  interface U256 {
    low: BigNumberish;
    high: BigNumberish;
  }

  const erc721_mock_approve = async (
    account: Account,
    to: string,
    tokenId: U256
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc721_mock",
          entrypoint: "approve",
          calldata: [to, tokenId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc721_mock_set_approval_for_all = async (
    account: Account,
    operator: string,
    approved: boolean
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc721_mock",
          entrypoint: "set_approval_for_all",
          calldata: [operator, approved],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc721_mock_get_approved = async (
    account: Account,
    tokenId: number
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc721_mock",
          entrypoint: "get_approved",
          calldata: [tokenId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc721_mock_is_approved_for_all = async (
    account: Account,
    owner: string,
    operator: string
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc721_mock",
          entrypoint: "is_approved_for_all",
          calldata: [owner, operator],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc721_mock_supports_interface = async (
    account: Account,
    interfaceId: number
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc721_mock",
          entrypoint: "supports_interface",
          calldata: [interfaceId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc721_mock_name = async (account: Account) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc721_mock",
          entrypoint: "name",
          calldata: [],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc721_mock_symbol = async (account: Account) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc721_mock",
          entrypoint: "symbol",
          calldata: [],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc721_mock_token_uri = async (account: Account, tokenId: number) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc721_mock",
          entrypoint: "token_uri",
          calldata: [tokenId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc721_mock_balanceOf = async (account: Account, address: string) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc721_mock",
          entrypoint: "balanceOf",
          calldata: [address],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc721_mock_ownerOf = async (account: Account, tokenId: number) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc721_mock",
          entrypoint: "ownerOf",
          calldata: [tokenId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc721_mock_safeTransferFrom = async (
    account: Account,
    from: string,
    to: string,
    tokenId: number,
    data: Array<number>
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc721_mock",
          entrypoint: "safeTransferFrom",
          calldata: [from, to, tokenId, data],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc721_mock_transferFrom = async (
    account: Account,
    from: string,
    to: string,
    tokenId: number
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc721_mock",
          entrypoint: "transferFrom",
          calldata: [from, to, tokenId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc721_mock_setApprovalForAll = async (
    account: Account,
    operator: string,
    approved: boolean
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc721_mock",
          entrypoint: "setApprovalForAll",
          calldata: [operator, approved],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc721_mock_getApproved = async (account: Account, tokenId: number) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc721_mock",
          entrypoint: "get_approved",
          calldata: [tokenId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc721_mock_isApprovedForAll = async (
    account: Account,
    owner: string,
    operator: string
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc721_mock",
          entrypoint: "is_approved_for_all",
          calldata: [owner, operator],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc721_mock_tokenUri = async (account: Account, tokenId: number) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc721_mock",
          entrypoint: "token_uri",
          calldata: [tokenId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc721_mock_mint = async (
    account: Account,
    recipient: string,
    tokenId_low: bigint,
    tokenId_high: bigint
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc721_mock",
          entrypoint: "mint",
          calldata: [recipient, tokenId_low, tokenId_high],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const pragma_mock_getDataMedian = async (dataType: constants.DataType) => {
    try {
      console.log(dataType);
      return await provider.call("tournament", {
        contractName: "pragma_mock",
        entrypoint: "get_data_median",
        calldata: [dataType],
      });
    } catch (error) {
      console.error(error);
    }
  };

  const erc20_mock_mint = async (
    account: Account,
    recipient: string,
    amount_high: bigint,
    amount_low: bigint
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc20_mock",
          entrypoint: "mint",
          calldata: [recipient, amount_high, amount_low],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const eth_mock_mint = async (
    account: Account,
    recipient: string,
    amount_high: bigint,
    amount_low: bigint
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "eth_mock",
          entrypoint: "mint",
          calldata: [recipient, amount_high, amount_low],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const lords_mock_mint = async (
    account: Account,
    recipient: string,
    amount_high: bigint,
    amount_low: bigint
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "lords_mock",
          entrypoint: "mint",
          calldata: [recipient, amount_high, amount_low],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc20_mock_total_supply = async (account: Account) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc20_mock",
          entrypoint: "total_supply",
          calldata: [],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc20_mock_balance_of = async (account: Account, address: string) => {
    try {
      return await provider.call("tournament", {
        contractName: "erc20_mock",
        entrypoint: "balance_of",
        calldata: [address],
      });
    } catch (error) {
      console.error(error);
    }
  };

  const eth_mock_balance_of = async (account: Account, address: string) => {
    try {
      return await provider.call("tournament", {
        contractName: "eth_mock",
        entrypoint: "balance_of",
        calldata: [address],
      });
    } catch (error) {
      console.error(error);
    }
  };

  const lords_mock_balance_of = async (address: string) => {
    try {
      return await provider.call("tournament", {
        contractName: "lords_mock",
        entrypoint: "balance_of",
        calldata: [address],
      });
    } catch (error) {
      console.error(error);
    }
  };

  const erc20_mock_allowance = async (owner: string, spender: string) => {
    try {
      return await provider.call("tournament", {
        contractName: "erc20_mock",
        entrypoint: "allowance",
        calldata: [owner, spender],
      });
    } catch (error) {
      console.error(error);
    }
  };

  const eth_mock_allowance = async (owner: string, spender: string) => {
    try {
      return await provider.call("tournament", {
        contractName: "eth_mock",
        entrypoint: "allowance",
        calldata: [owner, spender],
      });
    } catch (error) {
      console.error(error);
    }
  };

  const lords_mock_allowance = async (owner: string, spender: string) => {
    try {
      return await provider.call("tournament", {
        contractName: "lords_mock",
        entrypoint: "allowance",
        calldata: [owner, spender],
      });
    } catch (error) {
      console.error(error);
    }
  };

  const erc20_mock_transfer = async (
    account: Account,
    recipient: string,
    amount: number
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc20_mock",
          entrypoint: "transfer",
          calldata: [recipient, amount],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc20_mock_transfer_from = async (
    account: Account,
    sender: string,
    recipient: string,
    amount: number
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc20_mock",
          entrypoint: "transfer_from",
          calldata: [sender, recipient, amount],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc20_mock_approve = async (
    account: Account,
    spender: string,
    amount_high: bigint,
    amount_low: bigint
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc20_mock",
          entrypoint: "approve",
          calldata: [spender, amount_high, amount_low],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const eth_mock_approve = async (
    account: Account,
    spender: string,
    amount_high: BigNumberish,
    amount_low: BigNumberish
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "eth_mock",
          entrypoint: "approve",
          calldata: [spender, amount_high, amount_low],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const lords_mock_approve = async (
    account: Account,
    spender: string,
    amount_high: BigNumberish,
    amount_low: BigNumberish
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "lords_mock",
          entrypoint: "approve",
          calldata: [spender, amount_high, amount_low],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc20_mock_name = async (account: Account) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc20_mock",
          entrypoint: "name",
          calldata: [],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc20_mock_symbol = async (account: Account) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc20_mock",
          entrypoint: "symbol",
          calldata: [],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc20_mock_decimals = async (account: Account) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc20_mock",
          entrypoint: "decimals",
          calldata: [],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc20_mock_totalSupply = async (account: Account) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc20_mock",
          entrypoint: "totalSupply",
          calldata: [],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc20_mock_balanceOf = async (account: Account, address: string) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc20_mock",
          entrypoint: "balanceOf",
          calldata: [address],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const erc20_mock_transferFrom = async (
    account: Account,
    sender: string,
    recipient: string,
    amount: number
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "erc20_mock",
          entrypoint: "transferFrom",
          calldata: [sender, recipient, amount],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_initializer = async (
    account: Account,
    name: string,
    symbol: string,
    baseUri: string,
    ethAddress: string,
    lordsAddress: string,
    pragmaAddress: string
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "initializer",
          calldata: [
            name,
            symbol,
            baseUri,
            ethAddress,
            lordsAddress,
            pragmaAddress,
          ],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_getAdventurer = async (
    account: Account,
    adventurerId: number
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "get_adventurer",
          calldata: [adventurerId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_getAdventurerMeta = async (
    account: Account,
    adventurerId: number
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "get_adventurer_meta",
          calldata: [adventurerId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_getBag = async (
    account: Account,
    adventurerId: number
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "get_bag",
          calldata: [adventurerId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_getCostToPlay = async (account: Account) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "get_cost_to_play",
          calldata: [],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_newGame = async (
    account: Account,
    clientRewardAddress: string,
    weapon: number,
    name: number,
    goldenTokenId: number,
    delayReveal: boolean,
    customRenderer: string,
    launchTournamentWinnerTokenId: number,
    mintTo: string
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "new_game",
          calldata: [
            clientRewardAddress,
            weapon,
            name,
            goldenTokenId,
            delayReveal,
            customRenderer,
            launchTournamentWinnerTokenId,
            mintTo,
          ],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_setAdventurer = async (
    account: Account,
    adventurerId: BigNumberish,
    adventurer: models.Adventurer
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "set_adventurer",
          calldata: [adventurerId, adventurer],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_setAdventurerMeta = async (
    account: Account,
    adventurerId: number,
    adventurerMeta: models.AdventurerMetadata
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "set_adventurer_meta",
          calldata: [adventurerId, adventurerMeta],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_setBag = async (
    account: Account,
    adventurerId: number,
    bag: models.Bag
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "set_bag",
          calldata: [adventurerId, bag],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_balance_of = async (
    account: Account,
    address: string
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "balance_of",
          calldata: [address],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_owner_of = async (
    account: Account,
    tokenId: number
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "owner_of",
          calldata: [tokenId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_safe_transfer_from = async (
    account: Account,
    from: string,
    to: string,
    tokenId: number,
    data: Array<number>
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "safe_transfer_from",
          calldata: [from, to, tokenId, data],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_transfer_from = async (
    account: Account,
    from: string,
    to: string,
    tokenId: number
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "transfer_from",
          calldata: [from, to, tokenId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_approve = async (
    account: Account,
    to: string,
    tokenId: number
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "approve",
          calldata: [to, tokenId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_set_approval_for_all = async (
    account: Account,
    operator: string,
    approved: boolean
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "set_approval_for_all",
          calldata: [operator, approved],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_get_approved = async (
    account: Account,
    tokenId: number
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "get_approved",
          calldata: [tokenId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_is_approved_for_all = async (
    account: Account,
    owner: string,
    operator: string
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "is_approved_for_all",
          calldata: [owner, operator],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_supportsInterface = async (
    account: Account,
    interfaceId: number
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "supports_interface",
          calldata: [interfaceId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_name = async (account: Account) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "name",
          calldata: [],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_symbol = async (account: Account) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "symbol",
          calldata: [],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_token_uri = async (
    account: Account,
    tokenId: number
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "token_uri",
          calldata: [tokenId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_balanceOf = async (
    account: Account,
    address: string
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "balanceOf",
          calldata: [address],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_ownerOf = async (
    account: Account,
    tokenId: number
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "ownerOf",
          calldata: [tokenId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_safeTransferFrom = async (
    account: Account,
    from: string,
    to: string,
    tokenId: number,
    data: Array<number>
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "safeTransferFrom",
          calldata: [from, to, tokenId, data],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_transferFrom = async (
    account: Account,
    from: string,
    to: string,
    tokenId: number
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "transferFrom",
          calldata: [from, to, tokenId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_setApprovalForAll = async (
    account: Account,
    operator: string,
    approved: boolean
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "setApprovalForAll",
          calldata: [operator, approved],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_getApproved = async (
    account: Account,
    tokenId: number
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "getApproved",
          calldata: [tokenId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_isApprovedForAll = async (
    account: Account,
    owner: string,
    operator: string
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "isApprovedForAll",
          calldata: [owner, operator],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  const loot_survivor_mock_tokenUri = async (
    account: Account,
    tokenId: number
  ) => {
    try {
      return await provider.execute(
        account,
        {
          contractName: "loot_survivor_mock",
          entrypoint: "tokenURI",
          calldata: [tokenId],
        },
        "tournament"
      );
    } catch (error) {
      console.error(error);
    }
  };

  return {
    tournament_mock: {
      initializer: tournament_mock_initializer,
      totalTournaments: tournament_mock_totalTournaments,
      tournament: tournament_mock_tournament,
      tournamentEntries: tournament_mock_tournamentEntries,
      tournamentPrizeKeys: tournament_mock_tournamentPrizeKeys,
      topScores: tournament_mock_topScores,
      isTokenRegistered: tournament_mock_isTokenRegistered,
      createTournament: tournament_mock_createTournament,
      registerTokens: tournament_mock_registerTokens,
      enterTournament: tournament_mock_enterTournament,
      startTournament: tournament_mock_startTournament,
      submitScores: tournament_mock_submitScores,
      addPrize: tournament_mock_addPrize,
      distributePrizes: tournament_mock_distributePrizes,
    },
    erc721_mock: {
      balance_of: erc721_mock_balance_of,
      owner_of: erc721_mock_owner_of,
      safe_transfer_from: erc721_mock_safe_transfer_from,
      transfer_from: erc721_mock_transfer_from,
      approve: erc721_mock_approve,
      set_approval_for_all: erc721_mock_set_approval_for_all,
      get_approved: erc721_mock_get_approved,
      is_approved_for_all: erc721_mock_is_approved_for_all,
      name: erc721_mock_name,
      symbol: erc721_mock_symbol,
      token_uri: erc721_mock_token_uri,
      balanceOf: erc721_mock_balanceOf,
      ownerOf: erc721_mock_ownerOf,
      safeTransferFrom: erc721_mock_safeTransferFrom,
      transferFrom: erc721_mock_transferFrom,
      setApprovalForAll: erc721_mock_setApprovalForAll,
      getApproved: erc721_mock_getApproved,
      isApprovedForAll: erc721_mock_isApprovedForAll,
      tokenUri: erc721_mock_tokenUri,
      mint: erc721_mock_mint,
    },
    pragma_mock: {
      getDataMedian: pragma_mock_getDataMedian,
    },
    erc20_mock: {
      mint: erc20_mock_mint,
      total_supply: erc20_mock_total_supply,
      balance_of: erc20_mock_balance_of,
      allowance: erc20_mock_allowance,
      transfer: erc20_mock_transfer,
      transfer_from: erc20_mock_transfer_from,
      approve: erc20_mock_approve,
      name: erc20_mock_name,
      symbol: erc20_mock_symbol,
      decimals: erc20_mock_decimals,
      totalSupply: erc20_mock_totalSupply,
      balanceOf: erc20_mock_balanceOf,
      transferFrom: erc20_mock_transferFrom,
    },
    eth_mock: {
      mint: eth_mock_mint,
      balance_of: eth_mock_balance_of,
      approve: eth_mock_approve,
      allowance: eth_mock_allowance,
    },
    lords_mock: {
      mint: lords_mock_mint,
      balance_of: lords_mock_balance_of,
      approve: lords_mock_approve,
      allowance: lords_mock_allowance,
    },
    loot_survivor_mock: {
      initializer: loot_survivor_mock_initializer,
      getAdventurer: loot_survivor_mock_getAdventurer,
      getAdventurerMeta: loot_survivor_mock_getAdventurerMeta,
      getBag: loot_survivor_mock_getBag,
      getCostToPlay: loot_survivor_mock_getCostToPlay,
      newGame: loot_survivor_mock_newGame,
      setAdventurer: loot_survivor_mock_setAdventurer,
      setAdventurerMeta: loot_survivor_mock_setAdventurerMeta,
      setBag: loot_survivor_mock_setBag,
      balance_of: loot_survivor_mock_balance_of,
      owner_of: loot_survivor_mock_owner_of,
      safe_transfer_from: loot_survivor_mock_safe_transfer_from,
      transfer_from: loot_survivor_mock_transfer_from,
      approve: loot_survivor_mock_approve,
      set_approval_for_all: loot_survivor_mock_set_approval_for_all,
      get_approved: loot_survivor_mock_get_approved,
      is_approved_for_all: loot_survivor_mock_is_approved_for_all,
      name: loot_survivor_mock_name,
      symbol: loot_survivor_mock_symbol,
      token_uri: loot_survivor_mock_token_uri,
      balanceOf: loot_survivor_mock_balanceOf,
      ownerOf: loot_survivor_mock_ownerOf,
      safeTransferFrom: loot_survivor_mock_safeTransferFrom,
      transferFrom: loot_survivor_mock_transferFrom,
      setApprovalForAll: loot_survivor_mock_setApprovalForAll,
      getApproved: loot_survivor_mock_getApproved,
      isApprovedForAll: loot_survivor_mock_isApprovedForAll,
      tokenUri: loot_survivor_mock_tokenUri,
    },
  };
}
