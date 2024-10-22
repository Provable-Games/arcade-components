#[starknet::contract]
pub mod erc1155_mock {
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
            "erc1155_mock"
        }

        fn namespace(self: @ContractState) -> ByteArray {
            "tournament"
        }

        fn tag(self: @ContractState) -> ByteArray {
            "tournament-erc1155_mock"
        }

        fn name_hash(self: @ContractState) -> felt252 {
            3250238257263798247489988533400665746178893727502806941939940179585742706831
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            3513465382457774401660929656863894979351645367198604050918895380273858322651
        }

        fn selector(self: @ContractState) -> felt252 {
            379809586822697269504394504973916514867516499842221425069637530706767304240
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

    // use debug::PrintTrait;
    use core::byte_array::ByteArrayTrait;
    use starknet::{ContractAddress, get_contract_address, get_caller_address, get_block_timestamp};

    //-----------------------------------
    // OpenZeppelin start
    //
    use openzeppelin_introspection::src5::SRC5Component;
    use openzeppelin_token::erc1155::{ERC1155Component, ERC1155HooksEmptyImpl};
    component!(path: SRC5Component, storage: src5, event: SRC5Event);
    component!(path: ERC1155Component, storage: erc1155, event: ERC1155Event);
    #[abi(embed_v0)]
    impl ERC1155MixinImpl = ERC1155Component::ERC1155MixinImpl<ContractState>;
    impl ERC1155InternalImpl = ERC1155Component::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        world_dispatcher: IWorldDispatcher,
        #[substorage(v0)]
        upgradeable: dojo::contract::upgradeable::upgradeable::Storage,
        #[substorage(v0)]
        erc1155: ERC1155Component::Storage,
        #[substorage(v0)]
        src5: SRC5Component::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        UpgradeableEvent: dojo::contract::upgradeable::upgradeable::Event,
        #[flat]
        SRC5Event: SRC5Component::Event,
        #[flat]
        ERC1155Event: ERC1155Component::Event
    }
    //
    // OpenZeppelin end
    //-----------------------------------

    //*******************************
    fn TOKEN_NAME() -> ByteArray {
        ("Test ERC1155")
    }
    fn TOKEN_SYMBOL() -> ByteArray {
        ("T1155")
    }
    fn BASE_URI() -> ByteArray {
        ("https://testerc1155.io")
    }
    #[starknet::interface]
    pub trait IDojoInit<ContractState> {
        fn dojo_init(ref self: ContractState);
    }

    #[abi(embed_v0)]
    pub impl IDojoInitImpl of IDojoInit<ContractState> {
        fn dojo_init(ref self: ContractState) {
            if starknet::get_caller_address() != self.world().contract_address {
                core::panics::panic_with_byte_array(
                    @format!(
                        "Only the world can init contract `{}`, but caller is `{:?}`",
                        self.tag(),
                        starknet::get_caller_address()
                    )
                );
            }
            self.erc1155.initializer(BASE_URI(),);
        }
    }

    //-----------------------------------
    // Public
    //
    use super::{IERC1155MockPublic};
    #[abi(embed_v0)]
    impl ERC1155MockPublicImpl of IERC1155MockPublic<ContractState> {
        fn _name(self: @ContractState) -> ByteArray {
            TOKEN_NAME()
        }
        fn symbol(self: @ContractState) -> ByteArray {
            TOKEN_SYMBOL()
        }
        fn mint(ref self: ContractState, recipient: ContractAddress, token_id: u256, value: u256) {
            let data = ArrayTrait::<felt252>::new();
            self.erc1155.mint_with_acceptance_check(recipient, token_id, value, data.span());
        }
    }
}

