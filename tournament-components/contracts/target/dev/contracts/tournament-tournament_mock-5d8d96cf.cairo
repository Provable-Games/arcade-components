#[starknet::contract]
pub mod tournament_mock {
    use dojo::world;
    use dojo::world::IWorldDispatcher;
    use dojo::world::IWorldDispatcherTrait;
    use dojo::world::IWorldProvider;
    use dojo::contract::IContract;
    use starknet::storage::{
        StorageMapReadAccess, StorageMapWriteAccess, StoragePointerReadAccess,
        StoragePointerWriteAccess
    };

    component!(
        path: dojo::contract::upgradeable::upgradeable,
        storage: upgradeable,
        event: UpgradeableEvent
    );

    #[abi(embed_v0)]
    pub impl ContractImpl of IContract<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            "tournament_mock"
        }

        fn namespace(self: @ContractState) -> ByteArray {
            "tournament"
        }

        fn tag(self: @ContractState) -> ByteArray {
            "tournament-tournament_mock"
        }

        fn name_hash(self: @ContractState) -> felt252 {
            2866322938388476513537735525891369857413953479700384383286838645946262102336
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            3513465382457774401660929656863894979351645367198604050918895380273858322651
        }

        fn selector(self: @ContractState) -> felt252 {
            2644703826068304615306121590256198745281393713258693943589855463811589480121
        }
    }

    #[abi(embed_v0)]
    impl WorldProviderImpl of IWorldProvider<ContractState> {
        fn world(self: @ContractState) -> IWorldDispatcher {
            self.world_dispatcher.read()
        }
    }

    #[abi(embed_v0)]
    impl UpgradableImpl =
        dojo::contract::upgradeable::upgradeable::UpgradableImpl<ContractState>;

    use starknet::{ContractAddress, get_caller_address};
    use tournament::ls15_components::tournament::tournament_component;

    component!(path: tournament_component, storage: tournament, event: TournamentEvent);

    #[abi(embed_v0)]
    impl TournamentImpl = tournament_component::TournamentImpl<ContractState>;

    impl TournamentInternalImpl = tournament_component::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        world_dispatcher: IWorldDispatcher,
        #[substorage(v0)]
        upgradeable: dojo::contract::upgradeable::upgradeable::Storage,
        #[substorage(v0)]
        tournament: tournament_component::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        UpgradeableEvent: dojo::contract::upgradeable::upgradeable::Event,
        TournamentEvent: tournament_component::Event
    }

    mod Errors {
        const CALLER_IS_NOT_OWNER: felt252 = 'Tournament: caller is not owner';
    }

    #[abi(embed_v0)]
    impl TournamentInitializerImpl of super::ITournamentMockInit<ContractState> {
        fn initializer(
            ref self: ContractState,
            eth_address: ContractAddress,
            lords_address: ContractAddress,
            loot_survivor_address: ContractAddress,
            oracle_address: ContractAddress
        ) {
            assert(
                self.world().is_owner(self.selector(), get_caller_address()),
                Errors::CALLER_IS_NOT_OWNER
            );
            self
                .tournament
                .initialize(eth_address, lords_address, loot_survivor_address, oracle_address);
        }
    }
    #[starknet::interface]
    pub trait IDojoInit<ContractState> {
        fn dojo_init(self: @ContractState);
    }

    #[abi(embed_v0)]
    pub impl IDojoInitImpl of IDojoInit<ContractState> {
        fn dojo_init(self: @ContractState) {
            if starknet::get_caller_address() != self.world().contract_address {
                core::panics::panic_with_byte_array(
                    @format!(
                        "Only the world can init contract `{}`, but caller is `{:?}`",
                        self.tag(),
                        starknet::get_caller_address(),
                    )
                );
            }
        }
    }
}

