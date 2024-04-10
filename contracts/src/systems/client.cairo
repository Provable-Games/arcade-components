// Starknet imports
use starknet::{ContractAddress, get_caller_address};

// Dojo imports
use dojo::world::IWorldDispatcher;

// Origami imports
use token::erc721::ERC721;

// Local imports
use ls::models::config::Config;

// define the interface
#[starknet::interface]
trait IClient<TContractState> {
    fn initialize(
        self: @TContractState, world: IWorldDispatcher, token_address: ContractAddress
    );
    fn register(
        ref self: TContractState, world: IWorldDispatcher, id: felt252, game_id: felt252, name: felt252, url: felt252
    );
    fn change_url(self: @TContractState, world: IWorldDispatcher, id: felt252, url: felt252);
    fn rate(self: @TContractState, world: IWorldDispatcher, id: felt252, rating: u8);
    fn increment_play_count(self: @TContractState, world: IWorldDispatcher, id: felt252);
}

#[starknet::contract]
mod client {
    // Starknet imports
    use core::traits::Into;
use ls::store::StoreTrait;
    use starknet::ContractAddress;
    use starknet::info::{
        get_block_timestamp, get_block_number, get_caller_address, get_contract_address, get_tx_info
    };

    // Dojo imports
    use dojo::world;
    use dojo::world::IWorldDispatcher;
    use dojo::world::IWorldDispatcherTrait;
    use dojo::world::IWorldProvider;
    use dojo::world::IDojoResourceProvider;

    // Component imports - TODO: swap with origami lib imports
    use ls::token::components::token::erc721::erc721_approval::erc721_approval_component;
    use ls::token::components::token::erc721::erc721_balance::erc721_balance_component;
    use ls::token::components::token::erc721::erc721_metadata::erc721_metadata_component;
    use ls::token::components::token::erc721::erc721_mintable::erc721_mintable_component;
    use ls::token::components::token::erc721::erc721_burnable::erc721_burnable_component;
    use ls::token::components::token::erc721::erc721_owner::erc721_owner_component;

    component!(
        path: erc721_approval_component, storage: erc721_approval, event: ERC721ApprovalEvent
    );
    component!(path: erc721_balance_component, storage: erc721_balance, event: ERC721BalanceEvent);
    component!(path: erc721_metadata_component, storage: erc721_metadata, event: ERC721MetadataEvent);
    component!(path: erc721_mintable_component, storage: erc721_mintable, event: ERC721MintableEvent);
    component!(path: erc721_burnable_component, storage: erc721_burnable, event: ERC721BurnableEvent);
    component!(path: erc721_owner_component, storage: erc721_owner, event: ERC721OwnerEvent);

    impl ERC721ApprovalInternalImpl = erc721_approval_component::InternalImpl<ContractState>;
    impl ERC721BalanceInternalImpl = erc721_balance_component::InternalImpl<ContractState>;
    impl ERC721MetadataInternalImpl = erc721_metadata_component::InternalImpl<ContractState>;
    impl ERC721MintableInternalImpl = erc721_mintable_component::InternalImpl<ContractState>;
    impl ERC721BurnableInternalImpl = erc721_burnable_component::InternalImpl<ContractState>;
    impl ERC721OwnerInternalImpl = erc721_owner_component::InternalImpl<ContractState>;

    // LS imports
    use ls::constants::WORLD;
    use ls::models::client::{Client, ClientTrait};
    use ls::models::config::{Config, ConfigTrait};
    use ls::store::{Store, StoreImpl};

    // Local imports
    use super::IClient;

    // Errors
    mod errors {
        const CLIENT_ALREADY_REGISTERED: felt252 = 'Client: Client registered';
        const SAME_URL: felt252 = 'Client: URL must be different';
    }

    // Storage
    #[storage]
    struct Storage {
        #[substorage(v0)]
        erc721_approval: erc721_approval_component::Storage,
        #[substorage(v0)]
        erc721_balance: erc721_balance_component::Storage,
        #[substorage(v0)]
        erc721_metadata: erc721_metadata_component::Storage,
        #[substorage(v0)]
        erc721_mintable: erc721_mintable_component::Storage,
        #[substorage(v0)]
        erc721_burnable: erc721_burnable_component::Storage,
        #[substorage(v0)]
        erc721_owner: erc721_owner_component::Storage,
    }

    // Events
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        ERC721ApprovalEvent: erc721_approval_component::Event,
        ERC721BalanceEvent: erc721_balance_component::Event,
        ERC721MetadataEvent: erc721_metadata_component::Event,
        ERC721MintableEvent: erc721_mintable_component::Event,
        ERC721BurnableEvent: erc721_burnable_component::Event,
        ERC721OwnerEvent: erc721_owner_component::Event,
        RegisteredClient: RegisteredClient,
        ChangeUrl: ChangeUrl,
        Rate: Rate,
    }

    #[derive(Drop, starknet::Event)]
    struct RegisteredClient {
        client: Client,
        block: felt252
    }

    #[derive(Drop, starknet::Event)]
    struct ChangeUrl {
        client: Client,
        block: felt252
    }

    #[derive(Drop, starknet::Event)]
    struct Rate {
        client: Client,
        block: felt252
    }

    #[abi(embed_v0)]
    impl DojoResourceProviderImpl of IDojoResourceProvider<ContractState> {
        fn dojo_resource(self: @ContractState) -> felt252 {
            'client'
        }
    }

    #[abi(embed_v0)]
    impl WorldProviderImpl of IWorldProvider<ContractState> {
        fn world(self: @ContractState) -> IWorldDispatcher {
            IWorldDispatcher { contract_address: WORLD() }
        }
    }

    #[abi(embed_v0)]
    impl ClientImpl of IClient<ContractState> {
        fn initialize(
            self: @ContractState, world: IWorldDispatcher, token_address: ContractAddress
        ) {
            let store: Store = StoreImpl::new(world);
            store.set_config(ConfigTrait::new(token_address))

        }
        fn register(
            ref self: ContractState, world: IWorldDispatcher, id: felt252, game_id: felt252, name: felt252, url: felt252
        ) {
            let store: Store = StoreImpl::new(world);
            store.set_client(ClientTrait::new(id, game_id, name, url));
            let caller = get_caller_address();
            self.erc721_mintable.mint(caller, id.into());
        }

        fn change_url(self: @ContractState, world: IWorldDispatcher, id: felt252, url: felt252) {
            let store: Store = StoreImpl::new(world);
            store.set_url(id, url)
        }

        fn rate(self: @ContractState, world: IWorldDispatcher, id: felt252, rating: u8) {
            let store: Store = StoreImpl::new(world);
            let client = store.client(id);
            let rating = client.rating;
            let player_count = client.play_count;
            store.set_rating(id, rating)
        }

        fn increment_play_count(self: @ContractState, world: IWorldDispatcher, id: felt252) {
            let store: Store = StoreImpl::new(world);
        // store.increment_play_count(client_id)
        }
    }
}
