import { DojoProvider } from "@dojoengine/core";
import { Account } from "starknet";
import * as models from "./models.gen";

export async function setupWorld(provider: DojoProvider) {

	const erc20_mock_totalSupply = async (snAccount: Account) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "erc20_mock",
					entrypoint: "total_supply",
					calldata: [],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc20_mock_balanceOf = async (snAccount: Account, account: string) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "erc20_mock",
					entrypoint: "balance_of",
					calldata: [account],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc20_mock_allowance = async (snAccount: Account, owner: string, spender: string) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "erc20_mock",
					entrypoint: "allowance",
					calldata: [owner, spender],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc20_mock_transfer = async (snAccount: Account, recipient: string, amount: number) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "erc20_mock",
					entrypoint: "transfer",
					calldata: [recipient, amount],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc20_mock_transferFrom = async (snAccount: Account, sender: string, recipient: string, amount: number) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "erc20_mock",
					entrypoint: "transfer_from",
					calldata: [sender, recipient, amount],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc20_mock_approve = async (snAccount: Account, spender: string, amount: number) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "erc20_mock",
					entrypoint: "approve",
					calldata: [spender, amount],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc20_mock_name = async (snAccount: Account) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "erc20_mock",
					entrypoint: "name",
					calldata: [],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc20_mock_symbol = async (snAccount: Account) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "erc20_mock",
					entrypoint: "symbol",
					calldata: [],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc20_mock_decimals = async (snAccount: Account) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "erc20_mock",
					entrypoint: "decimals",
					calldata: [],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc20_mock_mint = async (snAccount: Account, recipient: string, amount: number) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "erc20_mock",
					entrypoint: "mint",
					calldata: [recipient, amount],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_getAdventurer = async (snAccount: Account, adventurerId: number) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "loot_survivor_mock",
					entrypoint: "get_adventurer",
					calldata: [adventurerId],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_getAdventurerMeta = async (snAccount: Account, adventurerId: number) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "loot_survivor_mock",
					entrypoint: "get_adventurer_meta",
					calldata: [adventurerId],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_getBag = async (snAccount: Account, adventurerId: number) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "loot_survivor_mock",
					entrypoint: "get_bag",
					calldata: [adventurerId],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_getCostToPlay = async (snAccount: Account) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "loot_survivor_mock",
					entrypoint: "get_cost_to_play",
					calldata: [],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_newGame = async (snAccount: Account, clientRewardAddress: string, weapon: number, name: number, goldenTokenId: number, delayReveal: boolean, customRenderer: string, launchTournamentWinnerTokenId: number, mintTo: string) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "loot_survivor_mock",
					entrypoint: "new_game",
					calldata: [clientRewardAddress, weapon, name, goldenTokenId, delayReveal, customRenderer, launchTournamentWinnerTokenId, mintTo],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_setAdventurer = async (snAccount: Account, adventurerId: number, adventurer: models.Adventurer) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "loot_survivor_mock",
					entrypoint: "set_adventurer",
					calldata: [adventurerId, adventurer],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_setAdventurerMeta = async (snAccount: Account, adventurerId: number, adventurerMeta: models.AdventurerMetadata) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "loot_survivor_mock",
					entrypoint: "set_adventurer_meta",
					calldata: [adventurerId, adventurerMeta],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_setBag = async (snAccount: Account, adventurerId: number, bag: models.Bag) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "loot_survivor_mock",
					entrypoint: "set_bag",
					calldata: [adventurerId, bag],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_initializer = async (snAccount: Account, name: string, symbol: string, baseUri: string, ethAddress: string, lordsAddress: string, pragmaAddress: string) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "loot_survivor_mock",
					entrypoint: "initializer",
					calldata: [name, symbol, baseUri, ethAddress, lordsAddress, pragmaAddress],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_balanceOf = async (snAccount: Account, account: string) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "loot_survivor_mock",
					entrypoint: "balance_of",
					calldata: [account],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_ownerOf = async (snAccount: Account, tokenId: number) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "loot_survivor_mock",
					entrypoint: "owner_of",
					calldata: [tokenId],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_safeTransferFrom = async (snAccount: Account, from: string, to: string, tokenId: number, data: Array<number>) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "loot_survivor_mock",
					entrypoint: "safe_transfer_from",
					calldata: [from, to, tokenId, data],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_transferFrom = async (snAccount: Account, from: string, to: string, tokenId: number) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "loot_survivor_mock",
					entrypoint: "transfer_from",
					calldata: [from, to, tokenId],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_approve = async (snAccount: Account, to: string, tokenId: number) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "loot_survivor_mock",
					entrypoint: "approve",
					calldata: [to, tokenId],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_setApprovalForAll = async (snAccount: Account, operator: string, approved: boolean) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "loot_survivor_mock",
					entrypoint: "set_approval_for_all",
					calldata: [operator, approved],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_getApproved = async (snAccount: Account, tokenId: number) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "loot_survivor_mock",
					entrypoint: "get_approved",
					calldata: [tokenId],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_isApprovedForAll = async (snAccount: Account, owner: string, operator: string) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "loot_survivor_mock",
					entrypoint: "is_approved_for_all",
					calldata: [owner, operator],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_supportsInterface = async (snAccount: Account, interfaceId: number) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "loot_survivor_mock",
					entrypoint: "supports_interface",
					calldata: [interfaceId],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_name = async (snAccount: Account) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "loot_survivor_mock",
					entrypoint: "name",
					calldata: [],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_symbol = async (snAccount: Account) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "loot_survivor_mock",
					entrypoint: "symbol",
					calldata: [],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const loot_survivor_mock_tokenUri = async (snAccount: Account, tokenId: number) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "loot_survivor_mock",
					entrypoint: "token_uri",
					calldata: [tokenId],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const pragma_mock_getDataMedian = async (snAccount: Account, dataType: models.DataType) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "pragma_mock",
					entrypoint: "get_data_median",
					calldata: [dataType],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_mint = async (snAccount: Account, recipient: string, tokenId: number) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "erc721_mock",
					entrypoint: "mint",
					calldata: [recipient, tokenId],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_balanceOf = async (snAccount: Account, account: string) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "erc721_mock",
					entrypoint: "balance_of",
					calldata: [account],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_ownerOf = async (snAccount: Account, tokenId: number) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "erc721_mock",
					entrypoint: "owner_of",
					calldata: [tokenId],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_safeTransferFrom = async (snAccount: Account, from: string, to: string, tokenId: number, data: Array<number>) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "erc721_mock",
					entrypoint: "safe_transfer_from",
					calldata: [from, to, tokenId, data],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_transferFrom = async (snAccount: Account, from: string, to: string, tokenId: number) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "erc721_mock",
					entrypoint: "transfer_from",
					calldata: [from, to, tokenId],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_approve = async (snAccount: Account, to: string, tokenId: number) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "erc721_mock",
					entrypoint: "approve",
					calldata: [to, tokenId],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_setApprovalForAll = async (snAccount: Account, operator: string, approved: boolean) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "erc721_mock",
					entrypoint: "set_approval_for_all",
					calldata: [operator, approved],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_getApproved = async (snAccount: Account, tokenId: number) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "erc721_mock",
					entrypoint: "get_approved",
					calldata: [tokenId],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_isApprovedForAll = async (snAccount: Account, owner: string, operator: string) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "erc721_mock",
					entrypoint: "is_approved_for_all",
					calldata: [owner, operator],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_supportsInterface = async (snAccount: Account, interfaceId: number) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "erc721_mock",
					entrypoint: "supports_interface",
					calldata: [interfaceId],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_name = async (snAccount: Account) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "erc721_mock",
					entrypoint: "name",
					calldata: [],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_symbol = async (snAccount: Account) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "erc721_mock",
					entrypoint: "symbol",
					calldata: [],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const erc721_mock_tokenUri = async (snAccount: Account, tokenId: number) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "erc721_mock",
					entrypoint: "token_uri",
					calldata: [tokenId],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_totalTournaments = async (snAccount: Account) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "tournament_mock",
					entrypoint: "total_tournaments",
					calldata: [],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_tournament = async (snAccount: Account, tournamentId: number) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "tournament_mock",
					entrypoint: "tournament",
					calldata: [tournamentId],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_tournamentEntries = async (snAccount: Account, tournamentId: number) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "tournament_mock",
					entrypoint: "tournament_entries",
					calldata: [tournamentId],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_tournamentPrizeKeys = async (snAccount: Account, tournamentId: number) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "tournament_mock",
					entrypoint: "tournament_prize_keys",
					calldata: [tournamentId],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_topScores = async (snAccount: Account, tournamentId: number) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "tournament_mock",
					entrypoint: "top_scores",
					calldata: [tournamentId],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_isTokenRegistered = async (snAccount: Account, token: string) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "tournament_mock",
					entrypoint: "is_token_registered",
					calldata: [token],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_createTournament = async (snAccount: Account, name: number, description: string, startTime: number, endTime: number, submissionPeriod: number, winnersCount: number, gatedType: models.Option, entryPremium: models.Option) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "tournament_mock",
					entrypoint: "create_tournament",
					calldata: [name, description, startTime, endTime, submissionPeriod, winnersCount, gatedType, entryPremium],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_registerTokens = async (snAccount: Account, tokens: Array<Token>) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "tournament_mock",
					entrypoint: "register_tokens",
					calldata: [tokens],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_enterTournament = async (snAccount: Account, tournamentId: number, gatedSubmissionType: models.Option) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "tournament_mock",
					entrypoint: "enter_tournament",
					calldata: [tournamentId, gatedSubmissionType],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_startTournament = async (snAccount: Account, tournamentId: number, startAll: boolean, startCount: models.Option) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "tournament_mock",
					entrypoint: "start_tournament",
					calldata: [tournamentId, startAll, startCount],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_submitScores = async (snAccount: Account, tournamentId: number, gameIds: Array<number>) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "tournament_mock",
					entrypoint: "submit_scores",
					calldata: [tournamentId, gameIds],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_addPrize = async (snAccount: Account, tournamentId: number, token: string, tokenDataType: models.TokenDataType, position: number) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "tournament_mock",
					entrypoint: "add_prize",
					calldata: [tournamentId, token, tokenDataType, position],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_distributePrizes = async (snAccount: Account, tournamentId: number, prizeKeys: Array<number>) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "tournament_mock",
					entrypoint: "distribute_prizes",
					calldata: [tournamentId, prizeKeys],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament_mock_initializer = async (snAccount: Account, ethAddress: string, lordsAddress: string, lootSurvivorAddress: string, oracleAddress: string) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "tournament_mock",
					entrypoint: "initializer",
					calldata: [ethAddress, lordsAddress, lootSurvivorAddress, oracleAddress],
				},
				"tournament",
			);
		} catch (error) {
			console.error(error);
		}
	};

	return {
		erc20_mock: {
			totalSupply: erc20_mock_totalSupply,
			balanceOf: erc20_mock_balanceOf,
			allowance: erc20_mock_allowance,
			transfer: erc20_mock_transfer,
			transferFrom: erc20_mock_transferFrom,
			approve: erc20_mock_approve,
			name: erc20_mock_name,
			symbol: erc20_mock_symbol,
			decimals: erc20_mock_decimals,
			mint: erc20_mock_mint,
		},
		loot_survivor_mock: {
			getAdventurer: loot_survivor_mock_getAdventurer,
			getAdventurerMeta: loot_survivor_mock_getAdventurerMeta,
			getBag: loot_survivor_mock_getBag,
			getCostToPlay: loot_survivor_mock_getCostToPlay,
			newGame: loot_survivor_mock_newGame,
			setAdventurer: loot_survivor_mock_setAdventurer,
			setAdventurerMeta: loot_survivor_mock_setAdventurerMeta,
			setBag: loot_survivor_mock_setBag,
			initializer: loot_survivor_mock_initializer,
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
		},
		pragma_mock: {
			getDataMedian: pragma_mock_getDataMedian,
		},
		erc721_mock: {
			mint: erc721_mock_mint,
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
		},
		tournament_mock: {
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
			initializer: tournament_mock_initializer,
		},
	};
}