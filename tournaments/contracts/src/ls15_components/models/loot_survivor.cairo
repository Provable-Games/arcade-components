use starknet::ContractAddress;

// dojo compatible structs

#[derive(Drop, Copy, Serde, Introspect)]
pub struct Stats { // 30 bits total
    pub strength: u8,
    pub dexterity: u8,
    pub vitality: u8, // 5 bits per stat
    pub intelligence: u8,
    pub wisdom: u8,
    pub charisma: u8,
    pub luck: u8, // dynamically generated, not stored.
}


#[derive(Drop, Copy, Serde, Introspect)]
pub struct Equipment { // 128 bits
    pub weapon: Item,
    pub chest: Item,
    pub head: Item,
    pub waist: Item, // 16 bits per item
    pub foot: Item,
    pub hand: Item,
    pub neck: Item,
    pub ring: Item,
}

#[derive(Drop, Copy, Serde, Introspect)]
pub struct Adventurer {
    pub health: u16, // 10 bits
    pub xp: u16, // 15 bits
    pub gold: u16, // 9 bits
    pub beast_health: u16, // 10 bits
    pub stat_upgrades_available: u8, // 4 bits
    pub stats: Stats, // 30 bits
    pub equipment: Equipment, // 128 bits
    pub battle_action_count: u8, // 8 bits
    pub mutated: bool, // not packed
    pub awaiting_item_specials: bool, // not packed
}

#[derive(Drop, Copy, Serde, Introspect)]
pub struct AdventurerMetadata {
    pub birth_date: u64, // 64 bits in storage
    pub death_date: u64, // 64 bits in storage
    pub level_seed: u64, // 64 bits in storage
    pub item_specials_seed: u16, // 16 bits in storage
    pub rank_at_death: u8, // 2 bits in storage
    pub delay_stat_reveal: bool, // 1 bit in storage
    pub golden_token_id: u8, // 8 bits in storage
    // launch_tournament_winner_token_id: u128, // 32 bits in storage
}


#[derive(Drop, Copy, Serde, Introspect)]
pub struct Item { // 21 storage bits
    pub id: u8, // 7 bits
    pub xp: u16, // 9 bits
}


#[derive(Drop, Copy, Serde, Introspect)]
pub struct Bag { // 240 bits
    pub item_1: Item, // 16 bits each
    pub item_2: Item,
    pub item_3: Item,
    pub item_4: Item,
    pub item_5: Item,
    pub item_6: Item,
    pub item_7: Item,
    pub item_8: Item,
    pub item_9: Item,
    pub item_10: Item,
    pub item_11: Item,
    pub item_12: Item,
    pub item_13: Item,
    pub item_14: Item,
    pub item_15: Item,
    pub mutated: bool,
}

///
/// Model
///

#[dojo::model]
#[derive(Copy, Drop, Serde)]
pub struct AdventurerModel {
    #[key]
    pub adventurer_id: felt252,
    pub adventurer: Adventurer,
}

#[dojo::model]
#[derive(Copy, Drop, Serde)]
pub struct AdventurerMetaModel {
    #[key]
    pub adventurer_id: felt252,
    pub adventurer_meta: AdventurerMetadata,
}

#[dojo::model]
#[derive(Copy, Drop, Serde)]
pub struct BagModel {
    #[key]
    pub adventurer_id: felt252,
    pub bag: Bag,
}

#[dojo::model]
#[derive(Copy, Drop, Serde)]
pub struct GameCountModel {
    #[key]
    pub contract_address: ContractAddress,
    pub game_count: u128,
}

#[dojo::model]
#[derive(Copy, Drop, Serde)]
pub struct Contracts {
    #[key]
    pub contract: ContractAddress,
    pub eth: ContractAddress,
    pub lords: ContractAddress,
    pub oracle: ContractAddress,
}
