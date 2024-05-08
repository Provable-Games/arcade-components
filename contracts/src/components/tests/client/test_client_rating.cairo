use starknet::testing;
use starknet::ContractAddress;
use integer::BoundedInt;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use dojo::test_utils::spawn_test_world;
use ls::tests::constants::{
    ZERO, OWNER, SPENDER, RECIPIENT, TOKEN_ID, CLIENT_ID, RATING, VOTE_COUNT
};
use ls::tests::utils;

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

use ls::components::tests::mocks::client::client_rating_mock::client_rating_mock;
use ls::components::tests::mocks::client::client_rating_mock::client_rating_mock::world_dispatcherContractMemberStateTrait;

use debug::PrintTrait;

//
// events helpers
//

fn assert_event_rate(
    emitter: ContractAddress, client_id: u256, player_address: ContractAddress, rating: u8
) {
    let event = utils::pop_log::<Rate>(emitter).unwrap();
    assert(event.client_id == client_id, 'Invalid `client_id`');
    assert(event.player_address == player_address, 'Invalid `player_address`');
    assert(event.rating == rating, 'Invalid `rating`');
}

fn assert_only_rate(
    emitter: ContractAddress, client_id: u256, player_address: ContractAddress, rating: u8
) {
    assert_event_rate(emitter, client_id, player_address, rating);
    utils::assert_no_events_left(emitter);
}

//
// initialize STATE
//

fn STATE() -> (IWorldDispatcher, client_rating_mock::ContractState) {
    let world = spawn_test_world(
        array![
            client_rating_total_model::TEST_CLASS_HASH, client_rating_player_model::TEST_CLASS_HASH
        ]
    );

    let mut state = client_rating_mock::contract_state_for_testing();
    state.world_dispatcher.write(world);

    utils::drop_event(ZERO());

    (world, state)
}

#[test]
fn test_client_calculate_new_rating() {
    let (_world, mut state) = STATE();

    testing::set_caller_address(OWNER());
    assert(state.client_rating.calculate_new_rating(RATING, 0, 0) == RATING, 'should be RATING');
    assert(state.client_rating.calculate_new_rating(60, 90, 20) == 88, 'should be 88');
    assert(state.client_rating.calculate_new_rating(28, 48, 2000) == 47, 'should be 47');
}

#[test]
fn test_client_rating() {
    let (_world, mut state) = STATE();

    testing::set_caller_address(OWNER());

    state.client_play.play(CLIENT_ID);
    utils::drop_event(ZERO());
    state.client_rating.rate(CLIENT_ID, RATING);
    assert_event_rate(ZERO(), CLIENT_ID, OWNER(), RATING);
    utils::drop_event(ZERO());
    assert(state.client_rating.get_rating_total(CLIENT_ID) == RATING, 'Should be RATING');
    assert(state.client_rating.get_rating_player(CLIENT_ID, OWNER()) == RATING, 'Should be RATING');
    state.client_play.play(CLIENT_ID);
    utils::drop_event(ZERO());
    state.client_rating.rate(CLIENT_ID, 42);
    assert_event_rate(ZERO(), CLIENT_ID, OWNER(), 42);
    assert(state.client_rating.get_rating_total(CLIENT_ID) == 53, 'Should be 53');
    assert(state.client_rating.get_rating_player(CLIENT_ID, OWNER()) == 53, 'Should be 53');
}

#[test]
#[should_panic(expected: ('Client: No votes remaining',))]
fn test_client_no_votes_remaining() {
    let (_world, mut state) = STATE();

    testing::set_caller_address(OWNER());

    state.client_play.play(CLIENT_ID);
    state.client_rating.rate(CLIENT_ID, RATING);
    state.client_rating.rate(CLIENT_ID, RATING);
}

#[test]
#[should_panic(expected: ('Client: Invalid rating',))]
fn test_client_invalid_rating() {
    let (_world, mut state) = STATE();

    testing::set_caller_address(OWNER());

    state.client_play.play(CLIENT_ID);
    state.client_rating.rate(CLIENT_ID, 105);
}