use debug::PrintTrait;
use core::option::Option;
use starknet::{
    ContractAddress, get_block_timestamp, get_contract_address, get_caller_address, testing,
    deploy_syscall
};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use dojo::model::{Model, ModelTest, ModelIndex, ModelEntityTest};
use dojo::utils::test::spawn_test_world;

use tournament::ls15_components::constants::{
    MIN_REGISTRATION_PERIOD, MAX_REGISTRATION_PERIOD, MIN_SUBMISSION_PERIOD, MAX_SUBMISSION_PERIOD,
    MIN_TOURNAMENT_LENGTH, MAX_TOURNAMENT_LENGTH, TokenType, TokenDataType, GatedType,
    GatedEntryType, GatedSubmissionType
};
use tournament::ls15_components::interfaces::{
    ERC20Data, ERC721Data, ERC1155Data, Token, Premium, GatedToken, EntryCriteria
};
use adventurer::{adventurer::Adventurer, bag::Bag, equipment::Equipment, item::Item, stats::Stats};

use tournament::tests::{
    utils,
    constants::{
        OWNER, RECIPIENT, SPENDER, ZERO, TOKEN_NAME, TOKEN_SYMBOL, BASE_URI, TOURNAMENT_NAME,
        TOURNAMENT_DESCRIPTION, STARTING_BALANCE, TEST_START_TIME, TEST_END_TIME
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
    utils::impersonate(OWNER());
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

#[test]
fn test_submit_multiple_scores_stress_test() {
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

    utils::impersonate(OWNER());

    let tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            TEST_START_TIME().into(),
            TEST_END_TIME().into(),
            MIN_SUBMISSION_PERIOD.into(),
            100, // 100 top scores
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );

    utils::impersonate(OWNER());

    eth.mint(OWNER(), 100 * 200000000000000);
    lords.mint(OWNER(), 100 * 50000000000000000000);

    // Enter tournament with 100 different addresses
    let mut i: u64 = 0;
    loop {
        if i == 100 {
            break;
        }
        tournament.enter_tournament(tournament_id, Option::None);
        i += 1;
    };

    testing::set_block_timestamp(TEST_START_TIME().into());

    lords.approve(tournament.contract_address, 100 * 50000000000000000000);
    eth.approve(tournament.contract_address, 100 * 200000000000000);

    // Approve game costs and start tournament for all players (the default will start all games for the address)
    tournament.start_tournament(tournament_id, false, Option::None);

    testing::set_block_timestamp(TEST_END_TIME().into());

    // Set data to adventurers with increasing XP
    let mut i: u64 = 0;
    loop {
        if i == 100 {
            break;
        }
        let submitted_adventurer = create_dead_adventurer_with_xp((i + 1).try_into().unwrap());
        loot_survivor.set_adventurer((i + 1).try_into().unwrap(), submitted_adventurer);
        i += 1;
    };

    // Submit scores in order of position
    let mut score_ids = array![];
    let mut i: u64 = 0;
    loop {
        if i == 100 {
            break;
        }
        score_ids.append((100 - i).try_into().unwrap());
        i += 1;
    };
    tournament.submit_scores(tournament_id, score_ids);

    // // Verify scores
    // let scores = tournament.top_scores(tournament_id);
    // assert(scores.len() == 100, 'Invalid scores length');
    // let mut i: u64 = 0;
    // loop {
    //     if i == 100 {
    //         break;
    //     }
    //     assert(*scores.at(i.try_into().unwrap()) == (100 - i).into(), 'Invalid score');
    //     i += 1;
    // };
}