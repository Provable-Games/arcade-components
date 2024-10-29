use starknet::get_block_timestamp;
use tournament::ls15_components::constants::{
    MIN_REGISTRATION_PERIOD, MIN_SUBMISSION_PERIOD, TokenType, TokenDataType, GatedType,
    GatedEntryType, GatedSubmissionType
};
use tournament::tests::{
    utils,
    constants::{
        OWNER, RECIPIENT, SPENDER, ZERO, TOKEN_NAME, TOKEN_SYMBOL, BASE_URI, TOURNAMENT_NAME,
        STARTING_BALANCE
    },
};
use tournament::ls15_components::tests::erc20_mock::{
    IERC20MockDispatcher, IERC20MockDispatcherTrait
};
use tournament::ls15_components::tests::erc721_mock::{
    IERC721MockDispatcher, IERC721MockDispatcherTrait
};
use tournament::ls15_components::tests::tournament_mock::{
    ITournamentMockDispatcher, ITournamentMockDispatcherTrait
};
use adventurer::{
    adventurer::Adventurer, bag::Bag, equipment::Equipment,
    item::Item, stats::Stats
};
use tournament::ls15_components::loot_survivor::AdventurerMetadata;
use tournament::ls15_components::interfaces::{
    ERC20Data, ERC721Data, ERC1155Data, Token, Premium, GatedToken, EntryCriteria
};

//
// Test Helpers
//

fn create_basic_tournament(tournament: ITournamentMockDispatcher) -> u64 {
    tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            2 + MIN_REGISTRATION_PERIOD.into(),
            3 + MIN_REGISTRATION_PERIOD.into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        )
}

fn approve_game_costs(eth: IERC20MockDispatcher, lords: IERC20MockDispatcher, tournament: ITournamentMockDispatcher, entries: u256) {
    lords.approve(tournament.contract_address, entries * 50000000000000000000);
    eth.approve(tournament.contract_address, entries * 200000000000000);
}

fn create_dead_adventurer_with_xp(xp: u16) -> Adventurer {
    Adventurer {
        health: 0,
        xp,
        stats: Stats {
            strength: 0, dexterity: 0, vitality: 0, intelligence: 0, wisdom: 0, charisma: 0, luck: 0
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
    }
}

fn create_adventurer_metadata_with_death_date(death_date: u64) -> AdventurerMetadata {
    AdventurerMetadata {
        birth_date: get_block_timestamp().into(),
        death_date: death_date,
        level_seed: 0,
        item_specials_seed: 0,
        rank_at_death: 0,
        delay_stat_reveal: false,
        golden_token_id: 0,
    }
}

fn register_tokens_for_test(
    tournament: ITournamentMockDispatcher,
    erc20: IERC20MockDispatcher,
    erc721: IERC721MockDispatcher,
) {
    let tokens = array![
        Token { 
            token: erc20.contract_address, 
            token_data_type: TokenDataType::erc20(ERC20Data { token_amount: 1 }) 
        },
        Token { 
            token: erc721.contract_address, 
            token_data_type: TokenDataType::erc721(ERC721Data { token_id: 1 }) 
        },
    ];
    
    erc20.approve(tournament.contract_address, 1);
    erc721.approve(tournament.contract_address, 1);
    
    tournament.register_tokens(tokens);
}
