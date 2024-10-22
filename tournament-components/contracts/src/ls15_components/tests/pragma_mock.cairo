use starknet::{ContractAddress};
use dojo::world::IWorldDispatcher;
use tournament::ls15_components::interfaces::{DataType, PragmaPricesResponse};

#[starknet::interface]
pub trait IPragmaMock<TState> {
    // IWorldProvider
    fn world(self: @TState,) -> IWorldDispatcher;

    // IERCPublic
    fn get_data_median(ref self: TState, data_type: DataType) -> PragmaPricesResponse;
}

#[starknet::interface]
pub trait IPragmaMockPublic<TState> {
    fn get_data_median(ref self: TState, data_type: DataType) -> PragmaPricesResponse;
}


#[dojo::contract]
pub mod pragma_mock {
    // use debug::PrintTrait;
    use core::byte_array::ByteArrayTrait;
    use starknet::{ContractAddress, get_contract_address, get_caller_address, get_block_timestamp};

    use tournament::ls15_components::interfaces::{DataType, PragmaPricesResponse};

    #[storage]
    struct Storage {}
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {}
    //
    // OpenZeppelin end
    //-----------------------------------

    //-----------------------------------
    // Public
    //
    use super::{IPragmaMockPublic};
    #[abi(embed_v0)]
    impl PragmaMockPublicImpl of IPragmaMockPublic<ContractState> {
        fn get_data_median(ref self: ContractState, data_type: DataType) -> PragmaPricesResponse {
            PragmaPricesResponse {
                price: 250000000000,
                decimals: 8,
                last_updated_timestamp: 1715145600,
                num_sources_aggregated: 1,
                expiration_timestamp: Option::None,
            }
        }
    }
}
