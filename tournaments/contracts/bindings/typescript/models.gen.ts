import type { SchemaType } from "@dojoengine/sdk";

import type { BigNumberish } from "starknet";
// Type definition for `tournament::ls15_components::models::loot_survivor::AdventurerMetaModel` struct
export interface AdventurerMetaModel {
  fieldOrder: string[];
  adventurer_id: BigNumberish;
  adventurer_meta: AdventurerMetadata;
}

// Type definition for `tournament::ls15_components::models::loot_survivor::AdventurerMetadata` struct
export interface AdventurerMetadata {
  fieldOrder: string[];
  birth_date: BigNumberish;
  death_date: BigNumberish;
  level_seed: BigNumberish;
  item_specials_seed: BigNumberish;
  rank_at_death: BigNumberish;
  delay_stat_reveal: boolean;
  golden_token_id: BigNumberish;
}

// Type definition for `tournament::ls15_components::models::loot_survivor::AdventurerMetaModelValue` struct
export interface AdventurerMetaModelValue {
  fieldOrder: string[];
  adventurer_meta: AdventurerMetadata;
}

// Type definition for `tournament::ls15_components::models::loot_survivor::AdventurerModelValue` struct
export interface AdventurerModelValue {
  fieldOrder: string[];
  adventurer: Adventurer;
}

// Type definition for `tournament::ls15_components::models::loot_survivor::Equipment` struct
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

// Type definition for `tournament::ls15_components::models::loot_survivor::Adventurer` struct
export interface Adventurer {
  fieldOrder: string[];
  health: BigNumberish;
  xp: BigNumberish;
  gold: BigNumberish;
  beast_health: BigNumberish;
  stat_upgrades_available: BigNumberish;
  stats: Stats;
  equipment: Equipment;
  battle_action_count: BigNumberish;
  mutated: boolean;
  awaiting_item_specials: boolean;
}

// Type definition for `tournament::ls15_components::models::loot_survivor::AdventurerModel` struct
export interface AdventurerModel {
  fieldOrder: string[];
  adventurer_id: BigNumberish;
  adventurer: Adventurer;
}

// Type definition for `tournament::ls15_components::models::loot_survivor::Item` struct
export interface Item {
  fieldOrder: string[];
  id: BigNumberish;
  xp: BigNumberish;
}

// Type definition for `tournament::ls15_components::models::loot_survivor::Stats` struct
export interface Stats {
  fieldOrder: string[];
  strength: BigNumberish;
  dexterity: BigNumberish;
  vitality: BigNumberish;
  intelligence: BigNumberish;
  wisdom: BigNumberish;
  charisma: BigNumberish;
  luck: BigNumberish;
}

// Type definition for `tournament::ls15_components::models::loot_survivor::BagModelValue` struct
export interface BagModelValue {
  fieldOrder: string[];
  bag: Bag;
}

// Type definition for `tournament::ls15_components::models::loot_survivor::BagModel` struct
export interface BagModel {
  fieldOrder: string[];
  adventurer_id: BigNumberish;
  bag: Bag;
}

// Type definition for `tournament::ls15_components::models::loot_survivor::Item` struct
export interface Item {
  fieldOrder: string[];
  id: BigNumberish;
  xp: BigNumberish;
}

// Type definition for `tournament::ls15_components::models::loot_survivor::Bag` struct
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

// Type definition for `tournament::ls15_components::models::loot_survivor::Contracts` struct
export interface Contracts {
  fieldOrder: string[];
  contract: string;
  eth: string;
  lords: string;
  oracle: string;
}

// Type definition for `tournament::ls15_components::models::loot_survivor::ContractsValue` struct
export interface ContractsValue {
  fieldOrder: string[];
  eth: string;
  lords: string;
  oracle: string;
}

// Type definition for `tournament::ls15_components::models::loot_survivor::GameCountModel` struct
export interface GameCountModel {
  fieldOrder: string[];
  contract_address: string;
  game_count: BigNumberish;
}

// Type definition for `tournament::ls15_components::models::loot_survivor::GameCountModelValue` struct
export interface GameCountModelValue {
  fieldOrder: string[];
  game_count: BigNumberish;
}

// Type definition for `tournament::ls15_components::models::tournament::ERC20Data` struct
export interface ERC20Data {
  fieldOrder: string[];
  token_amount: BigNumberish;
}

