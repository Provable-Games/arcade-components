use debug::PrintTrait;
use core::option::Option;
use starknet::{ContractAddress, get_contract_address, get_caller_address, testing, deploy_syscall};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use dojo::model::{Model, ModelTest, ModelIndex, ModelEntityTest};
use dojo::utils::test::spawn_test_world;

use tournament::ls15_components::constants::{
    MIN_REGISTRATION_PERIOD, MIN_SUBMISSION_PERIOD, TokenType, PrizeType, GatedType, GatedEntryType,
    GatedSubmissionType
};
use tournament::ls15_components::interfaces::{
    ERC20Prize, ERC721Prize, ERC1155Prize, Token, Premium, GatedToken, EntryCriteria
};
use adventurer::{
    adventurer::Adventurer, adventurer_meta::AdventurerMetadata, bag::Bag, equipment::Equipment,
    item::Item, stats::Stats
};

use tournament::tests::{
    utils,
    constants::{
        OWNER, RECIPIENT, SPENDER, ZERO, TOKEN_NAME, TOKEN_SYMBOL, BASE_URI, TOURNAMENT_NAME,
        STARTING_BALANCE
    },
};
use tournament::ls15_components::tests::erc20_mock::{
    erc20_mock, IERC20MockDispatcher, IERC20MockDispatcherTrait
};
use tournament::ls15_components::tests::erc721_mock::{
    erc721_mock, IERC721MockDispatcher, IERC721MockDispatcherTrait
};
use tournament::ls15_components::tests::erc1155_mock::{
    erc1155_mock, IERC1155MockDispatcher, IERC1155MockDispatcherTrait
};

use tournament::ls15_components::tests::tournament_mock::{
    tournament_mock, ITournamentMockDispatcher, ITournamentMockDispatcherTrait
};
use tournament::ls15_components::tests::loot_survivor_mock::{
    loot_survivor_mock, ILootSurvivorMockDispatcher, ILootSurvivorMockDispatcherTrait
};
use tournament::ls15_components::tests::pragma_mock::{
    pragma_mock, IPragmaMockDispatcher, IPragmaMockDispatcherTrait
};

use openzeppelin_token::erc721::interface;
use openzeppelin_token::erc721::{ERC721Component, ERC721Component::{Transfer, Approval,}};

//
// events helpers
//

fn assert_event_transfer(
    emitter: ContractAddress, from: ContractAddress, to: ContractAddress, token_id: u256
) {
    let event = utils::pop_log::<Transfer>(emitter).unwrap();
    assert(event.from == from, 'Invalid `from`');
    assert(event.to == to, 'Invalid `to`');
    assert(event.token_id == token_id, 'Invalid `token_id`');
}

fn assert_only_event_transfer(
    emitter: ContractAddress, from: ContractAddress, to: ContractAddress, token_id: u256
) {
    assert_event_transfer(emitter, from, to, token_id);
    utils::assert_no_events_left(emitter);
}

fn assert_event_approval(
    emitter: ContractAddress, owner: ContractAddress, approved: ContractAddress, token_id: u256
) {
    let event = utils::pop_log::<Approval>(emitter).unwrap();
    assert(event.owner == owner, 'Invalid `owner`');
    assert(event.approved == approved, 'Invalid `approved`');
    assert(event.token_id == token_id, 'Invalid `token_id`');
}

fn assert_only_event_approval(
    emitter: ContractAddress, owner: ContractAddress, approved: ContractAddress, token_id: u256
) {
    assert_event_approval(emitter, owner, approved, token_id);
    utils::assert_no_events_left(emitter);
}


//
// Setup
//

