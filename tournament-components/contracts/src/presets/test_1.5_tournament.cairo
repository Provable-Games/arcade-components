use starknet::testing;
use starknet::ContractAddress;
use integer::BoundedInt;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use dojo::test_utils::spawn_test_world;
use ls::tests::constants::{
    ZERO, OWNER, SPENDER, RECIPIENT, TOKEN_ID, CLIENT_ID, GITHUB_USERNAME, TELEGRAM_HANDLE,
    X_HANDLE, CLIENT_NAME, CREATOR_ID, GAME_ID, GAME_NAME, GAME_URL, NAME, SYMBOL, URI, RATING
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


use ls::presets::client_manager::{
    ClientManager, IClientManagerDispatcher, IClientManagerDispatcherTrait
};
use ls::presets::client_manager::ClientManager::world_dispatcherContractMemberStateTrait;

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
// Setup
//

fn setup() -> (IWorldDispatcher, IClientManagerDispatcher) {
    let world = spawn_test_world(array![client_creator_model::TEST_CLASS_HASH,]);

    // deploy contract
    let mut client_manager_dispatcher = IClientManagerDispatcher {
        contract_address: world
            .deploy_contract('salt', ClientManager::TEST_CLASS_HASH.try_into().unwrap())
    };

    // setup auth
    world.grant_writer('ClientCreatorModel', client_manager_dispatcher.contract_address);
    world.grant_writer('ClientPlayTotalModel', client_manager_dispatcher.contract_address);
    world.grant_writer('ClientPlayPlayerModel', client_manager_dispatcher.contract_address);
    world.grant_writer('ClientRatingTotalModel', client_manager_dispatcher.contract_address);
    world.grant_writer('ClientRatingPlayerModel', client_manager_dispatcher.contract_address);
    world.grant_writer('ClientRegistrationModel', client_manager_dispatcher.contract_address);
    world.grant_writer('ClientTotalModel', client_manager_dispatcher.contract_address);
    world.grant_writer('ERC721TokenApprovalModel', client_manager_dispatcher.contract_address);
    world.grant_writer('ERC721BalanceModel', client_manager_dispatcher.contract_address);
    world.grant_writer('ERC721EnumerableTotalModel', client_manager_dispatcher.contract_address);
    world.grant_writer('ERC721MetaModel', client_manager_dispatcher.contract_address);
    world.grant_writer('ERC721OwnerModel', client_manager_dispatcher.contract_address);

    // initialize contracts
    client_manager_dispatcher.initializer(NAME, SYMBOL, URI);

    // drop all events
    utils::drop_all_events(client_manager_dispatcher.contract_address);
    utils::drop_all_events(world.contract_address);

    (world, client_manager_dispatcher)
}

//
// initializer
//

#[test]
fn test_initializer() {
    let (_world, mut client_manager) = setup();

    assert(client_manager.name() == NAME, 'Name should be NAME');
    assert(client_manager.symbol() == SYMBOL, 'Symbol should be SYMBOL');
    assert(client_manager.token_uri(TOKEN_ID) == URI, 'Uri should be URI');
}

#[test]
fn test_register_creator() {
    let (_world, mut client_manager) = setup();

    utils::impersonate(OWNER());
    client_manager.register_creator(GITHUB_USERNAME, TELEGRAM_HANDLE, X_HANDLE);
    assert(client_manager.owner_of(0) == OWNER(), 'Should be OWNER');
    assert(client_manager.total_supply() == 1, 'Should be 1');
}

#[test]
fn test_register_client() {
    let (_world, mut client_manager) = setup();

    utils::impersonate(OWNER());
    client_manager.register_creator(GITHUB_USERNAME, TELEGRAM_HANDLE, X_HANDLE);
    client_manager.register_client(CREATOR_ID, GAME_ID, GAME_NAME, GAME_URL);
}

#[test]
#[should_panic(expected: ('Client: Not creator', 'ENTRYPOINT_FAILED'))]
fn test_register_after_transfer() {
    let (_world, mut client_manager) = setup();

    utils::impersonate(OWNER());

    client_manager.register_creator(GITHUB_USERNAME, TELEGRAM_HANDLE, X_HANDLE);
    client_manager.transfer_from(OWNER(), RECIPIENT(), 0);
    client_manager.register_client(CREATOR_ID, GAME_ID, GAME_NAME, GAME_URL);
}

#[test]
fn test_play_rate() {
    let (_world, mut client_manager) = setup();

    utils::impersonate(OWNER());
    client_manager.register_creator(GITHUB_USERNAME, TELEGRAM_HANDLE, X_HANDLE);
    client_manager.register_client(CREATOR_ID, GAME_ID, GAME_NAME, GAME_URL);
    client_manager.play(0);
    assert(client_manager.get_play_count_total(0) == 1, 'Should be 1');
    assert(client_manager.get_play_count_player(0, OWNER()) == 1, 'Should be 1');
    client_manager.rate(0, RATING);
    assert(client_manager.get_rating_total(0) == RATING, 'Should be RATING');
    assert(client_manager.get_rating_player(0, OWNER()) == RATING, 'Should be RATING');
}
