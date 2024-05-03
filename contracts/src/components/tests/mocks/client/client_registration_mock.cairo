use starknet::{ContractAddress, ClassHash};
use dojo::world::IWorldDispatcher;

#[starknet::interface]
trait IClientManager<TState> {
    // IERC721
    fn owner_of(self: @TState, account: ContractAddress) -> bool;
    fn balance_of(self: @TState, account: ContractAddress) -> u256;
    fn get_approved(self: @TState, token_id: u128) -> ContractAddress;
    fn transfer_from(ref self: TState, from: ContractAddress, to: ContractAddress, token_id: u128);
    fn approve(ref self: TState, to: ContractAddress, token_id: u128);

    // IERC721CamelOnly
    fn balanceOf(self: @TState, account: ContractAddress) -> u256;
    fn transferFrom(ref self: TState, from: ContractAddress, to: ContractAddress, token_id: u128);

    // IClient
    fn register_developer(ref self: TState, id: u256, game_id: u256, name: felt252, url: felt252);
    fn register_client(ref self: TState, id: u256, game_id: u256, name: felt252, url: felt252);
    fn change_github_username(self: @TState, id: u256, username: felt252);
    fn change_telegram_handle(self: @TState, id: u256, handle: felt252);
    fn change_x_handle(self: @TState, id: u256, handle: felt252);
    fn change_url(self: @TState, id: u256, url: felt252);
    fn get_rating_total(self: @TState, id: u256) -> u8;
    fn get_rating_player(self: @TState, id: u256, player_address: ContractAddress) -> u8;
    fn rate(self: @TState, id: u256, rating: u8);
    fn get_play_count_total(self: @TState, id: u256) -> u256;
    fn get_play_count_player(self: @TState, id: u256, player_address: ContractAddress) -> u256;
    fn play(self: @TState, id: u256);

    // IClientCamelOnly
    fn registerDeveloper(ref self: TState, id: u256, game_id: u256, name: felt252, url: felt252);
    fn registerClient(ref self: TState, id: u256, game_id: u256, name: felt252, url: felt252);
    fn changeGithubUsername(self: @TState, id: u256, username: felt252);
    fn changeTelegramHandle(self: @TState, id: u256, handle: felt252);
    fn changeXHandle(self: @TState, id: u256, handle: felt252);
    fn changeUrl(self: @TState, id: u256, url: felt252);
    fn getRatingTotal(self: @TState, id: u256) -> u8;
    fn getRatingPlayer(self: @TState, id: u256, player_address: ContractAddress) -> u8;
    fn getPlayCountTotal(self: @TState, id: u256) -> u256;
    fn getPlayCountPlayer(self: @TState, id: u256, player_address: ContractAddress) -> u256;


    // IWorldProvider
    fn world(self: @TState,) -> IWorldDispatcher;

    fn initializer(ref self: TState, recipient: ContractAddress, token_id: u128);
}

#[starknet::interface]
trait IClientManagerMockInit<TState> {
    fn initializer(ref self: TState, name: felt252, symbol: felt252, base_uri: felt252);
}

#[dojo::contract(allow_ref_self)]
mod client_registration_mock {
    use starknet::ContractAddress;

    use ls::components::client::client_developer::client_developer_component;
    use ls::components::client::client_play::client_play_component;
    use ls::components::client::client_rating::client_rating_component;
    use ls::components::client::client_registration::client_registration_component;
    use ls::components::token::erc721::erc721_approval::erc721_approval_component;
    use ls::components::token::erc721::erc721_balance::erc721_balance_component;
    use ls::components::token::erc721::erc721_enumerable::erc721_enumerable_component;
    use ls::components::token::erc721::erc721_metadata::erc721_metadata_component;
    use ls::components::token::erc721::erc721_mintable::erc721_mintable_component;
    use ls::components::token::erc721::erc721_owner::erc721_owner_component;

    component!(
        path: client_developer_component, storage: client_developer, event: ClientDeveloperEvent
    );
    component!(path: client_play_component, storage: client_play, event: ClientPlayEvent);
    component!(path: client_rating_component, storage: client_rating, event: ClientRatingEvent);
    component!(
        path: client_registration_component,
        storage: client_registration,
        event: ClientRegistrationEvent
    );
    component!(
        path: erc721_approval_component, storage: erc721_approval, event: ERC721ApprovalEvent
    );
    component!(path: erc721_balance_component, storage: erc721_balance, event: ERC721BalanceEvent);
    component!(
        path: erc721_enumerable_component, storage: erc721_enumerable, event: ERC721EnumerableEvent
    );
    component!(
        path: erc721_metadata_component, storage: erc721_metadata, event: ERC721MetadataEvent
    );
    component!(
        path: erc721_mintable_component, storage: erc721_mintable, event: ERC721MintableEvent
    );
    component!(path: erc721_owner_component, storage: erc721_owner, event: ERC721OwnerEvent);