fn setup_uninitialized() -> (
    IWorldDispatcher,
    ITournamentMockDispatcher,
    ILootSurvivorMockDispatcher,
    IPragmaMockDispatcher,
    IERC20MockDispatcher,
    IERC20MockDispatcher,
    IERC20MockDispatcher,
    IERC721MockDispatcher,
    IERC1155MockDispatcher
) {
    testing::set_block_number(1);
    testing::set_block_timestamp(1);
    let mut world = spawn_test_world(["tournament"].span(), get_models_test_class_hashes!(),);

    let mut tournament = ITournamentMockDispatcher {
        contract_address: world
            .deploy_contract('salt', tournament_mock::TEST_CLASS_HASH.try_into().unwrap())
    };
    world.grant_owner(dojo::utils::bytearray_hash(@"tournament"), tournament.contract_address);
    let call_data: Span<felt252> = array![].span();
    world.init_contract(selector_from_tag!("tournament-tournament_mock"), call_data);

    let mut loot_survivor = ILootSurvivorMockDispatcher {
        contract_address: world
            .deploy_contract('salt2', loot_survivor_mock::TEST_CLASS_HASH.try_into().unwrap())
    };
    world.grant_owner(dojo::utils::bytearray_hash(@"tournament"), loot_survivor.contract_address);
    let call_data: Span<felt252> = array![].span();
    world.init_contract(selector_from_tag!("tournament-loot_survivor_mock"), call_data);

    let mut pragma = IPragmaMockDispatcher {
        contract_address: world
            .deploy_contract('salt3', pragma_mock::TEST_CLASS_HASH.try_into().unwrap())
    };
    world.grant_owner(dojo::utils::bytearray_hash(@"tournament"), pragma.contract_address);
    let call_data: Span<felt252> = array![].span();
    world.init_contract(selector_from_tag!("tournament-pragma_mock"), call_data);

    let (contract, _) = deploy_syscall(
        erc20_mock::TEST_CLASS_HASH.try_into().unwrap(), 'salt4', call_data, false
    )
        .unwrap();
    let mut eth = IERC20MockDispatcher { contract_address: contract };

    let (contract, _) = deploy_syscall(
        erc20_mock::TEST_CLASS_HASH.try_into().unwrap(), 'salt5', call_data, false
    )
        .unwrap();
    let mut lords = IERC20MockDispatcher { contract_address: contract };

    let mut erc20 = IERC20MockDispatcher {
        contract_address: world
            .deploy_contract('salt6', erc20_mock::TEST_CLASS_HASH.try_into().unwrap())
    };
    world.grant_owner(dojo::utils::bytearray_hash(@"tournament"), erc20.contract_address);
    let call_data: Span<felt252> = array![].span();
    world.init_contract(selector_from_tag!("tournament-erc20_mock"), call_data);

    let mut erc721 = IERC721MockDispatcher {
        contract_address: world
            .deploy_contract('salt7', erc721_mock::TEST_CLASS_HASH.try_into().unwrap())
    };
    world.grant_owner(dojo::utils::bytearray_hash(@"tournament"), erc721.contract_address);
    let call_data: Span<felt252> = array![].span();
    world.init_contract(selector_from_tag!("tournament-erc721_mock"), call_data);

    let mut erc1155 = IERC1155MockDispatcher {
        contract_address: world
            .deploy_contract('salt8', erc1155_mock::TEST_CLASS_HASH.try_into().unwrap())
    };
    world.grant_owner(dojo::utils::bytearray_hash(@"tournament"), erc1155.contract_address);
    let call_data: Span<felt252> = array![].span();
    world.init_contract(selector_from_tag!("tournament-erc1155_mock"), call_data);

    (world, tournament, loot_survivor, pragma, eth, lords, erc20, erc721, erc1155)
}

fn setup() -> (
    IWorldDispatcher,
    ITournamentMockDispatcher,
    ILootSurvivorMockDispatcher,
    IPragmaMockDispatcher,
    IERC20MockDispatcher,
    IERC20MockDispatcher,
    IERC20MockDispatcher,
    IERC721MockDispatcher,
    IERC1155MockDispatcher
) {
    let (
        mut world,
        mut tournament,
        mut loot_survivor,
        mut pragma,
        mut eth,
        mut lords,
        mut erc20,
        mut erc721,
        mut erc1155
    ) =
        setup_uninitialized();

    // initialize contracts
    tournament
        .initializer(
            eth.contract_address,
            lords.contract_address,
            loot_survivor.contract_address,
            pragma.contract_address
        );
    loot_survivor
        .initializer(
            TOKEN_NAME(),
            TOKEN_SYMBOL(),
            BASE_URI(),
            eth.contract_address,
            lords.contract_address,
            pragma.contract_address
        );

    // mint tokens
    testing::set_account_contract_address(OWNER());
    testing::set_caller_address(OWNER());
    eth.mint(OWNER(), STARTING_BALANCE);
    lords.mint(OWNER(), STARTING_BALANCE);
    erc20.mint(OWNER(), STARTING_BALANCE);
    erc721.mint(OWNER(), 1);

    // drop all events
    utils::drop_all_events(world.contract_address);
    utils::drop_all_events(tournament.contract_address);
    utils::drop_all_events(loot_survivor.contract_address);

    (world, tournament, loot_survivor, pragma, eth, lords, erc20, erc721, erc1155)
}

//
// initialize
//

