use starknet::testing;
use starknet::ContractAddress;
use integer::BoundedInt;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use dojo::test_utils::spawn_test_world;
use ls::tests::constants::{
    ZERO, OWNER, SPENDER, RECIPIENT, TOKEN_ID, CLIENT_ID, GITHUB_USERNAME, TELEGRAM_HANDLE,
    X_HANDLE, CLIENT_NAME, CREATOR_ID, GAME_ID, GAME_NAME, GAME_URL, NEW_URL
};
use ls::tests::utils;

use ls::components::client::client_creator::{client_creator_model, ClientCreatorModel};
use ls::components::client::client_creator::client_creator_component;
use ls::components::client::client_creator::client_creator_component::{
    RegisterCreator, ClientCreatorImpl, InternalImpl as ClientCreatorInternalImpl
};

use ls::components::client::client_play::{
    client_play_total_model, ClientPlayTotalModel, client_play_player_model, ClientPlayPlayerModel,
};
use ls::components::client::client_play::client_play_component;
use ls::components::client::client_play::client_play_component::{
    Play, ClientPlayImpl, InternalImpl as ClientPlayInternalImpl
};

use ls::components::client::client_rating::{
    client_rating_total_model, ClientRatingTotalModel, client_rating_player_model,
    ClientRatingPlayerModel,
};
use ls::components::client::client_rating::client_rating_component;
use ls::components::client::client_rating::client_rating_component::{
    Rate, ClientRatingImpl, InternalImpl as ClientRatingInternalImpl
};

use ls::components::client::client_registration::{
    client_registration_model, ClientRegistrationModel,
};
use ls::components::client::client_registration::client_registration_component;
use ls::components::client::client_registration::client_registration_component::{
    RegisterClient, ClientRegistrationImpl, InternalImpl as ClientRegistrationInternalImpl
};

use ls::components::token::erc721::erc721_balance::{erc_721_balance_model, ERC721BalanceModel};
use ls::components::token::erc721::erc721_balance::erc721_balance_component;
use ls::components::token::erc721::erc721_balance::erc721_balance_component::{
    ERC721BalanceImpl, InternalImpl as ERC721BalanceInternalImpl
};


use ls::components::tests::mocks::client::client_registration_mock::client_registration_mock;
use ls::components::tests::mocks::client::client_registration_mock::client_registration_mock::world_dispatcherContractMemberStateTrait;

use debug::PrintTrait;

//
// events helpers
//

fn assert_event_register_client(
    emitter: ContractAddress, client_id: u256, game_id: u256, name: felt252, url: felt252
) {
    let event = utils::pop_log::<RegisterClient>(emitter).unwrap();
    assert(event.client_id == client_id, 'Invalid `client_id`');
    assert(event.game_id == game_id, 'Invalid `game_id`');
    assert(event.name == name, 'Invalid `name`');
    assert(event.url == url, 'Invalid `url`');
}

fn assert_only_register_client(
    emitter: ContractAddress, client_id: u256, game_id: u256, name: felt252, url: felt252
) {
    assert_event_register_client(emitter, client_id, game_id, name, url);
    utils::assert_no_events_left(emitter);
}

//
// initialize STATE
//

fn STATE() -> (IWorldDispatcher, client_registration_mock::ContractState) {
    let world = spawn_test_world(array![client_registration_model::TEST_CLASS_HASH]);

    let mut state = client_registration_mock::contract_state_for_testing();
    state.world_dispatcher.write(world);

    utils::drop_event(ZERO());

    (world, state)
}

#[test]
fn test_client_registration() {
    let (_world, mut state) = STATE();

    testing::set_caller_address(OWNER());

    state.client_creator.register_creator(GITHUB_USERNAME, TELEGRAM_HANDLE, X_HANDLE);
    utils::drop_all_events(ZERO());
    state.client_registration.register_client(CREATOR_ID, GAME_ID, GAME_NAME, GAME_URL);
    assert_event_register_client(ZERO(), 0, GAME_ID, GAME_NAME, GAME_URL);
    assert(state.client_registration.total_clients() == 1, 'Should be 1');
    assert(state.client_registration.get_client_game(0) == GAME_ID, 'Should be GAME_ID');
    assert(state.client_registration.get_client_name(0) == GAME_NAME, 'Should be GAME_NAME');
    assert(state.client_registration.get_client_url(0) == GAME_URL, 'Should be GAME_URL');
}

#[test]
fn test_change_url() {
    let (_world, mut state) = STATE();

    testing::set_caller_address(OWNER());

    state.client_creator.register_creator(GITHUB_USERNAME, TELEGRAM_HANDLE, X_HANDLE);
    state.client_registration.register_client(CREATOR_ID, GAME_ID, GAME_NAME, GAME_URL);
    state.client_registration.change_url(0, NEW_URL);
    assert(state.client_registration.get_client_url(0) == NEW_URL, 'Should be NEW_URL');
}

// test client registration fails after transfer

#[test]
#[should_panic(expected: ('Client: Not creator',))]
fn test_register_after_transfer() {
    let (_world, mut state) = STATE();

    testing::set_caller_address(OWNER());

    state.client_creator.register_creator(GITHUB_USERNAME, TELEGRAM_HANDLE, X_HANDLE);
    state.erc721_balance.transfer_from(OWNER(), RECIPIENT(), 0);
    state.client_registration.register_client(CREATOR_ID, GAME_ID, GAME_NAME, GAME_URL);
}


