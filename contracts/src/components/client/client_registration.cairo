use starknet::ContractAddress;

///
/// Model
///

#[derive(Model, Copy, Drop, Serde)]
struct ClientRegistrationModel {
    #[key]
    id: u128,
    game_id: u128,
    name: felt252,
    url: felt252,
}

#[starknet::interface]
trait IClientRegistration<TState> {
    fn register(
        ref self: TState, id: u256, game_id: u256, name: felt252, url: felt252
    );
    fn change_url(self: @TState, id: u256, url: felt252);
    fn initialize(ref self: TState, name: felt252, symbol: felt252, base_uri: felt252);
}

#[starknet::interface]
trait IClientRegistrationCamel<TState> {
    fn changeUrl(self: @TState, id: u256, url: felt252);
}


///
/// ClientRegistration Component
///
#[starknet::component]
mod client_registration_component {
    use super::ClientRegistrationModel;
    use super::IClientRegistration;
    use super::IClientRegistrationCamel;
    use core::traits::Into;
    use starknet::ContractAddress;
    use starknet::info::{
        get_block_timestamp, get_block_number, get_caller_address, get_contract_address, get_tx_info
    };

    use dojo::world::{
        IWorldProvider, IWorldProviderDispatcher, IWorldDispatcher, IWorldDispatcherTrait
    };

    // Component imports - TODO: swap with origami lib imports
    use ls::components::token::erc721::erc721_approval::erc721_approval_component as erc721_approval_comp;
    use ls::components::token::erc721::erc721_balance::erc721_balance_component as erc721_balance_comp;
    use ls::components::token::erc721::erc721_metadata::erc721_metadata_component as erc721_metadata_comp;
    use ls::components::token::erc721::erc721_mintable::erc721_mintable_component as erc721_mintable_comp;
    use ls::components::token::erc721::erc721_burnable::erc721_burnable_component as erc721_burnable_comp;
    use ls::components::token::erc721::erc721_owner::erc721_owner_component as erc721_owner_comp;

    use erc721_approval_comp::InternalImpl as ERC721ApprovalInternal;
    use erc721_balance_comp::InternalImpl as ERC721BalanceInternal;
    use erc721_metadata_comp::InternalImpl as ERC721MetadataInternal;
    use erc721_mintable_comp::InternalImpl as ERC721MintableInternal;
    use erc721_owner_comp::InternalImpl as ERC721OwnerInternal;

    // Errors
    mod errors {
        const CLIENT_ALREADY_REGISTERED: felt252 = 'Client: Client registered';
        const SAME_URL: felt252 = 'Client: URL must be different';
    }

    // Storage
    #[storage]
    struct Storage {}

    // Events
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Register: Register,
        ChangeUrl: ChangeUrl,
    }

    #[derive(Drop, starknet::Event)]
    struct Register {
        id: u256,
        game_id: u256,
        name: felt252,
        url: felt252,
    }

    #[derive(Drop, starknet::Event)]
    struct ChangeUrl {
        id: u256,
        game_id: u256,
        name: felt252,
        url: felt252,
    }

    #[embeddable_as(ClientRegistrationImpl)]
    impl ClientRegistration<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        impl ERC721Approval: erc721_approval_comp::HasComponent<TContractState>,
        impl ERC721Balance: erc721_balance_comp::HasComponent<TContractState>,
        impl ERC721Metadata: erc721_metadata_comp::HasComponent<TContractState>,
        impl ERC721Mintable: erc721_mintable_comp::HasComponent<TContractState>,
        impl ERC721Owner: erc721_owner_comp::HasComponent<TContractState>,
        +Drop<TContractState>,
    > of IClientRegistration<ComponentState<TContractState>> {
        fn register(
            ref self: ComponentState<TContractState>, id: u256, game_id: u256, name: felt252, url: felt252
        ) {
            self.set_client(id, game_id, name, url);
            let mut erc721_mintable = get_dep_component_mut!(ref self, ERC721Mintable);
            let caller = get_caller_address();
            erc721_mintable.mint(caller, id)
        }

        fn change_url(self: @ComponentState<TContractState>, id: u256, url: felt252) {
            self.set_url(id, url)
        }

        fn initialize(
            ref self: ComponentState<TContractState>, name: felt252, symbol: felt252, base_uri: felt252
        ) {
            let mut erc721_metadata = get_dep_component_mut!(ref self, ERC721Metadata);
            erc721_metadata.initialize(name, symbol, base_uri)
        }
    }

    #[embeddable_as(ClientRegistrationCamelImpl)]
    impl ClientRegistrationCamel<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        impl ERC721Mintable: erc721_mintable_comp::HasComponent<TContractState>,
        +Drop<TContractState>,
    > of IClientRegistrationCamel<ComponentState<TContractState>> {
        fn changeUrl(self: @ComponentState<TContractState>, id: u256, url: felt252) {
            self.set_url(id, url)
        }
    }

    #[generate_trait]
    impl InternalImpl<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        impl ERC721Mintable: erc721_mintable_comp::HasComponent<TContractState>,
        +Drop<TContractState>
    > of InternalTrait<TContractState> {
        fn get_client(self: @ComponentState<TContractState>, id: u256) -> ClientRegistrationModel {
            get!(self.get_contract().world(), id.low, (ClientRegistrationModel))
        }

        fn set_client(self: @ComponentState<TContractState>, id: u256, game_id: u256, name: felt252, url: felt252) {
            set!(
                self.get_contract().world(),
                ClientRegistrationModel {
                    id: id.low, game_id: game_id.low, name, url
                }
            )
        }

        fn set_url(self: @ComponentState<TContractState>, id: u256, url: felt252) {
            let client_meta = self.get_client(id);
            set!(
                self.get_contract().world(),
                ClientRegistrationModel {
                    id: client_meta.id, game_id: client_meta.game_id, name: client_meta.name, url
                }
            )
        }
    }

}