#[test]
fn test_initializer() {
    let (
        _world,
        _tournament,
        mut loot_survivor,
        _pragma,
        mut eth,
        mut lords,
        mut erc20,
        mut erc721,
        _erc1155
    ) =
        setup();

    assert(loot_survivor.symbol() == "LSVR", 'Symbol is wrong');

    assert(
        loot_survivor.supports_interface(interface::IERC721_ID) == true, 'should support IERC721_ID'
    );
    assert(
        loot_survivor.supports_interface(interface::IERC721_METADATA_ID) == true,
        'should support METADATA'
    );

    // TODO: Implement error suppression as wants to check contract is a receiver (need snforge
    // integration)
    // erc1155.mint(OWNER(), 1, 1);
    assert(erc20.balance_of(OWNER()) == STARTING_BALANCE, 'Invalid balance');
    assert(erc721.balance_of(OWNER()) == 1, 'Invalid balance');
    assert(eth.balance_of(OWNER()) == STARTING_BALANCE, 'Invalid balance');
    assert(lords.balance_of(OWNER()) == STARTING_BALANCE, 'Invalid balance');
    // assert(erc1155.balance_of(OWNER(), 1) == 1, 'Invalid balance');
}

#[test]
fn test_create_tournament() {
    let (_world, mut tournament, _loot_survivor, _pragma, _eth, _lords, _erc20, _erc721, _erc1155) =
        setup();

    let tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            2 + MIN_REGISTRATION_PERIOD.into(),
            3 + MIN_REGISTRATION_PERIOD.into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );

    let tournament_data = tournament.tournament(tournament_id);
    assert(tournament_data.name == TOURNAMENT_NAME(), 'Invalid tournament name');
    assert(
        tournament_data.start_time == 2 + MIN_REGISTRATION_PERIOD.into(),
        'Invalid tournament start time'
    );
    assert(
        tournament_data.end_time == 3 + MIN_REGISTRATION_PERIOD.into(),
        'Invalid tournament end time'
    );
    assert(tournament_data.gated_type == Option::None, 'Invalid tournament gated token');
    assert(tournament_data.entry_premium == Option::None, 'Invalid entry premium');
    assert(tournament.total_tournaments() == 1, 'Invalid tournaments count');
}

#[test]
#[should_panic(expected: ('invalid start time', 'ENTRYPOINT_FAILED'))]
fn test_create_tournament_invalid_start_time() {
    let (_world, mut tournament, _loot_survivor, _pragma, _eth, _lords, _erc20, _erc721, _erc1155) =
        setup();

    tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            MIN_REGISTRATION_PERIOD.into(),
            3 + MIN_REGISTRATION_PERIOD.into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );
}

#[test]
#[should_panic(expected: ('invalid end time', 'ENTRYPOINT_FAILED'))]
fn test_create_tournament_invalid_end_time() {
    let (_world, mut tournament, _loot_survivor, _pragma, _eth, _lords, _erc20, _erc721, _erc1155) =
        setup();

    tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            2 + MIN_REGISTRATION_PERIOD.into(),
            2 + MIN_REGISTRATION_PERIOD.into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );
}

#[test]
fn test_register_token() {
    let (
        _world,
        mut tournament,
        _loot_survivor,
        _pragma,
        _eth,
        _lords,
        mut erc20,
        mut erc721,
        _erc1155
    ) =
        setup();

    testing::set_account_contract_address(OWNER());
    testing::set_contract_address(OWNER());
    erc20.approve(tournament.contract_address, 1);
    erc721.approve(tournament.contract_address, 1);
    let tokens = array![
        Token { token: erc20.contract_address, token_id: 0, token_type: TokenType::ERC20 },
        Token { token: erc721.contract_address, token_id: 1, token_type: TokenType::ERC721 },
    ];

    tournament.register_tokens(tokens);
    assert(erc20.balance_of(OWNER()) == 1000000000000000000000, 'Invalid balance');
    assert(erc721.balance_of(OWNER()) == 1, 'Invalid balance');
    assert(tournament.is_token_registered(erc20.contract_address), 'Invalid registration');
    assert(tournament.is_token_registered(erc721.contract_address), 'Invalid registration');
}

