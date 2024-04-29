use starknet::testing;
use starknet::ContractAddress;
use integer::BoundedInt;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use dojo::test_utils::spawn_test_world;
use ls::tests::constants::{ZERO, OWNER, SPENDER, RECIPIENT, TOKEN_ID, GITHUB_USERNAME, TELEGRAM_HANDLE, X_HANDLE};
use ls::tests::utils;

use ls::components::client::client_developer::{
    client_developer_model, ClientDeveloperModel
};
use ls::components::client::client_developer::client_developer_component;
use ls::components::client::client_developer::client_developer_component::{
    RegisterDeveloper, UpdateDeveloper, ClientDeveloperImpl, InternalImpl as ClientDeveloperInternalImpl
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
    assert(event.id == id, 'Invalid `owner`');
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

//
// initialize STATE
//

fn STATE() -> (IWorldDispatcher, client_developer_mock::ContractState) {
    let world = spawn_test_world(array![client_developer_model::TEST_CLASS_HASH]);

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

}

// #[test]
// fn test_erc721_approval_approve_for_all() {
//     let (_world, mut state) = STATE();

//     testing::set_caller_address(OWNER());

//     state.erc721_approval.set_approval_for_all(SPENDER(), true);
//     assert(state.erc721_approval.is_approved_for_all(OWNER(), SPENDER()) == true, 'should be approved');

//     assert_only_event_approval_for_all(ZERO(), OWNER(), SPENDER(), true);
// }

// #[test]
// #[should_panic(expected: ('ERC721: unauthorized caller',))]
// fn test_erc721_approval_unauthorized_caller() {
//     let (_world, mut state) = STATE();

//     testing::set_caller_address(ZERO());

//     state.erc721_owner.set_owner(TOKEN_ID, OWNER());
//     state.erc721_approval.approve(SPENDER(), TOKEN_ID);
// }

// #[test]
// #[should_panic(expected: ('ERC721: approval to owner',))]
// fn test_erc721_approval_approval_to_owner() {
//     let (_world, mut state) = STATE();

//     testing::set_caller_address(OWNER());

//     state.erc721_owner.set_owner(TOKEN_ID, OWNER());
//     state.erc721_approval.approve(OWNER(), TOKEN_ID);
// }
