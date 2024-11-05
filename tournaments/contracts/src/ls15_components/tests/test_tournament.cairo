use core::option::Option;
use starknet::{ContractAddress, get_block_timestamp, testing};
use dojo::world::WorldStorage;
use dojo_cairo_test::{spawn_test_world, NamespaceDef, TestResource, ContractDefTrait};

use tournament::ls15_components::constants::{
    MIN_REGISTRATION_PERIOD, MAX_REGISTRATION_PERIOD, MIN_SUBMISSION_PERIOD, MAX_SUBMISSION_PERIOD,
    MIN_TOURNAMENT_LENGTH, MAX_TOURNAMENT_LENGTH
};

use tournament::ls15_components::interfaces::{WorldTrait};

use tournament::ls15_components::models::{
    loot_survivor::{
        m_AdventurerModel, m_AdventurerMetaModel, m_BagModel, m_GameCountModel, m_Contracts
    },
    tournament::{
        m_TournamentModel, m_TournamentEntryModel, m_TournamentEntryAddressesModel,
        m_TournamentEntriesAddressModel, m_TournamentStartIdsModel, m_TournamentEntriesModel,
        m_TournamentScoresModel, m_TournamentTotalsModel, m_TournamentPrizeKeysModel, m_PrizesModel,
        m_TokenModel, m_TournamentContracts, ERC20Data, ERC721Data, Token, Premium, GatedToken,
        EntryCriteria, TokenDataType, GatedType, GatedEntryType, GatedSubmissionType
    }
};

use tournament::tests::{
    utils,
    constants::{
        OWNER, TOKEN_NAME, TOKEN_SYMBOL, BASE_URI, TOURNAMENT_NAME, TOURNAMENT_DESCRIPTION,
        STARTING_BALANCE, TEST_START_TIME, TEST_END_TIME
    },
};
use tournament::ls15_components::tests::helpers::{
    approve_game_costs, create_basic_tournament, create_adventurer_metadata_with_death_date,
    create_dead_adventurer_with_xp, register_tokens_for_test
};
use tournament::ls15_components::tests::erc20_mock::{
    erc20_mock, IERC20MockDispatcher, IERC20MockDispatcherTrait
};
use tournament::ls15_components::tests::erc721_mock::{
    erc721_mock, IERC721MockDispatcher, IERC721MockDispatcherTrait
};
use tournament::ls15_components::tests::tournament_mock::{
    tournament_mock, ITournamentMockDispatcher, ITournamentMockDispatcherTrait
};
use tournament::ls15_components::tests::loot_survivor_mock::{
    loot_survivor_mock, ILootSurvivorMockDispatcher, ILootSurvivorMockDispatcherTrait
};
use tournament::ls15_components::tests::pragma_mock::{pragma_mock, IPragmaMockDispatcher};

use openzeppelin_token::erc721::interface;
use openzeppelin_token::erc721::{ERC721Component::{Transfer, Approval,}};

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

fn setup_uninitialized() -> (WorldStorage, IERC20MockDispatcher, IERC20MockDispatcher) {
    testing::set_block_number(1);
    testing::set_block_timestamp(1);

    let ndef = NamespaceDef {
        namespace: "tournament", resources: [
            // loot survivor models
            TestResource::Model(m_AdventurerModel::TEST_CLASS_HASH.try_into().unwrap()),
            TestResource::Model(m_AdventurerMetaModel::TEST_CLASS_HASH.try_into().unwrap()),
            TestResource::Model(m_BagModel::TEST_CLASS_HASH.try_into().unwrap()),
            TestResource::Model(m_GameCountModel::TEST_CLASS_HASH.try_into().unwrap()),
            TestResource::Model(m_Contracts::TEST_CLASS_HASH.try_into().unwrap()),
            // tournament models
            TestResource::Model(m_TournamentModel::TEST_CLASS_HASH.try_into().unwrap()),
            TestResource::Model(m_TournamentEntryModel::TEST_CLASS_HASH.try_into().unwrap()),
            TestResource::Model(
                m_TournamentEntriesAddressModel::TEST_CLASS_HASH.try_into().unwrap()
            ),
            TestResource::Model(
                m_TournamentEntryAddressesModel::TEST_CLASS_HASH.try_into().unwrap()
            ),
            TestResource::Model(m_TournamentStartIdsModel::TEST_CLASS_HASH.try_into().unwrap()),
            TestResource::Model(m_TournamentEntriesModel::TEST_CLASS_HASH.try_into().unwrap()),
            TestResource::Model(m_TournamentScoresModel::TEST_CLASS_HASH.try_into().unwrap()),
            TestResource::Model(m_TournamentTotalsModel::TEST_CLASS_HASH.try_into().unwrap()),
            TestResource::Model(m_TournamentPrizeKeysModel::TEST_CLASS_HASH.try_into().unwrap()),
            TestResource::Model(m_PrizesModel::TEST_CLASS_HASH.try_into().unwrap()),
            TestResource::Model(m_TokenModel::TEST_CLASS_HASH.try_into().unwrap()),
            TestResource::Model(m_TournamentContracts::TEST_CLASS_HASH.try_into().unwrap()),
            // contracts
            TestResource::Contract(
                ContractDefTrait::new(tournament_mock::TEST_CLASS_HASH, "tournament_mock")
                    .with_writer_of([dojo::utils::bytearray_hash(@"tournament")].span())
            ),
            TestResource::Contract(
                ContractDefTrait::new(loot_survivor_mock::TEST_CLASS_HASH, "loot_survivor_mock")
                    .with_writer_of([dojo::utils::bytearray_hash(@"tournament")].span())
            ),
            TestResource::Contract(
                ContractDefTrait::new(pragma_mock::TEST_CLASS_HASH, "pragma_mock")
                    .with_writer_of([dojo::utils::bytearray_hash(@"tournament")].span())
            ),
            TestResource::Contract(
                ContractDefTrait::new(erc20_mock::TEST_CLASS_HASH, "erc20_mock")
                    .with_writer_of([dojo::utils::bytearray_hash(@"tournament")].span())
            ),
            TestResource::Contract(
                ContractDefTrait::new(erc721_mock::TEST_CLASS_HASH, "erc721_mock")
                    .with_writer_of([dojo::utils::bytearray_hash(@"tournament")].span())
            ),
        ].span()
    };

    let mut world: WorldStorage = spawn_test_world([ndef].span());

    let call_data: Array<felt252> = array![];
    let contract = utils::deploy(erc20_mock::TEST_CLASS_HASH, 'salt4', call_data);
    let mut eth = IERC20MockDispatcher { contract_address: contract };

    let call_data: Array<felt252> = array![];
    let contract = utils::deploy(erc20_mock::TEST_CLASS_HASH, 'salt5', call_data);
    let mut lords = IERC20MockDispatcher { contract_address: contract };

    (world, eth, lords)
}

pub fn setup() -> (
    WorldStorage,
    ITournamentMockDispatcher,
    ILootSurvivorMockDispatcher,
    IPragmaMockDispatcher,
    IERC20MockDispatcher,
    IERC20MockDispatcher,
    IERC20MockDispatcher,
    IERC721MockDispatcher,
) {
    let (mut world, mut eth, mut lords) = setup_uninitialized();

    let tournament = world.tournament_mock_dispatcher();
    let loot_survivor = world.loot_survivor_mock_dispatcher();
    let pragma = world.pragma_mock_dispatcher();
    let erc20 = world.erc20_mock_dispatcher();
    let erc721 = world.erc721_mock_dispatcher();

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
    utils::impersonate(OWNER());
    eth.mint(OWNER(), STARTING_BALANCE);
    lords.mint(OWNER(), STARTING_BALANCE);
    erc20.mint(OWNER(), STARTING_BALANCE);
    erc721.mint(OWNER(), 1);

    // drop all events
    utils::drop_all_events(world.dispatcher.contract_address);
    utils::drop_all_events(tournament.contract_address);
    utils::drop_all_events(loot_survivor.contract_address);

    (world, tournament, loot_survivor, pragma, eth, lords, erc20, erc721)
}