#[test]
fn test_create_tournament_with_prizes() {
    let (
        _world,
        mut tournament,
        _loot_survivor,
        _pragma,
        _eth,
        _lords,
        mut erc20,
        mut erc721,
        _erc1155
    ) =
        setup();

    testing::set_account_contract_address(OWNER());
    testing::set_contract_address(OWNER());
    tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            2 + MIN_REGISTRATION_PERIOD.into(),
            3 + MIN_REGISTRATION_PERIOD.into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );
    erc20.approve(tournament.contract_address, 1);
    erc721.approve(tournament.contract_address, 1);
    let tokens = array![
        Token { token: erc20.contract_address, token_id: 0, token_type: TokenType::ERC20 },
        Token { token: erc721.contract_address, token_id: 1, token_type: TokenType::ERC721 },
    ];

    tournament.register_tokens(tokens);

    let prizes = array![
        PrizeType::erc20(
            ERC20Prize {
                token: erc20.contract_address, token_amount: STARTING_BALANCE.low, position: 1,
            }
        ),
        PrizeType::erc721(ERC721Prize { token: erc721.contract_address, token_id: 1, position: 1 }),
    ];
    erc20.approve(tournament.contract_address, STARTING_BALANCE);
    erc721.approve(tournament.contract_address, 1);
    tournament.add_prize(1, *prizes.at(0));
    tournament.add_prize(1, *prizes.at(1));
    assert(erc20.balance_of(OWNER()) == 0, 'Invalid balance');
    assert(erc721.balance_of(OWNER()) == 0, 'Invalid balance');
}

#[test]
#[should_panic(expected: ('token not registered', 'ENTRYPOINT_FAILED'))]
fn test_create_tournament_with_prizes_token_not_registered() {
    let (
        _world,
        mut tournament,
        _loot_survivor,
        _pragma,
        _eth,
        _lords,
        mut erc20,
        mut erc721,
        _erc1155
    ) =
        setup();

    testing::set_account_contract_address(OWNER());
    testing::set_contract_address(OWNER());
    tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            2 + MIN_REGISTRATION_PERIOD.into(),
            3 + MIN_REGISTRATION_PERIOD.into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );
    erc20.approve(tournament.contract_address, 1);
    erc721.approve(tournament.contract_address, 1);

    let prizes = array![
        PrizeType::erc20(
            ERC20Prize {
                token: erc20.contract_address, token_amount: STARTING_BALANCE.low, position: 1,
            }
        ),
        PrizeType::erc721(
            ERC721Prize { token: erc721.contract_address, token_id: 1, position: 1, }
        ),
    ];
    erc20.approve(tournament.contract_address, STARTING_BALANCE);
    erc721.approve(tournament.contract_address, 1);
    tournament.add_prize(1, *prizes.at(0));
    tournament.add_prize(1, *prizes.at(1));
}

#[test]
#[should_panic(expected: ('invalid token distribution', 'ENTRYPOINT_FAILED'))]
fn test_create_tournament_with_prizes_invalid_distribution() {
    let (
        _world,
        mut tournament,
        _loot_survivor,
        _pragma,
        _eth,
        _lords,
        mut erc20,
        mut erc721,
        _erc1155
    ) =
        setup();

    testing::set_account_contract_address(OWNER());
    testing::set_contract_address(OWNER());
    tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            2 + MIN_REGISTRATION_PERIOD.into(),
            3 + MIN_REGISTRATION_PERIOD.into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );
    erc20.approve(tournament.contract_address, 1);
    erc721.approve(tournament.contract_address, 1);
    let tokens = array![
        Token { token: erc20.contract_address, token_id: 0, token_type: TokenType::ERC20 },
        Token { token: erc721.contract_address, token_id: 1, token_type: TokenType::ERC721 },
    ];

    tournament.register_tokens(tokens);

    let prizes = array![
        PrizeType::erc20(
            ERC20Prize {
                token: erc20.contract_address, token_amount: STARTING_BALANCE.low, position: 2,
            }
        ),
        PrizeType::erc721(ERC721Prize { token: erc721.contract_address, token_id: 1, position: 2 }),
    ];
    erc20.approve(tournament.contract_address, STARTING_BALANCE);
    erc721.approve(tournament.contract_address, 1);
    tournament.add_prize(1, *prizes.at(0));
    tournament.add_prize(1, *prizes.at(1));
}

#[test]
fn test_enter_tournament() {
    let (_world, mut tournament, _loot_survivor, _pragma, _eth, _lords, _erc20, _erc721, _erc1155) =
        setup();

    testing::set_account_contract_address(OWNER());
    testing::set_contract_address(OWNER());

    let tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            2 + MIN_REGISTRATION_PERIOD.into(),
            3 + MIN_REGISTRATION_PERIOD.into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );

    tournament.enter_tournament(tournament_id, Option::None);
}

#[test]
#[should_panic(expected: ('tournament already started', 'ENTRYPOINT_FAILED'))]
fn test_enter_tournament_already_started() {
    let (_world, mut tournament, _loot_survivor, _pragma, _eth, _lords, _erc20, _erc721, _erc1155) =
        setup();

    let tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            2 + MIN_REGISTRATION_PERIOD.into(),
            3 + MIN_REGISTRATION_PERIOD.into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );

    testing::set_block_timestamp(2 + MIN_REGISTRATION_PERIOD.into());

    tournament.enter_tournament(tournament_id, Option::None);
}

