use starknet::{ContractAddress, ClassHash};
use dojo::world::IWorldDispatcher;
use tournament::ls15_components::tournament::{TournamentModel};
use tournament::ls15_components::interfaces::{LootRequirement, Token, StatRequirement, GatedToken, Premium};
use tournament::ls15_components::constants::{TokenType, PrizeType};

#[starknet::interface]
trait ITournamentMock<TState> {
    fn total_tournaments(self: @TState) -> u64;
    fn tournament(self: @TState, tournament_id: u64) -> TournamentModel;
    fn top_scores(self: @TState, tournament_id: u64) -> Array<u16>;
    fn is_tournament_active(self: @TState, tournament_id: u64) -> bool;
    fn is_token_registered(self: @TState, token: ContractAddress) -> bool;
    fn create_tournament(
        ref self: TState,
        name: ByteArray,
        gated_token: Option<GatedToken>,
        start_time: u64,
        end_time: u64,
        submission_period: u64,
        leaderboard_size: u8,
        entry_premium: Option<Premium>,
        prizes: Array<PrizeType>,
        stat_requirements: Array<StatRequirement>
    ) -> u64;
    fn register_tokens(ref self: TState, tokens: Array<Token>);
    fn enter_tournament(
        ref self: TState,
        tournament_id: u64,
        gated_token_id: u256
    );
    fn start_tournament(ref self: TState, tournament_id: u64, start_all: bool);
    fn submit_scores(ref self: TState, tournament_id: u64, character_ids: Array<u256>);
    fn claim_prizes(ref self: TState, tournament_id: u64);

    // IWorldProvider
    fn world(self: @TState,) -> IWorldDispatcher;

    fn initializer(
        ref self: TState,
        eth_address: ContractAddress,
        lords_address: ContractAddress,
        loot_survivor_address: ContractAddress,
        oracle_address: ContractAddress
    );
}

#[starknet::interface]
trait ITournamentMockInit<TState> {
    fn initializer(
        ref self: TState,
        eth_address: ContractAddress,
        lords_address: ContractAddress,
        loot_survivor_address: ContractAddress,
        oracle_address: ContractAddress
    );
}

#[dojo::contract]
mod tournament_mock {
    use starknet::{ContractAddress, get_caller_address};
    use tournament::ls15_components::tournament::tournament_component;

    component!(path: tournament_component, storage: tournament, event: TournamentEvent);

    #[abi(embed_v0)]
    impl TournamentImpl = tournament_component::TournamentImpl<ContractState>;

    impl TournamentInternalImpl = tournament_component::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        tournament: tournament_component::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        TournamentEvent: tournament_component::Event,
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
}