//
// Test initializers
//

#[test]
fn test_initializer() {
    let (
        _world, _tournament, mut loot_survivor, _pragma, mut eth, mut lords, mut erc20, mut erc721,
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

    assert(erc20.balance_of(OWNER()) == STARTING_BALANCE, 'Invalid balance');
    assert(erc721.balance_of(OWNER()) == 1, 'Invalid balance');
    assert(eth.balance_of(OWNER()) == STARTING_BALANCE, 'Invalid balance');
    assert(lords.balance_of(OWNER()) == STARTING_BALANCE, 'Invalid balance');
}
//
// Test creating tournaments
//

#[test]
fn test_create_tournament() {
    let (_world, mut tournament, _loot_survivor, _pragma, _eth, _lords, _erc20, _erc721) = setup();

    let tournament_id = create_basic_tournament(tournament);

    let tournament_data = tournament.tournament(tournament_id);
    assert(tournament_data.name == TOURNAMENT_NAME(), 'Invalid tournament name');
    assert(
        tournament_data.description == TOURNAMENT_DESCRIPTION(), 'Invalid tournament description'
    );
    assert(tournament_data.start_time == TEST_START_TIME().into(), 'Invalid tournament start time');
    assert(tournament_data.end_time == TEST_END_TIME().into(), 'Invalid tournament end time');
    assert(tournament_data.gated_type == Option::None, 'Invalid tournament gated token');
    assert(tournament_data.entry_premium == Option::None, 'Invalid entry premium');
    assert(tournament.total_tournaments() == 1, 'Invalid tournaments count');
}

#[test]
#[should_panic(expected: ('start time too close', 'ENTRYPOINT_FAILED'))]
fn test_create_tournament_start_time_too_close() {
    let (_world, mut tournament, _loot_survivor, _pragma, _eth, _lords, _erc20, _erc721) = setup();

    tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            2,
            TEST_END_TIME().into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );
}

#[test]
#[should_panic(expected: ('start time too far', 'ENTRYPOINT_FAILED'))]
fn test_create_tournament_start_time_too_far() {
    let (_world, mut tournament, _loot_survivor, _pragma, _eth, _lords, _erc20, _erc721) = setup();

    tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            (TEST_START_TIME() + MAX_REGISTRATION_PERIOD).into(),
            TEST_END_TIME().into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );
}

#[test]
#[should_panic(expected: ('tournament too short', 'ENTRYPOINT_FAILED'))]
fn test_create_tournament_end_time_too_close() {
    let (_world, mut tournament, _loot_survivor, _pragma, _eth, _lords, _erc20, _erc721) = setup();

    tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            2 + MIN_REGISTRATION_PERIOD.into(),
            2 + MIN_REGISTRATION_PERIOD.into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );
}

#[test]
#[should_panic(expected: ('tournament too long', 'ENTRYPOINT_FAILED'))]
fn test_create_tournament_end_time_too_far() {
    let (_world, mut tournament, _loot_survivor, _pragma, _eth, _lords, _erc20, _erc721) = setup();

    tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            TEST_START_TIME().into(),
            (TEST_END_TIME() + MAX_TOURNAMENT_LENGTH).into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );
}

#[test]
#[should_panic(expected: ('submission period too short', 'ENTRYPOINT_FAILED'))]
fn test_create_tournament_submission_period_too_short() {
    let (_world, mut tournament, _loot_survivor, _pragma, _eth, _lords, _erc20, _erc721) = setup();

    tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            TEST_START_TIME().into(),
            TEST_END_TIME().into(),
            MIN_SUBMISSION_PERIOD.into() - 1,
            1, // single top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );
}

#[test]
#[should_panic(expected: ('submission period too long', 'ENTRYPOINT_FAILED'))]
fn test_create_tournament_submission_period_too_long() {
    let (_world, mut tournament, _loot_survivor, _pragma, _eth, _lords, _erc20, _erc721) = setup();

    tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            TEST_START_TIME().into(),
            TEST_END_TIME().into(),
            MAX_SUBMISSION_PERIOD.into() + 1,
            1, // single top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );
}

#[test]
fn test_create_tournament_with_prizes() {
    let (_world, mut tournament, _loot_survivor, _pragma, _eth, _lords, mut erc20, mut erc721,) =
        setup();

    utils::impersonate(OWNER());
    let tournament_id = create_basic_tournament(tournament);
    register_tokens_for_test(tournament, erc20, erc721);

    erc20.approve(tournament.contract_address, STARTING_BALANCE);
    erc721.approve(tournament.contract_address, 1);
    tournament
        .add_prize(
            tournament_id,
            erc20.contract_address,
            TokenDataType::erc20(ERC20Data { token_amount: STARTING_BALANCE.low }),
            1
        );
    tournament
        .add_prize(
            tournament_id,
            erc721.contract_address,
            TokenDataType::erc721(ERC721Data { token_id: 1 }),
            1
        );
    assert(erc20.balance_of(OWNER()) == 0, 'Invalid balance');
    assert(erc721.balance_of(OWNER()) == 0, 'Invalid balance');
}

#[test]
#[should_panic(expected: ('prize token not registered', 'ENTRYPOINT_FAILED'))]
fn test_create_tournament_with_prizes_token_not_registered() {
    let (_world, mut tournament, _loot_survivor, _pragma, _eth, _lords, mut erc20, mut erc721,) =
        setup();

    utils::impersonate(OWNER());
    create_basic_tournament(tournament);
    erc20.approve(tournament.contract_address, 1);
    erc721.approve(tournament.contract_address, 1);

    erc20.approve(tournament.contract_address, STARTING_BALANCE);
    erc721.approve(tournament.contract_address, 1);
    tournament
        .add_prize(
            1,
            erc20.contract_address,
            TokenDataType::erc20(ERC20Data { token_amount: STARTING_BALANCE.low }),
            1
        );
    tournament
        .add_prize(
            1, erc721.contract_address, TokenDataType::erc721(ERC721Data { token_id: 1 }), 1
        );
}

#[test]
#[should_panic(expected: ('prize position too large', 'ENTRYPOINT_FAILED'))]
fn test_create_tournament_with_prizes_position_too_large() {
    let (_world, mut tournament, _loot_survivor, _pragma, _eth, _lords, mut erc20, mut erc721,) =
        setup();

    utils::impersonate(OWNER());
    let tournament_id = create_basic_tournament(tournament);
    register_tokens_for_test(tournament, erc20, erc721);

    erc20.approve(tournament.contract_address, STARTING_BALANCE);
    erc721.approve(tournament.contract_address, 1);
    tournament
        .add_prize(
            tournament_id,
            erc20.contract_address,
            TokenDataType::erc20(ERC20Data { token_amount: STARTING_BALANCE.low }),
            2
        );
    tournament
        .add_prize(
            tournament_id,
            erc721.contract_address,
            TokenDataType::erc721(ERC721Data { token_id: 1 }),
            2
        );
}

#[test]
#[should_panic(expected: ('premium distributions too long', 'ENTRYPOINT_FAILED'))]
fn test_create_tournament_with_premiums_too_long() {
    let (_world, mut tournament, _loot_survivor, _pragma, _eth, _lords, mut erc20, mut erc721,) =
        setup();

    utils::impersonate(OWNER());
    register_tokens_for_test(tournament, erc20, erc721);

    let entry_premium = Premium {
        token: erc20.contract_address,
        token_amount: 1,
        token_distribution: array![100, 0].span(),
        creator_fee: 0,
    };

    tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            TEST_START_TIME().into(),
            TEST_END_TIME().into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::None, // zero gated type
            Option::Some(entry_premium), // zero entry premium
        );
}