#[test]
fn test_start_tournament() {
    let (
        _world,
        mut tournament,
        mut loot_survivor,
        _pragma,
        mut eth,
        mut lords,
        _erc20,
        _erc721,
        _erc1155
    ) =
        setup();

    testing::set_account_contract_address(OWNER());
    testing::set_contract_address(OWNER());

    let tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            2 + MIN_REGISTRATION_PERIOD.into(),
            3 + MIN_REGISTRATION_PERIOD.into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );

    tournament.enter_tournament(tournament_id, Option::None);

    testing::set_block_timestamp(2 + MIN_REGISTRATION_PERIOD.into());

    lords.approve(tournament.contract_address, 50000000000000000000);
    // calculate eth to approve, $0.5 / 2500 = 0.0002
    eth.approve(tournament.contract_address, 200000000000000);

    tournament.start_tournament(tournament_id, false);

    // check tournament entries
    assert(tournament.tournament_entries(tournament_id) == 1, 'Invalid entries');
    // check owner now has game token
    assert(loot_survivor.owner_of(1) == OWNER(), 'Invalid owner');
    // check lords and eth balances of loot survivor after starting
    assert(
        lords.balance_of(loot_survivor.contract_address) == 50000000000000000000, 'Invalid balance'
    );
    assert(eth.balance_of(loot_survivor.contract_address) == 200000000000000, 'Invalid balance');

    // check lords and eth balances of owner after starting
    assert(lords.balance_of(OWNER()) == STARTING_BALANCE - 50000000000000000000, 'Invalid balance');
    assert(eth.balance_of(OWNER()) == STARTING_BALANCE - 200000000000000, 'Invalid balance');
}

#[test]
#[should_panic(expected: ('all entries started', 'ENTRYPOINT_FAILED'))]
fn test_start_tournament_entry_already_started() {
    let (
        _world,
        mut tournament,
        _loot_survivor,
        _pragma,
        mut eth,
        mut lords,
        _erc20,
        _erc721,
        _erc1155
    ) =
        setup();

    testing::set_account_contract_address(OWNER());
    testing::set_contract_address(OWNER());

    let tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            2 + MIN_REGISTRATION_PERIOD.into(),
            3 + MIN_REGISTRATION_PERIOD.into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );

    tournament.enter_tournament(tournament_id, Option::None);

    testing::set_block_timestamp(2 + MIN_REGISTRATION_PERIOD.into());

    lords.approve(tournament.contract_address, 2 * 50000000000000000000);
    // calculate eth to approve, $0.5 / 2500 = 0.0002
    eth.approve(tournament.contract_address, 2 * 200000000000000);

    tournament.start_tournament(tournament_id, false);
    tournament.start_tournament(tournament_id, false);
}

#[test]
fn test_submit_scores() {
    let (
        _world,
        mut tournament,
        mut loot_survivor,
        _pragma,
        mut eth,
        mut lords,
        _erc20,
        _erc721,
        _erc1155
    ) =
        setup();

    testing::set_account_contract_address(OWNER());
    testing::set_contract_address(OWNER());

    let tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            2 + MIN_REGISTRATION_PERIOD.into(),
            3 + MIN_REGISTRATION_PERIOD.into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );

    tournament.enter_tournament(tournament_id, Option::None);

    testing::set_block_timestamp(2 + MIN_REGISTRATION_PERIOD.into());

    lords.approve(tournament.contract_address, 50000000000000000000);
    // calculate eth to approve, $0.5 / 2500 = 0.0002
    eth.approve(tournament.contract_address, 200000000000000);

    tournament.start_tournament(tournament_id, false);

    testing::set_block_timestamp(3 + MIN_REGISTRATION_PERIOD.into());

    // set data to a dead adventurer with 1 xp
    let submitted_adventurer = Adventurer {
        health: 0,
        xp: 1,
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
    };
    loot_survivor.set_adventurer(1, submitted_adventurer);

    tournament.submit_scores(tournament_id, array![1]);
    let scores = tournament.top_scores(tournament_id);
    assert(scores.len() == 1, 'Invalid scores length');
    assert(*scores.at(0) == 1, 'Invalid score');
}

