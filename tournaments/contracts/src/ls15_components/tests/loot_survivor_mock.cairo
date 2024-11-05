// imports

use adventurer::{
    adventurer::{Adventurer, ImplAdventurer}, adventurer_meta::{ImplAdventurerMetadata}, bag::Bag
};
use tournament::ls15_components::models::loot_survivor::AdventurerMetadata;
use starknet::ContractAddress;
use dojo::world::IWorldDispatcher;

#[starknet::interface]
pub trait ILootSurvivorMock<TState> {
    // IWorldProvider
    fn world_dispatcher(self: @TState) -> IWorldDispatcher;
    
    // ISRC5
    fn supports_interface(self: @TState, interface_id: felt252) -> bool;
    // IERC721
    fn balance_of(self: @TState, account: ContractAddress) -> u256;
    fn owner_of(self: @TState, token_id: u256) -> ContractAddress;
    fn safe_transfer_from(
        ref self: TState,
        from: ContractAddress,
        to: ContractAddress,
        token_id: u256,
        data: Span<felt252>
    );
    fn transfer_from(ref self: TState, from: ContractAddress, to: ContractAddress, token_id: u256);
    fn approve(ref self: TState, to: ContractAddress, token_id: u256);
    fn set_approval_for_all(ref self: TState, operator: ContractAddress, approved: bool);
    fn get_approved(self: @TState, token_id: u256) -> ContractAddress;
    fn is_approved_for_all(
        self: @TState, owner: ContractAddress, operator: ContractAddress
    ) -> bool;
    // IERC721CamelOnly
    fn balanceOf(self: @TState, account: ContractAddress) -> u256;
    fn ownerOf(self: @TState, tokenId: u256) -> ContractAddress;
    fn safeTransferFrom(
        ref self: TState,
        from: ContractAddress,
        to: ContractAddress,
        tokenId: u256,
        data: Span<felt252>
    );
    fn transferFrom(ref self: TState, from: ContractAddress, to: ContractAddress, tokenId: u256);
    fn setApprovalForAll(ref self: TState, operator: ContractAddress, approved: bool);
    fn getApproved(self: @TState, tokenId: u256) -> ContractAddress;
    fn isApprovedForAll(self: @TState, owner: ContractAddress, operator: ContractAddress) -> bool;
    // IERC721Metadata
    fn name(self: @TState) -> ByteArray;
    fn symbol(self: @TState) -> ByteArray;
    fn token_uri(self: @TState, token_id: u256) -> ByteArray;
    // IERC721MetadataCamelOnly
    fn tokenURI(self: @TState, tokenId: u256) -> ByteArray;

    // LS
    fn get_adventurer(self: @TState, adventurer_id: felt252) -> Adventurer;
    fn get_adventurer_meta(self: @TState, adventurer_id: felt252) -> AdventurerMetadata;
    fn get_bag(self: @TState, adventurer_id: felt252) -> Bag;
    fn get_cost_to_play(self: @TState) -> u128;
    fn new_game(
        ref self: TState,
        client_reward_address: ContractAddress,
        weapon: u8,
        name: felt252,
        golden_token_id: u8,
        delay_reveal: bool,
        custom_renderer: ContractAddress,
        launch_tournament_winner_token_id: u128,
        mint_to: ContractAddress
    ) -> felt252;
    fn set_adventurer(self: @TState, adventurer_id: felt252, adventurer: Adventurer);
    fn set_adventurer_meta(
        self: @TState, adventurer_id: felt252, adventurer_meta: AdventurerMetadata
    );
    fn set_bag(self: @TState, adventurer_id: felt252, bag: Bag);

    fn initializer(
        ref self: TState,
        name: ByteArray,
        symbol: ByteArray,
        base_uri: ByteArray,
        eth_address: ContractAddress,
        lords_address: ContractAddress,
        pragma_address: ContractAddress
    );
}

#[starknet::interface]
trait ILootSurvivorMockInit<TState> {
    fn initializer(
        ref self: TState,
        name: ByteArray,
        symbol: ByteArray,
        base_uri: ByteArray,
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
            name: ByteArray,
            symbol: ByteArray,
            base_uri: ByteArray,
            eth_address: ContractAddress,
            lords_address: ContractAddress,
            pragma_address: ContractAddress
        ) {
            self.erc721.initializer(TOKEN_NAME(), TOKEN_SYMBOL(), BASE_URI(),);
            self.loot_survivor.initialize(eth_address, lords_address, pragma_address);
        }
    }
}
