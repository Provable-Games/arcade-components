use starknet::ContractAddress;

///
/// Model
///

#[derive(Model, Copy, Drop, Serde)]
struct ClientPlayTotalModel {
    #[key]
    client_id: u64,
    play_count: u128
}

#[derive(Model, Copy, Drop, Serde)]
struct ClientPlayPlayerModel {
    #[key]
    client_id: u64,
    #[key]
    player_address: ContractAddress,
    play_count: u128
}

#[starknet::interface]
trait IClientPlay<TState> {
    fn get_play_count_total(self:  @TState, client_id: u256) -> u256;
    fn get_play_count_player(self:  @TState, client_id: u256, player_address: ContractAddress) -> u256;
    fn play(ref self: TState, client_id: u256);
}

#[starknet::interface]
trait IClientPlayCamel<TState> {
    fn getPlayCountTotal(self:  @TState, client_id: u256) -> u256;
    fn getPlayCountPlayer(self:  @TState, client_id: u256, player_address: ContractAddress) -> u256;
}

///
/// ClientPlay Component
///
#[starknet::component]
mod client_play_component {
    use super::ClientPlayTotalModel;
    use super::ClientPlayPlayerModel;
    use super::IClientPlay;
    use super::IClientPlayCamel;

    use starknet::ContractAddress;
    use starknet::info::{
        get_caller_address, get_contract_address
    };

    use dojo::world::{
        IWorldProvider, IWorldProviderDispatcher, IWorldDispatcher, IWorldDispatcherTrait
    };

    #[storage]
    struct Storage {}

    // Events
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Play: Play,
    }

    #[derive(Copy, Drop, Serde, starknet::Event)]
    struct Play {
        client_id: u256,
        player_address: ContractAddress,
    }

    #[embeddable_as(ClientPlayImpl)]
    impl ClientPlay<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        +Drop<TContractState>,
    > of IClientPlay<ComponentState<TContractState>> {
        fn get_play_count_total(self: @ComponentState<TContractState>, client_id: u256) -> u256 {
            self.get_play_total(client_id).play_count.into()
        }

        fn get_play_count_player(self: @ComponentState<TContractState>, client_id: u256, player_address: ContractAddress) -> u256 {
            self.get_play_player(client_id, player_address).play_count.into()
        }

        fn play(ref self: ComponentState<TContractState>, client_id: u256) {
            let caller = get_caller_address();
            let total_play = self.get_play_total(client_id);
            let player_play = self.get_play_player(client_id, caller);

            self.set_play_total(client_id, total_play.play_count.into() + 1);
            self.set_play_player(client_id, caller, player_play.play_count.into() + 1);

            let play_event = Play { client_id, player_address: caller };
            self.emit(play_event.clone());
            emit!(self.get_contract().world(), (Event::Play(play_event)));
        }
    }

    #[embeddable_as(ClientPlayCamelImpl)]
    impl ClientPlayCamel<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        +Drop<TContractState>,
    > of IClientPlayCamel<ComponentState<TContractState>> {
        fn getPlayCountTotal(self: @ComponentState<TContractState>, client_id: u256) -> u256 {
            self.get_play_total(client_id).play_count.into()
        }

        fn getPlayCountPlayer(self: @ComponentState<TContractState>, client_id: u256, player_address: ContractAddress) -> u256 {
            self.get_play_player(client_id, player_address).play_count.into()
        }
    }

    #[generate_trait]
    impl InternalImpl<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        +Drop<TContractState>
    > of InternalTrait<TContractState> {
        fn get_play_total(self: @ComponentState<TContractState>, client_id: u256) -> ClientPlayTotalModel {
            get!(self.get_contract().world(), (client_id.low), ClientPlayTotalModel)
        }

        fn get_play_player(self: @ComponentState<TContractState>, client_id: u256, player_address: ContractAddress) -> ClientPlayPlayerModel {
            get!(self.get_contract().world(), (client_id.low, player_address), ClientPlayPlayerModel)
        }

        fn set_play_total(self: @ComponentState<TContractState>, client_id: u256, play_count: u256) {
            set!(self.get_contract().world(), ClientPlayTotalModel { client_id: client_id.low.try_into().unwrap(), play_count: play_count.low })
        }

        fn set_play_player(self: @ComponentState<TContractState>, client_id: u256, player_address: ContractAddress, play_count: u256) {
            set!(self.get_contract().world(), ClientPlayPlayerModel { client_id: client_id.low.try_into().unwrap(), player_address, play_count: play_count.low });
        }
    }
}


