use starknet::ContractAddress;
use starknet::contract_address_const;

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

fn TOKEN_NAME() -> ByteArray {
    ("Loot Survivor")
}
fn TOKEN_SYMBOL() -> ByteArray {
    ("LSVR")
}
fn BASE_URI() -> ByteArray {
    ("https://lootsurvivor.io")
}

fn TOURNAMENT_NAME() -> ByteArray {
    ("Genesis Tournament")
}

const STARTING_BALANCE: u256 = 1000000000000000000000;
