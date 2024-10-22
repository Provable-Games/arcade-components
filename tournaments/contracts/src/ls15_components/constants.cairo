use tournament::ls15_components::interfaces::{
    OpenRegistrationConfig, ExclusiveRegistrationConfig, ERC20Prize, ERC721Prize, ERC1155Prize
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

const VRF_COST_PER_GAME: u32 = 50000000; // $0.50 with 8 decimals
const MIN_REGISTRATION_PERIOD: u32 = 3600; // 1 day
const SUBMISSION_PERIOD: u32 = 86400; // 1 day
const GAME_EXPIRATION_PERIOD: u32 = 864000; // 10 days

#[derive(Copy, Drop, Serde, PartialEq, Introspect)]
enum StatRequirementEnum {
    Xp,
    Gold,
    Strength,
    Dexterity,
    Vitality,
    Intelligence,
    Wisdom,
    Charisma,
    Luck
}

#[derive(Copy, Drop, Serde, PartialEq, Introspect)]
enum Operation {
    GreaterThan,
    LessThan,
    Equal,
}

#[derive(Copy, Drop, Serde, PartialEq, Introspect)]
enum TokenType {
    ERC20,
    ERC721,
    ERC1155,
}

const TWO_POW_128: u128 = 100000000000000000000000000000000;

#[derive(Drop, Serde)]
enum RegistrationType {
    open: OpenRegistrationConfig,
    exclusive: ExclusiveRegistrationConfig,
}

#[derive(Drop, Serde, Introspect)]
enum PrizeType {
    erc20: ERC20Prize,
    erc721: ERC721Prize,
    erc1155: ERC1155Prize,
}