#[test]
#[should_panic(expected: ('premium distributions not 100%', 'ENTRYPOINT_FAILED'))]
fn test_create_tournament_with_premiums_not_100() {
    let (_world, mut tournament, _loot_survivor, _pragma, _eth, _lords, mut erc20, mut erc721,) =
        setup();

    utils::impersonate(OWNER());
    register_tokens_for_test(tournament, erc20, erc721);

    let entry_premium = Premium {
        token: erc20.contract_address,
        token_amount: 1,
        token_distribution: array![95].span(),
        creator_fee: 0,
    };

    tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            TEST_START_TIME().into(),
            TEST_END_TIME().into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::None, // zero gated type
            Option::Some(entry_premium), // zero entry premium
        );
}

#[test]
#[should_panic(expected: ('tournament not settled', 'ENTRYPOINT_FAILED'))]
fn test_create_gated_tournament_with_unsettled_tournament() {
    let (_world, mut tournament, _loot_survivor, _pragma, mut eth, mut lords, _erc20, _erc721,) =
        setup();

    utils::impersonate(OWNER());

    // Create first tournament
    let first_tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            TEST_START_TIME().into(),
            TEST_END_TIME().into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );

    // Enter first tournament
    tournament.enter_tournament(first_tournament_id, Option::None);

    // Move to tournament start time
    testing::set_block_timestamp(TEST_START_TIME().into());

    // Start first tournament
    approve_game_costs(eth, lords, tournament, 1);
    tournament.start_tournament(first_tournament_id, false, Option::None);

    // Try to create a second tournament gated by the first (unsettled) tournament
    let gated_type = GatedType::tournament(array![first_tournament_id].span());

    let current_time = get_block_timestamp();

    // This should panic because the first tournament hasn't been settled yet
    tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            current_time + MIN_REGISTRATION_PERIOD.into(), // start after first tournament
            current_time + 1 + MIN_REGISTRATION_PERIOD.into() + MIN_TOURNAMENT_LENGTH.into(),
            MIN_SUBMISSION_PERIOD.into(),
            1,
            Option::Some(gated_type), // Gate by first tournament
            Option::None,
        );
}

#[test]
fn test_create_tournament_gated_by_multiple_tournaments() {
    let (_world, mut tournament, mut loot_survivor, _pragma, mut eth, mut lords, _erc20, _erc721,) =
        setup();

    utils::impersonate(OWNER());

    // Create first tournament
    let first_tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            TEST_START_TIME().into(),
            TEST_END_TIME().into(),
            MIN_SUBMISSION_PERIOD.into(),
            1,
            Option::None,
            Option::None,
        );

    // Create second tournament
    let second_tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            TEST_START_TIME().into(),
            TEST_END_TIME().into(),
            MIN_SUBMISSION_PERIOD.into(),
            1,
            Option::None,
            Option::None,
        );

    // Enter and complete first tournament
    tournament.enter_tournament(first_tournament_id, Option::None);
    testing::set_block_timestamp(TEST_START_TIME().into());
    approve_game_costs(eth, lords, tournament, 1);
    tournament.start_tournament(first_tournament_id, false, Option::None);

    testing::set_block_timestamp(TEST_END_TIME().into());
    let submitted_adventurer = create_dead_adventurer_with_xp(10);
    loot_survivor.set_adventurer(1, submitted_adventurer);
    tournament.submit_scores(first_tournament_id, array![1]);

    // Enter and complete second tournament
    testing::set_block_timestamp(1);
    tournament.enter_tournament(second_tournament_id, Option::None);
    testing::set_block_timestamp(TEST_START_TIME().into());
    approve_game_costs(eth, lords, tournament, 1);
    tournament.start_tournament(second_tournament_id, false, Option::None);

    testing::set_block_timestamp(TEST_END_TIME().into());
    let submitted_adventurer = create_dead_adventurer_with_xp(20);
    loot_survivor.set_adventurer(2, submitted_adventurer);
    tournament.submit_scores(second_tournament_id, array![2]);

    // Settle tournaments
    testing::set_block_timestamp((TEST_END_TIME() + MIN_SUBMISSION_PERIOD).into());

    // Create tournament gated by both previous tournaments
    let gated_type = GatedType::tournament(
        array![first_tournament_id, second_tournament_id].span()
    );

    let current_time = get_block_timestamp();
    let gated_tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            current_time + MIN_REGISTRATION_PERIOD.into(),
            current_time + MIN_REGISTRATION_PERIOD.into() + MIN_TOURNAMENT_LENGTH.into() + 1,
            MIN_SUBMISSION_PERIOD.into(),
            1,
            Option::Some(gated_type),
            Option::None,
        );

    // Verify the gated tournament was created with correct parameters
    let gated_tournament = tournament.tournament(gated_tournament_id);
    assert(gated_tournament.gated_type == Option::Some(gated_type), 'Invalid tournament gate type');

    let gated_submission_type = GatedSubmissionType::game_id(array![1, 2].span());
    // This should succeed since we completed both required tournaments
    tournament.enter_tournament(gated_tournament_id, Option::Some(gated_submission_type));

    // Verify entry was successful
    let entries = tournament.tournament_entries(gated_tournament_id);
    assert(entries == 1, 'Invalid entry count');
}

//
// Test registering tokens
//

#[test]
fn test_register_token() {
    let (_world, mut tournament, _loot_survivor, _pragma, _eth, _lords, mut erc20, mut erc721,) =
        setup();

    utils::impersonate(OWNER());
    erc20.approve(tournament.contract_address, 1);
    erc721.approve(tournament.contract_address, 1);
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

    tournament.register_tokens(tokens);
    assert(erc20.balance_of(OWNER()) == 1000000000000000000000, 'Invalid balance');
    assert(erc721.balance_of(OWNER()) == 1, 'Invalid balance');
    assert(tournament.is_token_registered(erc20.contract_address), 'Invalid registration');
    assert(tournament.is_token_registered(erc721.contract_address), 'Invalid registration');
}

#[test]
#[should_panic(expected: ('token already registered', 'ENTRYPOINT_FAILED'))]
fn test_register_token_already_registered() {
    let (_world, mut tournament, _loot_survivor, _pragma, _eth, _lords, mut erc20, mut erc721,) =
        setup();

    utils::impersonate(OWNER());
    erc20.approve(tournament.contract_address, 1);
    erc721.approve(tournament.contract_address, 1);
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

    tournament.register_tokens(tokens);
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
    tournament.register_tokens(tokens);
}

//
// Test entering tournaments
//

#[test]
fn test_enter_tournament() {
    let (_world, mut tournament, _loot_survivor, _pragma, _eth, _lords, _erc20, _erc721) = setup();

    utils::impersonate(OWNER());

    let tournament_id = create_basic_tournament(tournament);

    tournament.enter_tournament(tournament_id, Option::None);
}

#[test]
#[should_panic(expected: ('tournament already started', 'ENTRYPOINT_FAILED'))]
fn test_enter_tournament_already_started() {
    let (_world, mut tournament, _loot_survivor, _pragma, _eth, _lords, _erc20, _erc721) = setup();

    let tournament_id = create_basic_tournament(tournament);

    testing::set_block_timestamp(TEST_START_TIME().into());

    tournament.enter_tournament(tournament_id, Option::None);
}