#[test]
fn test_submit_multiple_scores() {
    let (
        _world,
        mut tournament,
        mut loot_survivor,
        _pragma,
        mut eth,
        mut lords,
        _erc20,
        _erc721,
        _erc1155
    ) =
        setup();

    testing::set_account_contract_address(OWNER());
    testing::set_contract_address(OWNER());

    let tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            2 + MIN_REGISTRATION_PERIOD.into(),
            3 + MIN_REGISTRATION_PERIOD.into(),
            MIN_SUBMISSION_PERIOD.into(),
            3, // three top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );

    tournament.enter_tournament(tournament_id, Option::None);
    tournament.enter_tournament(tournament_id, Option::None);
    tournament.enter_tournament(tournament_id, Option::None);
    tournament.enter_tournament(tournament_id, Option::None);

    testing::set_block_timestamp(2 + MIN_REGISTRATION_PERIOD.into());

    // approve base costs for 4 entries
    lords.approve(tournament.contract_address, 4 * 50000000000000000000);
    // calculate eth to approve, $0.5 / 2500 = 0.0002
    eth.approve(tournament.contract_address, 4 * 200000000000000);

    tournament.start_tournament(tournament_id, false);

    testing::set_block_timestamp(3 + MIN_REGISTRATION_PERIOD.into());

    // set data to a dead adventurer with 1 xp
    let mut submitted_adventurer = Adventurer {
        health: 0,
        xp: 1,
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
    };
    loot_survivor.set_adventurer(1, submitted_adventurer);

    submitted_adventurer.xp = 2;
    loot_survivor.set_adventurer(2, submitted_adventurer);

    submitted_adventurer.xp = 5;
    loot_survivor.set_adventurer(3, submitted_adventurer);

    submitted_adventurer.xp = 1;
    loot_survivor.set_adventurer(4, submitted_adventurer);

    tournament.submit_scores(tournament_id, array![3, 2, 1]);
    let scores = tournament.top_scores(tournament_id);
    assert(scores.len() == 3, 'Invalid scores length');
    assert(*scores.at(0) == 3, 'Invalid score');
    assert(*scores.at(1) == 2, 'Invalid score');
    assert(*scores.at(2) == 1, 'Invalid score');
}

#[test]
fn test_claim_prizes() {
    let (
        _world,
        mut tournament,
        mut loot_survivor,
        _pragma,
        mut eth,
        mut lords,
        mut erc20,
        mut erc721,
        _erc1155
    ) =
        setup();

    testing::set_account_contract_address(OWNER());
    testing::set_contract_address(OWNER());

    let tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            2 + MIN_REGISTRATION_PERIOD.into(),
            3 + MIN_REGISTRATION_PERIOD.into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );

    erc20.approve(tournament.contract_address, 1);
    erc721.approve(tournament.contract_address, 1);
    let tokens = array![
        Token { token: erc20.contract_address, token_id: 0, token_type: TokenType::ERC20 },
        Token { token: erc721.contract_address, token_id: 1, token_type: TokenType::ERC721 },
    ];

    tournament.register_tokens(tokens);

    let prizes = array![
        PrizeType::erc20(
            ERC20Prize {
                token: erc20.contract_address, token_amount: STARTING_BALANCE.low, position: 1,
            }
        ),
        PrizeType::erc721(ERC721Prize { token: erc721.contract_address, token_id: 1, position: 1 }),
    ];
    erc20.approve(tournament.contract_address, STARTING_BALANCE);
    erc721.approve(tournament.contract_address, 1);
    tournament.add_prize(1, *prizes.at(0));
    tournament.add_prize(1, *prizes.at(1));

    tournament.enter_tournament(tournament_id, Option::None);

    testing::set_block_timestamp(2 + MIN_REGISTRATION_PERIOD.into());

    lords.approve(tournament.contract_address, 50000000000000000000);
    // calculate eth to approve, $0.5 / 2500 = 0.0002
    eth.approve(tournament.contract_address, 200000000000000);

    tournament.start_tournament(tournament_id, false);

    testing::set_block_timestamp(3 + MIN_REGISTRATION_PERIOD.into());

    // set data to a dead adventurer with 1 xp
    let submitted_adventurer = Adventurer {
        health: 0,
        xp: 1,
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
    };
    loot_survivor.set_adventurer(1, submitted_adventurer);

    tournament.submit_scores(tournament_id, array![1]);

    testing::set_block_timestamp(3 + MIN_REGISTRATION_PERIOD.into() + MIN_SUBMISSION_PERIOD.into());
    tournament.claim_prizes(tournament_id, true);

    // check balances of owner after claiming prizes
    assert(erc20.balance_of(OWNER()) == STARTING_BALANCE, 'Invalid balance');
    assert(erc721.owner_of(1) == OWNER(), 'Invalid owner');
}