// Type definition for `tournament::ls15_components::models::tournament::ERC721Data` struct
export interface ERC721Data {
  fieldOrder: string[];
  token_id: BigNumberish;
}

// Type definition for `tournament::ls15_components::models::tournament::PrizesModel` struct
export interface PrizesModel {
  fieldOrder: string[];
  prize_key: BigNumberish;
  token: string;
  token_data_type: TokenDataType;
  payout_position: BigNumberish;
  claimed: boolean;
}

// Type definition for `tournament::ls15_components::models::tournament::PrizesModelValue` struct
export interface PrizesModelValue {
  fieldOrder: string[];
  token: string;
  token_data_type: TokenDataType;
  payout_position: BigNumberish;
  claimed: boolean;
}

// Type definition for `tournament::ls15_components::models::tournament::TokenModel` struct
export interface TokenModel {
  fieldOrder: string[];
  token: string;
  name: string;
  symbol: string;
  token_data_type: TokenDataType;
  is_registered: boolean;
}

// Type definition for `tournament::ls15_components::models::tournament::ERC20Data` struct
export interface ERC20Data {
  fieldOrder: string[];
  token_amount: BigNumberish;
}

// Type definition for `tournament::ls15_components::models::tournament::ERC721Data` struct
export interface ERC721Data {
  fieldOrder: string[];
  token_id: BigNumberish;
}

// Type definition for `tournament::ls15_components::models::tournament::TokenModelValue` struct
export interface TokenModelValue {
  fieldOrder: string[];
  name: string;
  symbol: string;
  token_data_type: TokenDataType;
  is_registered: boolean;
}

// Type definition for `tournament::ls15_components::models::tournament::TournamentContracts` struct
export interface TournamentContracts {
  fieldOrder: string[];
  contract: string;
  eth: string;
  lords: string;
  loot_survivor: string;
  oracle: string;
}

// Type definition for `tournament::ls15_components::models::tournament::TournamentContractsValue` struct
export interface TournamentContractsValue {
  fieldOrder: string[];
  eth: string;
  lords: string;
  loot_survivor: string;
  oracle: string;
}

// Type definition for `tournament::ls15_components::models::tournament::TournamentEntriesAddressModelValue` struct
export interface TournamentEntriesAddressModelValue {
  fieldOrder: string[];
  entry_count: BigNumberish;
}

// Type definition for `tournament::ls15_components::models::tournament::TournamentEntriesAddressModel` struct
export interface TournamentEntriesAddressModel {
  fieldOrder: string[];
  tournament_id: BigNumberish;
  address: string;
  entry_count: BigNumberish;
}

// Type definition for `tournament::ls15_components::models::tournament::TournamentEntriesModel` struct
export interface TournamentEntriesModel {
  fieldOrder: string[];
  tournament_id: BigNumberish;
  entry_count: BigNumberish;
  premiums_formatted: boolean;
  distribute_called: boolean;
}

// Type definition for `tournament::ls15_components::models::tournament::TournamentEntriesModelValue` struct
export interface TournamentEntriesModelValue {
  fieldOrder: string[];
  entry_count: BigNumberish;
  premiums_formatted: boolean;
  distribute_called: boolean;
}

// Type definition for `tournament::ls15_components::models::tournament::TournamentEntryAddressesModel` struct
export interface TournamentEntryAddressesModel {
  fieldOrder: string[];
  tournament_id: BigNumberish;
  addresses: Array<string>;
}

// Type definition for `tournament::ls15_components::models::tournament::TournamentEntryAddressesModelValue` struct
export interface TournamentEntryAddressesModelValue {
  fieldOrder: string[];
  addresses: Array<string>;
}

// Type definition for `tournament::ls15_components::models::tournament::TournamentEntryModel` struct
export interface TournamentEntryModel {
  fieldOrder: string[];
  tournament_id: BigNumberish;
  game_id: BigNumberish;
  address: string;
  status: EntryStatus;
}

// Type definition for `tournament::ls15_components::models::tournament::TournamentEntryModelValue` struct
export interface TournamentEntryModelValue {
  fieldOrder: string[];
  address: string;
  status: EntryStatus;
}

// Type definition for `tournament::ls15_components::models::tournament::GatedToken` struct
export interface GatedToken {
  fieldOrder: string[];
  token: string;
  entry_type: GatedEntryType;
}