#[test]
#[should_panic(expected: ('invalid gated submission type', 'ENTRYPOINT_FAILED'))]
fn test_enter_tournament_wrong_submission_type() {
    let (_world, mut tournament, mut loot_survivor, _pragma, mut eth, mut lords, _erc20, _erc721,) =
        setup();

    utils::impersonate(OWNER());

    // First create and complete a tournament that will be used as a gate
    let first_tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            TEST_START_TIME().into(),
            TEST_END_TIME().into(),
            MIN_SUBMISSION_PERIOD.into(),
            1,
            Option::None,
            Option::None,
        );

    // Complete the first tournament
    tournament.enter_tournament(first_tournament_id, Option::None);
    testing::set_block_timestamp(TEST_START_TIME().into());
    approve_game_costs(eth, lords, tournament, 1);
    tournament.start_tournament(first_tournament_id, false, Option::None);

    testing::set_block_timestamp(TEST_END_TIME().into());
    let submitted_adventurer = create_dead_adventurer_with_xp(10);
    loot_survivor.set_adventurer(1, submitted_adventurer);
    tournament.submit_scores(first_tournament_id, array![1]);

    // Settle first tournament
    testing::set_block_timestamp((TEST_END_TIME() + MIN_SUBMISSION_PERIOD).into());

    // Create a tournament gated by the previous tournament
    let gated_type = GatedType::tournament(array![first_tournament_id].span());

    let current_time = get_block_timestamp();
    let gated_tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            current_time + MIN_REGISTRATION_PERIOD.into(),
            current_time + MIN_REGISTRATION_PERIOD.into() + MIN_TOURNAMENT_LENGTH.into() + 1,
            MIN_SUBMISSION_PERIOD.into(),
            1,
            Option::Some(gated_type),
            Option::None,
        );

    // Try to enter with wrong submission type (token_id instead of game_id)
    let wrong_submission_type = GatedSubmissionType::token_id(1);

    // This should panic because we're using token_id submission type for a tournament-gated
    // tournament
    tournament.enter_tournament(gated_tournament_id, Option::Some(wrong_submission_type));
}

//
// Test starting tournaments
//

#[test]
fn test_start_tournament() {
    let (_world, mut tournament, mut loot_survivor, _pragma, mut eth, mut lords, _erc20, _erc721,) =
        setup();

    utils::impersonate(OWNER());

    let tournament_id = create_basic_tournament(tournament);

    tournament.enter_tournament(tournament_id, Option::None);

    testing::set_block_timestamp(TEST_START_TIME().into());

    approve_game_costs(eth, lords, tournament, 1);

    tournament.start_tournament(tournament_id, false, Option::None);

    // check tournament entries
    assert(tournament.tournament_entries(tournament_id) == 1, 'Invalid entries');
    // check owner now has game token
    assert(loot_survivor.owner_of(1) == OWNER(), 'Invalid owner');
    // check lords and eth balances of loot survivor after starting
    assert(
        lords.balance_of(loot_survivor.contract_address) == 50000000000000000000,
        'Invalid
        balance'
    );
    assert(eth.balance_of(loot_survivor.contract_address) == 200000000000000, 'Invalid balance');

    // check lords and eth balances of owner after starting
    assert(
        lords.balance_of(OWNER()) == STARTING_BALANCE - 50000000000000000000, 'Invalid
    balance'
    );
    assert(eth.balance_of(OWNER()) == STARTING_BALANCE - 200000000000000, 'Invalid balance');
}

#[test]
#[should_panic(expected: ('all entries started', 'ENTRYPOINT_FAILED'))]
fn test_start_tournament_entry_already_started() {
    let (_world, mut tournament, _loot_survivor, _pragma, mut eth, mut lords, _erc20, _erc721,) =
        setup();

    utils::impersonate(OWNER());

    let tournament_id = create_basic_tournament(tournament);

    tournament.enter_tournament(tournament_id, Option::None);

    testing::set_block_timestamp(TEST_START_TIME().into());

    approve_game_costs(eth, lords, tournament, 2);

    tournament.start_tournament(tournament_id, false, Option::None);
    tournament.start_tournament(tournament_id, false, Option::None);
}

//
// Test submitting scores
//

#[test]
fn test_submit_scores() {
    let (_world, mut tournament, mut loot_survivor, _pragma, mut eth, mut lords, _erc20, _erc721,) =
        setup();

    utils::impersonate(OWNER());

    let tournament_id = create_basic_tournament(tournament);

    tournament.enter_tournament(tournament_id, Option::None);

    testing::set_block_timestamp(TEST_START_TIME().into());

    approve_game_costs(eth, lords, tournament, 1);

    tournament.start_tournament(tournament_id, false, Option::None);

    testing::set_block_timestamp(TEST_END_TIME().into());

    // set data to a dead adventurer with 1 xp
    let submitted_adventurer = create_dead_adventurer_with_xp(1);
    loot_survivor.set_adventurer(1, submitted_adventurer);

    tournament.submit_scores(tournament_id, array![1]);
    let scores = tournament.top_scores(tournament_id);
    assert(scores.len() == 1, 'Invalid scores length');
    assert(*scores.at(0) == 1, 'Invalid score');
}

#[test]
fn test_submit_multiple_scores() {
    let (_world, mut tournament, mut loot_survivor, _pragma, mut eth, mut lords, _erc20, _erc721,) =
        setup();

    utils::impersonate(OWNER());

    let tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            TEST_START_TIME().into(),
            TEST_END_TIME().into(),
            MIN_SUBMISSION_PERIOD.into(),
            3, // three top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );

    tournament.enter_tournament(tournament_id, Option::None);
    tournament.enter_tournament(tournament_id, Option::None);
    tournament.enter_tournament(tournament_id, Option::None);
    tournament.enter_tournament(tournament_id, Option::None);

    testing::set_block_timestamp(TEST_START_TIME().into());

    approve_game_costs(eth, lords, tournament, 4);

    tournament.start_tournament(tournament_id, false, Option::None);

    testing::set_block_timestamp(TEST_END_TIME().into());

    // set data to a dead adventurer with 1 xp
    let submitted_adventurer = create_dead_adventurer_with_xp(1);
    loot_survivor.set_adventurer(1, submitted_adventurer);

    let submitted_adventurer = create_dead_adventurer_with_xp(2);
    loot_survivor.set_adventurer(2, submitted_adventurer);

    let submitted_adventurer = create_dead_adventurer_with_xp(5);
    loot_survivor.set_adventurer(3, submitted_adventurer);

    let submitted_adventurer = create_dead_adventurer_with_xp(1);
    loot_survivor.set_adventurer(4, submitted_adventurer);

    tournament.submit_scores(tournament_id, array![3, 2, 1]);
    let scores = tournament.top_scores(tournament_id);
    assert(scores.len() == 3, 'Invalid scores length');
    assert(*scores.at(0) == 3, 'Invalid score');
    assert(*scores.at(1) == 2, 'Invalid score');
    assert(*scores.at(2) == 1, 'Invalid score');
}

#[test]
fn test_submit_scores_tiebreaker() {
    let (_world, mut tournament, mut loot_survivor, _pragma, mut eth, mut lords, _erc20, _erc721,) =
        setup();
    utils::impersonate(OWNER());

    let tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            TEST_START_TIME().into(),
            TEST_END_TIME().into(),
            MIN_SUBMISSION_PERIOD.into(),
            2, // two top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );

    // Complete tournament with tied scores but different death dates
    tournament.enter_tournament(tournament_id, Option::None);
    tournament.enter_tournament(tournament_id, Option::None);

    testing::set_block_timestamp(TEST_START_TIME().into());

    approve_game_costs(eth, lords, tournament, 2);

    tournament.start_tournament(tournament_id, true, Option::None);

    testing::set_block_timestamp(TEST_END_TIME().into());

    let adventurer1 = create_dead_adventurer_with_xp(1);
    let adventurer2 = create_dead_adventurer_with_xp(1);
    loot_survivor.set_adventurer(1, adventurer1);
    loot_survivor.set_adventurer(2, adventurer2);

    // Same score (1) but different death timestamps
    let adventurer1_metadata = create_adventurer_metadata_with_death_date(100);
    let adventurer2_metadata = create_adventurer_metadata_with_death_date(50);
    loot_survivor.set_adventurer_meta(1, adventurer1_metadata);
    loot_survivor.set_adventurer_meta(2, adventurer2_metadata);

    tournament.submit_scores(tournament_id, array![2, 1]);

    let scores = tournament.top_scores(tournament_id);
    assert(*scores.at(0) == 2, 'Wrong tiebreaker winner');
    assert(*scores.at(1) == 1, 'Wrong tiebreaker loser');
}

