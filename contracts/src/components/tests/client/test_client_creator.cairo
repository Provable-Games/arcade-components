use starknet::testing;
use starknet::ContractAddress;
use integer::BoundedInt;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use dojo::test_utils::spawn_test_world;
use ls::tests::constants::{
    ZERO, OWNER, SPENDER, RECIPIENT, TOKEN_ID, CREATOR_NAME, GITHUB_USERNAME, TELEGRAM_HANDLE, X_HANDLE,
    NEW_GITHUB_USERNAME, NEW_TELEGRAM_HANDLE, NEW_X_HANDLE, CREATOR_ID
};
use ls::tests::utils;

use ls::components::client::client_creator::{client_creator_model, ClientCreatorModel};
use ls::components::client::client_creator::client_creator_component;
use ls::components::client::client_creator::client_creator_component::{
    RegisterCreator, ClientCreatorImpl, InternalImpl as ClientCreatorInternalImpl
};

use ls::components::token::erc721::erc721_balance::{erc_721_balance_model, ERC721BalanceModel};
use ls::components::token::erc721::erc721_balance::erc721_balance_component;
use ls::components::token::erc721::erc721_balance::erc721_balance_component::{
    ERC721BalanceImpl, InternalImpl as ERC721BalanceInternalImpl
};


use ls::components::tests::mocks::client::client_creator_mock::client_creator_mock;
use ls::components::tests::mocks::client::client_creator_mock::client_creator_mock::world_dispatcherContractMemberStateTrait;

use debug::PrintTrait;

//
// events helpers
//

fn assert_event_register_creator(
    emitter: ContractAddress,
    creator_id: u256,
    name: felt252,
    github_username: felt252,
    telegram_handle: felt252,
    x_handle: felt252
) {
    let event = utils::pop_log::<RegisterCreator>(emitter).unwrap();
    assert(event.creator_id == creator_id, 'Invalid `id`');
    assert(event.name == name, 'Invalid `name`');
    assert(event.github_username == github_username, 'Invalid `github_username`');
    assert(event.telegram_handle == telegram_handle, 'Invalid `telegram_handle`');
    assert(event.x_handle == x_handle, 'Invalid `x_handle`');
}

fn assert_only_register_creator(
    emitter: ContractAddress,
    creator_id: u256,
    name: felt252,
    github_username: felt252,
    telegram_handle: felt252,
    x_handle: felt252
) {
    assert_event_register_creator(emitter, creator_id, name, github_username, telegram_handle, x_handle);
    utils::assert_no_events_left(emitter);
}

//
// initialize STATE
//

fn STATE() -> (IWorldDispatcher, client_creator_mock::ContractState) {
    let world = spawn_test_world(
        array![client_creator_model::TEST_CLASS_HASH, erc_721_balance_model::TEST_CLASS_HASH]
    );

    let mut state = client_creator_mock::contract_state_for_testing();
    state.world_dispatcher.write(world);

    utils::drop_event(ZERO());

    (world, state)
}

//
//  register_creator (register)
//

#[test]
fn test_client_register_creator() {
    let (_world, mut state) = STATE();

    testing::set_caller_address(OWNER());

    state.client_creator.register_creator(CREATOR_NAME, GITHUB_USERNAME, TELEGRAM_HANDLE, X_HANDLE);

    assert_event_register_creator(ZERO(), 0, CREATOR_NAME, GITHUB_USERNAME, TELEGRAM_HANDLE, X_HANDLE);

    assert(state.erc721_balance.balance_of(OWNER()) == 1, 'Should be 1');
}

//
//  change creator details (change_github_username, change_telegram_handle, change_x_handle)
//

#[test]
fn test_client_change_creator_details() {
    let (_world, mut state) = STATE();

    testing::set_caller_address(OWNER());

    state.client_creator.register_creator(CREATOR_NAME, GITHUB_USERNAME, TELEGRAM_HANDLE, X_HANDLE);
    utils::drop_all_events(ZERO());
    utils::assert_no_events_left(ZERO());
    state.client_creator.change_github_username(0, NEW_GITHUB_USERNAME);
    state.client_creator.change_telegram_handle(0, NEW_TELEGRAM_HANDLE);
    state.client_creator.change_x_handle(0, NEW_X_HANDLE);
}

#[test]
#[should_panic(expected: ('Client: Not creator',))]
fn test_change_after_transfer() {
    let (_world, mut state) = STATE();

    testing::set_caller_address(OWNER());

    state.client_creator.register_creator(CREATOR_NAME, GITHUB_USERNAME, TELEGRAM_HANDLE, X_HANDLE);
    state.erc721_balance.transfer_from(OWNER(), RECIPIENT(), 0);
    state.client_creator.change_github_username(CREATOR_ID, NEW_GITHUB_USERNAME);
}


