use starknet::testing;
use starknet::ContractAddress;
use integer::BoundedInt;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use dojo::test_utils::spawn_test_world;
use ls::tests::constants::{ZERO, OWNER, SPENDER, RECIPIENT, TOKEN_ID, GITHUB_USERNAME, TELEGRAM_HANDLE, X_HANDLE, NEW_GITHUB_USERNAME, NEW_TELEGRAM_HANDLE, NEW_X_HANDLE};
use ls::tests::utils;

use ls::components::client::client_developer::{
    client_developer_model, ClientDeveloperModel
};
use ls::components::client::client_developer::client_developer_component;
use ls::components::client::client_developer::client_developer_component::{
    RegisterDeveloper, UpdateDeveloper, ClientDeveloperImpl, InternalImpl as ClientDeveloperInternalImpl
};

use ls::components::token::erc721::erc721_balance::{
    erc_721_balance_model, ERC721BalanceModel
};
use ls::components::token::erc721::erc721_balance::erc721_balance_component;
use ls::components::token::erc721::erc721_balance::erc721_balance_component::{
   ERC721BalanceImpl, InternalImpl as ERC721BalanceInternalImpl
};


use ls::components::tests::mocks::client::client_developer_mock::client_developer_mock;
use ls::components::tests::mocks::client::client_developer_mock::client_developer_mock::world_dispatcherContractMemberStateTrait;

use debug::PrintTrait;

//
// events helpers
//

fn assert_event_register_developer(
    emitter: ContractAddress, id: u256, github_username: felt252, telegram_handle: felt252, x_handle: felt252
) {
    let event = utils::pop_log::<RegisterDeveloper>(emitter).unwrap();
    assert(event.id == id, 'Invalid `id`');
    assert(event.github_username == github_username, 'Invalid `github_username`');
    assert(event.telegram_handle == telegram_handle, 'Invalid `telegram_handle`');
    assert(event.x_handle == x_handle, 'Invalid `x_handle`');
}

fn assert_only_register_developer(
    emitter: ContractAddress, id: u256, github_username: felt252, telegram_handle: felt252, x_handle: felt252
) {
    assert_event_register_developer(emitter, id, github_username, telegram_handle, x_handle);
    utils::assert_no_events_left(emitter);
}


fn assert_event_update_developer(
    emitter: ContractAddress, id: u256, github_username: felt252, telegram_handle: felt252, x_handle: felt252
) {
    let event = utils::pop_log::<UpdateDeveloper>(emitter).unwrap();
    assert(event.id == id, 'Invalid `id`');
    assert(event.github_username == github_username, 'Invalid `github_username`');
    assert(event.telegram_handle == telegram_handle, 'Invalid `telegram_handle`');
    assert(event.x_handle == x_handle, 'Invalid `x_handle`');
}

fn assert_only_update_developer(
    emitter: ContractAddress, id: u256, github_username: felt252, telegram_handle: felt252, x_handle: felt252
) {
    assert_event_update_developer(emitter, id, github_username, telegram_handle, x_handle);
    utils::assert_no_events_left(emitter);
}

//
// initialize STATE
//

fn STATE() -> (IWorldDispatcher, client_developer_mock::ContractState) {
    let world = spawn_test_world(array![client_developer_model::TEST_CLASS_HASH, erc_721_balance_model::TEST_CLASS_HASH]);

    let mut state = client_developer_mock::contract_state_for_testing();
    state.world_dispatcher.write(world);

    utils::drop_event(ZERO());

    (world, state)
}

//
//  register_developer (register)
//

#[test]
fn test_client_register_developer() {
    let (_world, mut state) = STATE();

    testing::set_caller_address(OWNER());

    state.client_developer.register_developer(GITHUB_USERNAME, TELEGRAM_HANDLE, X_HANDLE);

    assert_event_register_developer(ZERO(), 0, GITHUB_USERNAME, TELEGRAM_HANDLE, X_HANDLE);

    assert(state.erc721_balance.balance_of(OWNER()) == 1, 'Should be 1');
}

//
//  change developer details (change_github_username, change_telegram_handle, change_x_handle)
//

#[test]
fn test_client_change_developer_details() {
    let (_world, mut state) = STATE();

    testing::set_caller_address(OWNER());

    state.client_developer.register_developer(GITHUB_USERNAME, TELEGRAM_HANDLE, X_HANDLE);
    utils::drop_all_events(ZERO());
    utils::assert_no_events_left(ZERO());
    state.client_developer.change_github_username(0, NEW_GITHUB_USERNAME);
    assert_event_update_developer(ZERO(), 0, NEW_GITHUB_USERNAME, TELEGRAM_HANDLE, X_HANDLE);
    utils::drop_event(ZERO());
    state.client_developer.change_telegram_handle(0, NEW_TELEGRAM_HANDLE);
    assert_event_update_developer(ZERO(), 0, NEW_GITHUB_USERNAME, NEW_TELEGRAM_HANDLE, X_HANDLE);
    utils::drop_event(ZERO());
    state.client_developer.change_x_handle(0, NEW_X_HANDLE);
    assert_event_update_developer(ZERO(), 0, NEW_GITHUB_USERNAME, NEW_TELEGRAM_HANDLE, NEW_X_HANDLE);
}

#[test]
#[should_panic(expected: ('Client: Developer registered',))]
fn test_client_developer_already_registered() {
    let (_world, mut state) = STATE();

    testing::set_caller_address(OWNER());

    state.client_developer.register_developer(GITHUB_USERNAME, TELEGRAM_HANDLE, X_HANDLE);
    state.client_developer.register_developer(GITHUB_USERNAME, TELEGRAM_HANDLE, X_HANDLE);
}