#[test]
#[should_panic(expected: ('prize already claimed', 'ENTRYPOINT_FAILED'))]
fn test_claim_single_prize_already_claimed() {
    let (
        _world,
        mut tournament,
        mut loot_survivor,
        _pragma,
        mut eth,
        mut lords,
        mut erc20,
        mut erc721,
        _erc1155
    ) =
        setup();

    testing::set_account_contract_address(OWNER());
    testing::set_contract_address(OWNER());

    let tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            2 + MIN_REGISTRATION_PERIOD.into(),
            3 + MIN_REGISTRATION_PERIOD.into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );

    erc20.approve(tournament.contract_address, 1);
    erc721.approve(tournament.contract_address, 1);
    let tokens = array![
        Token { token: erc20.contract_address, token_id: 0, token_type: TokenType::ERC20 },
        Token { token: erc721.contract_address, token_id: 1, token_type: TokenType::ERC721 },
    ];

    tournament.register_tokens(tokens);

    let prizes = array![
        PrizeType::erc20(
            ERC20Prize {
                token: erc20.contract_address, token_amount: STARTING_BALANCE.low, position: 1,
            }
        ),
        PrizeType::erc721(ERC721Prize { token: erc721.contract_address, token_id: 1, position: 1 }),
    ];
    erc20.approve(tournament.contract_address, STARTING_BALANCE);
    erc721.approve(tournament.contract_address, 1);
    tournament.add_prize(1, *prizes.at(0));
    tournament.add_prize(1, *prizes.at(1));

    tournament.enter_tournament(tournament_id, Option::None);

    testing::set_block_timestamp(2 + MIN_REGISTRATION_PERIOD.into());

    lords.approve(tournament.contract_address, 50000000000000000000);
    // calculate eth to approve, $0.5 / 2500 = 0.0002
    eth.approve(tournament.contract_address, 200000000000000);

    tournament.start_tournament(tournament_id, false);

    testing::set_block_timestamp(3 + MIN_REGISTRATION_PERIOD.into());

    // set data to a dead adventurer with 1 xp
    let submitted_adventurer = Adventurer {
        health: 0,
        xp: 1,
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
    };
    loot_survivor.set_adventurer(1, submitted_adventurer);

    tournament.submit_scores(tournament_id, array![1]);

    testing::set_block_timestamp(3 + MIN_REGISTRATION_PERIOD.into() + MIN_SUBMISSION_PERIOD.into());
    tournament.claim_prizes(tournament_id, false);
    tournament.claim_prizes(tournament_id, false);
}

#[test]
fn test_create_tournament_with_criteria_gated_tokens() {
    let (
        _world,
        mut tournament,
        mut loot_survivor,
        _pragma,
        mut eth,
        mut lords,
        _erc20,
        mut erc721,
        _erc1155
    ) =
        setup();

    testing::set_account_contract_address(OWNER());
    testing::set_contract_address(OWNER());

    let tokens = array![
        Token { token: erc721.contract_address, token_id: 1, token_type: TokenType::ERC721 },
    ];

    erc721.approve(tournament.contract_address, 1);

    tournament.register_tokens(tokens);

    let gated_type = GatedType::token(
        GatedToken {
            token: erc721.contract_address,
            entry_type: GatedEntryType::criteria(
                array![EntryCriteria { token_id: 1, entry_count: 2 }].span()
            ),
        }
    );

    let tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            2 + MIN_REGISTRATION_PERIOD.into(),
            3 + MIN_REGISTRATION_PERIOD.into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::Some(gated_type), // zero gated type
            Option::None, // zero entry premium
        );

    let tournament_data = tournament.tournament(tournament_id);
    assert(
        tournament_data.gated_type == Option::Some(gated_type), 'Invalid tournament gated token'
    );
    let gated_submission_type = GatedSubmissionType::token_id(1);

    tournament.enter_tournament(tournament_id, Option::Some(gated_submission_type));

    testing::set_block_timestamp(2 + MIN_REGISTRATION_PERIOD.into());

    // handle for 2 entries
    lords.approve(tournament.contract_address, 2 * 50000000000000000000);
    // calculate eth to approve, $0.5 / 2500 = 0.0002
    eth.approve(tournament.contract_address, 2 * 200000000000000);

    tournament.start_tournament(tournament_id, false);

    // check tournament entries
    assert(tournament.tournament_entries(tournament_id) == 2, 'Invalid entries');
    // check owner now has game token
    assert(loot_survivor.owner_of(1) == OWNER(), 'Invalid owner');
    assert(loot_survivor.owner_of(2) == OWNER(), 'Invalid owner');
    // check lords and eth balances of loot survivor after starting
    assert(
        lords.balance_of(loot_survivor.contract_address) == 2 * 50000000000000000000,
        'Invalid balance'
    );
    assert(
        eth.balance_of(loot_survivor.contract_address) == 2 * 200000000000000, 'Invalid balance'
    );

    testing::set_block_timestamp(3 + MIN_REGISTRATION_PERIOD.into());

    // set data to a dead adventurer with 1 xp
    let submitted_adventurer = Adventurer {
        health: 0,
        xp: 1,
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
    };
    loot_survivor.set_adventurer(1, submitted_adventurer);

    tournament.submit_scores(tournament_id, array![1]);

    testing::set_block_timestamp(3 + MIN_REGISTRATION_PERIOD.into() + MIN_SUBMISSION_PERIOD.into());
    tournament.claim_prizes(tournament_id, false);
}
// #[test]
// fn test_create_tournament_with_premiums() {
//     let (_world, mut tournament, mut loot_survivor, _pragma, mut eth, mut lords, _erc20, mut
//     erc721, _erc1155) =
//         setup();

