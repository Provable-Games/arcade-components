use starknet::ContractAddress;
use tournament::ls15_components::models::loot_survivor::{Adventurer, AdventurerMetadata, Bag};

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
    fn set_adventurer(ref self: TState, adventurer_id: felt252, adventurer: Adventurer);
    fn set_adventurer_meta(
        ref self: TState, adventurer_id: felt252, adventurer_meta: AdventurerMetadata
    );
    fn set_bag(ref self: TState, adventurer_id: felt252, bag: Bag);
}

///
/// Loot Survivor Component
///
#[starknet::component]
pub mod loot_survivor_component {
    use super::ILootSurvivor;

    use core::num::traits::Zero;

    use starknet::{ContractAddress, get_block_timestamp, get_caller_address, get_contract_address};
    use dojo::contract::components::world_provider::{IWorldProvider};

    use tournament::ls15_components::models::loot_survivor::{
        Adventurer, AdventurerMetadata, Bag, Stats, Equipment, Item, AdventurerModel,
        AdventurerMetaModel, BagModel, GameCountModel, Contracts
    };
    use tournament::ls15_components::interfaces::{WorldTrait, WorldImpl};
    use tournament::ls15_components::libs::store::{Store, StoreTrait};
    use tournament::ls15_components::libs::utils::{pow};