#[test]
#[should_panic(expected: ('tournament already settled', 'ENTRYPOINT_FAILED'))]
fn test_submit_scores_after_submission_period() {
    let (_world, mut tournament, mut loot_survivor, _pragma, mut eth, mut lords, _erc20, _erc721,) =
        setup();

    utils::impersonate(OWNER());

    // Create tournament with specific timing
    let tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            TEST_START_TIME().into(), // start time
            TEST_END_TIME().into(), // end time
            MIN_SUBMISSION_PERIOD.into(), // submission period
            1, // single top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );

    // Enter tournament
    tournament.enter_tournament(tournament_id, Option::None);

    // Move to tournament start time
    testing::set_block_timestamp(TEST_START_TIME().into());

    // Start tournament
    approve_game_costs(eth, lords, tournament, 1);
    tournament.start_tournament(tournament_id, false, Option::None);

    // Create adventurer with score
    let submitted_adventurer = create_dead_adventurer_with_xp(10);
    loot_survivor.set_adventurer(1, submitted_adventurer);

    // Move timestamp to after submission period ends
    // Tournament end (3 + MIN_REGISTRATION_PERIOD) + submission period
    testing::set_block_timestamp((TEST_END_TIME() + MIN_SUBMISSION_PERIOD).into());

    // This should panic with 'tournament already settled'
    tournament.submit_scores(tournament_id, array![1]);
}

#[test]
#[should_panic(expected: ('tournament not ended', 'ENTRYPOINT_FAILED'))]
fn test_submit_scores_before_tournament_ends() {
    let (_world, mut tournament, mut loot_survivor, _pragma, mut eth, mut lords, _erc20, _erc721,) =
        setup();

    utils::impersonate(OWNER());

    // Create tournament with future start time
    let tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            TEST_START_TIME().into(), // start time
            TEST_END_TIME().into(), // end time
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );

    // Enter tournament
    tournament.enter_tournament(tournament_id, Option::None);

    // Set timestamp before tournament start time
    testing::set_block_timestamp(TEST_START_TIME().into());

    // Start tournament
    approve_game_costs(eth, lords, tournament, 1);
    tournament.start_tournament(tournament_id, false, Option::None);

    // Create adventurer with score
    let submitted_adventurer = create_dead_adventurer_with_xp(10);
    loot_survivor.set_adventurer(1, submitted_adventurer);

    // Attempt to submit scores before tournament starts
    // This should panic with 'tournament not started'
    tournament.submit_scores(tournament_id, array![1]);
}

#[test]
fn test_submit_scores_replace_lower_score() {
    let (_world, mut tournament, mut loot_survivor, _pragma, mut eth, mut lords, _erc20, _erc721,) =
        setup();

    utils::impersonate(OWNER());

    // Create tournament with multiple top scores
    let tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            TEST_START_TIME().into(),
            TEST_END_TIME().into(),
            MIN_SUBMISSION_PERIOD.into(),
            3, // Track top 3 scores
            Option::None,
            Option::None,
        );

    // Create multiple players
    let player2 = starknet::contract_address_const::<0x456>();
    let player3 = starknet::contract_address_const::<0x789>();

    // Enter tournament with all players
    tournament.enter_tournament(tournament_id, Option::None);

    utils::impersonate(player2);
    eth.mint(player2, STARTING_BALANCE);
    lords.mint(player2, STARTING_BALANCE);
    tournament.enter_tournament(tournament_id, Option::None);

    utils::impersonate(player3);
    eth.mint(player3, STARTING_BALANCE);
    lords.mint(player3, STARTING_BALANCE);
    tournament.enter_tournament(tournament_id, Option::None);

    // Start tournament for all players
    testing::set_block_timestamp(TEST_START_TIME().into());

    utils::impersonate(OWNER());
    approve_game_costs(eth, lords, tournament, 1);
    tournament.start_tournament(tournament_id, false, Option::None);

    utils::impersonate(player2);
    approve_game_costs(eth, lords, tournament, 1);
    tournament.start_tournament(tournament_id, false, Option::None);

    utils::impersonate(player3);
    approve_game_costs(eth, lords, tournament, 1);
    tournament.start_tournament(tournament_id, false, Option::None);

    testing::set_block_timestamp(TEST_END_TIME().into());

    // Submit initial scores
    let low_score = create_dead_adventurer_with_xp(5);
    let mid_score = create_dead_adventurer_with_xp(10);
    let high_score = create_dead_adventurer_with_xp(15);

    loot_survivor.set_adventurer(1, low_score); // Owner's adventurer
    loot_survivor.set_adventurer(2, mid_score); // Player2's adventurer
    loot_survivor.set_adventurer(3, high_score); // Player3's adventurer

    utils::impersonate(OWNER());
    tournament.submit_scores(tournament_id, array![1]);

    // // Verify initial rankings
    let scores = tournament.top_scores(tournament_id);
    assert(scores.len() == 1, 'Invalid scores length');
    assert(*scores.at(0) == 1, 'Wrong top score'); // owner

    utils::impersonate(player2);
    tournament.submit_scores(tournament_id, array![1, 3, 2]);

    // Verify updated rankings
    let updated_scores = tournament.top_scores(tournament_id);
    assert(updated_scores.len() == 3, 'Invalid updated scores length');
    assert(*updated_scores.at(0) == 1, 'Wrong new top score'); // Owner
    assert(*updated_scores.at(1) == 3, 'Wrong new second score'); // Player3
    assert(*updated_scores.at(2) == 2, 'Wrong new third score'); // Player2
}

//
// Test distributing rewards
//

#[test]
fn test_distribute_prizes_with_prizes() {
    let (
        _world,
        mut tournament,
        mut loot_survivor,
        _pragma,
        mut eth,
        mut lords,
        mut erc20,
        mut erc721,
    ) =
        setup();

    utils::impersonate(OWNER());

    let tournament_id = create_basic_tournament(tournament);
    register_tokens_for_test(tournament, erc20, erc721);

    erc20.approve(tournament.contract_address, STARTING_BALANCE);
    erc721.approve(tournament.contract_address, 1);
    tournament
        .add_prize(
            tournament_id,
            erc20.contract_address,
            TokenDataType::erc20(ERC20Data { token_amount: STARTING_BALANCE.low }),
            1
        );
    tournament
        .add_prize(
            tournament_id,
            erc721.contract_address,
            TokenDataType::erc721(ERC721Data { token_id: 1 }),
            1
        );

    tournament.enter_tournament(tournament_id, Option::None);

    testing::set_block_timestamp(TEST_START_TIME().into());

    approve_game_costs(eth, lords, tournament, 1);

    tournament.start_tournament(tournament_id, false, Option::None);

    testing::set_block_timestamp(TEST_END_TIME().into());

    // set data to a dead adventurer with 1 xp
    let submitted_adventurer = create_dead_adventurer_with_xp(1);
    loot_survivor.set_adventurer(1, submitted_adventurer);

    tournament.submit_scores(tournament_id, array![1]);

    testing::set_block_timestamp((TEST_END_TIME() + MIN_SUBMISSION_PERIOD).into());
    tournament.distribute_prizes(tournament_id, array![1, 2]);

    // check balances of owner after claiming prizes
    assert(erc20.balance_of(OWNER()) == STARTING_BALANCE, 'Invalid balance');
    assert(erc721.owner_of(1) == OWNER(), 'Invalid owner');
}

