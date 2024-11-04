use starknet::ContractAddress;

// dojo compatible structs

#[derive(Drop, Copy, Serde, Introspect)]
pub struct Stats { // 30 bits total
    strength: u8,
    dexterity: u8,
    vitality: u8, // 5 bits per stat
    intelligence: u8,
    wisdom: u8,
    charisma: u8,
    luck: u8, // dynamically generated, not stored.
}


#[derive(Drop, Copy, Serde, Introspect)]
pub struct Equipment { // 128 bits
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
pub struct Adventurer {
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
pub struct AdventurerMetadata {
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
pub struct Item { // 21 storage bits
    id: u8, // 7 bits
    xp: u16, // 9 bits
}


#[derive(Drop, Copy, Serde, Introspect)]
pub struct Bag { // 240 bits
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