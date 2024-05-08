use starknet::ContractAddress;

///
/// Model
///

#[derive(Model, Copy, Drop, Serde)]
struct ClientCreatorModel {
    #[key]
    creator_id: u64,
    name: felt252, // TODO: replace with ByteArray in new dojo version
    github_username: felt252, // TODO: replace with ByteArray in new dojo version
    telegram_handle: felt252, // TODO: replace with ByteArray in new dojo version
    x_handle: felt252, // TODO: replace with ByteArray in new dojo version
    token_id: u128,
    // TODO: add some reputation metric
}

#[starknet::interface]
trait IClientCreator<TState> {
    fn register_creator(
        ref self: TState, name: felt252, github_username: felt252, telegram_handle: felt252, x_handle: felt252
    );
    fn get_creator(self: @TState, creator_id: u256) -> ClientCreatorModel;
    fn change_name(ref self: TState, creator_id: u256, name: felt252);
    fn change_github_username(ref self: TState, creator_id: u256, username: felt252);
    fn change_telegram_handle(ref self: TState, creator_id: u256, handle: felt252);
    fn change_x_handle(ref self: TState, creator_id: u256, handle: felt252);
    fn initialize(ref self: TState, name: felt252, symbol: felt252, base_uri: felt252);
}

#[starknet::interface]
trait IClientCreatorCamel<TState> {
    fn registerCreator(
        ref self: TState, name: felt252, githubUsername: felt252, telegramHandle: felt252, xHandle: felt252
    );
    fn getCreator(self: @TState, creator_id: u256) -> ClientCreatorModel;
    fn changeName(ref self: TState, creator_id: u256, name: felt252);
    fn changeGithubUsername(ref self: TState, creator_id: u256, username: felt252);
    fn changeTelegramHandle(ref self: TState, creator_id: u256, handle: felt252);
    fn changeXHandle(ref self: TState, creator_id: u256, handle: felt252);
}