#[test]
#[should_panic(expected: ('prize already claimed', 'ENTRYPOINT_FAILED'))]
fn test_distribute_prizes_prize_already_claimed() {
    let (
        _world,
        mut tournament,
        mut loot_survivor,
        _pragma,
        mut eth,
        mut lords,
        mut erc20,
        mut erc721,
    ) =
        setup();

    utils::impersonate(OWNER());

    let tournament_id = create_basic_tournament(tournament);
    register_tokens_for_test(tournament, erc20, erc721);

    erc20.approve(tournament.contract_address, STARTING_BALANCE);
    erc721.approve(tournament.contract_address, 1);
    tournament
        .add_prize(
            tournament_id,
            erc20.contract_address,
            TokenDataType::erc20(ERC20Data { token_amount: STARTING_BALANCE.low }),
            1
        );
    tournament
        .add_prize(
            tournament_id,
            erc721.contract_address,
            TokenDataType::erc721(ERC721Data { token_id: 1 }),
            1
        );

    tournament.enter_tournament(tournament_id, Option::None);

    testing::set_block_timestamp(TEST_START_TIME().into());

    approve_game_costs(eth, lords, tournament, 1);

    tournament.start_tournament(tournament_id, false, Option::None);

    testing::set_block_timestamp(TEST_END_TIME().into());

    // set data to a dead adventurer with 1 xp
    let submitted_adventurer = create_dead_adventurer_with_xp(1);
    loot_survivor.set_adventurer(1, submitted_adventurer);

    tournament.submit_scores(tournament_id, array![1]);

    testing::set_block_timestamp((TEST_END_TIME() + MIN_SUBMISSION_PERIOD).into());
    tournament.distribute_prizes(tournament_id, array![1, 2]);
    tournament.distribute_prizes(tournament_id, array![1, 2]);
}

#[test]
fn test_distribute_prizes_with_gated_tokens_criteria() {
    let (
        _world,
        mut tournament,
        mut loot_survivor,
        _pragma,
        mut eth,
        mut lords,
        mut erc20,
        mut erc721,
    ) =
        setup();

    utils::impersonate(OWNER());
    register_tokens_for_test(tournament, erc20, erc721);

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
            TOURNAMENT_DESCRIPTION(),
            TEST_START_TIME().into(),
            TEST_END_TIME().into(),
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

    testing::set_block_timestamp(TEST_START_TIME().into());

    approve_game_costs(eth, lords, tournament, 2);

    tournament.start_tournament(tournament_id, false, Option::None);

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

    testing::set_block_timestamp(TEST_END_TIME().into());

    // set data to a dead adventurer with 1 xp
    let submitted_adventurer = create_dead_adventurer_with_xp(1);
    loot_survivor.set_adventurer(1, submitted_adventurer);

    tournament.submit_scores(tournament_id, array![1]);
}

#[test]
fn test_distribute_prizes_with_gated_tokens_uniform() {
    let (
        _world,
        mut tournament,
        mut loot_survivor,
        _pragma,
        mut eth,
        mut lords,
        mut erc20,
        mut erc721,
    ) =
        setup();

    utils::impersonate(OWNER());
    register_tokens_for_test(tournament, erc20, erc721);

    let gated_type = GatedType::token(
        GatedToken { token: erc721.contract_address, entry_type: GatedEntryType::uniform(3), }
    );

    let tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            TEST_START_TIME().into(),
            TEST_END_TIME().into(),
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

    testing::set_block_timestamp(TEST_START_TIME().into());

    approve_game_costs(eth, lords, tournament, 3);

    tournament.start_tournament(tournament_id, false, Option::None);

    // check tournament entries
    assert(tournament.tournament_entries(tournament_id) == 3, 'Invalid entries');
    // check owner now has game token
    assert(loot_survivor.owner_of(1) == OWNER(), 'Invalid owner');
    assert(loot_survivor.owner_of(2) == OWNER(), 'Invalid owner');
    assert(loot_survivor.owner_of(3) == OWNER(), 'Invalid owner');
    // check lords and eth balances of loot survivor after starting
    assert(
        lords.balance_of(loot_survivor.contract_address) == 3 * 50000000000000000000,
        'Invalid balance'
    );
    assert(
        eth.balance_of(loot_survivor.contract_address) == 3 * 200000000000000, 'Invalid balance'
    );

    testing::set_block_timestamp(TEST_END_TIME().into());

    // set data to a dead adventurer with 1 xp
    let submitted_adventurer = create_dead_adventurer_with_xp(1);
    loot_survivor.set_adventurer(1, submitted_adventurer);

    tournament.submit_scores(tournament_id, array![1]);
}

#[test]
fn test_distribute_prizes_with_gated_tournaments() {
    let (_world, mut tournament, mut loot_survivor, _pragma, mut eth, mut lords, _erc20, _erc721,) =
        setup();

    utils::impersonate(OWNER());

    // create a standard tournament with one winner

    let tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            TEST_START_TIME().into(),
            TEST_END_TIME().into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );

    tournament.enter_tournament(tournament_id, Option::None);

    testing::set_block_timestamp(TEST_START_TIME().into());

    approve_game_costs(eth, lords, tournament, 1);

    tournament.start_tournament(tournament_id, false, Option::None);

    testing::set_block_timestamp(TEST_END_TIME().into());

    // set data to a dead adventurer with 1 xp
    let submitted_adventurer = create_dead_adventurer_with_xp(1);
    loot_survivor.set_adventurer(1, submitted_adventurer);

    tournament.submit_scores(tournament_id, array![1]);

    testing::set_block_timestamp((TEST_END_TIME() + MIN_SUBMISSION_PERIOD).into());

    // define a new tournament that has a gated type of the first tournament
    let gated_type = GatedType::tournament(array![1].span());

    let current_time = get_block_timestamp();

    let tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            current_time + MIN_REGISTRATION_PERIOD.into(),
            current_time + 1 + MIN_REGISTRATION_PERIOD.into() + MIN_TOURNAMENT_LENGTH.into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::Some(gated_type), // zero gated type
            Option::None, // zero entry premium
        );

    let tournament_data = tournament.tournament(tournament_id);
    assert(
        tournament_data.gated_type == Option::Some(gated_type), 'Invalid tournament gated token'
    );
    // submit game id 1
    let gated_submission_type = GatedSubmissionType::game_id(array![1].span());

    tournament.enter_tournament(tournament_id, Option::Some(gated_submission_type));

    testing::set_block_timestamp(current_time + MIN_REGISTRATION_PERIOD.into());

    approve_game_costs(eth, lords, tournament, 1);

    tournament.start_tournament(tournament_id, false, Option::None);

    testing::set_block_timestamp(
        current_time + 1 + MIN_REGISTRATION_PERIOD.into() + MIN_TOURNAMENT_LENGTH.into()
    );

    // this is now adventurer 2
    // set data to a dead adventurer with 1 xp
    let submitted_adventurer = create_dead_adventurer_with_xp(1);
    loot_survivor.set_adventurer(2, submitted_adventurer);

    tournament.submit_scores(tournament_id, array![2]);
}

#[test]
fn test_distribute_prizes_with_premiums() {
    let (
        _world,
        mut tournament,
        mut loot_survivor,
        _pragma,
        mut eth,
        mut lords,
        mut erc20,
        mut erc721,
    ) =
        setup();

    utils::impersonate(OWNER());
    register_tokens_for_test(tournament, erc20, erc721);

    let entry_premium = Premium {
        token: erc20.contract_address,
        token_amount: 1,
        token_distribution: array![100].span(),
        creator_fee: 0,
    };

    let tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            TEST_START_TIME().into(),
            TEST_END_TIME().into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::None, // zero gated type
            Option::Some(entry_premium), // zero entry premium
        );

    let tournament_data = tournament.tournament(tournament_id);
    assert(
        tournament_data.entry_premium == Option::Some(entry_premium), 'Invalid entry
    premium'
    );

    // handle approval for the premium
    erc20.approve(tournament.contract_address, 1);

    tournament.enter_tournament(tournament_id, Option::None);

    // check owner now has 1 less premium token
    assert(erc20.balance_of(OWNER()) == STARTING_BALANCE - 1, 'Invalid balance');

    // check tournament now has premium funds
    assert(erc20.balance_of(tournament.contract_address) == 1, 'Invalid balance');

    testing::set_block_timestamp(TEST_START_TIME().into());

    approve_game_costs(eth, lords, tournament, 1);

    tournament.start_tournament(tournament_id, false, Option::None);

    testing::set_block_timestamp(TEST_END_TIME().into());

    // set data to a dead adventurer with 1 xp
    let submitted_adventurer = create_dead_adventurer_with_xp(1);
    loot_survivor.set_adventurer(1, submitted_adventurer);

    tournament.submit_scores(tournament_id, array![1]);

    testing::set_block_timestamp((TEST_END_TIME() + MIN_SUBMISSION_PERIOD).into());
    tournament.distribute_prizes(tournament_id, array![1]);

    // check owner now has all premium funds back
    assert(erc20.balance_of(OWNER()) == STARTING_BALANCE, 'Invalid balance');
}

