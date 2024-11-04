import type { SchemaType } from "@dojoengine/sdk";

// Type definition for `tournament::ls15_components::loot_survivor::AdventurerMetadata` struct
export interface AdventurerMetadata {
	fieldOrder: string[];
	birth_date: number;
	death_date: number;
	level_seed: number;
	item_specials_seed: number;
	rank_at_death: number;
	delay_stat_reveal: boolean;
	golden_token_id: number;
}

// Type definition for `tournament::ls15_components::loot_survivor::AdventurerMetaModel` struct
export interface AdventurerMetaModel {
	fieldOrder: string[];
	adventurer_id: number;
	adventurer_meta: AdventurerMetadata;
}

// Type definition for `tournament::ls15_components::loot_survivor::Stats` struct
export interface Stats {
	fieldOrder: string[];
	strength: number;
	dexterity: number;
	vitality: number;
	intelligence: number;
	wisdom: number;
	charisma: number;
	luck: number;
}

// Type definition for `tournament::ls15_components::loot_survivor::Equipment` struct
export interface Equipment {
	fieldOrder: string[];
	weapon: Item;
	chest: Item;
	head: Item;
	waist: Item;
	foot: Item;
	hand: Item;
	neck: Item;
	ring: Item;
}

// Type definition for `tournament::ls15_components::loot_survivor::Item` struct
export interface Item {
	fieldOrder: string[];
	id: number;
	xp: number;
}

// Type definition for `tournament::ls15_components::loot_survivor::AdventurerModel` struct
export interface AdventurerModel {
	fieldOrder: string[];
	adventurer_id: number;
	adventurer: Adventurer;
}

// Type definition for `tournament::ls15_components::loot_survivor::Adventurer` struct
export interface Adventurer {
	fieldOrder: string[];
	health: number;
	xp: number;
	gold: number;
	beast_health: number;
	stat_upgrades_available: number;
	stats: Stats;
	equipment: Equipment;
	battle_action_count: number;
	mutated: boolean;
	awaiting_item_specials: boolean;
}

// Type definition for `tournament::ls15_components::loot_survivor::Item` struct
export interface Item {
	fieldOrder: string[];
	id: number;
	xp: number;
}

// Type definition for `tournament::ls15_components::loot_survivor::Bag` struct
export interface Bag {
	fieldOrder: string[];
	item_1: Item;
	item_2: Item;
	item_3: Item;
	item_4: Item;
	item_5: Item;
	item_6: Item;
	item_7: Item;
	item_8: Item;
	item_9: Item;
	item_10: Item;
	item_11: Item;
	item_12: Item;
	item_13: Item;
	item_14: Item;
	item_15: Item;
	mutated: boolean;
}

// Type definition for `tournament::ls15_components::loot_survivor::BagModel` struct
export interface BagModel {
	fieldOrder: string[];
	adventurer_id: number;
	bag: Bag;
}

// Type definition for `tournament::ls15_components::loot_survivor::Contracts` struct
export interface Contracts {
	fieldOrder: string[];
	contract: string;
	eth: string;
	lords: string;
	oracle: string;
}

// Type definition for `tournament::ls15_components::loot_survivor::GameCountModel` struct
export interface GameCountModel {
	fieldOrder: string[];
	contract_address: string;
	game_count: number;
}

// Type definition for `tournament::ls15_components::interfaces::ERC721Data` struct
export interface ERC721Data {
	fieldOrder: string[];
	token_id: number;
}

// Type definition for `tournament::ls15_components::interfaces::ERC20Data` struct
export interface ERC20Data {
	fieldOrder: string[];
	token_amount: number;
}

// Type definition for `tournament::ls15_components::interfaces::ERC1155Data` struct
export interface ERC1155Data {
	fieldOrder: string[];
	token_id: number;
	token_amount: number;
}

// Type definition for `tournament::ls15_components::tournament::PrizesModel` struct
export interface PrizesModel {
	fieldOrder: string[];
	prize_key: number;
	token: string;
	token_data_type: TokenDataType;
	payout_position: number;
	claimed: boolean;
}