//     testing::set_account_contract_address(OWNER());
//     testing::set_contract_address(OWNER());

//     let tokens = array![
//         Token { token: erc721.contract_address, token_id: 1, token_type: TokenType::ERC721 },
//     ];

//     erc721.approve(tournament.contract_address, 1);

//     tournament.register_tokens(tokens);

//     let entry_premium = EntryPremium {
//         token: erc721.contract_address,
//             entry_type: GatedEntryType::criteria(array![EntryCriteria { token_id: 1, entry_count:
//             2 }].span()),
//         }
//     };

//     let tournament_id = tournament
//         .create_tournament(
//             TOURNAMENT_NAME(),
//             2 + MIN_REGISTRATION_PERIOD.into(),
//             3 + MIN_REGISTRATION_PERIOD.into(),
//             MIN_SUBMISSION_PERIOD.into(),
//             1, // single top score
//             Option::None, // zero gated type
//             Option::Some(entry_premium), // zero entry premium
//         );

//     let tournament_data = tournament.tournament(tournament_id);
//     assert(tournament_data.gated_type == Option::Some(gated_type), 'Invalid tournament gated
//     token');
//     let gated_submission_type = GatedSubmissionType::token_id(1);

//     tournament.enter_tournament(tournament_id, Option::Some(gated_submission_type));

//     testing::set_block_timestamp(2 + MIN_REGISTRATION_PERIOD.into());

//     // handle for 2 entries
//     lords.approve(tournament.contract_address, 2 * 50000000000000000000);
//     // calculate eth to approve, $0.5 / 2500 = 0.0002
//     eth.approve(tournament.contract_address, 2 * 200000000000000);

//     tournament.start_tournament(tournament_id, false);

//     // check tournament entries
//     assert(tournament.tournament_entries(tournament_id) == 2, 'Invalid entries');
//     // check owner now has game token
//     assert(loot_survivor.owner_of(1) == OWNER(), 'Invalid owner');
//     assert(loot_survivor.owner_of(2) == OWNER(), 'Invalid owner');
//     // check lords and eth balances of loot survivor after starting
//     assert(
//         lords.balance_of(loot_survivor.contract_address) == 2 * 50000000000000000000, 'Invalid
//         balance'
//     );
//     assert(eth.balance_of(loot_survivor.contract_address) == 2 * 200000000000000, 'Invalid
//     balance');

//     testing::set_block_timestamp(3 + MIN_REGISTRATION_PERIOD.into());

//     // set data to a dead adventurer with 1 xp
//     let submitted_adventurer = Adventurer {
//         health: 0,
//         xp: 1,
//         stats: Stats {
//             strength: 0, dexterity: 0, vitality: 0, intelligence: 0, wisdom: 0, charisma: 0,
//             luck: 0
//         },
//         gold: 0,
//         equipment: Equipment {
//             weapon: Item { id: 12, xp: 0 },
//             chest: Item { id: 0, xp: 0 },
//             head: Item { id: 0, xp: 0 },
//             waist: Item { id: 0, xp: 0 },
//             foot: Item { id: 0, xp: 0 },
//             hand: Item { id: 0, xp: 0 },
//             neck: Item { id: 0, xp: 0 },
//             ring: Item { id: 0, xp: 0 }
//         },
//         beast_health: 3,
//         stat_upgrades_available: 0,
//         battle_action_count: 0,
//         mutated: false,
//         awaiting_item_specials: false
//     };
//     loot_survivor.set_adventurer(1, submitted_adventurer);

//     tournament.submit_scores(tournament_id, array![1]);

//     testing::set_block_timestamp(3 + MIN_REGISTRATION_PERIOD.into() +
//     MIN_SUBMISSION_PERIOD.into());
//     tournament.claim_prizes(tournament_id, false);
// }


