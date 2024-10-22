use starknet::ContractAddress;
use tournament::ls15_components::interfaces::{LootRequirement, Token, StatRequirement, GatedToken};
use tournament::ls15_components::constants::{TokenType, PrizeType};

/// Raise a number to a power.
/// O(log n) time complexity.
/// * `base` - The number to raise.
/// * `exp` - The exponent.
/// # Returns
/// * `T` - The result of base raised to the power of exp.
pub fn pow<T, +Sub<T>, +Mul<T>, +Div<T>, +Rem<T>, +PartialEq<T>, +Into<u8, T>, +Drop<T>, +Copy<T>>(
    base: T, exp: T
) -> T {
    if exp == 0_u8.into() {
        1_u8.into()
    } else if exp == 1_u8.into() {
        base
    } else if exp % 2_u8.into() == 0_u8.into() {
        pow(base * base, exp / 2_u8.into())
    } else {
        base * pow(base * base, exp / 2_u8.into())
    }
}

///
/// Model
///

// TODO: previous tournament ids that qualify?
#[dojo::model]
#[derive(Drop, Serde)]
struct TournamentModel {
    #[key]
    tournament_id: u64,
    name: ByteArray,
    creator: ContractAddress,
    gated_token: Option<GatedToken>,
    start_time: u64,
    end_time: u64,
    submission_period: u64,
    leaderboard_size: u8,
    entry_premium_token: Option<ContractAddress>,
    entry_premium_amount: u128,
    // entry_premium_creator_fee: u128,
    prizes: Array<PrizeType>,
    stat_requirements: Array<StatRequirement>,
    claimed: bool,
}

#[dojo::model]
#[derive(Copy, Drop, Serde)]
struct TournamentEntryModel {
    #[key]
    tournament_id: u64,
    #[key]
    game_id: u128,
    address: ContractAddress,
    entered: bool,
    started: bool,
    submitted_score: bool,
}

#[dojo::model]
#[derive(Drop, Serde)]
struct TournamentEntriesAddressModel {
    #[key]
    tournament_id: u64,
    #[key]
    address: ContractAddress,
    game_ids: Array<u128>,
}

#[dojo::model]
#[derive(Drop, Serde)]
struct TournamentEntriesModel {
    #[key]
    tournament_id: u64,
    game_ids: Array<u128>,
}

#[dojo::model]
#[derive(Drop, Serde)]
struct TournamentScoresModel {
    #[key]
    tournament_id: u64,
    top_score_ids: Array<u128>,
}

#[dojo::model]
#[derive(Drop, Serde)]
struct TokenModel {
    #[key]
    token: ContractAddress,
    name: ByteArray,
    symbol: ByteArray,
    token_type: TokenType,
    is_registered: bool,
}

#[dojo::model]
#[derive(Copy, Drop, Serde)]
struct TournamentTotalModel {
    #[key]
    contract: ContractAddress,
    total_tournaments: u64,
}

#[dojo::model]
#[derive(Copy, Drop, Serde)]
struct TournamentContracts {
    #[key]
    contract: ContractAddress,
    eth: ContractAddress,
    lords: ContractAddress,
    loot_survivor: ContractAddress,
    oracle: ContractAddress,
}

///
/// Interface
///

#[starknet::interface]
trait ITournament<TState> {
    fn total_tournaments(self: @TState) -> u64;
    fn tournament(self: @TState, tournament_id: u64) -> TournamentModel;
    fn top_scores(self: @TState, tournament_id: u64) -> Array<u128>;
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
        entry_premium_token: Option<ContractAddress>,
        entry_premium_amount: u256,
        prizes: Array<PrizeType>,
        stat_requirements: Array<StatRequirement>,
    ) -> u64;
    fn register_tokens(ref self: TState, tokens: Array<Token>);
    fn enter_tournament(
        ref self: TState,
        tournament_id: u64,
        client_reward_address: ContractAddress,
        weapon: u8,
        name: felt252,
        delay_reveal: bool,
        custom_renderer: ContractAddress,
        gated_token_id: u256
    );
    fn start_tournament(ref self: TState, tournament_id: u64, start_all: bool);
    fn submit_scores(ref self: TState, tournament_id: u64, game_ids: Array<u256>);
    fn claim_prizes(ref self: TState, tournament_id: u64);
}

///
/// Tournament Component
///
#[starknet::component]
mod tournament_component {
    use super::TournamentModel;
    use super::TournamentEntryModel;
    use super::TournamentEntriesAddressModel;
    use super::TournamentEntriesModel;
    use super::TournamentScoresModel;
    use super::TokenModel;
    use super::TournamentTotalModel;
    use super::TournamentContracts;
    use super::ITournament;

    use super::pow;

    use tournament::ls15_components::constants::{
        LOOT_SURVIVOR, Operation, StatRequirementEnum, TokenType, LORDS, ETH, ORACLE,
        VRF_COST_PER_GAME, TWO_POW_128, MIN_REGISTRATION_PERIOD, SUBMISSION_PERIOD,
        GAME_EXPIRATION_PERIOD, PrizeType
    };
    use tournament::ls15_components::interfaces::{
        LootRequirement, Token, StatRequirement, ILootSurvivor, ILootSurvivorDispatcher,
        ILootSurvivorDispatcherTrait, IPragmaABI, IPragmaABIDispatcher, IPragmaABIDispatcherTrait,
        AggregationMode, DataType, PragmaPricesResponse, GatedToken
    };