// Type definition for `tournament::ls15_components::interfaces::ERC20Data` struct
export interface ERC20Data {
	fieldOrder: string[];
	token_amount: number;
}

// Type definition for `tournament::ls15_components::interfaces::ERC721Data` struct
export interface ERC721Data {
	fieldOrder: string[];
	token_id: number;
}

// Type definition for `tournament::ls15_components::tournament::TokenModel` struct
export interface TokenModel {
	fieldOrder: string[];
	token: string;
	name: string;
	symbol: string;
	token_data_type: TokenDataType;
	is_registered: boolean;
}

// Type definition for `tournament::ls15_components::interfaces::ERC1155Data` struct
export interface ERC1155Data {
	fieldOrder: string[];
	token_id: number;
	token_amount: number;
}

// Type definition for `tournament::ls15_components::tournament::TournamentContracts` struct
export interface TournamentContracts {
	fieldOrder: string[];
	contract: string;
	eth: string;
	lords: string;
	loot_survivor: string;
	oracle: string;
}

// Type definition for `tournament::ls15_components::tournament::TournamentEntriesAddressModel` struct
export interface TournamentEntriesAddressModel {
	fieldOrder: string[];
	tournament_id: number;
	address: string;
	entry_count: number;
}

// Type definition for `tournament::ls15_components::tournament::TournamentEntriesModel` struct
export interface TournamentEntriesModel {
	fieldOrder: string[];
	tournament_id: number;
	entry_count: number;
	premiums_formatted: boolean;
	distribute_called: boolean;
}

// Type definition for `tournament::ls15_components::tournament::TournamentEntryAddressesModel` struct
export interface TournamentEntryAddressesModel {
	fieldOrder: string[];
	tournament_id: number;
	addresses: Array<string>;
}

// Type definition for `tournament::ls15_components::tournament::TournamentEntryModel` struct
export interface TournamentEntryModel {
	fieldOrder: string[];
	tournament_id: number;
	game_id: number;
	address: string;
	status: EntryStatus;
}

// Type definition for `tournament::ls15_components::interfaces::EntryCriteria` struct
export interface EntryCriteria {
	fieldOrder: string[];
	token_id: number;
	entry_count: number;
}

// Type definition for `tournament::ls15_components::interfaces::GatedToken` struct
export interface GatedToken {
	fieldOrder: string[];
	token: string;
	entry_type: GatedEntryType;
}

// Type definition for `tournament::ls15_components::tournament::TournamentModel` struct
export interface TournamentModel {
	fieldOrder: string[];
	tournament_id: number;
	name: number;
	description: string;
	creator: string;
	start_time: number;
	end_time: number;
	submission_period: number;
	winners_count: number;
	gated_type: Option;
	entry_premium: Option;
}

// Type definition for `tournament::ls15_components::interfaces::Premium` struct
export interface Premium {
	fieldOrder: string[];
	token: string;
	token_amount: number;
	token_distribution: Array<number>;
	creator_fee: number;
}

// Type definition for `tournament::ls15_components::tournament::TournamentPrizeKeysModel` struct
export interface TournamentPrizeKeysModel {
	fieldOrder: string[];
	tournament_id: number;
	prize_keys: Array<number>;
}

// Type definition for `tournament::ls15_components::tournament::TournamentScoresModel` struct
export interface TournamentScoresModel {
	fieldOrder: string[];
	tournament_id: number;
	top_score_ids: Array<number>;
}

// Type definition for `tournament::ls15_components::tournament::TournamentStartIdsModel` struct
export interface TournamentStartIdsModel {
	fieldOrder: string[];
	tournament_id: number;
	address: string;
	game_ids: Array<number>;
}

// Type definition for `tournament::ls15_components::tournament::TournamentTotalsModel` struct
export interface TournamentTotalsModel {
	fieldOrder: string[];
	contract: string;
	total_tournaments: number;
	total_prizes: number;
}

// Type definition for `tournament::ls15_components::constants::TokenDataType` enum
export enum TokenDataType {
	erc20,
	erc721,
	erc1155,
}