// Type definition for `tournament::ls15_components::models::tournament::TournamentModel` struct
export interface TournamentModel {
  fieldOrder: string[];
  tournament_id: BigNumberish;
  name: BigNumberish;
  description: string;
  creator: string;
  start_time: BigNumberish;
  end_time: BigNumberish;
  submission_period: BigNumberish;
  winners_count: BigNumberish;
  gated_type: Option;
  entry_premium: Option;
}

// Type definition for `tournament::ls15_components::models::tournament::Premium` struct
export interface Premium {
  fieldOrder: string[];
  token: string;
  token_amount: BigNumberish;
  token_distribution: Array<BigNumberish>;
  creator_fee: BigNumberish;
}

// Type definition for `tournament::ls15_components::models::tournament::TournamentModelValue` struct
export interface TournamentModelValue {
  fieldOrder: string[];
  name: BigNumberish;
  description: string;
  creator: string;
  start_time: BigNumberish;
  end_time: BigNumberish;
  submission_period: BigNumberish;
  winners_count: BigNumberish;
  gated_type: Option;
  entry_premium: Option;
}

// Type definition for `tournament::ls15_components::models::tournament::EntryCriteria` struct
export interface EntryCriteria {
  fieldOrder: string[];
  token_id: BigNumberish;
  entry_count: BigNumberish;
}

// Type definition for `tournament::ls15_components::models::tournament::TournamentPrizeKeysModel` struct
export interface TournamentPrizeKeysModel {
  fieldOrder: string[];
  tournament_id: BigNumberish;
  prize_keys: Array<BigNumberish>;
}

// Type definition for `tournament::ls15_components::models::tournament::TournamentPrizeKeysModelValue` struct
export interface TournamentPrizeKeysModelValue {
  fieldOrder: string[];
  prize_keys: Array<BigNumberish>;
}

// Type definition for `tournament::ls15_components::models::tournament::TournamentScoresModel` struct
export interface TournamentScoresModel {
  fieldOrder: string[];
  tournament_id: BigNumberish;
  top_score_ids: Array<BigNumberish>;
}

// Type definition for `tournament::ls15_components::models::tournament::TournamentScoresModelValue` struct
export interface TournamentScoresModelValue {
  fieldOrder: string[];
  top_score_ids: Array<BigNumberish>;
}

// Type definition for `tournament::ls15_components::models::tournament::TournamentStartIdsModelValue` struct
export interface TournamentStartIdsModelValue {
  fieldOrder: string[];
  game_ids: Array<BigNumberish>;
}

// Type definition for `tournament::ls15_components::models::tournament::TournamentStartIdsModel` struct
export interface TournamentStartIdsModel {
  fieldOrder: string[];
  tournament_id: BigNumberish;
  address: string;
  game_ids: Array<BigNumberish>;
}

// Type definition for `tournament::ls15_components::models::tournament::TournamentTotalsModel` struct
export interface TournamentTotalsModel {
  fieldOrder: string[];
  contract: string;
  total_tournaments: BigNumberish;
  total_prizes: BigNumberish;
}

// Type definition for `tournament::ls15_components::models::tournament::TournamentTotalsModelValue` struct
export interface TournamentTotalsModelValue {
  fieldOrder: string[];
  total_tournaments: BigNumberish;
  total_prizes: BigNumberish;
}

// Type definition for `tournament::ls15_components::models::tournament::TokenDataType` enum
export enum TokenDataType {
  erc20,
  erc721,
}

// Type definition for `tournament::ls15_components::models::tournament::EntryStatus` enum
export enum EntryStatus {
  Started,
  Submitted,
}

// Type definition for `tournament::ls15_components::models::tournament::GatedType` enum
export enum GatedType {
  token,
  tournament,
  address,
}

// Type definition for `tournament::ls15_components::models::tournament::GatedEntryType` enum
export enum GatedEntryType {
  criteria,
  uniform,
}

