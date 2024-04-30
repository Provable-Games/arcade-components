use starknet::ContractAddress;

///
/// Model
///

#[derive(Model, Copy, Drop, Serde)]
struct ClientRegistrationModel {
    #[key]
    client_id: u64,
    game_id: u64,
    name: felt252, // TODO: replace with ByteArray in new dojo version
    url: felt252, // TODO: replace with ByteArray in new dojo version
}

#[starknet::interface]
trait IClientRegistration<TState> {
    fn register_client(
        ref self: TState, client_id: u256, game_id: u256, name: felt252, url: felt252
    );
    fn change_url(self: @TState, client_id: u256, url: felt252);
}

#[starknet::interface]
trait IClientRegistrationCamel<TState> {
    fn registerClient(
        ref self: TState, client_id: u256, game_id: u256, name: felt252, url: felt252
    );
    fn changeUrl(self: @TState, client_id: u256, url: felt252);
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

    mod Errors {
        const NOT_DEVELOPER: felt252 = 'Client: Not developer';
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
        RegisterClient: RegisterClient,
        ChangeUrl: ChangeUrl,
    }

    #[derive(Copy, Drop, Serde, starknet::Event)]
    struct RegisterClient {
        client_id: u256,
        game_id: u256,
        name: felt252,
        url: felt252,
    }

    #[derive(Copy, Drop, Serde, starknet::Event)]
    struct ChangeUrl {
        client_id: u256,
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
        impl ERC721Owner: erc721_owner_comp::HasComponent<TContractState>,
        +Drop<TContractState>,
    > of IClientRegistration<ComponentState<TContractState>> {
        fn register_client(
            ref self: ComponentState<TContractState>, client_id: u256, game_id: u256, name: felt252, url: felt252
        ) {
            let mut erc721_balance = get_dep_component_mut!(ref self, ERC721Balance);
            assert(
                erc721_balance.get_balance(get_caller_address()).amount != 0,
                Errors::NOT_DEVELOPER
            );
            self.set_client(client_id, game_id, name, url);
        }

        fn change_url(self: @ComponentState<TContractState>, client_id: u256, url: felt252) {
            self.set_url(client_id, url)
        }
    }

    #[embeddable_as(ClientRegistrationCamelImpl)]
    impl ClientRegistrationCamel<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        +Drop<TContractState>,
    > of IClientRegistrationCamel<ComponentState<TContractState>> {
        fn registerClient(
            ref self: ComponentState<TContractState>, client_id: u256, game_id: u256, name: felt252, url: felt252
        ) {
            self.set_client(client_id, game_id, name, url);
        }

        fn changeUrl(self: @ComponentState<TContractState>, client_id: u256, url: felt252) {
            self.set_url(client_id, url)
        }
    }

    #[generate_trait]
    impl InternalImpl<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        +Drop<TContractState>
    > of InternalTrait<TContractState> {
        fn get_client(self: @ComponentState<TContractState>, client_id: u256) -> ClientRegistrationModel {
            get!(self.get_contract().world(), client_id.low, (ClientRegistrationModel))
        }

        fn set_client(ref self: ComponentState<TContractState>, client_id: u256, game_id: u256, name: felt252, url: felt252) {
            set!(
                self.get_contract().world(),
                ClientRegistrationModel {
                    client_id: client_id.low.try_into().unwrap(), game_id: game_id.low.try_into().unwrap(), name, url
                }
            );

            let register_client_event = RegisterClient { client_id, game_id, name, url };
            self.emit(register_client_event.clone());
            emit!(self.get_contract().world(), (Event::RegisterClient(register_client_event)));
        }

        fn set_url(self: @ComponentState<TContractState>, client_id: u256, url: felt252) {
            let client_meta = self.get_client(client_id);
            set!(
                self.get_contract().world(),
                ClientRegistrationModel {
                    client_id: client_meta.client_id, game_id: client_meta.game_id, name: client_meta.name, url
                }
            )
        }
    }

}