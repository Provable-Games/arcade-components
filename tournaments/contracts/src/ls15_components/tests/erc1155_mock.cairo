use starknet::{ContractAddress};
use dojo::world::IWorldDispatcher;

#[starknet::interface]
pub trait IERC1155Mock<TState> {
    // IWorldProvider
    fn world(self: @TState,) -> IWorldDispatcher;

    // ISRC5
    fn supports_interface(self: @TState, interface_id: felt252) -> bool;
    // IERC1155
    fn balance_of(self: @TState, account: ContractAddress, token_id: u256) -> u256;
    fn balance_of_batch(
        self: @TState, accounts: Span<ContractAddress>, token_ids: Span<u256>
    ) -> Span<u256>;
    fn safe_transfer_from(
        ref self: TState,
        from: ContractAddress,
        to: ContractAddress,
        token_id: u256,
        value: u256,
        data: Span<felt252>
    );
    fn safe_batch_transfer_from(
        ref self: TState,
        from: ContractAddress,
        to: ContractAddress,
        token_ids: Span<u256>,
        values: Span<u256>,
        data: Span<felt252>
    );
    fn set_approval_for_all(ref self: TState, operator: ContractAddress, approved: bool);
    fn is_approved_for_all(
        self: @TState, owner: ContractAddress, operator: ContractAddress
    ) -> bool;
    // IERC1155CamelOnly
    fn balanceOf(self: @TState, account: ContractAddress, tokenId: u256) -> u256;
    fn balanceOfBatch(
        self: @TState, accounts: Span<ContractAddress>, tokenIds: Span<u256>
    ) -> Span<u256>;
    fn safeTransferFrom(
        ref self: TState,
        from: ContractAddress,
        to: ContractAddress,
        tokenId: u256,
        value: u256,
        data: Span<felt252>
    );
    fn safeBatchTransferFrom(
        ref self: TState,
        from: ContractAddress,
        to: ContractAddress,
        tokenIds: Span<u256>,
        values: Span<u256>,
        data: Span<felt252>
    );
    fn setApprovalForAll(ref self: TState, operator: ContractAddress, approved: bool);
    fn isApprovedForAll(self: @TState, owner: ContractAddress, operator: ContractAddress) -> bool;

    // IERC1155MockPublic
    fn _name(self: @TState) -> ByteArray;
    fn symbol(self: @TState) -> ByteArray;
    fn mint(ref self: TState, recipient: ContractAddress, token_id: u256, value: u256);
}

#[starknet::interface]
pub trait IERC1155MockPublic<TState> {
    fn _name(self: @TState) -> ByteArray;
    fn symbol(self: @TState) -> ByteArray;
    fn mint(ref self: TState, recipient: ContractAddress, token_id: u256, value: u256);
}

#[dojo::contract]
pub mod erc1155_mock {
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
        #[substorage(v0)]
        erc1155: ERC1155Component::Storage,
        #[substorage(v0)]
        src5: SRC5Component::Storage,
    }
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        SRC5Event: SRC5Component::Event,
        #[flat]
        ERC1155Event: ERC1155Component::Event,
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
    //*******************************

    fn dojo_init(ref self: ContractState,) {
        self.erc1155.initializer(BASE_URI(),);
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
