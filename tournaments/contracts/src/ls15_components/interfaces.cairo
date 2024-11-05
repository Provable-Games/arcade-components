use starknet::ContractAddress;
use adventurer::{adventurer::Adventurer, bag::Bag};
use tournament::ls15_components::models::loot_survivor::AdventurerMetadata;

use dojo::world::{WorldStorage, WorldStorageTrait, IWorldDispatcher};

use tournament::ls15_components::tests::erc20_mock::IERC20MockDispatcher;
use tournament::ls15_components::tests::erc721_mock::IERC721MockDispatcher;
use tournament::ls15_components::tests::tournament_mock::ITournamentMockDispatcher;
use tournament::ls15_components::tests::loot_survivor_mock::ILootSurvivorMockDispatcher;
use tournament::ls15_components::tests::pragma_mock::IPragmaMockDispatcher;

use tournament::ls15_components::libs::utils::ZERO;

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
    pub price: u128,
    pub decimals: u32,
    pub last_updated_timestamp: u64,
    pub num_sources_aggregated: u32,
    pub expiration_timestamp: Option<u64>,
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

#[generate_trait]
pub impl WorldImpl of WorldTrait {
    fn contract_address(self: @WorldStorage, contract_name: @ByteArray) -> ContractAddress {
        match self.dns(contract_name) {
            Option::Some((contract_address, _)) => { (contract_address) },
            Option::None => { (ZERO()) },
        }
    }

    // Create a Store from a dispatcher
    // https://github.com/dojoengine/dojo/blob/main/crates/dojo/core/src/contract/components/world_provider.cairo
    // https://github.com/dojoengine/dojo/blob/main/crates/dojo/core/src/world/storage.cairo
    #[inline(always)]
    fn storage(dispatcher: IWorldDispatcher, namespace: @ByteArray) -> WorldStorage {
        (WorldStorageTrait::new(dispatcher, namespace))
    }

    //
    // addresses
    //

    #[inline(always)]
    fn tournament_mock_address(self: @WorldStorage) -> ContractAddress {
        (self.contract_address(@"tournament_mock"))
    }

    #[inline(always)]
    fn loot_survivor_mock_address(self: @WorldStorage) -> ContractAddress {
        (self.contract_address(@"loot_survivor_mock"))
    }

    #[inline(always)]
    fn pragma_mock_address(self: @WorldStorage) -> ContractAddress {
        (self.contract_address(@"pragma_mock"))
    }

    #[inline(always)]
    fn erc20_mock_address(self: @WorldStorage) -> ContractAddress {
        (self.contract_address(@"erc20_mock"))
    }

    #[inline(always)]
    fn erc721_mock_address(self: @WorldStorage) -> ContractAddress {
        (self.contract_address(@"erc721_mock"))
    }

    //
    // dispatchers
    //

    #[inline(always)]
    fn tournament_mock_dispatcher(self: @WorldStorage) -> ITournamentMockDispatcher {
        (ITournamentMockDispatcher { contract_address: self.tournament_mock_address() })
    }
    #[inline(always)]
    fn loot_survivor_mock_dispatcher(self: @WorldStorage) -> ILootSurvivorMockDispatcher {
        (ILootSurvivorMockDispatcher { contract_address: self.loot_survivor_mock_address() })
    }
    #[inline(always)]
    fn pragma_mock_dispatcher(self: @WorldStorage) -> IPragmaMockDispatcher {
        (IPragmaMockDispatcher { contract_address: self.pragma_mock_address() })
    }
    #[inline(always)]
    fn erc20_mock_dispatcher(self: @WorldStorage) -> IERC20MockDispatcher {
        (IERC20MockDispatcher { contract_address: self.erc20_mock_address() })
    }
    #[inline(always)]
    fn erc721_mock_dispatcher(self: @WorldStorage) -> IERC721MockDispatcher {
        (IERC721MockDispatcher { contract_address: self.erc721_mock_address() })
    }
}

