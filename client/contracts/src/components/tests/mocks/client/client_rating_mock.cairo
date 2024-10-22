#[dojo::contract]
mod client_rating_mock {
    use ls::components::client::client_play::client_play_component;
    use ls::components::client::client_rating::client_rating_component;

    component!(path: client_play_component, storage: client_play, event: ClientPlayEvent);
    component!(path: client_rating_component, storage: client_rating, event: ClientRatingEvent);

    #[abi(embed_v0)]
    impl ClientPlayImpl = client_play_component::ClientPlayImpl<ContractState>;

    #[abi(embed_v0)]
    impl ClientRatingImpl =
        client_rating_component::ClientRatingImpl<ContractState>;

    impl ClientPlayInternalImpl = client_play_component::InternalImpl<ContractState>;
    impl ClientRatingInternalImpl = client_rating_component::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        client_play: client_play_component::Storage,
        #[substorage(v0)]
        client_rating: client_rating_component::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        ClientPlayEvent: client_play_component::Event,
        ClientRatingEvent: client_rating_component::Event,
    }
}