    #[abi(embed_v0)]
    impl ClientDeveloperImpl =
        client_developer_component::ClientDeveloperImpl<ContractState>;

    #[abi(embed_v0)]
    impl ClientDeveloperCamelImpl =
        client_developer_component::ClientDeveloperCamelImpl<ContractState>;

    #[abi(embed_v0)]
    impl ClientPlayImpl = client_play_component::ClientPlayImpl<ContractState>;

    #[abi(embed_v0)]
    impl ClientPlayCamelImpl =
        client_play_component::ClientPlayCamelImpl<ContractState>;

    #[abi(embed_v0)]
    impl ClientRatingImpl =
        client_rating_component::ClientRatingImpl<ContractState>;

    #[abi(embed_v0)]
    impl ClientRatingCamelImpl =
        client_rating_component::ClientRatingCamelImpl<ContractState>;

    #[abi(embed_v0)]
    impl ClientRegistrationImpl =
        client_registration_component::ClientRegistrationImpl<ContractState>;

    #[abi(embed_v0)]
    impl ClientRegistrationCamelImpl =
        client_registration_component::ClientRegistrationCamelImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721ApprovalImpl =
        erc721_approval_component::ERC721ApprovalImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721ApprovalCamelImpl =
        erc721_approval_component::ERC721ApprovalCamelImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721BalanceImpl =
        erc721_balance_component::ERC721BalanceImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721BalanceCamelImpl =
        erc721_balance_component::ERC721BalanceCamelImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721EnumerableImpl =
        erc721_enumerable_component::ERC721EnumerableImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721EnumerableCamelImpl =
        erc721_enumerable_component::ERC721EnumerableCamelImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721MetadataImpl =
        erc721_metadata_component::ERC721MetadataImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721OwnerImpl = erc721_owner_component::ERC721OwnerImpl<ContractState>;

    impl ClientDeveloperInternalImpl = client_developer_component::InternalImpl<ContractState>;
    impl ClientPlayInternalImpl = client_play_component::InternalImpl<ContractState>;
    impl ClientRatingInternalImpl = client_rating_component::InternalImpl<ContractState>;
    impl ClientRegistrationInternalImpl =
        client_registration_component::InternalImpl<ContractState>;
    impl ERC721ApprovalInternalImpl = erc721_approval_component::InternalImpl<ContractState>;
    impl ERC721BalanceInternalImpl = erc721_balance_component::InternalImpl<ContractState>;
    impl ERC721EnumerableInternalImpl = erc721_enumerable_component::InternalImpl<ContractState>;
    impl ERC721MetadataInternalImpl = erc721_metadata_component::InternalImpl<ContractState>;
    impl ERC721MintableInternalImpl = erc721_mintable_component::InternalImpl<ContractState>;
    impl ERC721OwnerInternalImpl = erc721_owner_component::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        client_developer: client_developer_component::Storage,
        #[substorage(v0)]
        client_play: client_play_component::Storage,
        #[substorage(v0)]
        client_rating: client_rating_component::Storage,
        #[substorage(v0)]
        client_registration: client_registration_component::Storage,
        #[substorage(v0)]
        erc721_approval: erc721_approval_component::Storage,
        #[substorage(v0)]
        erc721_balance: erc721_balance_component::Storage,
        #[substorage(v0)]
        erc721_enumerable: erc721_enumerable_component::Storage,
        #[substorage(v0)]
        erc721_metadata: erc721_metadata_component::Storage,
        #[substorage(v0)]
        erc721_mintable: erc721_mintable_component::Storage,
        #[substorage(v0)]
        erc721_owner: erc721_owner_component::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        ClientDeveloperEvent: client_developer_component::Event,
        ClientPlayEvent: client_play_component::Event,
        ClientRatingEvent: client_rating_component::Event,
        ClientRegistrationEvent: client_registration_component::Event,
        ERC721ApprovalEvent: erc721_approval_component::Event,
        ERC721BalanceEvent: erc721_balance_component::Event,
        ERC721EnumerableEvent: erc721_enumerable_component::Event,
        ERC721MetadataEvent: erc721_metadata_component::Event,
        ERC721MintableEvent: erc721_mintable_component::Event,
        ERC721OwnerEvent: erc721_owner_component::Event,
    }


    #[abi(embed_v0)]
    impl InitializerImpl of super::IClientManagerMockInit<ContractState> {
        fn initializer(ref self: ContractState, name: felt252, symbol: felt252, base_uri: felt252) {
            // mint to recipient
            self.erc721_metadata.initialize(name, symbol, base_uri);
        }
    }
}
