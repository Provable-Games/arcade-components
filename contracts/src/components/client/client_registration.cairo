use starknet::ContractAddress;

///
/// Model
///

#[derive(Model, Copy, Drop, Serde)]
struct ClientRegistrationModel {
    #[key]
    client_id: u64,
    developer_id: u64,
    game_id: u64,
    name: felt252, // TODO: replace with ByteArray in new dojo version
    url: felt252, // TODO: replace with ByteArray in new dojo version
}

#[derive(Model, Copy, Drop, Serde)]
struct ClientTotalModel {
    #[key]
    contract: ContractAddress,
    total_clients: u128,
}

#[starknet::interface]
trait IClientRegistration<TState> {
    fn get_client_game(self: @TState, client_id: u256) -> u256;
    fn get_client_name(
        self: @TState, client_id: u256
    ) -> felt252; // TODO: replace with ByteArray in new dojo version
    fn get_client_url(
        self: @TState, client_id: u256
    ) -> felt252; // TODO: replace with ByteArray in new dojo version
    fn total_clients(self: @TState) -> u256;
    fn register_client(
        ref self: TState, developer_id: u256, game_id: u256, name: felt252, url: felt252
    );
    fn change_url(self: @TState, client_id: u256, url: felt252);
}

#[starknet::interface]
trait IClientRegistrationCamel<TState> {
    fn getClientGame(self: @TState, client_id: u256) -> u256;
    fn getClientName(
        self: @TState, client_id: u256
    ) -> felt252; // TODO: replace with ByteArray in new dojo version
    fn getClientUrl(
        self: @TState, client_id: u256
    ) -> felt252; // TODO: replace with ByteArray in new dojo version
    fn totalClients(self: @TState) -> u256;
    fn registerClient(
        ref self: TState, developer_id: u256, game_id: u256, name: felt252, url: felt252
    );
    fn changeUrl(self: @TState, client_id: u256, url: felt252);
}


///
/// ClientRegistration Component
///
#[starknet::component]
mod client_registration_component {
    use super::ClientRegistrationModel;
    use super::ClientTotalModel;
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
    use ls::components::token::erc721::erc721_owner::erc721_owner_component as erc721_owner_comp;

    use erc721_approval_comp::InternalImpl as ERC721ApprovalInternal;
    use erc721_balance_comp::InternalImpl as ERC721BalanceInternal;
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
    }

    #[derive(Copy, Drop, Serde, starknet::Event)]
    struct RegisterClient {
        client_id: u256,
        developer_id: u256,
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
        fn get_client_game(self: @ComponentState<TContractState>, client_id: u256) -> u256 {
            self.get_client_internal(client_id).game_id.into()
        }

        fn get_client_name(self: @ComponentState<TContractState>, client_id: u256) -> felt252 {
            self.get_client_internal(client_id).name
        }

        fn get_client_url(self: @ComponentState<TContractState>, client_id: u256) -> felt252 {
            self.get_client_internal(client_id).url
        }

        fn total_clients(self: @ComponentState<TContractState>) -> u256 {
            self.get_total_clients().total_clients.into()
        }

        fn register_client(
            ref self: ComponentState<TContractState>,
            developer_id: u256,
            game_id: u256,
            name: felt252,
            url: felt252
        ) {
            let mut erc721_owner = get_dep_component_mut!(ref self, ERC721Owner);
            let caller = get_caller_address();
            let total_clients = self.get_total_clients().total_clients.into();
            assert(erc721_owner.get_owner(developer_id).address == caller, Errors::NOT_DEVELOPER);
            self.set_client(total_clients, developer_id, game_id, name, url);
            self.set_total_clients(total_clients + 1);
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
        impl ERC721Approval: erc721_approval_comp::HasComponent<TContractState>,
        impl ERC721Balance: erc721_balance_comp::HasComponent<TContractState>,
        impl ERC721Owner: erc721_owner_comp::HasComponent<TContractState>,
        +Drop<TContractState>,
    > of IClientRegistrationCamel<ComponentState<TContractState>> {
        fn getClientGame(self: @ComponentState<TContractState>, client_id: u256) -> u256 {
            self.get_client_game(client_id)
        }

        fn getClientName(self: @ComponentState<TContractState>, client_id: u256) -> felt252 {
            self.get_client_name(client_id)
        }

        fn getClientUrl(self: @ComponentState<TContractState>, client_id: u256) -> felt252 {
            self.get_client_url(client_id)
        }

        fn totalClients(self: @ComponentState<TContractState>) -> u256 {
            self.total_clients()
        }

        fn registerClient(
            ref self: ComponentState<TContractState>,
            developer_id: u256,
            game_id: u256,
            name: felt252,
            url: felt252
        ) {
            self.register_client(developer_id, game_id, name, url);
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
        fn get_client_internal(
            self: @ComponentState<TContractState>, client_id: u256
        ) -> ClientRegistrationModel {
            get!(self.get_contract().world(), client_id.low, (ClientRegistrationModel))
        }

        fn get_total_clients(self: @ComponentState<TContractState>,) -> ClientTotalModel {
            get!(self.get_contract().world(), get_contract_address(), (ClientTotalModel))
        }

        fn set_client(
            ref self: ComponentState<TContractState>,
            client_id: u256,
            developer_id: u256,
            game_id: u256,
            name: felt252,
            url: felt252
        ) {
            set!(
                self.get_contract().world(),
                ClientRegistrationModel {
                    client_id: client_id.low.try_into().unwrap(),
                    developer_id: developer_id.low.try_into().unwrap(),
                    game_id: game_id.low.try_into().unwrap(),
                    name,
                    url
                }
            );

            let register_client_event = RegisterClient {
                client_id, developer_id, game_id, name, url
            };
            self.emit(register_client_event.clone());
            emit!(self.get_contract().world(), (Event::RegisterClient(register_client_event)));
        }

        fn set_total_clients(self: @ComponentState<TContractState>, total_clients: u256) {
            set!(
                self.get_contract().world(),
                ClientTotalModel {
                    contract: get_contract_address(), total_clients: total_clients.low
                }
            )
        }

        fn set_url(self: @ComponentState<TContractState>, client_id: u256, url: felt252) {
            let client_meta = self.get_client_internal(client_id);
            set!(
                self.get_contract().world(),
                ClientRegistrationModel {
                    client_id: client_meta.client_id,
                    developer_id: client_meta.developer_id,
                    game_id: client_meta.game_id,
                    name: client_meta.name,
                    url
                }
            )
        }
    }
}
