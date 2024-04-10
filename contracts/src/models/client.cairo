// Assertion models:
//  - game_id, name, url

use starknet::{ContractAddress};

#[derive(Model, Copy, Drop, Serde)]
struct Client {
    #[key]
    id: felt252,
    game_id: felt252,
    name: felt252,
    url: felt252,
    rating: u8, // 7 bits
    #[key]
    player_address: felt252,
    play_count: felt252,
    vote_count: felt252,
}

#[generate_trait]
impl ClientImpl of ClientTrait {
    #[inline(always)]
    fn new(id: felt252, game_id: felt252, name: felt252, url: felt252) -> Client {
        Client { id, game_id, name, url, rating: 0, player_address: 0, play_count: 0, vote_count: 0 }
    }
}
