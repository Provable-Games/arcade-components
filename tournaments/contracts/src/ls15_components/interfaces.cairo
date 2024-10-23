use starknet::ContractAddress;
use adventurer::{adventurer::Adventurer, bag::Bag};
use tournament::ls15_components::constants::{Operation, StatRequirementEnum, TokenType};
use tournament::ls15_components::loot_survivor::AdventurerMetadata;

#[derive(Drop, Copy, Serde, Introspect)]
struct Token {
    token: ContractAddress,
    token_id: u128,
    token_type: TokenType,
}

// TODO: add advanced config enum to enter ids for entries, and basic config enum for entries across
// all ids
#[derive(Copy, Drop, Serde, PartialEq, Introspect)]
struct EntryCriteria {
    token_id: u128,
    token_amount: u128, // not essential
    entry_count: u8,
}

#[derive(Drop, Serde, PartialEq, Introspect)]
struct GatedToken {
    token: ContractAddress,
    entry_criteria: Array<EntryCriteria>,
    token_type: TokenType,
}

// enum config ERC20, ERC721, ERC1155
#[derive(Drop, Serde, Introspect)]
struct ERC20Prize {
    token: ContractAddress,
    token_amount: u128,
    token_distribution: Array<u8>,
}

#[derive(Drop, Serde, Introspect)]
struct ERC721Prize {
    token: ContractAddress,
    token_id: u128,
    position: u8,
}

#[derive(Drop, Serde, Introspect)]
struct ERC1155Prize {
    token: ContractAddress,
    token_id: u128,
    token_amount: u128,
    token_distribution: Array<u8>,
}

#[derive(Drop, Serde, PartialEq, Introspect)]
struct Premium {
    token: ContractAddress,
    token_amount: u128,
    token_distribution: Array<u8>,
    creator_fee: u8,
}

#[derive(Drop, Copy, Serde, Introspect)]
struct StatRequirement {
    stat: StatRequirementEnum,
    value: u16,
    operation: Operation,
}

#[derive(Drop, Copy, Serde, Introspect)]
struct LootRequirement {
    loot: u8,
    xp: u16,
    operation: Operation,
}

// #[derive(Drop, Serde)]
// struct ExclusiveRegistrationConfig {
//     gated_token: ContractAddress,
//     start_time: u64,
//     end_time: u64,
//     entry_premium_token: ContractAddress,
//     entry_premium_amount: u128,
//     prizes: Array<Prize2>,
//     stat_requirements: Array<StatRequirement>,
//     loot_requirements: Array<LootRequirement>,
// }

// #[derive(Drop, Serde)]
// struct OpenRegistrationConfig {
//     start_time: u64,
//     end_time: u64,
//     entry_premium_token: ContractAddress,
//     entry_premium_amount: u128,
//     prizes: Array<Prize2>,
//     stat_requirements: Array<StatRequirement>,
//     loot_requirements: Array<LootRequirement>,
// }

#[derive(Drop, Copy, Serde)]
enum DataType {
    SpotEntry: felt252,
    FutureEntry: (felt252, u64),
    GenericEntry: felt252,
}

#[derive(Serde, Drop, Copy)]
enum AggregationMode {
    Median: (),
    Mean: (),
    Error: (),
}

#[derive(Serde, Drop, Copy)]
struct PragmaPricesResponse {
    price: u128,
    decimals: u32,
    last_updated_timestamp: u64,
    num_sources_aggregated: u32,
    expiration_timestamp: Option<u64>,
}

#[starknet::interface]
trait ILootSurvivor<TState> {
    fn get_adventurer(self: @TState, adventurer_id: felt252) -> Adventurer;
    fn get_adventurer_meta(self: @TState, adventurer_id: felt252) -> AdventurerMetadata;
    fn get_bag(self: @TState, adventurer_id: felt252) -> Bag;
    fn get_cost_to_play(self: @TState) -> u128;
    fn new_game(
        ref self: TState,
        client_reward_address: ContractAddress,
        weapon: u8,
        name: felt252,
        golden_token_id: u8,
        delay_reveal: bool,
        custom_renderer: ContractAddress,
        launch_tournament_winner_token_id: u128,
        mint_to: ContractAddress
    ) -> felt252;
    fn transfer_from(self: @TState, from: ContractAddress, to: ContractAddress, character_id: u256);
}

#[starknet::interface]
trait IPragmaABI<TContractState> {
    fn get_data_median(self: @TContractState, data_type: DataType) -> PragmaPricesResponse;
}

