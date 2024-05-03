use starknet::ContractAddress;

///
/// Model
///

#[derive(Model, Copy, Drop, Serde)]
struct ClientDeveloperModel {
    #[key]
    id: u64,
    github_username: felt252, // TODO: replace with ByteArray in new dojo version
    telegram_handle: felt252, // TODO: replace with ByteArray in new dojo version
    x_handle: felt252, // TODO: replace with ByteArray in new dojo version
}

#[starknet::interface]
trait IClientDeveloper<TState> {
    fn register_developer(
        ref self: TState, github_username: felt252, telegram_handle: felt252, x_handle: felt252
    );
    fn get_developer(self: @TState, id: u256) -> ClientDeveloperModel;
    fn change_github_username(ref self: TState, id: u256, username: felt252);
    fn change_telegram_handle(ref self: TState, id: u256, handle: felt252);
    fn change_x_handle(ref self: TState, id: u256, handle: felt252);
    fn initialize(ref self: TState, name: felt252, symbol: felt252, base_uri: felt252);
}

#[starknet::interface]
trait IClientDeveloperCamel<TState> {
    fn registerDeveloper(
        ref self: TState, github_username: felt252, telegram_handle: felt252, x_handle: felt252
    );
    fn getDeveloper(self: @TState, id: u256) -> ClientDeveloperModel;
    fn changeGithubUsername(ref self: TState, id: u256, username: felt252);
    fn changeTelegramHandle(ref self: TState, id: u256, handle: felt252);
    fn changeXHandle(ref self: TState, id: u256, handle: felt252);
}


///
/// ClientRegistration Component
///
#[starknet::component]
mod client_developer_component {
    use super::ClientDeveloperModel;
    use super::IClientDeveloper;
    use super::IClientDeveloperCamel;
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
    use ls::components::token::erc721::erc721_enumerable::erc721_enumerable_component as erc721_enumerable_comp;
    use ls::components::token::erc721::erc721_metadata::erc721_metadata_component as erc721_metadata_comp;
    use ls::components::token::erc721::erc721_mintable::erc721_mintable_component as erc721_mintable_comp;
    use ls::components::token::erc721::erc721_burnable::erc721_burnable_component as erc721_burnable_comp;
    use ls::components::token::erc721::erc721_owner::erc721_owner_component as erc721_owner_comp;

    use erc721_approval_comp::InternalImpl as ERC721ApprovalInternal;
    use erc721_balance_comp::InternalImpl as ERC721BalanceInternal;
    use erc721_enumerable_comp::InternalImpl as ERC721EnumerableInternal;
    use erc721_metadata_comp::InternalImpl as ERC721MetadataInternal;
    use erc721_mintable_comp::InternalImpl as ERC721MintableInternal;
    use erc721_owner_comp::InternalImpl as ERC721OwnerInternal;

    mod Errors {
        const DEVELOPER_ALREADY_REGISTERED: felt252 = 'Client: Developer registered';
    }

    // Storage
    #[storage]
    struct Storage {}

