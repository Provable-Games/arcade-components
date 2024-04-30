#[dojo::contract]
mod client_play_mock {
    use ls::components::client::client_play::client_play_component;

    component!(
        path: client_play_component, storage: client_play, event: ClientPlayEvent
    );

    #[abi(embed_v0)]
    impl ClientPlayImpl =
        client_play_component::ClientPlayImpl<ContractState>;

    impl ClientPlayInternalImpl = client_play_component::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        client_play: client_play_component::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        ClientPlayEvent: client_play_component::Event,
    }
}
