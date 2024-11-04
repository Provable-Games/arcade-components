use tournament::ls15_components::interfaces::{
    ERC20Data, ERC721Data, ERC1155Data, GatedToken, EntryCriteria
};

fn LOOT_SURVIVOR() -> starknet::ContractAddress {
    starknet::contract_address_const::<
        0x018108b32cea514a78ef1b0e4a0753e855cdf620bc0565202c02456f618c4dc4
    >()
}

fn LORDS() -> starknet::ContractAddress {
    starknet::contract_address_const::<
        0x0124aeb495b947201f5fac96fd1138e326ad86195b98df6dec9009158a533b49
    >()
}

fn ETH() -> starknet::ContractAddress {
    starknet::contract_address_const::<
        0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7
    >()
}

fn ORACLE() -> starknet::ContractAddress {
    starknet::contract_address_const::<
        0x2a85bd616f912537c50a49a4076db02c00b29b2cdc8a197ce92ed1837fa875b
    >()
}

pub const VRF_COST_PER_GAME: u32 = 50000000; // $0.50 with 8 decimals

//
// Tournament time constraints
//

pub const MIN_REGISTRATION_PERIOD: u32 = 300; // 5 minutes
pub const MAX_REGISTRATION_PERIOD: u32 = 2592000; // 1 month
pub const MIN_TOURNAMENT_LENGTH: u32 = 3600; // 1 hour
pub const MAX_TOURNAMENT_LENGTH: u32 = 15552000; // 6 months
pub const MIN_SUBMISSION_PERIOD: u32 = 1800; // 30 mins
pub const MAX_SUBMISSION_PERIOD: u32 = 1209600; // 2 weeks
pub const GAME_EXPIRATION_PERIOD: u32 = 864000; // 10 days

#[derive(Copy, Drop, Serde, PartialEq, Introspect)]
pub enum TokenType {
    ERC20,
    ERC721,
    ERC1155,
}

const TWO_POW_128: u128 = 100000000000000000000000000000000;

// TODO: add account addresses
#[derive(Copy, Drop, Serde, PartialEq, Introspect)]
pub enum GatedType {
    token: GatedToken,
    tournament: Span<u64>,
}

#[derive(Copy, Drop, Serde, Introspect)]
pub enum GatedSubmissionType {
    token_id: u256,
    game_id: Span<felt252>,
}

#[derive(Copy, Drop, Serde, PartialEq, Introspect)]
pub enum GatedEntryType {
    criteria: Span<EntryCriteria>,
    uniform: u64,
}

#[derive(Copy, Drop, Serde, Introspect)]
pub enum TokenDataType {
    erc20: ERC20Data,
    erc721: ERC721Data,
    erc1155: ERC1155Data,
}

#[derive(Copy, Drop, Serde, PartialEq, Introspect)]
pub enum EntryStatus {
    Started,
    Submitted,
}