#[test]
fn test_distribute_prizes_with_premium_creator_fee() {
    let (
        _world,
        mut tournament,
        mut loot_survivor,
        _pragma,
        mut eth,
        mut lords,
        mut erc20,
        mut erc721,
    ) =
        setup();

    utils::impersonate(OWNER());
    register_tokens_for_test(tournament, erc20, erc721);

    // Create premium with 10% creator fee and 90% to winner
    let entry_premium = Premium {
        token: erc20.contract_address,
        token_amount: 100, // 100 tokens per entry
        token_distribution: array![100].span(), // 100% to winner
        creator_fee: 10, // 10% creator fee
    };

    let tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            TEST_START_TIME().into(),
            TEST_END_TIME().into(),
            MIN_SUBMISSION_PERIOD.into(),
            1, // single top score
            Option::None, // zero gated type
            Option::Some(entry_premium), // premium with creator fee
        );

    // Enter tournament with two players
    utils::impersonate(OWNER());
    erc20.approve(tournament.contract_address, 100);
    tournament.enter_tournament(tournament_id, Option::None);

    let player2 = starknet::contract_address_const::<0x456>();
    utils::impersonate(player2);
    erc20.mint(player2, 100);
    erc20.approve(tournament.contract_address, 100);
    tournament.enter_tournament(tournament_id, Option::None);

    // Start tournament and submit scores
    testing::set_block_timestamp(TEST_START_TIME().into());

    let creator_initial_balance = erc20.balance_of(OWNER());

    utils::impersonate(OWNER());
    approve_game_costs(eth, lords, tournament, 1);
    tournament.start_tournament(tournament_id, false, Option::None);

    // Verify creator fee distribution (10% of 200 total = 20)
    assert(erc20.balance_of(OWNER()) == creator_initial_balance + 20, 'Invalid creator fee');

    utils::impersonate(player2);
    eth.mint(player2, STARTING_BALANCE);
    lords.mint(player2, STARTING_BALANCE);
    approve_game_costs(eth, lords, tournament, 1);
    tournament.start_tournament(tournament_id, false, Option::None);

    testing::set_block_timestamp(TEST_END_TIME().into());

    // Set scores (player2 wins)
    let winner_adventurer = create_dead_adventurer_with_xp(10);
    let loser_adventurer = create_dead_adventurer_with_xp(5);
    loot_survivor.set_adventurer(1, loser_adventurer);
    loot_survivor.set_adventurer(2, winner_adventurer);

    utils::impersonate(OWNER());
    tournament.submit_scores(tournament_id, array![2]);

    // Check initial balances
    let winner_initial_balance = erc20.balance_of(player2);

    // Distribute rewards
    testing::set_block_timestamp((TEST_END_TIME() + MIN_SUBMISSION_PERIOD).into());
    tournament.distribute_prizes(tournament_id, array![1]);

    // Verify winner prize distribution (90% of 200 total = 180)
    assert(
        erc20.balance_of(player2) == winner_initial_balance + 180, 'Invalid winner distribution'
    );
}

#[test]
fn test_distribute_prizes_with_premium_multiple_winners() {
    let (
        _world,
        mut tournament,
        mut loot_survivor,
        _pragma,
        mut eth,
        mut lords,
        mut erc20,
        mut erc721,
    ) =
        setup();

    utils::impersonate(OWNER());
    register_tokens_for_test(tournament, erc20, erc721);

    // Create premium with 10% creator fee and split remaining 90% between top 3:
    // 1st: 50%, 2nd: 30%, 3rd: 20%
    let entry_premium = Premium {
        token: erc20.contract_address,
        token_amount: 100, // 100 tokens per entry
        token_distribution: array![50, 30, 20].span(), // Distribution percentages
        creator_fee: 10, // 10% creator fee
    };

    let tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            TEST_START_TIME().into(),
            TEST_END_TIME().into(),
            MIN_SUBMISSION_PERIOD.into(),
            3, // three top scores
            Option::None, // zero gated type
            Option::Some(entry_premium), // premium with distribution
        );

    // Create and enter with 4 players
    let player2 = starknet::contract_address_const::<0x456>();
    let player3 = starknet::contract_address_const::<0x789>();
    let player4 = starknet::contract_address_const::<0x101>();

    // Owner enters
    utils::impersonate(OWNER());
    erc20.approve(tournament.contract_address, 100);
    tournament.enter_tournament(tournament_id, Option::None);

    // Player 2 enters
    utils::impersonate(player2);
    erc20.mint(player2, 100);
    erc20.approve(tournament.contract_address, 100);
    tournament.enter_tournament(tournament_id, Option::None);

    // Player 3 enters
    utils::impersonate(player3);
    erc20.mint(player3, 100);
    erc20.approve(tournament.contract_address, 100);
    tournament.enter_tournament(tournament_id, Option::None);

    // Player 4 enters
    utils::impersonate(player4);
    erc20.mint(player4, 100);
    erc20.approve(tournament.contract_address, 100);
    tournament.enter_tournament(tournament_id, Option::None);

    // Start tournament
    testing::set_block_timestamp(TEST_START_TIME().into());

    let third_initial = erc20.balance_of(OWNER());

    // Start games for all players
    utils::impersonate(OWNER());
    approve_game_costs(eth, lords, tournament, 1);
    tournament.start_tournament(tournament_id, false, Option::None);

    utils::impersonate(player2);
    eth.mint(player2, STARTING_BALANCE);
    lords.mint(player2, STARTING_BALANCE);
    approve_game_costs(eth, lords, tournament, 1);
    tournament.start_tournament(tournament_id, false, Option::None);

    utils::impersonate(player3);
    eth.mint(player3, STARTING_BALANCE);
    lords.mint(player3, STARTING_BALANCE);
    approve_game_costs(eth, lords, tournament, 1);
    tournament.start_tournament(tournament_id, false, Option::None);

    utils::impersonate(player4);
    eth.mint(player4, STARTING_BALANCE);
    lords.mint(player4, STARTING_BALANCE);
    approve_game_costs(eth, lords, tournament, 1);
    tournament.start_tournament(tournament_id, false, Option::None);

    testing::set_block_timestamp(TEST_END_TIME().into());

    // Set scores (player2 wins, player3 second, owner third, player4 last)
    let first_place = create_dead_adventurer_with_xp(100);
    let second_place = create_dead_adventurer_with_xp(75);
    let third_place = create_dead_adventurer_with_xp(50);
    let fourth_place = create_dead_adventurer_with_xp(25);

    loot_survivor.set_adventurer(2, first_place); // player2's adventurer
    loot_survivor.set_adventurer(3, second_place); // player3's adventurer
    loot_survivor.set_adventurer(1, third_place); // owner's adventurer
    loot_survivor.set_adventurer(4, fourth_place); // player4's adventurer

    // Submit scores
    utils::impersonate(player2);
    tournament.submit_scores(tournament_id, array![2, 3, 1]);

    // Store initial balances
    let first_initial = erc20.balance_of(player2);
    let second_initial = erc20.balance_of(player3);

    // Distribute rewards
    testing::set_block_timestamp((TEST_END_TIME() + MIN_SUBMISSION_PERIOD).into());
    // 3 premium prizes
    tournament.distribute_prizes(tournament_id, array![1, 2, 3]);

    // Total pool = 4 players * 100 tokens = 400 tokens
    // Creator fee = 10% of 400 = 40 tokens
    // Remaining pool = 360 tokens
    // 1st place (50%) = 180 tokens
    // 2nd place (30%) = 108 tokens
    // 3rd place (20%) = 72 tokens

    // Verify winner distributions
    assert(erc20.balance_of(player2) == first_initial + 180, 'Invalid first distribution');
    assert(erc20.balance_of(player3) == second_initial + 108, 'Invalid second distribution');
    assert(erc20.balance_of(OWNER()) == third_initial + 72 + 40, 'Invalid third distribution');
}

