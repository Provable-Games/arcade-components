
use starknet::{ContractAddress};

use token::erc721::interface::{IERC721Dispatcher, IERC721DispatcherTrait};

#[derive(Model, Copy, Drop, Serde)]
struct Config {
    #[key]
    key: u8,
    reward_token_address: ContractAddress,
}

#[generate_trait]
impl ConfigImpl of ConfigTrait {
    #[inline(always)]
    fn new(reward_token_address: ContractAddress) -> Config {
        Config { key: 1, reward_token_address }
    }
    #[inline(always)]
    fn ierc721(self: Config) -> IERC721Dispatcher {
        IERC721Dispatcher{contract_address: self.reward_token_address}
    }
}