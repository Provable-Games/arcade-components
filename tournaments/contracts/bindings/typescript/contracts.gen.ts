import { DojoProvider } from "@dojoengine/core";
import { Account } from "starknet";
import * as models from "./models.gen";

export async function setupWorld(provider: DojoProvider) {{

	const name = async (account: Account) => {
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

	const mint = async (account: Account, recipient: string, tokenId: number) => {
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

	const balanceOf = async (account: Account, account: string) => {
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

	const ownerOf = async (account: Account, tokenId: number) => {
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

	const safeTransferFrom = async (account: Account, from: string, to: string, tokenId: number, data: Array<number>) => {
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

	const transferFrom = async (account: Account, from: string, to: string, tokenId: number) => {
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

	const approve = async (account: Account, to: string, tokenId: number) => {
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

	const setApprovalForAll = async (account: Account, operator: string, approved: boolean) => {
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

	const getApproved = async (account: Account, tokenId: number) => {
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

	const isApprovedForAll = async (account: Account, owner: string, operator: string) => {
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

	const supportsInterface = async (account: Account, interfaceId: number) => {
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

	const name = async (account: Account) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "erc721_mock",
					entryPoint: "_name",
					calldata: [],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const symbol = async (account: Account) => {
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

	const tokenUri = async (account: Account, tokenId: number) => {
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

	const balanceOf = async (account: Account, account: string) => {
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

	const ownerOf = async (account: Account, tokenId: number) => {
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

	const safeTransferFrom = async (account: Account, from: string, to: string, tokenId: number, data: Array<number>) => {
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

	const transferFrom = async (account: Account, from: string, to: string, tokenId: number) => {
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

	const setApprovalForAll = async (account: Account, operator: string, approved: boolean) => {
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

	const getApproved = async (account: Account, tokenId: number) => {
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

	const isApprovedForAll = async (account: Account, owner: string, operator: string) => {
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

	const tokenUri = async (account: Account, tokenId: number) => {
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

	const getDataMedian = async (account: Account, dataType: models.DataType) => {
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

	const name = async (account: Account) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "pragma_mock",
					entryPoint: "name",
					calldata: [],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const totalTournaments = async (account: Account) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "LSTournament",
					entryPoint: "total_tournaments",
					calldata: [],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournament = async (account: Account, tournamentId: number) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "LSTournament",
					entryPoint: "tournament",
					calldata: [tournamentId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournamentEntries = async (account: Account, tournamentId: number) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "LSTournament",
					entryPoint: "tournament_entries",
					calldata: [tournamentId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const tournamentPrizeKeys = async (account: Account, tournamentId: number) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "LSTournament",
					entryPoint: "tournament_prize_keys",
					calldata: [tournamentId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const topScores = async (account: Account, tournamentId: number) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "LSTournament",
					entryPoint: "top_scores",
					calldata: [tournamentId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const isTournamentActive = async (account: Account, tournamentId: number) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "LSTournament",
					entryPoint: "is_tournament_active",
					calldata: [tournamentId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const isTokenRegistered = async (account: Account, token: string) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "LSTournament",
					entryPoint: "is_token_registered",
					calldata: [token],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const createTournament = async (account: Account, name: number, description: string, startTime: number, endTime: number, submissionPeriod: number, winnersCount: number, gatedType: models.Option, entryPremium: models.Option) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "LSTournament",
					entryPoint: "create_tournament",
					calldata: [name, description, startTime, endTime, submissionPeriod, winnersCount, gatedType, entryPremium],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const registerTokens = async (account: Account, tokens: Array<Token>) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "LSTournament",
					entryPoint: "register_tokens",
					calldata: [tokens],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const enterTournament = async (account: Account, tournamentId: number, gatedSubmissionType: models.Option) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "LSTournament",
					entryPoint: "enter_tournament",
					calldata: [tournamentId, gatedSubmissionType],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const startTournament = async (account: Account, tournamentId: number, startAll: boolean, startCount: models.Option) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "LSTournament",
					entryPoint: "start_tournament",
					calldata: [tournamentId, startAll, startCount],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const submitScores = async (account: Account, tournamentId: number, gameIds: Array<number>) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "LSTournament",
					entryPoint: "submit_scores",
					calldata: [tournamentId, gameIds],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const addPrize = async (account: Account, tournamentId: number, token: string, tokenDataType: models.TokenDataType, position: number) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "LSTournament",
					entryPoint: "add_prize",
					calldata: [tournamentId, token, tokenDataType, position],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const distributePrizes = async (account: Account, tournamentId: number, prizeKeys: Array<number>) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "LSTournament",
					entryPoint: "distribute_prizes",
					calldata: [tournamentId, prizeKeys],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const initializer = async (account: Account, ethAddress: string, lordsAddress: string, lootSurvivorAddress: string, oracleAddress: string) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "LSTournament",
					entryPoint: "initializer",
					calldata: [ethAddress, lordsAddress, lootSurvivorAddress, oracleAddress],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const name = async (account: Account) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "LSTournament",
					entryPoint: "name",
					calldata: [],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const totalTournaments = async (account: Account) => {
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

	const tournament = async (account: Account, tournamentId: number) => {
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

	const tournamentEntries = async (account: Account, tournamentId: number) => {
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

	const tournamentPrizeKeys = async (account: Account, tournamentId: number) => {
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

	const topScores = async (account: Account, tournamentId: number) => {
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

	const isTournamentActive = async (account: Account, tournamentId: number) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "tournament_mock",
					entryPoint: "is_tournament_active",
					calldata: [tournamentId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const isTokenRegistered = async (account: Account, token: string) => {
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

	const createTournament = async (account: Account, name: number, description: string, startTime: number, endTime: number, submissionPeriod: number, winnersCount: number, gatedType: models.Option, entryPremium: models.Option) => {
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

	const registerTokens = async (account: Account, tokens: Array<Token>) => {
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

	const enterTournament = async (account: Account, tournamentId: number, gatedSubmissionType: models.Option) => {
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

	const startTournament = async (account: Account, tournamentId: number, startAll: boolean, startCount: models.Option) => {
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

	const submitScores = async (account: Account, tournamentId: number, gameIds: Array<number>) => {
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

	const addPrize = async (account: Account, tournamentId: number, token: string, tokenDataType: models.TokenDataType, position: number) => {
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

	const distributePrizes = async (account: Account, tournamentId: number, prizeKeys: Array<number>) => {
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

	const initializer = async (account: Account, ethAddress: string, lordsAddress: string, lootSurvivorAddress: string, oracleAddress: string) => {
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

	const name = async (account: Account) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "tournament_mock",
					entryPoint: "name",
					calldata: [],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const name = async (account: Account) => {
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

	const balanceOf = async (account: Account, account: string) => {
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

	const ownerOf = async (account: Account, tokenId: number) => {
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

	const safeTransferFrom = async (account: Account, from: string, to: string, tokenId: number, data: Array<number>) => {
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

	const transferFrom = async (account: Account, from: string, to: string, tokenId: number) => {
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

	const approve = async (account: Account, to: string, tokenId: number) => {
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

	const setApprovalForAll = async (account: Account, operator: string, approved: boolean) => {
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

	const getApproved = async (account: Account, tokenId: number) => {
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

	const isApprovedForAll = async (account: Account, owner: string, operator: string) => {
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

	const supportsInterface = async (account: Account, interfaceId: number) => {
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

	const name = async (account: Account) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "loot_survivor_mock",
					entryPoint: "_name",
					calldata: [],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const symbol = async (account: Account) => {
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

	const tokenUri = async (account: Account, tokenId: number) => {
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

	const balanceOf = async (account: Account, account: string) => {
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

	const ownerOf = async (account: Account, tokenId: number) => {
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

	const safeTransferFrom = async (account: Account, from: string, to: string, tokenId: number, data: Array<number>) => {
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

	const transferFrom = async (account: Account, from: string, to: string, tokenId: number) => {
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

	const setApprovalForAll = async (account: Account, operator: string, approved: boolean) => {
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

	const getApproved = async (account: Account, tokenId: number) => {
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

	const isApprovedForAll = async (account: Account, owner: string, operator: string) => {
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

	const tokenUri = async (account: Account, tokenId: number) => {
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

	const getAdventurer = async (account: Account, adventurerId: number) => {
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

	const getAdventurerMeta = async (account: Account, adventurerId: number) => {
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

	const getBag = async (account: Account, adventurerId: number) => {
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

	const getCostToPlay = async (account: Account) => {
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

	const newGame = async (account: Account, clientRewardAddress: string, weapon: number, name: number, goldenTokenId: number, delayReveal: boolean, customRenderer: string, launchTournamentWinnerTokenId: number, mintTo: string) => {
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

	const setAdventurer = async (account: Account, adventurerId: number, adventurer: Adventurer) => {
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

	const setAdventurerMeta = async (account: Account, adventurerId: number, adventurerMeta: AdventurerMetadata) => {
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

	const setBag = async (account: Account, adventurerId: number, bag: Bag) => {
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

	const initializer = async (account: Account, name: string, symbol: string, baseUri: string, ethAddress: string, lordsAddress: string, pragmaAddress: string) => {
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

	const name = async (account: Account) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "erc1155_mock",
					entryPoint: "name",
					calldata: [],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const balanceOf = async (account: Account, account: string, tokenId: number) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "erc1155_mock",
					entryPoint: "balance_of",
					calldata: [account, tokenId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const balanceOfBatch = async (account: Account, accounts: Array<string>, tokenIds: Array<number>) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "erc1155_mock",
					entryPoint: "balance_of_batch",
					calldata: [accounts, tokenIds],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const safeTransferFrom = async (account: Account, from: string, to: string, tokenId: number, value: number, data: Array<number>) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "erc1155_mock",
					entryPoint: "safe_transfer_from",
					calldata: [from, to, tokenId, value, data],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const safeBatchTransferFrom = async (account: Account, from: string, to: string, tokenIds: Array<number>, values: Array<number>, data: Array<number>) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "erc1155_mock",
					entryPoint: "safe_batch_transfer_from",
					calldata: [from, to, tokenIds, values, data],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const isApprovedForAll = async (account: Account, owner: string, operator: string) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "erc1155_mock",
					entryPoint: "is_approved_for_all",
					calldata: [owner, operator],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const setApprovalForAll = async (account: Account, operator: string, approved: boolean) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "erc1155_mock",
					entryPoint: "set_approval_for_all",
					calldata: [operator, approved],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const supportsInterface = async (account: Account, interfaceId: number) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "erc1155_mock",
					entryPoint: "supports_interface",
					calldata: [interfaceId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const uri = async (account: Account, tokenId: number) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "erc1155_mock",
					entryPoint: "uri",
					calldata: [tokenId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const balanceOf = async (account: Account, account: string, tokenId: number) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "erc1155_mock",
					entryPoint: "balanceOf",
					calldata: [account, tokenId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const balanceOfBatch = async (account: Account, accounts: Array<string>, tokenIds: Array<number>) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "erc1155_mock",
					entryPoint: "balanceOfBatch",
					calldata: [accounts, tokenIds],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const safeTransferFrom = async (account: Account, from: string, to: string, tokenId: number, value: number, data: Array<number>) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "erc1155_mock",
					entryPoint: "safeTransferFrom",
					calldata: [from, to, tokenId, value, data],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const safeBatchTransferFrom = async (account: Account, from: string, to: string, tokenIds: Array<number>, values: Array<number>, data: Array<number>) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "erc1155_mock",
					entryPoint: "safeBatchTransferFrom",
					calldata: [from, to, tokenIds, values, data],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const isApprovedForAll = async (account: Account, owner: string, operator: string) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "erc1155_mock",
					entryPoint: "isApprovedForAll",
					calldata: [owner, operator],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const setApprovalForAll = async (account: Account, operator: string, approved: boolean) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "erc1155_mock",
					entryPoint: "setApprovalForAll",
					calldata: [operator, approved],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const name = async (account: Account) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "erc1155_mock",
					entryPoint: "_name",
					calldata: [],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const symbol = async (account: Account) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "erc1155_mock",
					entryPoint: "symbol",
					calldata: [],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const mint = async (account: Account, recipient: string, tokenId: number, value: number) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "erc1155_mock",
					entryPoint: "mint",
					calldata: [recipient, tokenId, value],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const mint = async (account: Account, recipient: string, amount: number) => {
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

	const name = async (account: Account) => {
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

	const totalSupply = async (account: Account) => {
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

	const balanceOf = async (account: Account, account: string) => {
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

	const allowance = async (account: Account, owner: string, spender: string) => {
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

	const transfer = async (account: Account, recipient: string, amount: number) => {
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

	const transferFrom = async (account: Account, sender: string, recipient: string, amount: number) => {
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

	const approve = async (account: Account, spender: string, amount: number) => {
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

	const name = async (account: Account) => {
		try {
			return await provider.execute(

				account,
				{
					contractName: "erc20_mock",
					entryPoint: "_name",
					calldata: [],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const symbol = async (account: Account) => {
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

	const decimals = async (account: Account) => {
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

	const totalSupply = async (account: Account) => {
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

	const balanceOf = async (account: Account, account: string) => {
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

	const transferFrom = async (account: Account, sender: string, recipient: string, amount: number) => {
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

	return {
		name,
		mint,
		balanceOf,
		ownerOf,
		safeTransferFrom,
		transferFrom,
		approve,
		setApprovalForAll,
		getApproved,
		isApprovedForAll,
		supportsInterface,
		name,
		symbol,
		tokenUri,
		balanceOf,
		ownerOf,
		safeTransferFrom,
		transferFrom,
		setApprovalForAll,
		getApproved,
		isApprovedForAll,
		tokenUri,
		getDataMedian,
		name,
		totalTournaments,
		tournament,
		tournamentEntries,
		tournamentPrizeKeys,
		topScores,
		isTournamentActive,
		isTokenRegistered,
		createTournament,
		registerTokens,
		enterTournament,
		startTournament,
		submitScores,
		addPrize,
		distributePrizes,
		initializer,
		name,
		totalTournaments,
		tournament,
		tournamentEntries,
		tournamentPrizeKeys,
		topScores,
		isTournamentActive,
		isTokenRegistered,
		createTournament,
		registerTokens,
		enterTournament,
		startTournament,
		submitScores,
		addPrize,
		distributePrizes,
		initializer,
		name,
		name,
		balanceOf,
		ownerOf,
		safeTransferFrom,
		transferFrom,
		approve,
		setApprovalForAll,
		getApproved,
		isApprovedForAll,
		supportsInterface,
		name,
		symbol,
		tokenUri,
		balanceOf,
		ownerOf,
		safeTransferFrom,
		transferFrom,
		setApprovalForAll,
		getApproved,
		isApprovedForAll,
		tokenUri,
		getAdventurer,
		getAdventurerMeta,
		getBag,
		getCostToPlay,
		newGame,
		setAdventurer,
		setAdventurerMeta,
		setBag,
		initializer,
		name,
		balanceOf,
		balanceOfBatch,
		safeTransferFrom,
		safeBatchTransferFrom,
		isApprovedForAll,
		setApprovalForAll,
		supportsInterface,
		uri,
		balanceOf,
		balanceOfBatch,
		safeTransferFrom,
		safeBatchTransferFrom,
		isApprovedForAll,
		setApprovalForAll,
		name,
		symbol,
		mint,
		mint,
		name,
		totalSupply,
		balanceOf,
		allowance,
		transfer,
		transferFrom,
		approve,
		name,
		symbol,
		decimals,
		totalSupply,
		balanceOf,
		transferFrom,
	};
}