#[test]
fn test_tournament_with_no_submissions() {
    let (
        _world, mut tournament, _loot_survivor, _pragma, mut eth, mut lords, mut erc20, mut erc721,
    ) =
        setup();

    utils::impersonate(OWNER());
    register_tokens_for_test(tournament, erc20, erc721);

    // Create tournament with prizes and premium
    let entry_premium = Premium {
        token: erc20.contract_address,
        token_amount: 100,
        token_distribution: array![100].span(), // 100% to winner
        creator_fee: 10, // 10% creator fee
    };

    let tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            TEST_START_TIME().into(),
            TEST_END_TIME().into(),
            MIN_SUBMISSION_PERIOD.into(),
            3, // Track top 3 scores
            Option::None,
            Option::Some(entry_premium),
        );

    // Add some prizes
    erc20.approve(tournament.contract_address, STARTING_BALANCE);
    erc721.approve(tournament.contract_address, 1);
    tournament
        .add_prize(
            tournament_id,
            erc20.contract_address,
            TokenDataType::erc20(ERC20Data { token_amount: STARTING_BALANCE.low }),
            1
        );
    tournament
        .add_prize(
            tournament_id,
            erc721.contract_address,
            TokenDataType::erc721(ERC721Data { token_id: 1 }),
            1
        );

    // Create multiple players
    let player2 = starknet::contract_address_const::<0x456>();
    let player3 = starknet::contract_address_const::<0x789>();

    // Enter tournament with all players
    erc20.mint(OWNER(), 100);
    erc20.approve(tournament.contract_address, 100);
    tournament.enter_tournament(tournament_id, Option::None);

    utils::impersonate(player2);
    erc20.mint(player2, 100);
    erc20.approve(tournament.contract_address, 100);
    tournament.enter_tournament(tournament_id, Option::None);

    utils::impersonate(player3);
    erc20.mint(player3, 100);
    erc20.approve(tournament.contract_address, 100);
    tournament.enter_tournament(tournament_id, Option::None);

    // Start tournament for all players
    testing::set_block_timestamp(TEST_START_TIME().into());

    // Store initial balances
    let creator_initial = erc20.balance_of(OWNER());

    utils::impersonate(OWNER());
    approve_game_costs(eth, lords, tournament, 1);
    tournament.start_tournament(tournament_id, false, Option::None);

    utils::impersonate(player2);
    eth.mint(player2, STARTING_BALANCE);
    lords.mint(player2, STARTING_BALANCE);
    approve_game_costs(eth, lords, tournament, 1);
    tournament.start_tournament(tournament_id, false, Option::None);

    utils::impersonate(player3);
    eth.mint(player3, STARTING_BALANCE);
    lords.mint(player3, STARTING_BALANCE);
    approve_game_costs(eth, lords, tournament, 1);
    tournament.start_tournament(tournament_id, false, Option::None);

    // Move to after tournament and submission period without any score submissions
    testing::set_block_timestamp((TEST_END_TIME() + MIN_SUBMISSION_PERIOD).into());

    // Distribute rewards
    utils::impersonate(OWNER());
    // 2 deposited prizes and 1 tournament premium prize
    tournament.distribute_prizes(tournament_id, array![1, 2, 3]);

    // Verify final state
    let final_scores = tournament.top_scores(tournament_id);
    assert(final_scores.len() == 0, 'Should have no scores');

    // Verify first caller gets all prizes
    // creator also gets the prize balance back (STARTING BALANCE)
    assert(
        erc20.balance_of(OWNER()) == creator_initial + 300 + STARTING_BALANCE,
        'Invalid owner refund'
    );
    assert(erc20.balance_of(player2) == 0, 'Invalid player2 refund');
    assert(erc20.balance_of(player3) == 0, 'Invalid player3 refund');

    // Verify prize returns to tournament creator
    assert(erc721.owner_of(1) == OWNER(), 'Prize should return to caller');
}

#[test]
fn test_tournament_with_no_starts() {
    let (_world, mut tournament, _loot_survivor, _pragma, _eth, _lords, mut erc20, mut erc721,) =
        setup();

    utils::impersonate(OWNER());
    register_tokens_for_test(tournament, erc20, erc721);

    // Create tournament with prizes and premium
    let entry_premium = Premium {
        token: erc20.contract_address,
        token_amount: 100,
        token_distribution: array![100].span(), // 100% to winner
        creator_fee: 10, // 10% creator fee
    };

    let tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            TEST_START_TIME().into(),
            TEST_END_TIME().into(),
            MIN_SUBMISSION_PERIOD.into(),
            3, // Track top 3 scores
            Option::None,
            Option::Some(entry_premium),
        );

    // Add some prizes
    erc20.approve(tournament.contract_address, STARTING_BALANCE);
    erc721.approve(tournament.contract_address, 1);
    tournament
        .add_prize(
            tournament_id,
            erc20.contract_address,
            TokenDataType::erc20(ERC20Data { token_amount: STARTING_BALANCE.low }),
            1
        );
    tournament
        .add_prize(
            tournament_id,
            erc721.contract_address,
            TokenDataType::erc721(ERC721Data { token_id: 1 }),
            1
        );

    // Create multiple players
    let player2 = starknet::contract_address_const::<0x456>();
    let player3 = starknet::contract_address_const::<0x789>();

    // Enter tournament with all players
    erc20.mint(OWNER(), 100);
    erc20.approve(tournament.contract_address, 100);
    tournament.enter_tournament(tournament_id, Option::None);

    utils::impersonate(player2);
    erc20.mint(player2, 100);
    erc20.approve(tournament.contract_address, 100);
    tournament.enter_tournament(tournament_id, Option::None);

    utils::impersonate(player3);
    erc20.mint(player3, 100);
    erc20.approve(tournament.contract_address, 100);
    tournament.enter_tournament(tournament_id, Option::None);

    // Start tournament for all players
    testing::set_block_timestamp(TEST_START_TIME().into());

    // Store initial balances
    let creator_initial = erc20.balance_of(OWNER());

    // Move to after tournament and submission period without any score submissions
    testing::set_block_timestamp((TEST_END_TIME() + MIN_SUBMISSION_PERIOD).into());

    // Distribute rewards
    utils::impersonate(OWNER());
    // 2 deposited prizes and 1 tournament premium prize
    tournament.distribute_prizes(tournament_id, array![1, 2, 3]);

    // Verify final state
    let final_scores = tournament.top_scores(tournament_id);
    assert(final_scores.len() == 0, 'Should have no scores');

    // Verify first caller gets all prizes
    // creator also gets the prize balance back (STARTING BALANCE)
    assert(
        erc20.balance_of(OWNER()) == creator_initial + 300 + STARTING_BALANCE,
        'Invalid owner refund'
    );
    assert(erc20.balance_of(player2) == 0, 'Invalid player2 refund');
    assert(erc20.balance_of(player3) == 0, 'Invalid player3 refund');

    // Verify prize returns to tournament creator
    assert(erc721.owner_of(1) == OWNER(), 'Prize should return to caller');
}