    use starknet::{
        ContractAddress, get_block_timestamp, get_contract_address, get_caller_address,
        storage::MutableVecTrait, contract_address_const
    };
    use dojo::world::{
        IWorldProvider, IWorldProviderDispatcher, IWorldDispatcher, IWorldDispatcherTrait
    };
    use origami_token::components::introspection::src5::{ISRC5Dispatcher, ISRC5DispatcherTrait};
    use openzeppelin_token::erc20::interface::{
        IERC20, IERC20Dispatcher, IERC20DispatcherTrait, IERC20Metadata, IERC20MetadataDispatcher,
        IERC20MetadataDispatcherTrait
    };
    use openzeppelin_token::erc721::interface::{
        IERC721, IERC721Dispatcher, IERC721DispatcherTrait, IERC721Metadata,
        IERC721MetadataDispatcher, IERC721MetadataDispatcherTrait
    };
    use openzeppelin_token::erc1155::interface::{
        IERC1155, IERC1155Dispatcher, IERC1155DispatcherTrait
    };
    use tournament::ls15_components::tests::erc1155_mock::{
        IERC1155Mock, IERC1155MockDispatcher, IERC1155MockDispatcherTrait
    };

    use adventurer::{adventurer::Adventurer, adventurer_meta::AdventurerMetadata, bag::Bag};

    #[storage]
    struct Storage {}

    #[event]
    #[derive(Copy, Drop, Serde, starknet::Event)]
    enum Event {
        CreateTournament: CreateTournament,
        EnterTournament: EnterTournament,
        StartTournament: StartTournament,
        SubmitScore: SubmitScore,
        NewHighScore: NewHighScore,
        SettleTournament: SettleTournament,
        RegisterToken: RegisterToken,
    }

    #[derive(Copy, Drop, Serde, starknet::Event)]
    struct CreateTournament {
        creator: ContractAddress,
        tournament_id: u64,
    }

    #[derive(Copy, Drop, Serde, starknet::Event)]
    struct EnterTournament {
        account: ContractAddress,
        tournament_id: u64,
    }

    #[derive(Copy, Drop, Serde, starknet::Event)]
    struct StartTournament {
        account: ContractAddress,
        tournament_id: u64,
    }

    #[derive(Copy, Drop, Serde, starknet::Event)]
    struct SubmitScore {
        tournament_id: u64,
        game_id: u256,
        score: u16,
    }

    #[derive(Copy, Drop, Serde, starknet::Event)]
    struct NewHighScore {
        tournament_id: u64,
        game_id: u256,
        score: u16,
        rank: u8,
    }

    #[derive(Copy, Drop, Serde, starknet::Event)]
    struct SettleTournament {
        tournament_id: u64,
        first: u16,
        second: u16,
        third: u16,
    }

    #[derive(Copy, Drop, Serde, starknet::Event)]
    struct RegisterToken {
        token: ContractAddress,
        token_type: TokenType,
    }

    mod Errors {
        const INVALID_START_TIME: felt252 = 'invalid start time';
        const INVALID_END_TIME: felt252 = 'invalid end time';
        const INVALID_LEADERBOARD_SIZE: felt252 = 'invalid leaderboard size';
        const NO_QUALIFYING_NFT: felt252 = 'no qualifying nft';
        const TOURNAMENT_ALREADY_STARTED: felt252 = 'tournament already started';
        const TOURNAMENT_NOT_STARTED: felt252 = 'tournament not started';
        const TOURNAMENT_NOT_ENDED: felt252 = 'tournament not ended';
        const TOURNAMENT_NOT_ACTIVE: felt252 = 'tournament not active';
        const TOURNAMENT_NOT_SETTLED: felt252 = 'tournament not settled';
        const TOURNAMENT_ALREADY_SETTLED: felt252 = 'tournament already settled';
        const NOT_OWNER: felt252 = 'not owner';
        const NOT_ENTERED: felt252 = 'tournament not entered';
        const TOURNAMENT_ALREADY_CLAIMED: felt252 = 'tournament already claimed';
        const TOURNAMENT_ENTRY_NOT_ENTERED: felt252 = 'entry not entered';
        const TOURNAMENT_ENTRY_ALREADY_STARTED: felt252 = 'entry already started';
        const TOURNAMENT_ENTRY_ALREADY_SUBMITTED: felt252 = 'entry already submitted';
        const TOKEN_ALREADY_REGISTERED: felt252 = 'token already registered';
        const TOKEN_TRANSFER_FAILED: felt252 = 'token transfer failed';
        const TOKEN_BALANCE_TOO_HIGH: felt252 = 'token supply too high';
        const TOKEN_NOT_REGISTERED: felt252 = 'token not registered';
        const FETCHING_ETH_PRICE_ERROR: felt252 = 'error fetching eth price';
        const INVALID_DISTRIBUTION: felt252 = 'invalid distribution';
        const INVALID_SCORE: felt252 = 'invalid score';
        const INVALID_SCORES_SUBMISSION: felt252 = 'invalid scores submission';
    }

