#[starknet::contract]
pub mod loot_survivor_mock {
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
            "loot_survivor_mock"
        }

        fn namespace(self: @ContractState) -> ByteArray {
            "tournament"
        }

        fn tag(self: @ContractState) -> ByteArray {
            "tournament-loot_survivor_mock"
        }

        fn name_hash(self: @ContractState) -> felt252 {
            975688464256550969326686590170189677665352327237533840718004208044728327730
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            3513465382457774401660929656863894979351645367198604050918895380273858322651
        }

        fn selector(self: @ContractState) -> felt252 {
            1468083568895391355455036170184518457338604784610921149014120162133322444843
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

    use adventurer::{
        adventurer::{Adventurer, ImplAdventurer},
        adventurer_meta::{AdventurerMetadata, ImplAdventurerMetadata}, bag::Bag
    };
    use starknet::{ContractAddress, get_caller_address};

    use tournament::ls15_components::loot_survivor::loot_survivor_component;
    use openzeppelin_introspection::src5::SRC5Component;
    use openzeppelin_token::erc721::{ERC721Component, ERC721HooksEmptyImpl};

    component!(path: loot_survivor_component, storage: loot_survivor, event: LootSurvivorEvent);
    component!(path: SRC5Component, storage: src5, event: SRC5Event);
    component!(path: ERC721Component, storage: erc721, event: ERC721Event);

    #[abi(embed_v0)]
    impl LootSurvivorImpl =
        loot_survivor_component::LootSurvivorImpl<ContractState>;
    #[abi(embed_v0)]
    impl ERC721MixinImpl = ERC721Component::ERC721MixinImpl<ContractState>;

    impl LootSurvivorInternalImpl = loot_survivor_component::InternalImpl<ContractState>;
    impl ERC721InternalImpl = ERC721Component::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        world_dispatcher: IWorldDispatcher,
        #[substorage(v0)]
        upgradeable: dojo::contract::upgradeable::upgradeable::Storage,
        #[substorage(v0)]
        loot_survivor: loot_survivor_component::Storage,
        #[substorage(v0)]
        erc721: ERC721Component::Storage,
        #[substorage(v0)]
        src5: SRC5Component::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        UpgradeableEvent: dojo::contract::upgradeable::upgradeable::Event,
        #[flat]
        LootSurvivorEvent: loot_survivor_component::Event,
        #[flat]
        SRC5Event: SRC5Component::Event,
        #[flat]
        ERC721Event: ERC721Component::Event
    }

    mod Errors {
        const CALLER_IS_NOT_OWNER: felt252 = 'ERC721: caller is not owner';
    }

    //*******************************
    fn TOKEN_NAME() -> ByteArray {
        ("Loot Survivor")
    }
    fn TOKEN_SYMBOL() -> ByteArray {
        ("LSVR")
    }
    fn BASE_URI() -> ByteArray {
        ("https://lootsurvivor.io")
    }
    //*******************************

    #[abi(embed_v0)]
    impl LootSurvivorInitializerImpl of super::ILootSurvivorMockInit<ContractState> {
        fn initializer(
            ref self: ContractState,
            name: ByteArray,
            symbol: ByteArray,
            base_uri: ByteArray,
            eth_address: ContractAddress,
            lords_address: ContractAddress,
            pragma_address: ContractAddress
        ) {
            assert(
                self.world().is_owner(self.selector(), get_caller_address()),
                Errors::CALLER_IS_NOT_OWNER
            );

            self.erc721.initializer(TOKEN_NAME(), TOKEN_SYMBOL(), BASE_URI(),);
            self.loot_survivor.initialize(eth_address, lords_address, pragma_address);
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

