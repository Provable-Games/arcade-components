use starknet::ContractAddress;

/// Raise a number to a power.
/// O(log n) time complexity.
/// * `base` - The number to raise.
/// * `exp` - The exponent.
/// # Returns
/// * `T` - The result of base raised to the power of exp.
pub fn pow<T, +Sub<T>, +Mul<T>, +Div<T>, +Rem<T>, +PartialEq<T>, +Into<u8, T>, +Drop<T>, +Copy<T>>(
    base: T, exp: T
) -> T {
    if exp == 0_u8.into() {
        1_u8.into()
    } else if exp == 1_u8.into() {
        base
    } else if exp % 2_u8.into() == 0_u8.into() {
        pow(base * base, exp / 2_u8.into())
    } else {
        base * pow(base * base, exp / 2_u8.into())
    }
}

// dojo compatible structs

#[derive(Drop, Copy, Serde, Introspect)]
struct Stats { // 30 bits total
    strength: u8,
    dexterity: u8,
    vitality: u8, // 5 bits per stat
    intelligence: u8,
    wisdom: u8,
    charisma: u8,
    luck: u8, // dynamically generated, not stored.
}


#[derive(Drop, Copy, Serde, Introspect)]
struct Equipment { // 128 bits
    weapon: Item,
    chest: Item,
    head: Item,
    waist: Item, // 16 bits per item
    foot: Item,
    hand: Item,
    neck: Item,
    ring: Item,
}

#[derive(Drop, Copy, Serde, Introspect)]
struct Adventurer {
    health: u16, // 10 bits
    xp: u16, // 15 bits
    gold: u16, // 9 bits
    beast_health: u16, // 10 bits
    stat_upgrades_available: u8, // 4 bits
    stats: Stats, // 30 bits
    equipment: Equipment, // 128 bits
    battle_action_count: u8, // 8 bits
    mutated: bool, // not packed
    awaiting_item_specials: bool, // not packed
}

#[derive(Drop, Copy, Serde, Introspect)]
struct AdventurerMetadata {
    birth_date: u64, // 64 bits in storage
    death_date: u64, // 64 bits in storage
    level_seed: u64, // 64 bits in storage
    item_specials_seed: u16, // 16 bits in storage
    rank_at_death: u8, // 2 bits in storage
    delay_stat_reveal: bool, // 1 bit in storage
    golden_token_id: u8, // 8 bits in storage
    // launch_tournament_winner_token_id: u128, // 32 bits in storage
}


#[derive(Drop, Copy, Serde, Introspect)]
struct Item { // 21 storage bits
    id: u8, // 7 bits
    xp: u16, // 9 bits
}


#[derive(Drop, Copy, Serde, Introspect)]
struct Bag { // 240 bits
    item_1: Item, // 16 bits each
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
    mutated: bool,
}

///
/// Model
///

#[dojo::model]
#[derive(Copy, Drop, Serde)]
struct AdventurerModel {
    #[key]
    adventurer_id: felt252,
    adventurer: Adventurer,
}

#[dojo::model]
#[derive(Copy, Drop, Serde)]
struct AdventurerMetaModel {
    #[key]
    adventurer_id: felt252,
    adventurer_meta: AdventurerMetadata,
}

#[dojo::model]
#[derive(Copy, Drop, Serde)]
struct BagModel {
    #[key]
    adventurer_id: felt252,
    bag: Bag,
}

#[dojo::model]
#[derive(Copy, Drop, Serde)]
struct GameCountModel {
    #[key]
    contract_address: ContractAddress,
    game_count: u128,
}

#[dojo::model]
#[derive(Copy, Drop, Serde)]
struct Contracts {
    #[key]
    contract: ContractAddress,
    eth: ContractAddress,
    lords: ContractAddress,
    oracle: ContractAddress,
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
    fn set_adventurer(self: @TState, adventurer_id: felt252, adventurer: Adventurer);
    fn set_adventurer_meta(self: @TState, adventurer_id: felt252, adventurer_meta: AdventurerMetadata);
    fn set_bag(self: @TState, adventurer_id: felt252, bag: Bag);
}

///
/// Loot Survivor Component
///
#[starknet::component]
mod loot_survivor_component {
    use super::ILootSurvivor;
    use super::Adventurer;
    use super::AdventurerMetadata;
    use super::Bag;
    use super::Item;
    use super::Equipment;
    use super::Stats;
    use super::AdventurerModel;
    use super::AdventurerMetaModel;
    use super::BagModel;
    use super::GameCountModel;
    use super::Contracts;
    use super::pow;

    use starknet::{ContractAddress, get_block_timestamp, get_caller_address, get_contract_address};
    use dojo::world::{
        IWorldProvider, IWorldProviderDispatcher, IWorldDispatcher, IWorldDispatcherTrait
    };

