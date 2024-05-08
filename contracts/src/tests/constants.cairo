use starknet::ContractAddress;
use starknet::contract_address_const;

const NAME: felt252 = 'NAME';
const SYMBOL: felt252 = 'SYMBOL';
const DECIMALS: u8 = 18_u8;
const SUPPLY: u256 = 2000;
const VALUE: u256 = 300;
const ROLE: felt252 = 'ROLE';
const OTHER_ROLE: felt252 = 'OTHER_ROLE';
const URI: felt252 = 'URI';
const TOKEN_ID: u256 = 21;
const TOKEN_AMOUNT: u256 = 42;
const TOKEN_ID_2: u128 = 2;
const TOKEN_AMOUNT_2: u256 = 69;
const PUBKEY: felt252 = 'PUBKEY';
const OTHER_ID: felt252 = 'OTHER_ID';
const GITHUB_USERNAME: felt252 = 'GITHUB_USERNAME';
const TELEGRAM_HANDLE: felt252 = 'TELEGRAM_HANDLE';
const X_HANDLE: felt252 = 'X_HANDLE';
const NEW_GITHUB_USERNAME: felt252 = 'NEW_GITHUB_USERNAME';
const NEW_TELEGRAM_HANDLE: felt252 = 'NEW_TELEGRAM_HANDLE';
const NEW_X_HANDLE: felt252 = 'NEW_X_HANDLE';
const CLIENT_ID: u256 = 345;
const RATING: u8 = 64;
const VOTE_COUNT: u256 = 200;
const CLIENT_NAME: felt252 = 'CLIENT_NAME';
const CREATOR_ID: u256 = 0;
const GAME_ID: u256 = 32;
const GAME_NAME: felt252 = 'GAME_NAME';
const GAME_URL: felt252 = 'GAME_URL';
const NEW_URL: felt252 = 'NEW_URL';

fn ADMIN() -> ContractAddress {
    contract_address_const::<'ADMIN'>()
}

fn AUTHORIZED() -> ContractAddress {
    contract_address_const::<'AUTHORIZED'>()
}

fn ZERO() -> ContractAddress {
    contract_address_const::<0>()
}

fn CALLER() -> ContractAddress {
    contract_address_const::<'CALLER'>()
}

fn OWNER() -> ContractAddress {
    contract_address_const::<'OWNER'>()
}

fn NEW_OWNER() -> ContractAddress {
    contract_address_const::<'NEW_OWNER'>()
}

fn OTHER() -> ContractAddress {
    contract_address_const::<'OTHER'>()
}

fn OTHER_ADMIN() -> ContractAddress {
    contract_address_const::<'OTHER_ADMIN'>()
}

fn SPENDER() -> ContractAddress {
    contract_address_const::<'SPENDER'>()
}

fn RECIPIENT() -> ContractAddress {
    contract_address_const::<'RECIPIENT'>()
}

fn OPERATOR() -> ContractAddress {
    contract_address_const::<'OPERATOR'>()
}

fn BRIDGE() -> ContractAddress {
    contract_address_const::<'BRIDGE'>()
}