    #[embeddable_as(TournamentImpl)]
    impl Tournament<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        +Drop<TContractState>
    > of ITournament<ComponentState<TContractState>> {
        fn total_tournaments(self: @ComponentState<TContractState>) -> u64 {
            self.get_total_tournaments().total_tournaments
        }

        fn tournament(
            self: @ComponentState<TContractState>, tournament_id: u64
        ) -> TournamentModel {
            self.get_tournament(tournament_id)
        }

        fn top_scores(self: @ComponentState<TContractState>, tournament_id: u64) -> Array<u128> {
            self.get_tournament_scores(tournament_id).top_score_ids
        }

        fn is_tournament_active(self: @ComponentState<TContractState>, tournament_id: u64) -> bool {
            self._is_tournament_active(tournament_id)
        }

        fn is_token_registered(
            self: @ComponentState<TContractState>, token: ContractAddress
        ) -> bool {
            self._is_token_registered(token)
        }

        fn create_tournament(
            ref self: ComponentState<TContractState>,
            name: ByteArray,
            gated_token: Option<GatedToken>,
            start_time: u64,
            end_time: u64,
            submission_period: u64,
            leaderboard_size: u8,
            entry_premium_token: Option<ContractAddress>,
            entry_premium_amount: u256,
            mut prizes: Array<PrizeType>,
            stat_requirements: Array<StatRequirement>,
        ) -> u64 {
            // assert the start time is not in the past
            assert(
                start_time >= get_block_timestamp() + MIN_REGISTRATION_PERIOD.into(),
                Errors::INVALID_START_TIME
            );
            // assert the end time is larger than start_time
            assert(end_time > start_time, Errors::INVALID_END_TIME);
            // assert the tournament duration is not longer than the game expiration period
            assert(
                end_time < get_block_timestamp() + GAME_EXPIRATION_PERIOD.into(),
                Errors::INVALID_END_TIME
            );
            // assert leaderboard size is bigger than 0
            assert(leaderboard_size > 0, Errors::INVALID_LEADERBOARD_SIZE);

            // TODO: fix the borrowing state of option
            // // assert the gated token is registered (if exists)
            // let is_registered = match gated_token {
            //     Option::Some(ref gated_token_inner) => {
            //         self._is_token_registered(gated_token_inner.token)
            //     },
            //     Option::None => true,
            // };
            // assert(is_registered, Errors::TOKEN_NOT_REGISTERED);

            // add prizes to the contract
            self._deposit_prizes(ref prizes, leaderboard_size);

            // get the current tournament count
            let tournament_count = self.get_total_tournaments().total_tournaments;

            // create a new tournament
            self
                ._create_tournament(
                    tournament_count + 1,
                    name,
                    get_caller_address(),
                    gated_token,
                    start_time,
                    end_time,
                    submission_period,
                    leaderboard_size,
                    entry_premium_token,
                    entry_premium_amount.low,
                    prizes,
                    stat_requirements,
                );

            self.set_total_tournaments(tournament_count + 1);
            tournament_count + 1
        }

        fn register_tokens(ref self: ComponentState<TContractState>, tokens: Array<Token>) {
            self._register_tokens(tokens);
        }

        // gated entries must register all
        fn enter_tournament(
            ref self: ComponentState<TContractState>,
            tournament_id: u64,
            client_reward_address: ContractAddress,
            weapon: u8,
            name: felt252,
            delay_reveal: bool,
            custom_renderer: ContractAddress,
            gated_token_id: u256
        ) {
            // assert game tournament has not started
            assert(!self._is_tournament_started(tournament_id), Errors::TOURNAMENT_ALREADY_STARTED);

            let tournament = self.get_tournament(tournament_id);

            let mut entries = 1;

            match tournament.gated_token {
                Option::Some(token) => {
                    // assert the caller has a qualifying nft
                    self
                        ._assert_has_qualifying_nft(
                            token.token, get_caller_address(), gated_token_id
                        );
                    entries = self._get_entries(token, gated_token_id);
                },
                Option::None => {},
            };

            let contracts = self.get_contracts();

            // get current game cost
            let ls_dispatcher = ILootSurvivorDispatcher {
                contract_address: contracts.loot_survivor
            };
            let cost_to_play = ls_dispatcher.get_cost_to_play();

            // transfer base game cost
            let lords_dispatcher: IERC20Dispatcher = IERC20Dispatcher {
                contract_address: contracts.lords
            };
            lords_dispatcher
                .transfer_from(
                    get_caller_address(),
                    get_contract_address(),
                    entries.into() * cost_to_play.into()
                );

            // transfer VRF cost
            let eth_dispatcher: IERC20Dispatcher = IERC20Dispatcher {
                contract_address: contracts.eth
            };
            let vrf_cost = self._convert_usd_to_wei(entries.into() * VRF_COST_PER_GAME.into());
            eth_dispatcher
                .transfer_from(get_caller_address(), get_contract_address(), vrf_cost.into());

            match tournament.entry_premium_token {
                Option::Some(token) => {
                    // transfer tournament premium
                    let premium_dispatcher = IERC20Dispatcher { contract_address: token };
                    premium_dispatcher
                        .transfer_from(
                            get_caller_address(),
                            tournament.creator,
                            entries.into() * tournament.entry_premium_amount.into()
                        );
                },
                Option::None => {},
            };

            // set the approvals according to entries
            lords_dispatcher.approve(contracts.loot_survivor, entries.into() * cost_to_play.into());
            eth_dispatcher.approve(contracts.loot_survivor, vrf_cost.into());

            let mut game_ids = ArrayTrait::<u128>::new();

            // create the games for the number of entries
            loop {
                if game_ids.len() == entries.into() {
                    break;
                }
                let game_id = ls_dispatcher
                    .new_game(
                        get_contract_address(),
                        weapon,
                        name,
                        0,
                        delay_reveal,
                        custom_renderer,
                        0,
                        contract_address_const::<0>()
                    );
                game_ids.append(game_id.try_into().unwrap());
            };
            // maybe unneccesary loop
            // TODO: can store multiple game ids in single felt with merkle tree?
            self.set_tournament_entries(tournament_id, game_ids);
        }

        // TODO: support both claiming your own games and claiming other people's games (extra bool
        // option to distribute all)
        fn start_tournament(ref self: ComponentState<TContractState>, tournament_id: u64, start_all: bool) {
            assert(self._is_tournament_active(tournament_id), Errors::TOURNAMENT_NOT_ACTIVE);
            let mut game_ids = ArrayTrait::<u128>::new();
            if start_all {
                game_ids = self.get_total_entries(tournament_id).game_ids;
            } else {
                game_ids = self.get_address_entries(tournament_id, get_caller_address()).game_ids;
            }
            let contracts = self.get_contracts();
            let mut ls_dispatcher = ILootSurvivorDispatcher {
                contract_address: contracts.loot_survivor
            };
            self.set_tournament_starts(tournament_id, game_ids, ls_dispatcher);
        }

        // for more efficient gas we assume that the game ids are in order of highest score
        fn submit_scores(
            ref self: ComponentState<TContractState>, tournament_id: u64, game_ids: Array<u256>
        ) {
            let tournament = self.get_tournament(tournament_id);
            // assert tournament ended but not settled
            self._assert_tournament_ended(tournament_id);
            // assert the submitted scores are less than or equal to leaderboard size
            assert(game_ids.len() <= tournament.leaderboard_size.into(), Errors::INVALID_SCORES_SUBMISSION);
            assert(
                tournament.end_time + tournament.submission_period > get_block_timestamp(),
                Errors::TOURNAMENT_ALREADY_SETTLED
            );

            let contracts = self.get_contracts();
            let mut ls_dispatcher = ILootSurvivorDispatcher {
                contract_address: contracts.loot_survivor
            };
            let mut num_games = game_ids.len();
            let mut game_index = 0;
            let mut new_score_ids = ArrayTrait::<u128>::new();
            loop {
                if game_index == num_games {
                    break;
                }
                let game_id = *game_ids.at(game_index);
                self._assert_tournament_entry(tournament_id, game_id);
                self._assert_tournament_not_submitted(tournament_id, game_id);

                let adventurer = ls_dispatcher.get_adventurer(game_id.try_into().unwrap());

                self._assert_valid_score(adventurer);
                // TODO: look into for v2
                // self._assert_stat_requirements(tournament_id, adventurer);
                // self._assert_loot_requirements(tournament_id, adventurer, bag);

                if self._is_top_score(tournament_id, adventurer.xp) {
                    self._update_tournament_scores(tournament_id, game_id, adventurer.xp, ref new_score_ids, game_index);
                }

                self.set_submitted_score(tournament_id, game_id, adventurer.xp);
                game_index += 1;
            };
            set!(
                self.get_contract().world(),
                (TournamentScoresModel { tournament_id, top_score_ids: new_score_ids })
            );
        }

        // TODO: to protect step errors can be claimed for set of game ids
        fn claim_prizes(ref self: ComponentState<TContractState>, tournament_id: u64) {
            let tournament = get!(self.get_contract().world(), (tournament_id), (TournamentModel));
            assert(
                tournament.end_time + tournament.submission_period <= get_block_timestamp(),
                Errors::TOURNAMENT_NOT_SETTLED
            );
            self._assert_tournament_not_claimed(tournament_id);

            let mut top_score_ids = self.get_tournament_scores(tournament_id).top_score_ids;
            let tournament = self.get_tournament(tournament_id);

            self._distribute_prizes(tournament.prizes, ref top_score_ids);

            self._claimed(tournament_id, top_score_ids);
        }
    }


