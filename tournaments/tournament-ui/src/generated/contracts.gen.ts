import { DojoProvider } from "@dojoengine/core";
import { Account } from "starknet";
import * as models from "./models.gen";

export async function setupWorld(provider: DojoProvider) {

	const tournament_mock_initializer = async (account: Account, ethAddress: string, lordsAddress: string, lootSurvivorAddress: string, oracleAddress: string) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "tournament_mock",
					entryPoint: "initializer",
					calldata: [ethAddress, lordsAddress, lootSurvivorAddress, oracleAddress],
				}
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
					entryPoint: "total_tournaments",
					calldata: [],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_tournament = async (account: Account, tournamentId: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "tournament_mock",
					entryPoint: "tournament",
					calldata: [tournamentId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_tournamentEntries = async (account: Account, tournamentId: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "tournament_mock",
					entryPoint: "tournament_entries",
					calldata: [tournamentId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_tournamentPrizeKeys = async (account: Account, tournamentId: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "tournament_mock",
					entryPoint: "tournament_prize_keys",
					calldata: [tournamentId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_topScores = async (account: Account, tournamentId: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "tournament_mock",
					entryPoint: "top_scores",
					calldata: [tournamentId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_isTokenRegistered = async (account: Account, token: string) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "tournament_mock",
					entryPoint: "is_token_registered",
					calldata: [token],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_createTournament = async (account: Account, name: number, description: string, startTime: number, endTime: number, submissionPeriod: number, winnersCount: number, gatedType: models.Option, entryPremium: models.Option) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "tournament_mock",
					entryPoint: "create_tournament",
					calldata: [name, description, startTime, endTime, submissionPeriod, winnersCount, gatedType, entryPremium],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_registerTokens = async (account: Account, tokens: Array<Token>) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "tournament_mock",
					entryPoint: "register_tokens",
					calldata: [tokens],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_enterTournament = async (account: Account, tournamentId: number, gatedSubmissionType: models.Option) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "tournament_mock",
					entryPoint: "enter_tournament",
					calldata: [tournamentId, gatedSubmissionType],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_startTournament = async (account: Account, tournamentId: number, startAll: boolean, startCount: models.Option) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "tournament_mock",
					entryPoint: "start_tournament",
					calldata: [tournamentId, startAll, startCount],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_submitScores = async (account: Account, tournamentId: number, gameIds: Array<number>) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "tournament_mock",
					entryPoint: "submit_scores",
					calldata: [tournamentId, gameIds],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_addPrize = async (account: Account, tournamentId: number, token: string, tokenDataType: models.TokenDataType, position: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "tournament_mock",
					entryPoint: "add_prize",
					calldata: [tournamentId, token, tokenDataType, position],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_distributePrizes = async (account: Account, tournamentId: number, prizeKeys: Array<number>) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "tournament_mock",
					entryPoint: "distribute_prizes",
					calldata: [tournamentId, prizeKeys],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_balanceOf = async (account: Account, account: string) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "erc721_mock",
					entryPoint: "balance_of",
					calldata: [account],
				}
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
					entryPoint: "owner_of",
					calldata: [tokenId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_safeTransferFrom = async (account: Account, from: string, to: string, tokenId: number, data: Array<number>) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "erc721_mock",
					entryPoint: "safe_transfer_from",
					calldata: [from, to, tokenId, data],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_transferFrom = async (account: Account, from: string, to: string, tokenId: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "erc721_mock",
					entryPoint: "transfer_from",
					calldata: [from, to, tokenId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_approve = async (account: Account, to: string, tokenId: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "erc721_mock",
					entryPoint: "approve",
					calldata: [to, tokenId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_setApprovalForAll = async (account: Account, operator: string, approved: boolean) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "erc721_mock",
					entryPoint: "set_approval_for_all",
					calldata: [operator, approved],
				}
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
					entryPoint: "get_approved",
					calldata: [tokenId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_isApprovedForAll = async (account: Account, owner: string, operator: string) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "erc721_mock",
					entryPoint: "is_approved_for_all",
					calldata: [owner, operator],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_supportsInterface = async (account: Account, interfaceId: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "erc721_mock",
					entryPoint: "supports_interface",
					calldata: [interfaceId],
				}
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
					entryPoint: "name",
					calldata: [],
				}
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
					entryPoint: "symbol",
					calldata: [],
				}
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
					entryPoint: "token_uri",
					calldata: [tokenId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_balanceOf = async (account: Account, account: string) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "erc721_mock",
					entryPoint: "balanceOf",
					calldata: [account],
				}
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
					entryPoint: "ownerOf",
					calldata: [tokenId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_safeTransferFrom = async (account: Account, from: string, to: string, tokenId: number, data: Array<number>) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "erc721_mock",
					entryPoint: "safeTransferFrom",
					calldata: [from, to, tokenId, data],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_transferFrom = async (account: Account, from: string, to: string, tokenId: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "erc721_mock",
					entryPoint: "transferFrom",
					calldata: [from, to, tokenId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_setApprovalForAll = async (account: Account, operator: string, approved: boolean) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "erc721_mock",
					entryPoint: "setApprovalForAll",
					calldata: [operator, approved],
				}
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
					entryPoint: "getApproved",
					calldata: [tokenId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_isApprovedForAll = async (account: Account, owner: string, operator: string) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "erc721_mock",
					entryPoint: "isApprovedForAll",
					calldata: [owner, operator],
				}
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
					entryPoint: "tokenURI",
					calldata: [tokenId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_mint = async (account: Account, recipient: string, tokenId: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "erc721_mock",
					entryPoint: "mint",
					calldata: [recipient, tokenId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const pragma_mock_getDataMedian = async (account: Account, dataType: models.DataType) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "pragma_mock",
					entryPoint: "get_data_median",
					calldata: [dataType],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc20_mock_mint = async (account: Account, recipient: string, amount: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "erc20_mock",
					entryPoint: "mint",
					calldata: [recipient, amount],
				}
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
					entryPoint: "total_supply",
					calldata: [],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc20_mock_balanceOf = async (account: Account, account: string) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "erc20_mock",
					entryPoint: "balance_of",
					calldata: [account],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc20_mock_allowance = async (account: Account, owner: string, spender: string) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "erc20_mock",
					entryPoint: "allowance",
					calldata: [owner, spender],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc20_mock_transfer = async (account: Account, recipient: string, amount: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "erc20_mock",
					entryPoint: "transfer",
					calldata: [recipient, amount],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc20_mock_transferFrom = async (account: Account, sender: string, recipient: string, amount: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "erc20_mock",
					entryPoint: "transfer_from",
					calldata: [sender, recipient, amount],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc20_mock_approve = async (account: Account, spender: string, amount: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "erc20_mock",
					entryPoint: "approve",
					calldata: [spender, amount],
				}
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
					entryPoint: "name",
					calldata: [],
				}
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
					entryPoint: "symbol",
					calldata: [],
				}
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
					entryPoint: "decimals",
					calldata: [],
				}
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
					entryPoint: "totalSupply",
					calldata: [],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc20_mock_balanceOf = async (account: Account, account: string) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "erc20_mock",
					entryPoint: "balanceOf",
					calldata: [account],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc20_mock_transferFrom = async (account: Account, sender: string, recipient: string, amount: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "erc20_mock",
					entryPoint: "transferFrom",
					calldata: [sender, recipient, amount],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_initializer = async (account: Account, name: string, symbol: string, baseUri: string, ethAddress: string, lordsAddress: string, pragmaAddress: string) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "initializer",
					calldata: [name, symbol, baseUri, ethAddress, lordsAddress, pragmaAddress],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_getAdventurer = async (account: Account, adventurerId: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "get_adventurer",
					calldata: [adventurerId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_getAdventurerMeta = async (account: Account, adventurerId: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "get_adventurer_meta",
					calldata: [adventurerId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_getBag = async (account: Account, adventurerId: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "get_bag",
					calldata: [adventurerId],
				}
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
					entryPoint: "get_cost_to_play",
					calldata: [],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_newGame = async (account: Account, clientRewardAddress: string, weapon: number, name: number, goldenTokenId: number, delayReveal: boolean, customRenderer: string, launchTournamentWinnerTokenId: number, mintTo: string) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "new_game",
					calldata: [clientRewardAddress, weapon, name, goldenTokenId, delayReveal, customRenderer, launchTournamentWinnerTokenId, mintTo],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_setAdventurer = async (account: Account, adventurerId: number, adventurer: Adventurer) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "set_adventurer",
					calldata: [adventurerId, adventurer],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_setAdventurerMeta = async (account: Account, adventurerId: number, adventurerMeta: AdventurerMetadata) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "set_adventurer_meta",
					calldata: [adventurerId, adventurerMeta],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_setBag = async (account: Account, adventurerId: number, bag: Bag) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "set_bag",
					calldata: [adventurerId, bag],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_balanceOf = async (account: Account, account: string) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "balance_of",
					calldata: [account],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_ownerOf = async (account: Account, tokenId: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "owner_of",
					calldata: [tokenId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_safeTransferFrom = async (account: Account, from: string, to: string, tokenId: number, data: Array<number>) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "safe_transfer_from",
					calldata: [from, to, tokenId, data],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_transferFrom = async (account: Account, from: string, to: string, tokenId: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "transfer_from",
					calldata: [from, to, tokenId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_approve = async (account: Account, to: string, tokenId: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "approve",
					calldata: [to, tokenId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_setApprovalForAll = async (account: Account, operator: string, approved: boolean) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "set_approval_for_all",
					calldata: [operator, approved],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_getApproved = async (account: Account, tokenId: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "get_approved",
					calldata: [tokenId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_isApprovedForAll = async (account: Account, owner: string, operator: string) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "is_approved_for_all",
					calldata: [owner, operator],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_supportsInterface = async (account: Account, interfaceId: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "supports_interface",
					calldata: [interfaceId],
				}
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
					entryPoint: "name",
					calldata: [],
				}
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
					entryPoint: "symbol",
					calldata: [],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_tokenUri = async (account: Account, tokenId: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "token_uri",
					calldata: [tokenId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_balanceOf = async (account: Account, account: string) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "balanceOf",
					calldata: [account],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_ownerOf = async (account: Account, tokenId: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "ownerOf",
					calldata: [tokenId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_safeTransferFrom = async (account: Account, from: string, to: string, tokenId: number, data: Array<number>) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "safeTransferFrom",
					calldata: [from, to, tokenId, data],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_transferFrom = async (account: Account, from: string, to: string, tokenId: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "transferFrom",
					calldata: [from, to, tokenId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_setApprovalForAll = async (account: Account, operator: string, approved: boolean) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "setApprovalForAll",
					calldata: [operator, approved],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_getApproved = async (account: Account, tokenId: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "getApproved",
					calldata: [tokenId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_isApprovedForAll = async (account: Account, owner: string, operator: string) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "isApprovedForAll",
					calldata: [owner, operator],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_tokenUri = async (account: Account, tokenId: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "tokenURI",
					calldata: [tokenId],
				}
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
			balanceOf: erc721_mock_balanceOf,
			ownerOf: erc721_mock_ownerOf,
			safeTransferFrom: erc721_mock_safeTransferFrom,
			transferFrom: erc721_mock_transferFrom,
			approve: erc721_mock_approve,
			setApprovalForAll: erc721_mock_setApprovalForAll,
			getApproved: erc721_mock_getApproved,
			isApprovedForAll: erc721_mock_isApprovedForAll,
			supportsInterface: erc721_mock_supportsInterface,
			name: erc721_mock_name,
			symbol: erc721_mock_symbol,
			tokenUri: erc721_mock_tokenUri,
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
			totalSupply: erc20_mock_totalSupply,
			balanceOf: erc20_mock_balanceOf,
			allowance: erc20_mock_allowance,
			transfer: erc20_mock_transfer,
			transferFrom: erc20_mock_transferFrom,
			approve: erc20_mock_approve,
			name: erc20_mock_name,
			symbol: erc20_mock_symbol,
			decimals: erc20_mock_decimals,
			totalSupply: erc20_mock_totalSupply,
			balanceOf: erc20_mock_balanceOf,
			transferFrom: erc20_mock_transferFrom,
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
			balanceOf: loot_survivor_mock_balanceOf,
			ownerOf: loot_survivor_mock_ownerOf,
			safeTransferFrom: loot_survivor_mock_safeTransferFrom,
			transferFrom: loot_survivor_mock_transferFrom,
			approve: loot_survivor_mock_approve,
			setApprovalForAll: loot_survivor_mock_setApprovalForAll,
			getApproved: loot_survivor_mock_getApproved,
			isApprovedForAll: loot_survivor_mock_isApprovedForAll,
			supportsInterface: loot_survivor_mock_supportsInterface,
			name: loot_survivor_mock_name,
			symbol: loot_survivor_mock_symbol,
			tokenUri: loot_survivor_mock_tokenUri,
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