use starknet::{ContractAddress, ClassHash};
use dojo::world::IWorldDispatcher;

#[starknet::interface]
trait ITournament<TState> {
    // IERC721
    fn name(self: @TState) -> felt252;


    // IWorldProvider
    fn world(self: @TState,) -> IWorldDispatcher;

    fn initializer(ref self: TState, name: felt252, symbol: felt252, base_uri: felt252);
}

#[starknet::interface]
trait ITournamentInit<TState> {
    fn initializer(ref self: TState, name: felt252, symbol: felt252, base_uri: felt252);
}

#[dojo::contract(allow_ref_self)]
mod Tournament {
    use starknet::ContractAddress;

    use ls::components::client::client_creator::client_creator_component;
    use ls::components::client::client_play::client_play_component;
    use ls::components::client::client_rating::client_rating_component;
    use ls::components::client::client_registration::client_registration_component;
    use ls::components::token::erc721::erc721_approval::erc721_approval_component;
    use ls::components::token::erc721::erc721_balance::erc721_balance_component;
    use ls::components::token::erc721::erc721_enumerable::erc721_enumerable_component;
    use ls::components::token::erc721::erc721_metadata::erc721_metadata_component;
    use ls::components::token::erc721::erc721_mintable::erc721_mintable_component;
    use ls::components::token::erc721::erc721_owner::erc721_owner_component;

    component!(path: client_creator_component, storage: client_creator, event: ClientCreatorEvent);
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
    impl ClientCreatorImpl =
        client_creator_component::ClientCreatorImpl<ContractState>;

    #[abi(embed_v0)]
    impl ClientCreatorCamelImpl =
        client_creator_component::ClientCreatorCamelImpl<ContractState>;

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

    impl ClientCreatorInternalImpl = client_creator_component::InternalImpl<ContractState>;
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
        client_creator: client_creator_component::Storage,
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
        ClientCreatorEvent: client_creator_component::Event,
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
    impl InitializerImpl of super::IClientManagerInit<ContractState> {
        fn initializer(ref self: ContractState, name: felt252, symbol: felt252, base_uri: felt252) {
            // initialize metadata
            self.erc721_metadata.initialize(name, symbol, base_uri);
        }
    }
}