    #[generate_trait]
    impl InternalImpl<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        +Drop<TContractState>
    > of InternalTrait<TContractState> {
        fn initialize(
            self: @ComponentState<TContractState>,
            eth: ContractAddress,
            lords: ContractAddress,
            loot_survivor: ContractAddress,
            oracle: ContractAddress
        ) {
            set!(
                self.get_contract().world(),
                TournamentContracts {
                    contract: get_contract_address(), eth, lords, loot_survivor, oracle
                }
            );
        }

        fn get_contracts(self: @ComponentState<TContractState>) -> TournamentContracts {
            get!(self.get_contract().world(), (get_contract_address()), (TournamentContracts))
        }

        fn get_total_tournaments(self: @ComponentState<TContractState>) -> TournamentTotalModel {
            get!(self.get_contract().world(), (get_contract_address()), (TournamentTotalModel))
        }

        fn get_tournament(
            self: @ComponentState<TContractState>, tournament_id: u64
        ) -> TournamentModel {
            get!(self.get_contract().world(), (tournament_id), (TournamentModel))
        }

        fn get_tournament_entry(
            self: @ComponentState<TContractState>, tournament_id: u64, game_id: u256
        ) -> TournamentEntryModel {
            get!(self.get_contract().world(), (tournament_id, game_id.low), (TournamentEntryModel))
        }

        fn get_address_entries(
            self: @ComponentState<TContractState>, tournament_id: u64, address: ContractAddress
        ) -> TournamentEntriesAddressModel {
            get!(self.get_contract().world(), (tournament_id, address), (TournamentEntriesAddressModel))
        }

        fn get_total_entries(
            self: @ComponentState<TContractState>, tournament_id: u64
        ) -> TournamentEntriesModel {
            get!(self.get_contract().world(), (tournament_id), (TournamentEntriesModel))
        }

        fn get_tournament_scores(
            self: @ComponentState<TContractState>, tournament_id: u64
        ) -> TournamentScoresModel {
            get!(self.get_contract().world(), (tournament_id), (TournamentScoresModel))
        }

        fn get_score_from_id(
            self: @ComponentState<TContractState>, game_id: u128
        ) -> u16 {
            let ls_dispatcher = ILootSurvivorDispatcher {
                contract_address: self.get_contracts().loot_survivor
            };
            ls_dispatcher.get_adventurer(game_id.try_into().unwrap()).xp
        }

        fn _is_tournament_started(
            self: @ComponentState<TContractState>, tournament_id: u64
        ) -> bool {
            let tournament = get!(self.get_contract().world(), (tournament_id), (TournamentModel));
            tournament.start_time <= get_block_timestamp()
        }


        fn _is_tournament_active(
            self: @ComponentState<TContractState>, tournament_id: u64
        ) -> bool {
            let tournament = get!(self.get_contract().world(), (tournament_id), (TournamentModel));
            tournament.start_time <= get_block_timestamp()
                && tournament.end_time > get_block_timestamp()
        }

        fn _is_tournament_ended(self: @ComponentState<TContractState>, tournament_id: u64) -> bool {
            let tournament = get!(self.get_contract().world(), (tournament_id), (TournamentModel));
            tournament.end_time <= get_block_timestamp()
        }

        fn _is_top_score(
            self: @ComponentState<TContractState>, tournament_id: u64, score: u16
        ) -> bool {
            let top_score_ids = self.get_tournament_scores(tournament_id).top_score_ids;
            let num_scores = top_score_ids.len();
            if num_scores == 0 {
                true
            } else {
                let last_place_id = *top_score_ids.at(num_scores - 1);
                let last_place_score = self.get_score_from_id(last_place_id);
                // if same score then score is not added (first to get score has privelage)
                score > last_place_score
            }
        }

        fn _is_token_registered(
            self: @ComponentState<TContractState>, token: ContractAddress
        ) -> bool {
            let stored_token = get!(self.get_contract().world(), (token), (TokenModel));
            stored_token.is_registered
        }


        fn set_total_tournaments(self: @ComponentState<TContractState>, total_tournaments: u64) {
            set!(
                self.get_contract().world(),
                TournamentTotalModel { contract: get_contract_address(), total_tournaments }
            );
        }

        fn set_tournament_entries(
            self: @ComponentState<TContractState>, tournament_id: u64, game_ids: Array<u128>
        ) {
            let address_entries = self.get_address_entries(tournament_id, get_caller_address());
            let mut address_games = address_entries.game_ids;
            let num_entries = game_ids.len();
            let mut entry_index = 0;
            loop {
                if entry_index == num_entries {
                    break;
                }
                let game_id = *game_ids.at(entry_index);
                address_games.append(game_id);
                set!(
                    self.get_contract().world(),
                    TournamentEntryModel {
                        tournament_id,
                        game_id: game_id,
                        address: get_caller_address(),
                        entered: true,
                        started: false,
                        submitted_score: false
                    }
                );
                entry_index += 1;
            };
            set!(
                self.get_contract().world(),
                TournamentEntriesAddressModel {
                    tournament_id, address: get_caller_address(), game_ids: address_games
                }
            );
        }

        fn set_tournament_starts(
            self: @ComponentState<TContractState>,
            tournament_id: u64,
            game_ids: Array<u128>,
            ls_dispatcher: ILootSurvivorDispatcher
        ) {
            let num_entries = game_ids.len();
            let mut entry_index = 0;
            loop {
                if entry_index == num_entries {
                    break;
                }
                let game_id = *game_ids.at(entry_index);
                let entry = self.get_tournament_entry(tournament_id, game_id.into());
                assert(entry.entered, Errors::TOURNAMENT_ENTRY_NOT_ENTERED);
                assert(!entry.started, Errors::TOURNAMENT_ENTRY_ALREADY_STARTED);
                ls_dispatcher.transfer_from(get_contract_address(), entry.address, game_id.into());
                set!(
                    self.get_contract().world(),
                    TournamentEntryModel {
                        tournament_id,
                        game_id: game_id,
                        address: entry.address,
                        entered: true, // can be just enum instead of 3 bools
                        started: true,
                        submitted_score: false
                    }
                );
                entry_index += 1;
            }
        }

        fn set_submitted_score(
            ref self: ComponentState<TContractState>, tournament_id: u64, game_id: u256, score: u16
        ) {
            let entry = self.get_tournament_entry(tournament_id, game_id);
            set!(
                self.get_contract().world(),
                TournamentEntryModel {
                    tournament_id,
                    game_id: game_id.low,
                    address: entry.address,
                    entered: true,
                    started: true,
                    submitted_score: true
                }
            );
            let submit_score_event = SubmitScore { tournament_id, game_id, score };
            self.emit(submit_score_event.clone());
            emit!(self.get_contract().world(), (Event::SubmitScore(submit_score_event)));
        }

        fn _create_tournament(
            ref self: ComponentState<TContractState>,
            tournament_id: u64,
            name: ByteArray,
            creator: ContractAddress,
            gated_token: Option<GatedToken>,
            start_time: u64,
            end_time: u64,
            submission_period: u64,
            leaderboard_size: u8,
            entry_premium_token: Option<ContractAddress>,
            entry_premium_amount: u128,
            prizes: Array<PrizeType>,
            stat_requirements: Array<StatRequirement>,
        ) {
            set!(
                self.get_contract().world(),
                TournamentModel {
                    tournament_id: tournament_id,
                    name: name,
                    creator: creator,
                    gated_token: gated_token,
                    start_time: start_time,
                    end_time: end_time,
                    submission_period: submission_period,
                    leaderboard_size: leaderboard_size,
                    entry_premium_token: entry_premium_token,
                    entry_premium_amount: entry_premium_amount,
                    prizes: prizes,
                    stat_requirements: stat_requirements,
                    claimed: false
                }
            );
            let create_tournament_event = CreateTournament { creator, tournament_id };
            self.emit(create_tournament_event.clone());
            emit!(self.get_contract().world(), (Event::CreateTournament(create_tournament_event)));
        }

        fn _register_tokens(ref self: ComponentState<TContractState>, tokens: Array<Token>) {
            let num_tokens = tokens.len();
            let mut token_index = 0;
            loop {
                if token_index == num_tokens {
                    break;
                }
                let token = *tokens.at(token_index);

                assert(!self._is_token_registered(token.token), Errors::TOKEN_ALREADY_REGISTERED);

                let mut name = "";
                let mut symbol = "";

                match token.token_type.into() {
                    TokenType::ERC20(()) => {
                        let token_dispatcher = IERC20Dispatcher { contract_address: token.token };
                        let token_dispatcher_metadata = IERC20MetadataDispatcher {
                            contract_address: token.token
                        };
                        name = token_dispatcher_metadata._name();
                        symbol = token_dispatcher_metadata.symbol();
                        // check that the contract is approved for the minimal amount
                        let allowance = token_dispatcher
                            .allowance(get_caller_address(), get_contract_address());
                        assert(allowance == 1, Errors::TOKEN_TRANSFER_FAILED);
                        // take a reading of the current balance (incase contract has assets
                        // already)
                        let current_balance = token_dispatcher.balance_of(get_contract_address());
                        // trnsfer a minimal amount to the contract
                        token_dispatcher
                            .transfer_from(get_caller_address(), get_contract_address(), 1);
                        // take a reading of the new balance
                        let new_balance = token_dispatcher.balance_of(get_contract_address());
                        assert(new_balance == current_balance + 1, Errors::TOKEN_TRANSFER_FAILED);
                        // transfer back the minimal amount
                        token_dispatcher.transfer(get_caller_address(), 1);
                        // check the total supply is legitimate
                        let total_supply = token_dispatcher.total_supply();
                        assert(total_supply < TWO_POW_128.into(), Errors::TOKEN_TRANSFER_FAILED);
                    },
                    TokenType::ERC721(()) => {
                        let token_dispatcher = IERC721Dispatcher { contract_address: token.token };
                        let token_dispatcher_metadata = IERC721MetadataDispatcher {
                            contract_address: token.token
                        };
                        name = token_dispatcher_metadata._name();
                        symbol = token_dispatcher_metadata.symbol();
                        // check that the contract is approved for the specific id
                        let approved = token_dispatcher.get_approved(token.token_id.into());
                        assert(approved == get_contract_address(), Errors::TOKEN_TRANSFER_FAILED);
                        // transfer a specific id to the contract
                        token_dispatcher
                            .transfer_from(
                                get_caller_address(), get_contract_address(), token.token_id.into()
                            );
                        // check the balance of the contract
                        let balance = token_dispatcher.balance_of(get_contract_address());
                        assert(balance == 1, Errors::TOKEN_TRANSFER_FAILED);
                        let owner = token_dispatcher.owner_of(token.token_id.into());
                        assert(owner == get_contract_address(), Errors::TOKEN_TRANSFER_FAILED);
                        // transfer back the token
                        token_dispatcher
                            .transfer_from(
                                get_contract_address(), get_caller_address(), token.token_id.into()
                            );
                    },
                    TokenType::ERC1155(()) => {
                        let token_dispatcher = IERC1155Dispatcher { contract_address: token.token };
                        let token_dispatcher_metadata = IERC1155MockDispatcher {
                            contract_address: token.token
                        };
                        name = token_dispatcher_metadata._name();
                        symbol = token_dispatcher_metadata.symbol();
                        let data = ArrayTrait::<felt252>::new();
                        // check that the contract is approved for all ids
                        let approved = token_dispatcher
                            .is_approved_for_all(get_caller_address(), get_contract_address());
                        assert(approved, Errors::TOKEN_TRANSFER_FAILED);
                        // take a reading of the current balance (incase contract has assets
                        // already)
                        let current_balance = token_dispatcher
                            .balance_of(get_contract_address(), token.token_id.into());
                        // trnsfer a minimal amount to the contract
                        token_dispatcher
                            .safe_transfer_from(
                                get_caller_address(),
                                get_contract_address(),
                                token.token_id.into(),
                                1,
                                data.span()
                            );
                        // take a reading of the new balance
                        let new_balance = token_dispatcher
                            .balance_of(get_contract_address(), token.token_id.into());
                        assert(new_balance == current_balance + 1, Errors::TOKEN_TRANSFER_FAILED);
                        // transfer back the minimal amount
                        token_dispatcher
                            .safe_transfer_from(
                                get_contract_address(),
                                get_caller_address(),
                                token.token_id.into(),
                                1,
                                data.span()
                            );
                    }
                }
                set!(
                    self.get_contract().world(),
                    TokenModel {
                        token: token.token,
                        name,
                        symbol,
                        token_type: token.token_type,
                        is_registered: true
                    }
                );
                let register_token_event = RegisterToken {
                    token: token.token, token_type: token.token_type
                };
                self.emit(register_token_event.clone());
                emit!(self.get_contract().world(), (Event::RegisterToken(register_token_event)));
                token_index += 1;
            }
        }

        fn _update_tournament_scores(
            ref self: ComponentState<TContractState>, tournament_id: u64, game_id: u256, score: u16, ref new_score_ids: Array<u128>, game_index: u32
        ) {
            // let leaderboard_size = self.get_tournament(tournament_id).leaderboard_size;
            // get current scores which will be mutated as part of this function
            let mut top_score_ids = self.get_tournament_scores(tournament_id).top_score_ids;
            let num_scores = top_score_ids.len();

            if num_scores == 0 {
                new_score_ids.append(game_id.low);
            } else {
                if (game_index < num_scores) {
                    let top_score_id = *top_score_ids.at(game_index);
                    let top_score = self.get_score_from_id(top_score_id);
                    if (score > top_score) {
                        new_score_ids.append(game_id.low);
                    } else {
                        new_score_ids.append(top_score_id);
                    }
                } else {
                    new_score_ids.append(game_id.low);
                }
            }
            // let new_high_score_event = NewHighScore { tournament_id, game_id, score, rank };
        // self.emit(new_high_score_event.clone());
        // emit!(self.get_contract().world(), (Event::NewHighScore(new_high_score_event)));
        }

        fn _claimed(
            ref self: ComponentState<TContractState>, tournament_id: u64, scores: Array<u128>
        ) {
            let mut tournament = self.get_tournament(tournament_id);
            tournament.claimed = true;
            set!(self.get_contract().world(), (tournament,));
            // let settle_tournament_event = SettleTournament {
        //     tournament_id, first: scores.first, second: scores.second, third: scores.third
        // };
        // self.emit(settle_tournament_event.clone());
        // emit!(self.get_contract().world(),
        // (Event::SettleTournament(settle_tournament_event)));
        }

        fn _convert_usd_to_wei(self: @ComponentState<TContractState>, usd: u128) -> u128 {
            let contracts = self.get_contracts();
            let oracle_dispatcher = IPragmaABIDispatcher { contract_address: contracts.oracle };
            let response = oracle_dispatcher.get_data_median(DataType::SpotEntry('ETH/USD'));
            assert(response.price > 0, Errors::FETCHING_ETH_PRICE_ERROR);
            (usd * pow(10, response.decimals.into()) * 1000000000000000000)
                / (response.price * 100000000)
        }

        fn _deposit_prizes(
            ref self: ComponentState<TContractState>,
            ref prizes: Array<PrizeType>,
            leaderboard_size: u8
        ) {
            let num_prizes = prizes.len();
            let mut prize_index = 0;
            loop {
                if prize_index == num_prizes {
                    break;
                }
                let prize = prizes.at(prize_index);
                match prize {
                    PrizeType::erc20(prize) => {
                        assert(
                            self._is_token_registered(*prize.token), Errors::TOKEN_NOT_REGISTERED
                        );
                        assert(
                            prize.token_distribution.len() == leaderboard_size.into(),
                            Errors::INVALID_DISTRIBUTION
                        );
                        let token_dispatcher = IERC20Dispatcher { contract_address: *prize.token };
                        token_dispatcher
                            .transfer_from(
                                get_caller_address(),
                                get_contract_address(),
                                (*prize.token_amount).into()
                            );
                    },
                    PrizeType::erc721(prize) => {
                        assert(
                            self._is_token_registered(*prize.token), Errors::TOKEN_NOT_REGISTERED
                        );
                        let token_dispatcher = IERC721Dispatcher { contract_address: *prize.token };
                        token_dispatcher
                            .transfer_from(
                                get_caller_address(),
                                get_contract_address(),
                                (*prize.token_id).into()
                            );
                    },
                    PrizeType::erc1155(prize) => {
                        assert(
                            self._is_token_registered(*prize.token), Errors::TOKEN_NOT_REGISTERED
                        );
                        assert(
                            prize.token_distribution.len() == leaderboard_size.into(),
                            Errors::INVALID_DISTRIBUTION
                        );
                        let token_dispatcher = IERC1155Dispatcher {
                            contract_address: *prize.token
                        };
                        let data = ArrayTrait::<felt252>::new();
                        token_dispatcher
                            .safe_transfer_from(
                                get_caller_address(),
                                get_contract_address(),
                                (*prize.token_id).into(),
                                (*prize.token_amount).into(),
                                data.span()
                            );
                    },
                }
                prize_index += 1;
            }
        }

        fn _distribute_prizes(
            ref self: ComponentState<TContractState>,
            prizes: Array<PrizeType>,
            ref top_score_ids: Array<u128>
        ) {
            let contracts = self.get_contracts();
            let num_prizes = prizes.len();
            let mut prize_index = 0;
            loop {
                if prize_index == num_prizes {
                    break;
                }
                let prize = prizes.at(prize_index);

                match prize {
                    PrizeType::erc20(prize) => {
                        let token_dispatcher = IERC20Dispatcher { contract_address: *prize.token };

                        let num_distributions = prize.token_distribution.len();
                        let mut distribution_index = 0;
                        loop {
                            if distribution_index == num_distributions {
                                break;
                            }
                            let prize_distribution = prize.token_distribution;
                            let distribution = *prize_distribution.at(distribution_index);
                            let score_id = *top_score_ids.at(distribution_index);
                            let score = self.get_score_from_id(score_id);
                            let amount = self
                                ._calculate_payout(distribution.into(), *prize.token_amount);
                            if (amount > 0) {
                                let address = self
                                    ._get_owner(contracts.loot_survivor, score.into());
                                token_dispatcher.transfer(address, amount.into());
                            }
                            distribution_index += 1;
                        };
                    },
                    PrizeType::erc721(prize) => {
                        let token_dispatcher = IERC721Dispatcher { contract_address: *prize.token };
                        let distribution_position = *prize.position;
                        let score_id = *top_score_ids.at(distribution_position.into() - 1);
                        let score = self.get_score_from_id(score_id);
                        let address = self._get_owner(contracts.loot_survivor, score.into());
                        token_dispatcher
                            .transfer_from(
                                get_contract_address(), address, (*prize.token_id).into()
                            );
                    },
                    PrizeType::erc1155(prize) => {
                        let token_dispatcher = IERC1155Dispatcher {
                            contract_address: *prize.token
                        };
                        let data = ArrayTrait::<felt252>::new();

                        let num_distributions = prize.token_distribution.len();
                        let mut distribution_index = 0;
                        loop {
                            if distribution_index == num_distributions {
                                break;
                            }
                            let prize_distribution = prize.token_distribution;
                            let distribution = *prize_distribution.at(distribution_index);
                            let score_id = *top_score_ids.at(distribution_index);
                            let score = self.get_score_from_id(score_id);
                            let amount = self
                                ._calculate_payout(distribution.into(), *prize.token_amount);
                            if (amount > 0) {
                                let address = self
                                    ._get_owner(contracts.loot_survivor, score.into());
                                token_dispatcher
                                    .safe_transfer_from(
                                        get_contract_address(),
                                        address,
                                        (*prize.token_id).into(),
                                        amount.into(),
                                        data.span()
                                    );
                            }
                            distribution_index += 1;
                        };
                    },
                }
                prize_index += 1;
            }
        }

        fn _assert_has_qualifying_nft(
            self: @ComponentState<TContractState>,
            gated_token: ContractAddress,
            account: ContractAddress,
            token_id: u256
        ) {
            let owner = self._get_owner(gated_token, token_id);
            assert(owner == account, Errors::NO_QUALIFYING_NFT);
        }

        fn _assert_tournament_is_active(self: @ComponentState<TContractState>, tournament_id: u64) {
            let is_active = self._is_tournament_active(tournament_id);
            assert(is_active, Errors::TOURNAMENT_NOT_STARTED);
        }

        fn _assert_tournament_ended(self: @ComponentState<TContractState>, tournament_id: u64) {
            let tournament = self.get_tournament(tournament_id);
            assert(tournament.end_time <= get_block_timestamp(), Errors::TOURNAMENT_NOT_ENDED);
        }

        fn _assert_tournament_not_claimed(
            self: @ComponentState<TContractState>, tournament_id: u64
        ) {
            let tournament = self.get_tournament(tournament_id);
            assert(!tournament.claimed, Errors::TOURNAMENT_ALREADY_CLAIMED);
        }

        fn _assert_tournament_entry(
            self: @ComponentState<TContractState>, tournament_id: u64, game_id: u256
        ) {
            let entry = self.get_tournament_entry(tournament_id, game_id);
            assert(entry.entered, Errors::TOURNAMENT_NOT_ACTIVE);
        }

        fn _assert_tournament_not_submitted(
            self: @ComponentState<TContractState>, tournament_id: u64, game_id: u256
        ) {
            let entry = self.get_tournament_entry(tournament_id, game_id);
            assert(!entry.submitted_score, Errors::TOURNAMENT_ENTRY_ALREADY_SUBMITTED);
        }

        fn _assert_token_owner(
            self: @ComponentState<TContractState>,
            tournament_id: u64,
            game_id: u256,
            account: ContractAddress
        ) {
            let contracts = self.get_contracts();
            let owner = self._get_owner(contracts.loot_survivor, game_id);
            assert(owner == account, Errors::NOT_OWNER);
        }

        fn _assert_valid_score(self: @ComponentState<TContractState>, adventurer: Adventurer) {
            assert(adventurer.health == 0, Errors::INVALID_SCORE);
        }

        // TODO: add stat requirements in v2
        fn _assert_stat_requirements(
            self: @ComponentState<TContractState>, tournament_id: u64, adventurer: Adventurer
        ) {
            let stat_requirements: Array<StatRequirement> = self
                .get_tournament(tournament_id)
                .stat_requirements;

            let num_requirements = stat_requirements.len();
            let mut requirement_index = 0;
            loop {
                if requirement_index == num_requirements {
                    break;
                }
                // get requirement
                let requirement: StatRequirement = *stat_requirements.at(requirement_index);
                // handle requirement stat
                match requirement.stat.into() {
                    StatRequirementEnum::Xp => {
                        self
                            ._assert_stat_operation(
                                adventurer.xp, requirement.value, requirement.operation
                            );
                    },
                    StatRequirementEnum::Gold => {
                        self
                            ._assert_stat_operation(
                                adventurer.gold, requirement.value, requirement.operation
                            );
                    },
                    StatRequirementEnum::Strength => {
                        self
                            ._assert_stat_operation(
                                adventurer.stats.strength.into(),
                                requirement.value,
                                requirement.operation
                            );
                    },
                    StatRequirementEnum::Dexterity => {
                        self
                            ._assert_stat_operation(
                                adventurer.stats.dexterity.into(),
                                requirement.value,
                                requirement.operation
                            );
                    },
                    StatRequirementEnum::Vitality => {
                        self
                            ._assert_stat_operation(
                                adventurer.stats.vitality.into(),
                                requirement.value,
                                requirement.operation
                            );
                    },
                    StatRequirementEnum::Intelligence => {
                        self
                            ._assert_stat_operation(
                                adventurer.stats.intelligence.into(),
                                requirement.value,
                                requirement.operation
                            );
                    },
                    StatRequirementEnum::Wisdom => {
                        self
                            ._assert_stat_operation(
                                adventurer.stats.wisdom.into(),
                                requirement.value,
                                requirement.operation
                            );
                    },
                    StatRequirementEnum::Charisma => {
                        self
                            ._assert_stat_operation(
                                adventurer.stats.charisma.into(),
                                requirement.value,
                                requirement.operation
                            );
                    },
                    StatRequirementEnum::Luck => {
                        self
                            ._assert_stat_operation(
                                adventurer.stats.luck.into(),
                                requirement.value,
                                requirement.operation
                            );
                    },
                };
                requirement_index += 1;
            }
        }

        fn _assert_stat_operation(
            self: @ComponentState<TContractState>, stat: u16, value: u16, operation: Operation,
        ) {
            match operation {
                Operation::GreaterThan => {
                    assert(stat > value, 'Tournament: requirement not met');
                },
                Operation::LessThan => { assert(stat < value, 'Tournament: requirement not met'); },
                Operation::Equal => { assert(stat == value, 'Tournament: requirement not met'); }
            };
        }

        fn _get_owner(
            self: @ComponentState<TContractState>, token: ContractAddress, token_id: u256
        ) -> ContractAddress {
            IERC721Dispatcher { contract_address: token }.owner_of(token_id)
        }

        fn _get_entries(
            self: @ComponentState<TContractState>, gated_token: GatedToken, token_id: u256
        ) -> u8 {
            let entry_criteria = gated_token.entry_criteria;

            let mut entry_count = 0;
            let num_criteria = entry_criteria.len();
            let mut criteria_index = 0;
            match gated_token.token_type {
                TokenType::ERC20 => {
                    let balance = IERC20Dispatcher { contract_address: gated_token.token }
                        .balance_of(get_caller_address());
                    loop {
                        if criteria_index == num_criteria {
                            break;
                        }
                        let criteria = *entry_criteria.at(criteria_index);
                        if balance.low >= criteria.token_amount {
                            entry_count += criteria.entry_count;
                        }
                        criteria_index += 1;
                    };
                },
                TokenType::ERC721 => {
                    loop {
                        if criteria_index == num_criteria {
                            break;
                        }
                        let criteria = *entry_criteria.at(criteria_index);
                        if criteria.token_id == token_id.low {
                            entry_count += criteria.entry_count;
                        }
                        criteria_index += 1;
                    };
                },
                TokenType::ERC1155 => {
                    let balance = IERC1155Dispatcher { contract_address: gated_token.token }
                        .balance_of(get_caller_address(), token_id);
                    loop {
                        if criteria_index == num_criteria {
                            break;
                        }
                        let criteria = *entry_criteria.at(criteria_index);
                        if balance.low >= criteria.token_amount {
                            entry_count += criteria.entry_count;
                        }
                        criteria_index += 1;
                    };
                }
            }
            entry_count
        }

        fn _calculate_payout(
            ref self: ComponentState<TContractState>, bp: u128, price: u128
        ) -> u128 {
            (bp * price) / 100
        }
    }
}