// Type definition for `tournament::ls15_components::constants::EntryStatus` enum
export enum EntryStatus {
	Started,
	Submitted,
}

// Type definition for `tournament::ls15_components::constants::GatedType` enum
export enum GatedType {
	token,
	tournament,
}

// Type definition for `tournament::ls15_components::constants::GatedEntryType` enum
export enum GatedEntryType {
	criteria,
	uniform,
}

export interface TournamentSchemaType extends SchemaType {
	tournament: {
		AdventurerMetadata: AdventurerMetadata,
		AdventurerMetaModel: AdventurerMetaModel,
		Stats: Stats,
		Equipment: Equipment,
		Item: Item,
		AdventurerModel: AdventurerModel,
		Adventurer: Adventurer,
		Bag: Bag,
		BagModel: BagModel,
		Contracts: Contracts,
		GameCountModel: GameCountModel,
		ERC721Data: ERC721Data,
		ERC20Data: ERC20Data,
		ERC1155Data: ERC1155Data,
		PrizesModel: PrizesModel,
		TokenModel: TokenModel,
		TournamentContracts: TournamentContracts,
		TournamentEntriesAddressModel: TournamentEntriesAddressModel,
		TournamentEntriesModel: TournamentEntriesModel,
		TournamentEntryAddressesModel: TournamentEntryAddressesModel,
		TournamentEntryModel: TournamentEntryModel,
		EntryCriteria: EntryCriteria,
		GatedToken: GatedToken,
		TournamentModel: TournamentModel,
		Premium: Premium,
		TournamentPrizeKeysModel: TournamentPrizeKeysModel,
		TournamentScoresModel: TournamentScoresModel,
		TournamentStartIdsModel: TournamentStartIdsModel,
		TournamentTotalsModel: TournamentTotalsModel,
		ERC__Balance: ERC__Balance,
		ERC__Token: ERC__Token,
		ERC__Transfer: ERC__Transfer,
	},
}
export const schema: TournamentSchemaType = {
	tournament: {
		AdventurerMetadata: {
			fieldOrder: ['birth_date', 'death_date', 'level_seed', 'item_specials_seed', 'rank_at_death', 'delay_stat_reveal', 'golden_token_id'],
			birth_date: 0,
			death_date: 0,
			level_seed: 0,
			item_specials_seed: 0,
			rank_at_death: 0,
			delay_stat_reveal: false,
			golden_token_id: 0,
		},
		AdventurerMetaModel: {
			fieldOrder: ['adventurer_id', 'adventurer_meta'],
			adventurer_id: 0,
			adventurer_meta: { birth_date: 0,
death_date: 0,
level_seed: 0,
item_specials_seed: 0,
rank_at_death: 0,
delay_stat_reveal: false,
golden_token_id: 0, },
		},
		Stats: {
			fieldOrder: ['strength', 'dexterity', 'vitality', 'intelligence', 'wisdom', 'charisma', 'luck'],
			strength: 0,
			dexterity: 0,
			vitality: 0,
			intelligence: 0,
			wisdom: 0,
			charisma: 0,
			luck: 0,
		},
		Equipment: {
			fieldOrder: ['weapon', 'chest', 'head', 'waist', 'foot', 'hand', 'neck', 'ring'],
			weapon: { id: 0,
xp: 0, },
			chest: { id: 0,
xp: 0, },
			head: { id: 0,
xp: 0, },
			waist: { id: 0,
xp: 0, },
			foot: { id: 0,
xp: 0, },
			hand: { id: 0,
xp: 0, },
			neck: { id: 0,
xp: 0, },
			ring: { id: 0,
xp: 0, },
		},
		Item: {
			fieldOrder: ['id', 'xp'],
			id: 0,
			xp: 0,
		},
		AdventurerModel: {
			fieldOrder: ['adventurer_id', 'adventurer'],
			adventurer_id: 0,
			adventurer: { health: 0,
xp: 0,
gold: 0,
beast_health: 0,
stat_upgrades_available: 0,
stats: Stats,
equipment: Equipment,
battle_action_count: 0,
mutated: false,
awaiting_item_specials: false, },
		},
		Adventurer: {
			fieldOrder: ['health', 'xp', 'gold', 'beast_health', 'stat_upgrades_available', 'stats', 'equipment', 'battle_action_count', 'mutated', 'awaiting_item_specials'],
			health: 0,
			xp: 0,
			gold: 0,
			beast_health: 0,
			stat_upgrades_available: 0,
			stats: { strength: 0,
dexterity: 0,
vitality: 0,
intelligence: 0,
wisdom: 0,
charisma: 0,
luck: 0, },
			equipment: { weapon: Item,
chest: Item,
head: Item,
waist: Item,
foot: Item,
hand: Item,
neck: Item,
ring: Item, },
			battle_action_count: 0,
			mutated: false,
			awaiting_item_specials: false,
		},
		Bag: {
			fieldOrder: ['item_1', 'item_2', 'item_3', 'item_4', 'item_5', 'item_6', 'item_7', 'item_8', 'item_9', 'item_10', 'item_11', 'item_12', 'item_13', 'item_14', 'item_15', 'mutated'],
			item_1: { id: 0,
xp: 0, },
			item_2: { id: 0,
xp: 0, },
			item_3: { id: 0,
xp: 0, },
			item_4: { id: 0,
xp: 0, },
			item_5: { id: 0,
xp: 0, },
			item_6: { id: 0,
xp: 0, },
			item_7: { id: 0,
xp: 0, },
			item_8: { id: 0,
xp: 0, },
			item_9: { id: 0,
xp: 0, },
			item_10: { id: 0,
xp: 0, },
			item_11: { id: 0,
xp: 0, },
			item_12: { id: 0,
xp: 0, },
			item_13: { id: 0,
xp: 0, },
			item_14: { id: 0,
xp: 0, },
			item_15: { id: 0,
xp: 0, },
			mutated: false,
		},
		BagModel: {
			fieldOrder: ['adventurer_id', 'bag'],
			adventurer_id: 0,
			bag: { item_1: Item,
item_2: Item,
item_3: Item,
item_4: Item,
item_5: Item,
item_6: Item,
item_7: Item,
item_8: Item,
item_9: Item,
item_10: Item,
item_11: Item,
item_12: Item,
item_13: Item,
item_14: Item,
item_15: Item,
mutated: false, },
		},
		Contracts: {
			fieldOrder: ['contract', 'eth', 'lords', 'oracle'],
			contract: "",
			eth: "",
			lords: "",
			oracle: "",
		},
		GameCountModel: {
			fieldOrder: ['contract_address', 'game_count'],
			contract_address: "",
			game_count: 0,
		},
		ERC721Data: {
			fieldOrder: ['token_id'],
			token_id: 0,
		},
		ERC20Data: {
			fieldOrder: ['token_amount'],
			token_amount: 0,
		},
		ERC1155Data: {
			fieldOrder: ['token_id', 'token_amount'],
			token_id: 0,
			token_amount: 0,
		},
		PrizesModel: {
			fieldOrder: ['prize_key', 'token', 'token_data_type', 'payout_position', 'claimed'],
			prize_key: 0,
			token: "",
			token_data_type: TokenDataType.erc20,
			payout_position: 0,
			claimed: false,
		},
		TokenModel: {
			fieldOrder: ['token', 'name', 'symbol', 'token_data_type', 'is_registered'],
			token: "",
			name: "",
			symbol: "",
			token_data_type: TokenDataType.erc20,
			is_registered: false,
		},
		TournamentContracts: {
			fieldOrder: ['contract', 'eth', 'lords', 'loot_survivor', 'oracle'],
			contract: "",
			eth: "",
			lords: "",
			loot_survivor: "",
			oracle: "",
		},
		TournamentEntriesAddressModel: {
			fieldOrder: ['tournament_id', 'address', 'entry_count'],
			tournament_id: 0,
			address: "",
			entry_count: 0,
		},
		TournamentEntriesModel: {
			fieldOrder: ['tournament_id', 'entry_count', 'premiums_formatted', 'distribute_called'],
			tournament_id: 0,
			entry_count: 0,
			premiums_formatted: false,
			distribute_called: false,
		},
		TournamentEntryAddressesModel: {
			fieldOrder: ['tournament_id', 'addresses'],
			tournament_id: 0,
			addresses: [""],
		},
		TournamentEntryModel: {
			fieldOrder: ['tournament_id', 'game_id', 'address', 'status'],
			tournament_id: 0,
			game_id: 0,
			address: "",
			status: EntryStatus.Started,
		},
		EntryCriteria: {
			fieldOrder: ['token_id', 'entry_count'],
			token_id: 0,
			entry_count: 0,
		},
		GatedToken: {
			fieldOrder: ['token', 'entry_type'],
			token: "",
			entry_type: GatedEntryType.criteria,
		},
		TournamentModel: {
			fieldOrder: ['tournament_id', 'name', 'description', 'creator', 'start_time', 'end_time', 'submission_period', 'winners_count', 'gated_type', 'entry_premium'],
			tournament_id: 0,
			name: 0,
			description: "",
			creator: "",
			start_time: 0,
			end_time: 0,
			submission_period: 0,
			winners_count: 0,
			gated_type: Option,
			entry_premium: Option,
		},
		Premium: {
			fieldOrder: ['token', 'token_amount', 'token_distribution', 'creator_fee'],
			token: "",
			token_amount: 0,
			token_distribution: [0],
			creator_fee: 0,
		},
		TournamentPrizeKeysModel: {
			fieldOrder: ['tournament_id', 'prize_keys'],
			tournament_id: 0,
			prize_keys: [0],
		},
		TournamentScoresModel: {
			fieldOrder: ['tournament_id', 'top_score_ids'],
			tournament_id: 0,
			top_score_ids: [0],
		},
		TournamentStartIdsModel: {
			fieldOrder: ['tournament_id', 'address', 'game_ids'],
			tournament_id: 0,
			address: "",
			game_ids: [0],
		},
		TournamentTotalsModel: {
			fieldOrder: ['contract', 'total_tournaments', 'total_prizes'],
			contract: "",
			total_tournaments: 0,
			total_prizes: 0,
		},
		ERC__Balance: {
			fieldorder: ['balance', 'type', 'tokenmetadata'],
			balance: '',
			type: 'ERC20',
			tokenMetadata: {
				fieldorder: ['name', 'symbol', 'tokenId', 'decimals', 'contractAddress'],
				name: '',
				symbol: '',
				tokenId: '',
				decimals: '',
				contractAddress: '',
			},
		},
		ERC__Token: {
			fieldOrder: ['name', 'symbol', 'tokenId', 'decimals', 'contractAddress'],
			name: '',
			symbol: '',
			tokenId: '',
			decimals: '',
			contractAddress: '',
		},
		ERC__Transfer: {
			fieldOrder: ['from', 'to', 'amount', 'type', 'executed', 'tokenMetadata'],
			from: '',
			to: '',
			amount: '',
			type: 'ERC20',
			executedAt: '',
			tokenMetadata: {
				fieldOrder: ['name', 'symbol', 'tokenId', 'decimals', 'contractAddress'],
				name: '',
				symbol: '',
				tokenId: '',
				decimals: '',
				contractAddress: '',
			},
			transactionHash: '',
		},

	},
};
// Type definition for ERC__Balance struct
export type ERC__Type = 'ERC20' | 'ERC721';
export interface ERC__Balance {
    fieldOrder: string[];
    balance: string;
    type: string;
    tokenMetadata: ERC__Token;
}
export interface ERC__Token {
    fieldOrder: string[];
    name: string;
    symbol: string;
    tokenId: string;
    decimals: string;
    contractAddress: string;
}
export interface ERC__Transfer {
    fieldOrder: string[];
    from: string;
    to: string;
    amount: string;
    type: string;
    executedAt: string;
    tokenMetadata: ERC__Token;
    transactionHash: string;
}