    use openzeppelin_introspection::src5::SRC5Component;
    use openzeppelin_token::erc721::{
        ERC721Component, ERC721Component::{InternalImpl as ERC721InternalImpl},
    };
    use openzeppelin_token::erc721::interface;
    use openzeppelin_token::erc20::interface::{IERC20, IERC20Dispatcher, IERC20DispatcherTrait};

    use tournament::ls15_components::constants::{VRF_COST_PER_GAME};
    use tournament::ls15_components::interfaces::{
        DataType, IPragmaABIDispatcher, IPragmaABIDispatcherTrait
    };

    #[storage]
    struct Storage {}

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {}

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
            self.get_adventurer_internal(adventurer_id)
        }

        fn get_adventurer_meta(
            self: @ComponentState<TContractState>, adventurer_id: felt252
        ) -> AdventurerMetadata {
            self.get_adventurer_meta_internal(adventurer_id)
        }

        fn get_bag(self: @ComponentState<TContractState>, adventurer_id: felt252) -> Bag {
            self.get_bag_internal(adventurer_id)
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
            let contracts = self.get_contracts();
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
            if mint_to.is_non_zero() {
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
            self.set_adventurer_internal(adventurer_id.into(), adventurer);

            let adventurer_meta = AdventurerMetadata {
                birth_date: get_block_timestamp().into(),
                death_date: 0,
                level_seed: 0,
                item_specials_seed: 0,
                rank_at_death: 0,
                delay_stat_reveal: delay_reveal,
                golden_token_id,
            };
            self.set_adventurer_meta_internal(adventurer_id.into(), adventurer_meta);
            self.set_game_count(adventurer_id);
            adventurer_id.into()
        }

        fn set_adventurer(
            self: @ComponentState<TContractState>, adventurer_id: felt252, adventurer: Adventurer
        ) {
            self.set_adventurer_internal(adventurer_id.into(), adventurer);
        }

        fn set_adventurer_meta(
            self: @ComponentState<TContractState>, adventurer_id: felt252, adventurer_meta: AdventurerMetadata
        ) {
            self.set_adventurer_meta_internal(adventurer_id.into(), adventurer_meta);
        }

        fn set_bag(self: @ComponentState<TContractState>, adventurer_id: felt252, bag: Bag) {
            self.set_bag_internal(adventurer_id.into(), bag);
        }
    }

    #[generate_trait]
    impl InternalImpl<
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
            set!(
                self.get_contract().world(),
                Contracts {
                    contract: get_contract_address(),
                    eth: eth_address,
                    lords: lords_address,
                    oracle: pragma_address
                }
            );
        }

        fn get_contracts(self: @ComponentState<TContractState>) -> Contracts {
            get!(self.get_contract().world(), (get_contract_address()), (Contracts))
        }

        fn get_game_count(self: @ComponentState<TContractState>) -> u128 {
            get!(self.get_contract().world(), (get_contract_address()), (GameCountModel)).game_count
        }

        fn get_adventurer_internal(
            self: @ComponentState<TContractState>, adventurer_id: felt252
        ) -> Adventurer {
            get!(self.get_contract().world(), (adventurer_id), (AdventurerModel)).adventurer
        }

        fn get_adventurer_meta_internal(
            self: @ComponentState<TContractState>, adventurer_id: felt252
        ) -> AdventurerMetadata {
            get!(self.get_contract().world(), (adventurer_id), (AdventurerMetaModel))
                .adventurer_meta
        }

        fn get_bag_internal(self: @ComponentState<TContractState>, adventurer_id: felt252) -> Bag {
            get!(self.get_contract().world(), (adventurer_id), (BagModel)).bag
        }

        fn set_game_count(self: @ComponentState<TContractState>, count: u128) {
            set!(
                self.get_contract().world(),
                GameCountModel { contract_address: get_contract_address(), game_count: count, }
            );
        }

        fn set_adventurer_internal(
            self: @ComponentState<TContractState>, adventurer_id: felt252, adventurer: Adventurer
        ) {
            set!(self.get_contract().world(), AdventurerModel { adventurer_id, adventurer, });
        }

        fn set_adventurer_meta_internal(
            self: @ComponentState<TContractState>,
            adventurer_id: felt252,
            adventurer_meta: AdventurerMetadata
        ) {
            set!(
                self.get_contract().world(), AdventurerMetaModel { adventurer_id, adventurer_meta, }
            );
        }

        fn set_bag_internal(
            self: @ComponentState<TContractState>, adventurer_id: felt252, bag: Bag
        ) {
            set!(self.get_contract().world(), BagModel { adventurer_id, bag, });
        }

        fn _convert_usd_to_wei(self: @ComponentState<TContractState>, usd: u128) -> u128 {
            let contracts = self.get_contracts();
            let oracle_dispatcher = IPragmaABIDispatcher { contract_address: contracts.oracle };
            let response = oracle_dispatcher.get_data_median(DataType::SpotEntry('ETH/USD'));
            assert(response.price > 0, 'error fetching eth price');
            (usd * pow(10, response.decimals.into()) * 1000000000000000000)
                / (response.price * 100000000)
        }
    }
}