export interface TournamentSchemaType extends SchemaType {
  tournament: {
    AdventurerMetaModel: AdventurerMetaModel;
    AdventurerMetadata: AdventurerMetadata;
    AdventurerMetaModelValue: AdventurerMetaModelValue;
    AdventurerModelValue: AdventurerModelValue;
    Equipment: Equipment;
    Adventurer: Adventurer;
    AdventurerModel: AdventurerModel;
    Item: Item;
    Stats: Stats;
    BagModelValue: BagModelValue;
    BagModel: BagModel;
    Bag: Bag;
    Contracts: Contracts;
    ContractsValue: ContractsValue;
    GameCountModel: GameCountModel;
    GameCountModelValue: GameCountModelValue;
    ERC20Data: ERC20Data;
    ERC721Data: ERC721Data;
    PrizesModel: PrizesModel;
    PrizesModelValue: PrizesModelValue;
    TokenModel: TokenModel;
    TokenModelValue: TokenModelValue;
    TournamentContracts: TournamentContracts;
    TournamentContractsValue: TournamentContractsValue;
    TournamentEntriesAddressModelValue: TournamentEntriesAddressModelValue;
    TournamentEntriesAddressModel: TournamentEntriesAddressModel;
    TournamentEntriesModel: TournamentEntriesModel;
    TournamentEntriesModelValue: TournamentEntriesModelValue;
    TournamentEntryAddressesModel: TournamentEntryAddressesModel;
    TournamentEntryAddressesModelValue: TournamentEntryAddressesModelValue;
    TournamentEntryModel: TournamentEntryModel;
    TournamentEntryModelValue: TournamentEntryModelValue;
    GatedToken: GatedToken;
    TournamentModel: TournamentModel;
    Premium: Premium;
    TournamentModelValue: TournamentModelValue;
    EntryCriteria: EntryCriteria;
    TournamentPrizeKeysModel: TournamentPrizeKeysModel;
    TournamentPrizeKeysModelValue: TournamentPrizeKeysModelValue;
    TournamentScoresModel: TournamentScoresModel;
    TournamentScoresModelValue: TournamentScoresModelValue;
    TournamentStartIdsModelValue: TournamentStartIdsModelValue;
    TournamentStartIdsModel: TournamentStartIdsModel;
    TournamentTotalsModel: TournamentTotalsModel;
    TournamentTotalsModelValue: TournamentTotalsModelValue;
    ERC__Balance: ERC__Balance;
    ERC__Token: ERC__Token;
    ERC__Transfer: ERC__Transfer;
  };
}
export const schema: TournamentSchemaType = {
  tournament: {
    AdventurerMetaModel: {
      fieldOrder: ["adventurer_id", "adventurer_meta"],
      adventurer_id: 0,
      adventurer_meta: {
        fieldOrder: [
          "birth_date",
          "death_date",
          "level_seed",
          "item_specials_seed",
          "rank_at_death",
          "delay_stat_reveal",
          "golden_token_id",
        ],
        birth_date: 0,
        death_date: 0,
        level_seed: 0,
        item_specials_seed: 0,
        rank_at_death: 0,
        delay_stat_reveal: false,
        golden_token_id: 0,
      },
    },
    AdventurerMetadata: {
      fieldOrder: [
        "birth_date",
        "death_date",
        "level_seed",
        "item_specials_seed",
        "rank_at_death",
        "delay_stat_reveal",
        "golden_token_id",
      ],
      birth_date: 0,
      death_date: 0,
      level_seed: 0,
      item_specials_seed: 0,
      rank_at_death: 0,
      delay_stat_reveal: false,
      golden_token_id: 0,
    },
    AdventurerMetaModelValue: {
      fieldOrder: ["adventurer_meta"],
      adventurer_meta: {
        fieldOrder: [
          "birth_date",
          "death_date",
          "level_seed",
          "item_specials_seed",
          "rank_at_death",
          "delay_stat_reveal",
          "golden_token_id",
        ],
        birth_date: 0,
        death_date: 0,
        level_seed: 0,
        item_specials_seed: 0,
        rank_at_death: 0,
        delay_stat_reveal: false,
        golden_token_id: 0,
      },
    },
    AdventurerModelValue: {
      fieldOrder: ["adventurer"],
      adventurer: {
        fieldOrder: [
          "health",
          "xp",
          "gold",
          "beast_health",
          "stat_upgrades_available",
          "stats",
          "equipment",
          "battle_action_count",
          "mutated",
          "awaiting_item_specials",
        ],
        health: 0,
        xp: 0,
        gold: 0,
        beast_health: 0,
        stat_upgrades_available: 0,
        stats: Stats,
        equipment: Equipment,
        battle_action_count: 0,
        mutated: false,
        awaiting_item_specials: false,
      },
    },
    Equipment: {
      fieldOrder: [
        "weapon",
        "chest",
        "head",
        "waist",
        "foot",
        "hand",
        "neck",
        "ring",
      ],
      weapon: { fieldOrder: ["id", "xp"], id: 0, xp: 0 },
      chest: { fieldOrder: ["id", "xp"], id: 0, xp: 0 },
      head: { fieldOrder: ["id", "xp"], id: 0, xp: 0 },
      waist: { fieldOrder: ["id", "xp"], id: 0, xp: 0 },
      foot: { fieldOrder: ["id", "xp"], id: 0, xp: 0 },
      hand: { fieldOrder: ["id", "xp"], id: 0, xp: 0 },
      neck: { fieldOrder: ["id", "xp"], id: 0, xp: 0 },
      ring: { fieldOrder: ["id", "xp"], id: 0, xp: 0 },
    },
    Adventurer: {
      fieldOrder: [
        "health",
        "xp",
        "gold",
        "beast_health",
        "stat_upgrades_available",
        "stats",
        "equipment",
        "battle_action_count",
        "mutated",
        "awaiting_item_specials",
      ],
      health: 0,
      xp: 0,
      gold: 0,
      beast_health: 0,
      stat_upgrades_available: 0,
      stats: {
        fieldOrder: [
          "strength",
          "dexterity",
          "vitality",
          "intelligence",
          "wisdom",
          "charisma",
          "luck",
        ],
        strength: 0,
        dexterity: 0,
        vitality: 0,
        intelligence: 0,
        wisdom: 0,
        charisma: 0,
        luck: 0,
      },
      equipment: {
        fieldOrder: [
          "weapon",
          "chest",
          "head",
          "waist",
          "foot",
          "hand",
          "neck",
          "ring",
        ],
        weapon: Item,
        chest: Item,
        head: Item,
        waist: Item,
        foot: Item,
        hand: Item,
        neck: Item,
        ring: Item,
      },
      battle_action_count: 0,
      mutated: false,
      awaiting_item_specials: false,
    },
    AdventurerModel: {
      fieldOrder: ["adventurer_id", "adventurer"],
      adventurer_id: 0,
      adventurer: {
        fieldOrder: [
          "health",
          "xp",
          "gold",
          "beast_health",
          "stat_upgrades_available",
          "stats",
          "equipment",
          "battle_action_count",
          "mutated",
          "awaiting_item_specials",
        ],
        health: 0,
        xp: 0,
        gold: 0,
        beast_health: 0,
        stat_upgrades_available: 0,
        stats: Stats,
        equipment: Equipment,
        battle_action_count: 0,
        mutated: false,
        awaiting_item_specials: false,
      },
    },
    Item: {
      fieldOrder: ["id", "xp"],
      id: 0,
      xp: 0,
    },
    Stats: {
      fieldOrder: [
        "strength",
        "dexterity",
        "vitality",
        "intelligence",
        "wisdom",
        "charisma",
        "luck",
      ],
      strength: 0,
      dexterity: 0,
      vitality: 0,
      intelligence: 0,
      wisdom: 0,
      charisma: 0,
      luck: 0,
    },
    BagModelValue: {
      fieldOrder: ["bag"],
      bag: {
        fieldOrder: [
          "item_1",
          "item_2",
          "item_3",
          "item_4",
          "item_5",
          "item_6",
          "item_7",
          "item_8",
          "item_9",
          "item_10",
          "item_11",
          "item_12",
          "item_13",
          "item_14",
          "item_15",
          "mutated",
        ],
        item_1: Item,
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
        mutated: false,
      },
    },
    BagModel: {
      fieldOrder: ["adventurer_id", "bag"],
      adventurer_id: 0,
      bag: {
        fieldOrder: [
          "item_1",
          "item_2",
          "item_3",
          "item_4",
          "item_5",
          "item_6",
          "item_7",
          "item_8",
          "item_9",
          "item_10",
          "item_11",
          "item_12",
          "item_13",
          "item_14",
          "item_15",
          "mutated",
        ],
        item_1: Item,
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
        mutated: false,
      },
    },
    Bag: {
      fieldOrder: [
        "item_1",
        "item_2",
        "item_3",
        "item_4",
        "item_5",
        "item_6",
        "item_7",
        "item_8",
        "item_9",
        "item_10",
        "item_11",
        "item_12",
        "item_13",
        "item_14",
        "item_15",
        "mutated",
      ],
      item_1: { fieldOrder: ["id", "xp"], id: 0, xp: 0 },
      item_2: { fieldOrder: ["id", "xp"], id: 0, xp: 0 },
      item_3: { fieldOrder: ["id", "xp"], id: 0, xp: 0 },
      item_4: { fieldOrder: ["id", "xp"], id: 0, xp: 0 },
      item_5: { fieldOrder: ["id", "xp"], id: 0, xp: 0 },
      item_6: { fieldOrder: ["id", "xp"], id: 0, xp: 0 },
      item_7: { fieldOrder: ["id", "xp"], id: 0, xp: 0 },
      item_8: { fieldOrder: ["id", "xp"], id: 0, xp: 0 },
      item_9: { fieldOrder: ["id", "xp"], id: 0, xp: 0 },
      item_10: { fieldOrder: ["id", "xp"], id: 0, xp: 0 },
      item_11: { fieldOrder: ["id", "xp"], id: 0, xp: 0 },
      item_12: { fieldOrder: ["id", "xp"], id: 0, xp: 0 },
      item_13: { fieldOrder: ["id", "xp"], id: 0, xp: 0 },
      item_14: { fieldOrder: ["id", "xp"], id: 0, xp: 0 },
      item_15: { fieldOrder: ["id", "xp"], id: 0, xp: 0 },
      mutated: false,
    },
    Contracts: {
      fieldOrder: ["contract", "eth", "lords", "oracle"],
      contract: "",
      eth: "",
      lords: "",
      oracle: "",
    },
    ContractsValue: {
      fieldOrder: ["eth", "lords", "oracle"],
      eth: "",
      lords: "",
      oracle: "",
    },
    GameCountModel: {
      fieldOrder: ["contract_address", "game_count"],
      contract_address: "",
      game_count: 0,
    },
    GameCountModelValue: {
      fieldOrder: ["game_count"],
      game_count: 0,
    },
    ERC20Data: {
      fieldOrder: ["token_amount"],
      token_amount: 0,
    },
    ERC721Data: {
      fieldOrder: ["token_id"],
      token_id: 0,
    },
    PrizesModel: {
      fieldOrder: [
        "prize_key",
        "token",
        "token_data_type",
        "payout_position",
        "claimed",
      ],
      prize_key: 0,
      token: "",
      token_data_type: TokenDataType.erc20,
      payout_position: 0,
      claimed: false,
    },
    PrizesModelValue: {
      fieldOrder: ["token", "token_data_type", "payout_position", "claimed"],
      token: "",
      token_data_type: TokenDataType.erc20,
      payout_position: 0,
      claimed: false,
    },
    TokenModel: {
      fieldOrder: [
        "token",
        "name",
        "symbol",
        "token_data_type",
        "is_registered",
      ],
      token: "",
      name: "",
      symbol: "",
      token_data_type: TokenDataType.erc20,
      is_registered: false,
    },
    TokenModelValue: {
      fieldOrder: ["name", "symbol", "token_data_type", "is_registered"],
      name: "",
      symbol: "",
      token_data_type: TokenDataType.erc20,
      is_registered: false,
    },
    TournamentContracts: {
      fieldOrder: ["contract", "eth", "lords", "loot_survivor", "oracle"],
      contract: "",
      eth: "",
      lords: "",
      loot_survivor: "",
      oracle: "",
    },
    TournamentContractsValue: {
      fieldOrder: ["eth", "lords", "loot_survivor", "oracle"],
      eth: "",
      lords: "",
      loot_survivor: "",
      oracle: "",
    },
    TournamentEntriesAddressModelValue: {
      fieldOrder: ["entry_count"],
      entry_count: 0,
    },
    TournamentEntriesAddressModel: {
      fieldOrder: ["tournament_id", "address", "entry_count"],
      tournament_id: 0,
      address: "",
      entry_count: 0,
    },
    TournamentEntriesModel: {
      fieldOrder: [
        "tournament_id",
        "entry_count",
        "premiums_formatted",
        "distribute_called",
      ],
      tournament_id: 0,
      entry_count: 0,
      premiums_formatted: false,
      distribute_called: false,
    },
    TournamentEntriesModelValue: {
      fieldOrder: ["entry_count", "premiums_formatted", "distribute_called"],
      entry_count: 0,
      premiums_formatted: false,
      distribute_called: false,
    },
    TournamentEntryAddressesModel: {
      fieldOrder: ["tournament_id", "addresses"],
      tournament_id: 0,
      addresses: [""],
    },
    TournamentEntryAddressesModelValue: {
      fieldOrder: ["addresses"],
      addresses: [""],
    },
    TournamentEntryModel: {
      fieldOrder: ["tournament_id", "game_id", "address", "status"],
      tournament_id: 0,
      game_id: 0,
      address: "",
      status: EntryStatus.Started,
    },
    TournamentEntryModelValue: {
      fieldOrder: ["address", "status"],
      address: "",
      status: EntryStatus.Started,
    },
    GatedToken: {
      fieldOrder: ["token", "entry_type"],
      token: "",
      entry_type: GatedEntryType.criteria,
    },
    TournamentModel: {
      fieldOrder: [
        "tournament_id",
        "name",
        "description",
        "creator",
        "start_time",
        "end_time",
        "submission_period",
        "winners_count",
        "gated_type",
        "entry_premium",
      ],
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
      fieldOrder: [
        "token",
        "token_amount",
        "token_distribution",
        "creator_fee",
      ],
      token: "",
      token_amount: 0,
      token_distribution: [0],
      creator_fee: 0,
    },
    TournamentModelValue: {
      fieldOrder: [
        "name",
        "description",
        "creator",
        "start_time",
        "end_time",
        "submission_period",
        "winners_count",
        "gated_type",
        "entry_premium",
      ],
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
    EntryCriteria: {
      fieldOrder: ["token_id", "entry_count"],
      token_id: 0,
      entry_count: 0,
    },
    TournamentPrizeKeysModel: {
      fieldOrder: ["tournament_id", "prize_keys"],
      tournament_id: 0,
      prize_keys: [0],
    },
    TournamentPrizeKeysModelValue: {
      fieldOrder: ["prize_keys"],
      prize_keys: [0],
    },
    TournamentScoresModel: {
      fieldOrder: ["tournament_id", "top_score_ids"],
      tournament_id: 0,
      top_score_ids: [0],
    },
    TournamentScoresModelValue: {
      fieldOrder: ["top_score_ids"],
      top_score_ids: [0],
    },
    TournamentStartIdsModelValue: {
      fieldOrder: ["game_ids"],
      game_ids: [0],
    },
    TournamentStartIdsModel: {
      fieldOrder: ["tournament_id", "address", "game_ids"],
      tournament_id: 0,
      address: "",
      game_ids: [0],
    },
    TournamentTotalsModel: {
      fieldOrder: ["contract", "total_tournaments", "total_prizes"],
      contract: "",
      total_tournaments: 0,
      total_prizes: 0,
    },
    TournamentTotalsModelValue: {
      fieldOrder: ["total_tournaments", "total_prizes"],
      total_tournaments: 0,
      total_prizes: 0,
    },
    ERC__Balance: {
      fieldOrder: ["balance", "type", "tokenmetadata"],
      balance: "",
      type: "ERC20",
      tokenMetadata: {
        fieldOrder: [
          "name",
          "symbol",
          "tokenId",
          "decimals",
          "contractAddress",
        ],
        name: "",
        symbol: "",
        tokenId: "",
        decimals: "",
        contractAddress: "",
      },
    },
    ERC__Token: {
      fieldOrder: ["name", "symbol", "tokenId", "decimals", "contractAddress"],
      name: "",
      symbol: "",
      tokenId: "",
      decimals: "",
      contractAddress: "",
    },
    ERC__Transfer: {
      fieldOrder: ["from", "to", "amount", "type", "executed", "tokenMetadata"],
      from: "",
      to: "",
      amount: "",
      type: "ERC20",
      executedAt: "",
      tokenMetadata: {
        fieldOrder: [
          "name",
          "symbol",
          "tokenId",
          "decimals",
          "contractAddress",
        ],
        name: "",
        symbol: "",
        tokenId: "",
        decimals: "",
        contractAddress: "",
      },
      transactionHash: "",
    },
  },
};
// Type definition for ERC__Balance struct
export type ERC__Type = "ERC20" | "ERC721";
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