    use openzeppelin_introspection::src5::SRC5Component;
    use openzeppelin_token::erc721::{
        ERC721Component, ERC721Component::{InternalImpl as ERC721InternalImpl},
    };
    use openzeppelin_token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};

    use tournament::ls15_components::constants::{VRF_COST_PER_GAME};
    use tournament::ls15_components::interfaces::{
        DataType, IPragmaABIDispatcher, IPragmaABIDispatcherTrait
    };

    #[storage]
    pub struct Storage {}

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {}

    mod Errors {
        const CALLER_IS_NOT_OWNER: felt252 = 'ERC721: caller is not owner';
    }

    #[embeddable_as(LootSurvivorImpl)]
    impl LootSurvivor<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        +SRC5Component::HasComponent<TContractState>,
        +ERC721Component::ERC721HooksTrait<TContractState>,
        impl ERC721: ERC721Component::HasComponent<TContractState>,
        +Drop<TContractState>
    > of ILootSurvivor<ComponentState<TContractState>> {
        fn get_adventurer(
            self: @ComponentState<TContractState>, adventurer_id: felt252
        ) -> Adventurer {
            let mut world = WorldTrait::storage(
                self.get_contract().world_dispatcher(), @"tournament"
            );
            let mut store: Store = StoreTrait::new(world);
            store.get_adventurer_model(adventurer_id).adventurer
        }

        fn get_adventurer_meta(
            self: @ComponentState<TContractState>, adventurer_id: felt252
        ) -> AdventurerMetadata {
            let mut world = WorldTrait::storage(
                self.get_contract().world_dispatcher(), @"tournament"
            );
            let mut store: Store = StoreTrait::new(world);
            store.get_adventurer_meta_model(adventurer_id).adventurer_meta
        }

        fn get_bag(self: @ComponentState<TContractState>, adventurer_id: felt252) -> Bag {
            let mut world = WorldTrait::storage(
                self.get_contract().world_dispatcher(), @"tournament"
            );
            let mut store: Store = StoreTrait::new(world);
            store.get_bag_model(adventurer_id).bag
        }

        fn get_cost_to_play(self: @ComponentState<TContractState>) -> u128 {
            50000000000000000000
        }

        fn new_game(
            ref self: ComponentState<TContractState>,
            client_reward_address: ContractAddress,
            weapon: u8,
            name: felt252,
            golden_token_id: u8,
            delay_reveal: bool,
            custom_renderer: ContractAddress,
            launch_tournament_winner_token_id: u128,
            mint_to: ContractAddress
        ) -> felt252 {
            let mut world = WorldTrait::storage(
                self.get_contract().world_dispatcher(), @"tournament"
            );
            let mut store: Store = StoreTrait::new(world);
            let contracts = store.get_contracts_model(get_contract_address());
            let cost_to_play = self.get_cost_to_play();
            // transfer base game cost
            let lords_dispatcher: IERC20Dispatcher = IERC20Dispatcher {
                contract_address: contracts.lords
            };
            lords_dispatcher
                .transfer_from(get_caller_address(), get_contract_address(), cost_to_play.into());

            // transfer VRF cost
            let eth_dispatcher: IERC20Dispatcher = IERC20Dispatcher {
                contract_address: contracts.eth
            };
            let vrf_cost = self._convert_usd_to_wei(VRF_COST_PER_GAME.into());
            eth_dispatcher
                .transfer_from(get_caller_address(), get_contract_address(), vrf_cost.into());

            let adventurer_id = self.get_game_count() + 1;
            // if a mint to address was provided, mint the adventurer to that address
            if !mint_to.is_zero() {
                let mut erc721 = get_dep_component_mut!(ref self, ERC721);
                // mint to the provided address
                erc721.mint(mint_to, adventurer_id.into());
            } else {
                let mut erc721 = get_dep_component_mut!(ref self, ERC721);
                // otherwise mint to the caller
                erc721.mint(get_caller_address(), adventurer_id.into());
            }

            let adventurer: Adventurer = Adventurer {
                health: 100,
                xp: 0,
                stats: Stats {
                    strength: 0,
                    dexterity: 0,
                    vitality: 0,
                    intelligence: 0,
                    wisdom: 0,
                    charisma: 0,
                    luck: 0
                },
                gold: 0,
                equipment: Equipment {
                    weapon: Item { id: 12, xp: 0 },
                    chest: Item { id: 0, xp: 0 },
                    head: Item { id: 0, xp: 0 },
                    waist: Item { id: 0, xp: 0 },
                    foot: Item { id: 0, xp: 0 },
                    hand: Item { id: 0, xp: 0 },
                    neck: Item { id: 0, xp: 0 },
                    ring: Item { id: 0, xp: 0 }
                },
                beast_health: 3,
                stat_upgrades_available: 0,
                battle_action_count: 0,
                mutated: false,
                awaiting_item_specials: false
            };
            store
                .set_adventurer_model(
                    @AdventurerModel { adventurer_id: adventurer_id.into(), adventurer }
                );

            let adventurer_meta = AdventurerMetadata {
                birth_date: get_block_timestamp().into(),
                death_date: 0,
                level_seed: 0,
                item_specials_seed: 0,
                rank_at_death: 0,
                delay_stat_reveal: delay_reveal,
                golden_token_id,
            };
            store
                .set_adventurer_meta_model(
                    @AdventurerMetaModel { adventurer_id: adventurer_id.into(), adventurer_meta }
                );
            store
                .set_game_count_model(
                    @GameCountModel {
                        contract_address: get_contract_address(), game_count: adventurer_id
                    }
                );
            adventurer_id.into()
        }

        fn set_adventurer(
            ref self: ComponentState<TContractState>, adventurer_id: felt252, adventurer: Adventurer
        ) {
            let mut world = WorldTrait::storage(
                self.get_contract().world_dispatcher(), @"tournament"
            );
            let mut store: Store = StoreTrait::new(world);
            store.set_adventurer_model(@AdventurerModel { adventurer_id, adventurer });
        }

        fn set_adventurer_meta(
            ref self: ComponentState<TContractState>,
            adventurer_id: felt252,
            adventurer_meta: AdventurerMetadata
        ) {
            let mut world = WorldTrait::storage(
                self.get_contract().world_dispatcher(), @"tournament"
            );
            let mut store: Store = StoreTrait::new(world);
            store
                .set_adventurer_meta_model(@AdventurerMetaModel { adventurer_id, adventurer_meta });
        }

        fn set_bag(ref self: ComponentState<TContractState>, adventurer_id: felt252, bag: Bag) {
            let mut world = WorldTrait::storage(
                self.get_contract().world_dispatcher(), @"tournament"
            );
            let mut store: Store = StoreTrait::new(world);
            store.set_bag_model(@BagModel { adventurer_id, bag });
        }
    }

    #[generate_trait]
    pub impl InternalImpl<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        +Drop<TContractState>
    > of InternalTrait<TContractState> {
        fn initialize(
            self: @ComponentState<TContractState>,
            eth_address: ContractAddress,
            lords_address: ContractAddress,
            pragma_address: ContractAddress
        ) {
            let mut world = WorldTrait::storage(
                self.get_contract().world_dispatcher(), @"tournament"
            );
            let mut store: Store = StoreTrait::new(world);
            let contracts = Contracts {
                contract: get_contract_address(),
                eth: eth_address,
                lords: lords_address,
                oracle: pragma_address
            };
            store.set_contracts_model(@contracts);
        }

        fn get_game_count(self: @ComponentState<TContractState>) -> u128 {
            let mut world = WorldTrait::storage(
                self.get_contract().world_dispatcher(), @"tournament"
            );
            let mut store: Store = StoreTrait::new(world);
            store.get_game_count_model(get_contract_address()).game_count
        }


        fn _convert_usd_to_wei(self: @ComponentState<TContractState>, usd: u128) -> u128 {
            let mut world = WorldTrait::storage(
                self.get_contract().world_dispatcher(), @"tournament"
            );
            let mut store: Store = StoreTrait::new(world);
            let contracts = store.get_contracts_model(get_contract_address());
            let oracle_dispatcher = IPragmaABIDispatcher { contract_address: contracts.oracle };
            let response = oracle_dispatcher.get_data_median(DataType::SpotEntry('ETH/USD'));
            assert(response.price > 0, 'error fetching eth price');
            (usd * pow(10, response.decimals.into()) * 1000000000000000000)
                / (response.price * 100000000)
        }
    }
}