///
/// ClientCreator Component
///
#[starknet::component]
mod client_creator_component {
    use super::ClientCreatorModel;
    use super::IClientCreator;
    use super::IClientCreatorCamel;
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
        const NOT_CREATOR: felt252 = 'Client: Not creator';
    }

    // Storage
    #[storage]
    struct Storage {}

    // Events
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        RegisterCreator: RegisterCreator,
    }

    #[derive(Copy, Drop, Serde, starknet::Event)]
    struct RegisterCreator {
        creator_id: u256,
        name: felt252,
        github_username: felt252,
        telegram_handle: felt252,
        x_handle: felt252,
        token_id: u256
    }

    #[embeddable_as(ClientCreatorImpl)]
    impl ClientCreator<
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
    > of IClientCreator<ComponentState<TContractState>> {
        fn register_creator(
            ref self: ComponentState<TContractState>,
            name: felt252,
            github_username: felt252,
            telegram_handle: felt252,
            x_handle: felt252
        ) {
            let mut erc721_enumerable = get_dep_component_mut!(ref self, ERC721Enumerable);
            let total_supply = erc721_enumerable.get_total_supply().total_supply.into();
            self.set_creator(total_supply, name, github_username, telegram_handle, x_handle, total_supply); // TODO: Make the creator id a separate supply track
            let mut erc721_mintable = get_dep_component_mut!(ref self, ERC721Mintable);
            let caller = get_caller_address();
            erc721_mintable.mint(caller, total_supply);
            erc721_enumerable.set_total_supply(total_supply + 1);
        }

        fn change_name(
            ref self: ComponentState<TContractState>, creator_id: u256, name: felt252
        ) {
            self.set_name(creator_id, name)
        }

        fn get_creator(self: @ComponentState<TContractState>, creator_id: u256) -> ClientCreatorModel {
            self.get_creator_internal(creator_id)
        }

        fn change_github_username(
            ref self: ComponentState<TContractState>, creator_id: u256, username: felt252
        ) {
            self.set_github_username(creator_id, username)
        }

        fn change_telegram_handle(
            ref self: ComponentState<TContractState>, creator_id: u256, handle: felt252
        ) {
            self.set_telegram_handle(creator_id, handle)
        }

        fn change_x_handle(ref self: ComponentState<TContractState>, creator_id: u256, handle: felt252) {
            self.set_x_handle(creator_id, handle)
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

    #[embeddable_as(ClientCreatorCamelImpl)]
    impl ClientCreatorCamel<
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
    > of IClientCreatorCamel<ComponentState<TContractState>> {
        fn registerCreator(
            ref self: ComponentState<TContractState>,
            name: felt252,
            githubUsername: felt252,
            telegramHandle: felt252,
            xHandle: felt252
        ) {
            self.register_creator(name, githubUsername, telegramHandle, xHandle)
        }

        fn getCreator(self: @ComponentState<TContractState>, creator_id: u256) -> ClientCreatorModel {
            self.get_creator(creator_id)
        }

        fn changeName(
            ref self: ComponentState<TContractState>, creator_id: u256, name: felt252
        ) {
            self.change_name(creator_id, name)
        }

        fn changeGithubUsername(
            ref self: ComponentState<TContractState>, creator_id: u256, username: felt252
        ) {
            self.set_github_username(creator_id, username)
        }

        fn changeTelegramHandle(
            ref self: ComponentState<TContractState>, creator_id: u256, handle: felt252
        ) {
            self.set_telegram_handle(creator_id, handle)
        }

        fn changeXHandle(ref self: ComponentState<TContractState>, creator_id: u256, handle: felt252) {
            self.set_x_handle(creator_id, handle)
        }
    }

    #[generate_trait]
    impl InternalImpl<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        impl ERC721Owner: erc721_owner_comp::HasComponent<TContractState>,
        +Drop<TContractState>
    > of InternalTrait<TContractState> {
        fn get_creator_internal(
            self: @ComponentState<TContractState>, creator_id: u256
        ) -> ClientCreatorModel {
            get!(self.get_contract().world(), creator_id.low, (ClientCreatorModel))
        }

        fn set_creator(
            ref self: ComponentState<TContractState>,
            creator_id: u256,
            name: felt252,
            github_username: felt252,
            telegram_handle: felt252,
            x_handle: felt252,
            token_id: u256
        ) {
            set!(
                self.get_contract().world(),
                ClientCreatorModel {
                    creator_id: creator_id.low.try_into().unwrap(), name, github_username, telegram_handle, x_handle, token_id: token_id.low
                }
            );

            let register_creator_event = RegisterCreator {
                creator_id, name, github_username, telegram_handle, x_handle, token_id
            };
            self.emit(register_creator_event.clone());
            emit!(
                self.get_contract().world(), (Event::RegisterCreator(register_creator_event))
            );
        }

        fn set_name(
            ref self: ComponentState<TContractState>, creator_id: u256, name: felt252
        ) {
            let mut creator_meta = self.get_creator_internal(creator_id);
            let caller = get_caller_address();
            let mut erc721_owner = get_dep_component_mut!(ref self, ERC721Owner);
            assert(
                erc721_owner.get_owner(creator_meta.token_id.into()).address == caller,
                Errors::NOT_CREATOR
            );
            creator_meta.name = name;
            
            set!(self.get_contract().world(), (creator_meta,));
        }


        fn set_github_username(
            ref self: ComponentState<TContractState>, creator_id: u256, username: felt252
        ) {
            let mut creator_meta = self.get_creator_internal(creator_id);
            let caller = get_caller_address();
            let mut erc721_owner = get_dep_component_mut!(ref self, ERC721Owner);
            assert(
                erc721_owner.get_owner(creator_meta.token_id.into()).address == caller,
                Errors::NOT_CREATOR
            );
            creator_meta.github_username = username;
            
            set!(self.get_contract().world(), (creator_meta,));
        }

        fn set_telegram_handle(
            ref self: ComponentState<TContractState>, creator_id: u256, handle: felt252
        ) {
            let mut creator_meta = self.get_creator_internal(creator_id);
            let caller = get_caller_address();
            let mut erc721_owner = get_dep_component_mut!(ref self, ERC721Owner);
            assert(
                erc721_owner.get_owner(creator_meta.token_id.into()).address == caller,
                Errors::NOT_CREATOR
            );
            creator_meta.telegram_handle = handle;
            
            set!(self.get_contract().world(), (creator_meta,));
        }

        fn set_x_handle(ref self: ComponentState<TContractState>, creator_id: u256, handle: felt252) {
            let mut creator_meta = self.get_creator_internal(creator_id);
            let caller = get_caller_address();
            let mut erc721_owner = get_dep_component_mut!(ref self, ERC721Owner);
            assert(
                erc721_owner.get_owner(creator_meta.token_id.into()).address == caller,
                Errors::NOT_CREATOR
            );
            creator_meta.x_handle = handle;
            
            set!(self.get_contract().world(), (creator_meta,));
        }
    }
}
