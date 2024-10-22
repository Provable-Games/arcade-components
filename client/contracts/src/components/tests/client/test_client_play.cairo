use starknet::testing;
use starknet::ContractAddress;
use integer::BoundedInt;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use dojo::test_utils::spawn_test_world;
use ls::tests::constants::{ZERO, OWNER, SPENDER, RECIPIENT, TOKEN_ID, CLIENT_ID};
use ls::tests::utils;

use ls::components::client::client_play::{
    client_play_total_model, ClientPlayTotalModel, client_play_player_model, ClientPlayPlayerModel,
};
use ls::components::client::client_play::client_play_component;
use ls::components::client::client_play::client_play_component::{
    Play, ClientPlayImpl, InternalImpl as ClientPlayInternalImpl
};

use ls::components::tests::mocks::client::client_play_mock::client_play_mock;
use ls::components::tests::mocks::client::client_play_mock::client_play_mock::world_dispatcherContractMemberStateTrait;

use debug::PrintTrait;

//
// events helpers
//

fn assert_event_play(emitter: ContractAddress, client_id: u256, player_address: ContractAddress) {
    let event = utils::pop_log::<Play>(emitter).unwrap();
    assert(event.client_id == client_id, 'Invalid `client_id`');
    assert(event.player_address == player_address, 'Invalid `player_address`');
}

fn assert_only_play(emitter: ContractAddress, client_id: u256, player_address: ContractAddress,) {
    assert_event_play(emitter, client_id, player_address);
    utils::assert_no_events_left(emitter);
}

//
// initialize STATE
//

fn STATE() -> (IWorldDispatcher, client_play_mock::ContractState) {
    let world = spawn_test_world(
        array![client_play_total_model::TEST_CLASS_HASH, client_play_player_model::TEST_CLASS_HASH]
    );

    let mut state = client_play_mock::contract_state_for_testing();
    state.world_dispatcher.write(world);

    utils::drop_event(ZERO());

    (world, state)
}

//
//  play (play)
//

#[test]
fn test_client_play() {
    let (_world, mut state) = STATE();

    testing::set_caller_address(OWNER());

    state.client_play.play(CLIENT_ID);

    assert_event_play(ZERO(), CLIENT_ID, OWNER());

    assert(state.client_play.get_play_count_total(CLIENT_ID) == 1, 'Should be 1');
    assert(state.client_play.get_play_count_player(CLIENT_ID, OWNER()) == 1, 'Should be 1');
}
