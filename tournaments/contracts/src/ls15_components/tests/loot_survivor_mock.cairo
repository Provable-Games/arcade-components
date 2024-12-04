// imports

use adventurer::{adventurer::{ImplAdventurer}, adventurer_meta::{ImplAdventurerMetadata}};
use starknet::ContractAddress;

#[starknet::interface]
trait ILootSurvivorMockInit<TState> {
    fn initializer(
        ref self: TState,
        eth_address: ContractAddress,
        lords_address: ContractAddress,
        pragma_address: ContractAddress
    );
}

#[dojo::contract]
mod loot_survivor_mock {
    use adventurer::{adventurer::ImplAdventurer, adventurer_meta::{ImplAdventurerMetadata}};
    use starknet::ContractAddress;

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
        #[substorage(v0)]
        loot_survivor: loot_survivor_component::Storage,
        #[substorage(v0)]
        erc721: ERC721Component::Storage,
        #[substorage(v0)]
        src5: SRC5Component::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        LootSurvivorEvent: loot_survivor_component::Event,
        #[flat]
        SRC5Event: SRC5Component::Event,
        #[flat]
        ERC721Event: ERC721Component::Event,
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
            eth_address: ContractAddress,
            lords_address: ContractAddress,
            pragma_address: ContractAddress
        ) {
            self.erc721.initializer(TOKEN_NAME(), TOKEN_SYMBOL(), BASE_URI(),);
            self.loot_survivor.initialize(eth_address, lords_address, pragma_address);
        }
    }
}
