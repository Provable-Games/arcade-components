use starknet::ContractAddress;

///
/// Model
///

#[derive(Model, Copy, Drop, Serde)]
struct ClientRatingTotalModel {
    #[key]
    id: u128,
    rating: u8,
    vote_count: u128,
}

#[derive(Model, Copy, Drop, Serde)]
struct ClientRatingPlayerModel {
    #[key]
    id: u128,
    #[key]
    player_address: ContractAddress,
    rating: u8,
    vote_count: u128,
}

#[starknet::interface]
trait IClientRating<TState> {
    fn get_rating_total(self: @TState, id: u256) -> u8;
    fn get_rating_player(self: @TState, id: u256, player_address: ContractAddress) -> u8;
    fn rate(self: @TState, id: u256, rating: u8);
}

#[starknet::interface]
trait IClientRatingCamel<TState> {
    fn getRatingTotal(self: @TState, id: u256) -> u8;
    fn getRatingPlayer(self: @TState, id: u256, player_address: ContractAddress) -> u8;
}

///
/// ClientRating Component
///
#[starknet::component]
mod client_rating_component {
    use super::ClientRatingTotalModel;
    use super::ClientRatingPlayerModel;
    use super::IClientRating;
    use super::IClientRatingCamel;

    use starknet::ContractAddress;
    use starknet::info::{
        get_caller_address, get_contract_address
    };

    use dojo::world::{
        IWorldProvider, IWorldProviderDispatcher, IWorldDispatcher, IWorldDispatcherTrait
    };

    // Storage
    #[storage]
    struct Storage {}

    // Events
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Rate: Rate,
    }


    #[derive(Drop, starknet::Event)]
    struct Rate {
        id: u256,
        rating: u8,
    }

    #[embeddable_as(ClientRatingImpl)]
    impl ClientRating<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        +Drop<TContractState>,
    > of IClientRating<ComponentState<TContractState>> {
        fn get_rating_total(self: @ComponentState<TContractState>, id: u256) -> u8 {
            self.get_rating_total_internal(id).rating
        }

        fn get_rating_player(self: @ComponentState<TContractState>, id: u256, player_address: ContractAddress) -> u8 {
            self.get_rating_player_internal(id, player_address).rating
        }

        fn rate(self: @ComponentState<TContractState>, id: u256, rating: u8) {
            let caller = get_caller_address();
            let total_rating = self.get_rating_total_internal(id);
            let player_rating = self.get_rating_player_internal(id, caller);

            let new_total_rating = self.calculate_new_rating(total_rating.rating, total_rating.vote_count.into());
            self.set_total_rating(id, new_total_rating, total_rating.vote_count.into() + 1);

            let new_player_rating = self.calculate_new_rating(player_rating.rating, player_rating.vote_count.into());
            self.set_player_rating(id, caller, new_player_rating, player_rating.vote_count.into() + 1)
        }
    }

    #[embeddable_as(ClientRatingCamelImpl)]
    impl ClientRatingCamel<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        +Drop<TContractState>,
    > of IClientRatingCamel<ComponentState<TContractState>> {
        fn getRatingTotal(self: @ComponentState<TContractState>, id: u256) -> u8 {
            self.get_rating_total_internal(id).rating
        }

        fn getRatingPlayer(self: @ComponentState<TContractState>, id: u256, player_address: ContractAddress) -> u8 {
            self.get_rating_player_internal(id, player_address).rating
        }
    }

    #[generate_trait]
    impl InternalImpl<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        +Drop<TContractState>
    > of InternalTrait<TContractState> {
        fn get_rating_total_internal(self: @ComponentState<TContractState>, id: u256) -> ClientRatingTotalModel {
            get!(self.get_contract().world(),
                (get_contract_address(), id.low),
                ClientRatingTotalModel)
        }

        fn get_rating_player_internal(self: @ComponentState<TContractState>, id: u256, player_address: ContractAddress) -> ClientRatingPlayerModel {
            get!(self.get_contract().world(),
                (get_contract_address(), id.low, player_address),
                ClientRatingPlayerModel)
        }

        fn calculate_new_rating(self: @ComponentState<TContractState>, rating: u8, vote_count: u256) -> u8 {
            let current_total = rating.into() * vote_count;
            (current_total / (vote_count + 1)).low.try_into().unwrap()
        }

        fn set_total_rating(self: @ComponentState<TContractState>, id: u256, rating: u8, vote_count: u256) {
            set!(
                self.get_contract().world(),
                ClientRatingTotalModel { id: id.low, rating, vote_count: vote_count.low}
            );
        }

        fn set_player_rating(self: @ComponentState<TContractState>, id: u256, player_address: ContractAddress, rating: u8, vote_count: u256) {
            set!(
                self.get_contract().world(),
                ClientRatingPlayerModel { id: id.low, player_address, rating, vote_count: vote_count.low}
            );
        }
    }
}