    // Events
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        RegisterDeveloper: RegisterDeveloper,
    }

    #[derive(Copy, Drop, Serde, starknet::Event)]
    struct RegisterDeveloper {
        id: u256,
        github_username: felt252,
        telegram_handle: felt252,
        x_handle: felt252
    }

    #[embeddable_as(ClientDeveloperImpl)]
    impl ClientDeveloper<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        impl ERC721Approval: erc721_approval_comp::HasComponent<TContractState>,
        impl ERC721Balance: erc721_balance_comp::HasComponent<TContractState>,
        impl ERC721Enumerable: erc721_enumerable_comp::HasComponent<TContractState>,
        impl ERC721Metadata: erc721_metadata_comp::HasComponent<TContractState>,
        impl ERC721Mintable: erc721_mintable_comp::HasComponent<TContractState>,
        impl ERC721Owner: erc721_owner_comp::HasComponent<TContractState>,
        +Drop<TContractState>,
    > of IClientDeveloper<ComponentState<TContractState>> {
        fn register_developer(
            ref self: ComponentState<TContractState>,
            github_username: felt252,
            telegram_handle: felt252,
            x_handle: felt252
        ) {
            let mut erc721_balance = get_dep_component_mut!(ref self, ERC721Balance);
            let mut erc721_enumerable = get_dep_component_mut!(ref self, ERC721Enumerable);
            let total_supply = erc721_enumerable.get_total_supply().total_supply.into();
            assert(
                erc721_balance.get_balance(get_caller_address()).amount == 0,
                Errors::DEVELOPER_ALREADY_REGISTERED
            );
            self.set_developer(total_supply, github_username, telegram_handle, x_handle);
            let mut erc721_mintable = get_dep_component_mut!(ref self, ERC721Mintable);
            let caller = get_caller_address();
            erc721_mintable.mint(caller, total_supply);
            erc721_enumerable.set_total_supply(total_supply + 1);
        }

        fn get_developer(self: @ComponentState<TContractState>, id: u256) -> ClientDeveloperModel {
            self.get_developer_internal(id)
        }

        fn change_github_username(
            ref self: ComponentState<TContractState>, id: u256, username: felt252
        ) {
            self.set_github_username(id, username)
        }

        fn change_telegram_handle(
            ref self: ComponentState<TContractState>, id: u256, handle: felt252
        ) {
            self.set_telegram_handle(id, handle)
        }

        fn change_x_handle(ref self: ComponentState<TContractState>, id: u256, handle: felt252) {
            self.set_x_handle(id, handle)
        }

        fn initialize(
            ref self: ComponentState<TContractState>,
            name: felt252,
            symbol: felt252,
            base_uri: felt252
        ) {
            let mut erc721_metadata = get_dep_component_mut!(ref self, ERC721Metadata);
            erc721_metadata.initialize(name, symbol, base_uri)
        }
    }

    #[embeddable_as(ClientDeveloperCamelImpl)]
    impl ClientDeveloperCamel<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        impl ERC721Approval: erc721_approval_comp::HasComponent<TContractState>,
        impl ERC721Balance: erc721_balance_comp::HasComponent<TContractState>,
        impl ERC721Enumerable: erc721_enumerable_comp::HasComponent<TContractState>,
        impl ERC721Metadata: erc721_metadata_comp::HasComponent<TContractState>,
        impl ERC721Mintable: erc721_mintable_comp::HasComponent<TContractState>,
        impl ERC721Owner: erc721_owner_comp::HasComponent<TContractState>,
        +Drop<TContractState>,
    > of IClientDeveloperCamel<ComponentState<TContractState>> {
        fn registerDeveloper(
            ref self: ComponentState<TContractState>,
            github_username: felt252,
            telegram_handle: felt252,
            x_handle: felt252
        ) {
            self.register_developer(github_username, telegram_handle, x_handle)
        }

        fn getDeveloper(self: @ComponentState<TContractState>, id: u256) -> ClientDeveloperModel {
            self.get_developer(id)
        }

        fn changeGithubUsername(
            ref self: ComponentState<TContractState>, id: u256, username: felt252
        ) {
            self.set_github_username(id, username)
        }

        fn changeTelegramHandle(
            ref self: ComponentState<TContractState>, id: u256, handle: felt252
        ) {
            self.set_telegram_handle(id, handle)
        }

        fn changeXHandle(ref self: ComponentState<TContractState>, id: u256, handle: felt252) {
            self.set_x_handle(id, handle)
        }
    }

    #[generate_trait]
    impl InternalImpl<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        // impl ERC721Mintable: erc721_mintable_comp::HasComponent<TContractState>,
        +Drop<TContractState>
    > of InternalTrait<TContractState> {
        fn get_developer_internal(
            self: @ComponentState<TContractState>, id: u256
        ) -> ClientDeveloperModel {
            get!(self.get_contract().world(), id.low, (ClientDeveloperModel))
        }

        fn set_developer(
            ref self: ComponentState<TContractState>,
            id: u256,
            github_username: felt252,
            telegram_handle: felt252,
            x_handle: felt252
        ) {
            set!(
                self.get_contract().world(),
                ClientDeveloperModel {
                    id: id.low.try_into().unwrap(), github_username, telegram_handle, x_handle
                }
            );

            let register_developer_event = RegisterDeveloper {
                id, github_username, telegram_handle, x_handle
            };
            self.emit(register_developer_event.clone());
            emit!(
                self.get_contract().world(), (Event::RegisterDeveloper(register_developer_event))
            );
        }

        fn set_github_username(
            ref self: ComponentState<TContractState>, id: u256, username: felt252
        ) {
            let developer_meta = self.get_developer_internal(id);
            set!(
                self.get_contract().world(),
                ClientDeveloperModel {
                    id: developer_meta.id,
                    github_username: username,
                    telegram_handle: developer_meta.telegram_handle,
                    x_handle: developer_meta.x_handle
                }
            );
        }

        fn set_telegram_handle(
            ref self: ComponentState<TContractState>, id: u256, handle: felt252
        ) {
            let developer_meta = self.get_developer_internal(id);
            set!(
                self.get_contract().world(),
                ClientDeveloperModel {
                    id: developer_meta.id,
                    github_username: developer_meta.github_username,
                    telegram_handle: handle,
                    x_handle: developer_meta.x_handle
                }
            );
        }

        fn set_x_handle(ref self: ComponentState<TContractState>, id: u256, handle: felt252) {
            let developer_meta = self.get_developer_internal(id);
            set!(
                self.get_contract().world(),
                ClientDeveloperModel {
                    id: developer_meta.id,
                    github_username: developer_meta.github_username,
                    telegram_handle: developer_meta.telegram_handle,
                    x_handle: handle
                }
            );
        }
    }
}
