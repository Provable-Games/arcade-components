use starknet::ContractAddress;

///
/// Model
///

#[derive(Model, Copy, Drop, Serde)]
struct ClientRatingTotalModel {
    #[key]
    client_id: u64,
    rating: u8,
    vote_count: u128,
}

#[derive(Model, Copy, Drop, Serde)]
struct ClientRatingPlayerModel {
    #[key]
    client_id: u64,
    #[key]
    player_address: ContractAddress,
    rating: u8,
    vote_count: u128,
}

#[starknet::interface]
trait IClientRating<TState> {
    fn get_rating_total(self: @TState, client_id: u256) -> u8;
    fn get_rating_player(self: @TState, client_id: u256, player_address: ContractAddress) -> u8;
    fn rate(ref self: TState, client_id: u256, rating: u8);
}

#[starknet::interface]
trait IClientRatingCamel<TState> {
    fn getRatingTotal(self: @TState, client_id: u256) -> u8;
    fn getRatingPlayer(self: @TState, client_id: u256, player_address: ContractAddress) -> u8;
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

    use ls::components::client::client_play::client_play_component as client_play_comp;

    use client_play_comp::InternalImpl as ClientPlayInternal;

    mod Errors {
        const NOT_ENOUGH_GAMES: felt252 = 'Client: Not enough games';
    }

    // Storage
    #[storage]
    struct Storage {}

    // Events
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Rate: Rate,
    }

    #[derive(Copy, Drop, Serde, starknet::Event)]
    struct Rate {
        client_id: u256,
        player_address: ContractAddress,
        rating: u8,
    }

    #[embeddable_as(ClientRatingImpl)]
    impl ClientRating<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        impl ClientPlay: client_play_comp::HasComponent<TContractState>,
        +Drop<TContractState>,
    > of IClientRating<ComponentState<TContractState>> {
        fn get_rating_total(self: @ComponentState<TContractState>, client_id: u256) -> u8 {
            self.get_rating_total_internal(client_id).rating
        }

        fn get_rating_player(self: @ComponentState<TContractState>, client_id: u256, player_address: ContractAddress) -> u8 {
            self.get_rating_player_internal(client_id, player_address).rating
        }

        fn rate(ref self: ComponentState<TContractState>, client_id: u256, rating: u8) {
            let caller = get_caller_address();
            let total_rating = self.get_rating_total_internal(client_id);
            let player_rating = self.get_rating_player_internal(client_id, caller);

            let mut client_play = get_dep_component_mut!(ref self, ClientPlay);
            assert(client_play.get_play_player(client_id, caller).play_count > player_rating.vote_count, Errors::NOT_ENOUGH_GAMES);

            let new_total_rating = self.calculate_new_rating(rating, total_rating.rating, total_rating.vote_count.into());
            self.set_total_rating(client_id, new_total_rating, total_rating.vote_count.into() + 1);

            let new_player_rating = self.calculate_new_rating(rating, player_rating.rating, player_rating.vote_count.into());
            self.set_player_rating(client_id, caller, new_player_rating, player_rating.vote_count.into() + 1);

            let rate_event = Rate { client_id, player_address: caller, rating };
            self.emit(rate_event.clone());
            emit!(self.get_contract().world(), (Event::Rate(rate_event)));
        }
    }

    #[embeddable_as(ClientRatingCamelImpl)]
    impl ClientRatingCamel<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        +Drop<TContractState>,
    > of IClientRatingCamel<ComponentState<TContractState>> {
        fn getRatingTotal(self: @ComponentState<TContractState>, client_id: u256) -> u8 {
            self.get_rating_total_internal(client_id).rating
        }

        fn getRatingPlayer(self: @ComponentState<TContractState>, client_id: u256, player_address: ContractAddress) -> u8 {
            self.get_rating_player_internal(client_id, player_address).rating
        }
    }

    #[generate_trait]
    impl InternalImpl<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        +Drop<TContractState>
    > of InternalTrait<TContractState> {
        fn get_rating_total_internal(self: @ComponentState<TContractState>, client_id: u256) -> ClientRatingTotalModel {
            get!(self.get_contract().world(),
                (client_id.low),
                ClientRatingTotalModel)
        }

        fn get_rating_player_internal(self: @ComponentState<TContractState>, client_id: u256, player_address: ContractAddress) -> ClientRatingPlayerModel {
            get!(self.get_contract().world(),
                (client_id.low, player_address),
                ClientRatingPlayerModel)
        }

        fn calculate_new_rating(self: @ComponentState<TContractState>, added_rating: u8, total_rating: u8, vote_count: u256) -> u8 {
            let current_total = total_rating.into() * vote_count;
            let new_total = current_total + added_rating.into();
            (new_total / (vote_count + 1)).low.try_into().unwrap()
        }

        fn set_total_rating(self: @ComponentState<TContractState>, client_id: u256, rating: u8, vote_count: u256) {
            set!(
                self.get_contract().world(),
                ClientRatingTotalModel { client_id: client_id.low.try_into().unwrap(), rating, vote_count: vote_count.low}
            );
        }

        fn set_player_rating(self: @ComponentState<TContractState>, client_id: u256, player_address: ContractAddress, rating: u8, vote_count: u256) {
            set!(
                self.get_contract().world(),
                ClientRatingPlayerModel { client_id: client_id.low.try_into().unwrap(), player_address, rating, vote_count: vote_count.low}
            );
        }
    }
}