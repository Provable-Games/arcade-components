use starknet::ContractAddress;
use adventurer::{adventurer::Adventurer, bag::Bag};
use tournament::ls15_components::constants::{
    TokenDataType, GatedEntryType
};
use tournament::ls15_components::loot_survivor::AdventurerMetadata;

#[derive(Drop, Copy, Serde, Introspect)]
pub struct Token {
    token: ContractAddress,
    token_data_type: TokenDataType,
}

#[derive(Copy, Drop, Serde, PartialEq, Introspect)]
pub struct EntryCriteria {
    token_id: u128,
    entry_count: u64,
}

#[derive(Copy, Drop, Serde, PartialEq, Introspect)]
pub struct GatedToken {
    token: ContractAddress,
    entry_type: GatedEntryType,
}

// enum config ERC20, ERC721, ERC1155
#[derive(Copy, Drop, Serde, Introspect)]
pub struct ERC20Data {
    token_amount: u128,
}

#[derive(Copy, Drop, Serde, Introspect)]
pub struct ERC721Data {
    token_id: u128,
}

#[derive(Copy, Drop, Serde, Introspect)]
pub struct ERC1155Data {
    token_id: u128,
    token_amount: u128,
}

#[derive(Copy, Drop, Serde, PartialEq, Introspect)]
pub struct Premium {
    token: ContractAddress,
    token_amount: u128,
    token_distribution: Span<u8>,
    creator_fee: u8,
}

#[derive(Drop, Copy, Serde)]
pub enum DataType {
    SpotEntry: felt252,
    FutureEntry: (felt252, u64),
    GenericEntry: felt252,
}

#[derive(Serde, Drop, Copy)]
pub enum AggregationMode {
    Median: (),
    Mean: (),
    Error: (),
}

#[derive(Serde, Drop, Copy)]
pub struct PragmaPricesResponse {
    price: u128,
    decimals: u32,
    last_updated_timestamp: u64,
    num_sources_aggregated: u32,
    expiration_timestamp: Option<u64>,
}

#[starknet::interface]
pub trait ILootSurvivor<TState> {
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
pub trait IPragmaABI<TContractState> {
    fn get_data_median(self: @TContractState, data_type: DataType) -> PragmaPricesResponse;
}

