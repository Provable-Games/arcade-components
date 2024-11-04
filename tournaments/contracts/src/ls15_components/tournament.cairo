use starknet::ContractAddress;
use tournament::ls15_components::interfaces::{
    LootRequirement, Token, StatRequirement, GatedToken, Premium
};
use tournament::ls15_components::constants::{
    TokenDataType, EntryStatus, GatedType, GatedSubmissionType
};

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

#[dojo::model]
#[derive(Drop, Serde)]
struct TournamentModel {
    #[key]
    tournament_id: u64,
    name: felt252, // change to felt to do name
    description: ByteArray,
    creator: ContractAddress,
    start_time: u64,
    end_time: u64,
    submission_period: u64,
    winners_count: u8,
    gated_type: Option<GatedType>,
    entry_premium: Option<Premium>,
}

#[dojo::model]
#[derive(Copy, Drop, Serde)]
struct TournamentEntryModel {
    #[key]
    tournament_id: u64,
    #[key]
    game_id: u64,
    address: ContractAddress,
    status: EntryStatus,
}

#[dojo::model]
#[derive(Drop, Serde)]
struct TournamentEntryAddressesModel {
    #[key]
    tournament_id: u64,
    addresses: Array<ContractAddress>,
}

#[dojo::model]
#[derive(Drop, Serde)]
struct TournamentEntriesAddressModel {
    #[key]
    tournament_id: u64,
    #[key]
    address: ContractAddress,
    entry_count: u64,
}

#[dojo::model]
#[derive(Drop, Serde)]
struct TournamentStartIdsModel {
    #[key]
    tournament_id: u64,
    #[key]
    address: ContractAddress,
    game_ids: Array<u64>,
}

#[dojo::model]
#[derive(Drop, Serde)]
struct TournamentEntriesModel {
    #[key]
    tournament_id: u64,
    entry_count: u64,
    premiums_formatted: bool,
    distribute_called: bool,
}

#[dojo::model]
#[derive(Drop, Serde)]
struct TournamentScoresModel {
    #[key]
    tournament_id: u64,
    top_score_ids: Array<u64>,
}

#[dojo::model]
#[derive(Copy, Drop, Serde)]
struct TournamentTotalsModel {
    #[key]
    contract: ContractAddress,
    total_tournaments: u64,
    total_prizes: u64,
}

#[dojo::model]
#[derive(Drop, Serde)]
struct TournamentPrizeKeysModel {
    #[key]
    tournament_id: u64,
    prize_keys: Array<u64>,
}

#[dojo::model]
#[derive(Copy, Drop, Serde)]
struct PrizesModel {
    #[key]
    prize_key: u64,
    token: ContractAddress,
    token_data_type: TokenDataType,
    payout_position: u8,
    claimed: bool
}

#[dojo::model]
#[derive(Drop, Serde)]
struct TokenModel {
    #[key]
    token: ContractAddress,
    name: ByteArray,
    symbol: ByteArray,
    token_data_type: TokenDataType,
    is_registered: bool,
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
    fn tournament_entries(self: @TState, tournament_id: u64) -> u64;
    fn tournament_prize_keys(self: @TState, tournament_id: u64) -> Array<u64>;
    fn top_scores(self: @TState, tournament_id: u64) -> Array<u64>;
    fn is_tournament_active(self: @TState, tournament_id: u64) -> bool;
    fn is_token_registered(self: @TState, token: ContractAddress) -> bool;
    fn create_tournament(
        ref self: TState,
        name: felt252,
        description: ByteArray,
        start_time: u64,
        end_time: u64,
        submission_period: u64,
        winners_count: u8,
        gated_type: Option<GatedType>,
        entry_premium: Option<Premium>,
    ) -> u64;
    fn register_tokens(ref self: TState, tokens: Array<Token>);
    fn enter_tournament(
        ref self: TState, tournament_id: u64, gated_submission_type: Option<GatedSubmissionType>
    );
    fn start_tournament(
        ref self: TState, tournament_id: u64, start_all: bool, start_count: Option<u64>
    );
    fn submit_scores(ref self: TState, tournament_id: u64, game_ids: Array<felt252>);
    fn add_prize(
        ref self: TState,
        tournament_id: u64,
        token: ContractAddress,
        token_data_type: TokenDataType,
        position: u8
    );
    fn distribute_prizes(ref self: TState, tournament_id: u64, prize_keys: Array<u64>);
}

///
/// Tournament Component
///
#[starknet::component]
mod tournament_component {
    use super::TournamentModel;
    use super::TournamentEntryModel;
    use super::TournamentEntryAddressesModel;
    use super::TournamentEntriesAddressModel;
    use super::TournamentStartIdsModel;
    use super::TournamentEntriesModel;
    use super::TournamentScoresModel;
    use super::TournamentTotalsModel;
    use super::TournamentPrizeKeysModel;
    use super::PrizesModel;
    use super::TokenModel;
    use super::TournamentContracts;
    use super::ITournament;

    use super::pow;

    use tournament::ls15_components::constants::{
        LOOT_SURVIVOR, Operation, StatRequirementEnum, LORDS, ETH, ORACLE, VRF_COST_PER_GAME,
        TWO_POW_128, MIN_REGISTRATION_PERIOD, MAX_REGISTRATION_PERIOD, MIN_TOURNAMENT_LENGTH,
        MAX_TOURNAMENT_LENGTH, MIN_SUBMISSION_PERIOD, MAX_SUBMISSION_PERIOD, GAME_EXPIRATION_PERIOD,
        TokenDataType, EntryStatus, GatedType, GatedSubmissionType, GatedEntryType
    };
    use tournament::ls15_components::interfaces::{
        LootRequirement, Token, StatRequirement, ILootSurvivor, ILootSurvivorDispatcher,
        ILootSurvivorDispatcherTrait, IPragmaABI, IPragmaABIDispatcher, IPragmaABIDispatcherTrait,
        AggregationMode, DataType, PragmaPricesResponse, GatedToken, Premium, ERC20Data
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

    use adventurer::{adventurer::Adventurer, bag::Bag};

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
        AddNewPrize: AddNewPrize,
        ClaimTournament: ClaimTournament,
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
        game_id: felt252,
        score: u16,
    }

    #[derive(Copy, Drop, Serde, starknet::Event)]
    struct NewHighScore {
        tournament_id: u64,
        game_id: felt252,
        score: u16,
        rank: u8,
    }

    #[derive(Copy, Drop, Serde, starknet::Event)]
    struct AddNewPrize {
        tournament_id: u64,
        token: ContractAddress,
        token_data_type: TokenDataType,
        payout_position: u8,
    }

    #[derive(Copy, Drop, Serde, starknet::Event)]
    struct ClaimTournament {
        tournament_id: u64,
    }

    #[derive(Copy, Drop, Serde, starknet::Event)]
    struct RegisterToken {
        token: ContractAddress,
        token_data_type: TokenDataType,
    }

    mod Errors {
        //
        // Create Tournament
        //
        const START_TIME_NOT_AFTER_MIN_REGISTRATION: felt252 = 'start time too close';
        const START_TIME_NOT_BEFORE_MAX_REGISTRATION: felt252 = 'start time too far';
        const TOURNAMENT_TOO_SHORT: felt252 = 'tournament too short';
        const TOURNAMENT_TOO_LONG: felt252 = 'tournament too long';
        const ZERO_WINNERS_COUNT: felt252 = 'zero winners count';
        const NO_QUALIFYING_NFT: felt252 = 'no qualifying nft';
        const GATED_TOKEN_NOT_REGISTERED: felt252 = 'gated token not registered';
        const PREMIUM_TOKEN_NOT_REGISTERED: felt252 = 'premium token not registered';
        const PREMIUM_DISTRIBUTIONS_TOO_LONG: felt252 = 'premium distributions too long';
        const PREMIUM_DISTRIBUTIONS_NOT_100: felt252 = 'premium distributions not 100%';
        const SUBMISSION_PERIOD_TOO_SHORT: felt252 = 'submission period too short';
        const SUBMISSION_PERIOD_TOO_LONG: felt252 = 'submission period too long';
        //
        // Register Tokens
        //
        const TOKEN_ALREADY_REGISTERED: felt252 = 'token already registered';
        const INVALID_TOKEN_ALLOWANCES: felt252 = 'invalid token allowances';
        const INVALID_TOKEN_BALANCES: felt252 = 'invalid token balances';
        const TOKEN_SUPPLY_TOO_LARGE: felt252 = 'token supply too large';
        const INVALID_TOKEN_APPROVALS: felt252 = 'invalid token approvals';
        const INVALID_TOKEN_OWNER: felt252 = 'invalid token owner';
        //
        // Enter Tournament
        //
        const TOURNAMENT_ALREADY_STARTED: felt252 = 'tournament already started';
        const TOURNAMENT_NOT_STARTED: felt252 = 'tournament not started';
        //
        // Start Tournament
        //
        const TOURNAMENT_NOT_ACTIVE: felt252 = 'tournament not active';
        const FETCHING_ETH_PRICE_ERROR: felt252 = 'error fetching eth price';
        const ALL_ENTRIES_STARTED: felt252 = 'all entries started';
        const ADDRESS_ENTRIES_STARTED: felt252 = 'address entries started';
        const START_COUNT_TOO_LARGE: felt252 = 'start count too large';
        const TOURNAMENT_PERIOD_TOO_LONG: felt252 = 'period too long to start all';
        //
        // Submit Scores
        //
        const TOURNAMENT_NOT_ENDED: felt252 = 'tournament not ended';
        const TOURNAMENT_ALREADY_SETTLED: felt252 = 'tournament already settled';
        const NOT_GAME_OWNER: felt252 = 'not game owner';
        const GAME_NOT_STARTED: felt252 = 'game not started';
        const INVALID_SCORES_SUBMISSION: felt252 = 'invalid scores submission';
        const INVALID_SCORE: felt252 = 'invalid score';
        const INVALID_GATED_SUBMISSION_TYPE: felt252 = 'invalid gated submission type';
        const INVALID_SUBMITTED_GAMES_LENGTH: felt252 = 'invalid submitted games length';
        const NOT_OWNER_OF_SUBMITTED_GAME_ID: felt252 = 'not owner of submitted game';
        const SUBMITTED_GAME_NOT_TOP_SCORE: felt252 = 'submitted game not top score';
        //
        // Add Prize
        //
        const PRIZE_POSITION_TOO_LARGE: felt252 = 'prize position too large';
        const PRIZE_TOKEN_NOT_REGISTERED: felt252 = 'prize token not registered';
        //
        // Distribute Prizes
        //
        const TOURNAMENT_NOT_SETTLED: felt252 = 'tournament not settled';
        const DISTRIBUTE_ALREADY_CALLED: felt252 = 'distribute already called';
        const NO_PRIZE_KEYS: felt252 = 'no prize keys provided';
        const PRIZE_DOES_NOT_EXIST: felt252 = 'prize does not exist';
        const PRIZE_ALREADY_CLAIMED: felt252 = 'prize already claimed';
    }

    #[embeddable_as(TournamentImpl)]
    impl Tournament<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        +Drop<TContractState>
    > of ITournament<ComponentState<TContractState>> {
        fn total_tournaments(self: @ComponentState<TContractState>) -> u64 {
            self.get_totals().total_tournaments
        }

        fn tournament(
            self: @ComponentState<TContractState>, tournament_id: u64
        ) -> TournamentModel {
            self.get_tournament(tournament_id)
        }

        fn tournament_entries(self: @ComponentState<TContractState>, tournament_id: u64) -> u64 {
            self.get_total_entries(tournament_id).entry_count
        }

        fn tournament_prize_keys(self: @ComponentState<TContractState>, tournament_id: u64) -> Array<u64> {
            self.get_prize_keys(tournament_id).prize_keys
        }

        fn top_scores(self: @ComponentState<TContractState>, tournament_id: u64) -> Array<u64> {
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
            name: felt252,
            description: ByteArray,
            start_time: u64,
            end_time: u64,
            submission_period: u64,
            winners_count: u8,
            gated_type: Option<GatedType>,
            entry_premium: Option<Premium>,
        ) -> u64 {
            self._assert_start_time_after_min_registration(start_time);
            self._assert_start_time_before_max_registration(start_time);
            self._assert_tournament_length_not_too_short(end_time, start_time);
            self._assert_tournament_length_not_too_long(end_time, start_time);
            self._assert_submission_period_larger_than_minimum(submission_period);
            self._assert_submission_period_less_than_maximum(submission_period);
            self._assert_winners_count_greater_than_zero(winners_count);
            self._assert_gated_type_validates(gated_type);
            self
                ._assert_premium_token_registered_and_distribution_valid(
                    entry_premium.clone(), winners_count
                );

            // create a new tournament
            self
                ._create_tournament(
                    name,
                    description,
                    get_caller_address(),
                    start_time,
                    end_time,
                    submission_period,
                    winners_count,
                    gated_type,
                    entry_premium,
                )
        }

        fn register_tokens(ref self: ComponentState<TContractState>, tokens: Array<Token>) {
            self._register_tokens(tokens);
        }

        // gated token entries must play using all entry allowances
        fn enter_tournament(
            ref self: ComponentState<TContractState>,
            tournament_id: u64,
            gated_submission_type: Option<GatedSubmissionType>,
        ) {
            // assert tournament has not started
            self._assert_tournament_not_started(tournament_id);

            let tournament = self.get_tournament(tournament_id);

            let mut entries: u64 = 1;

            // if tournament is gated then assert the submission type qualifies
            // also add mutate the entries based on criteria
            match tournament.gated_type {
                Option::Some(gated_type) => {
                    self
                        ._assert_gated_submission_qualifies(
                            gated_type, gated_submission_type, get_caller_address(), ref entries
                        );
                },
                Option::None => {},
            };

            // if tournament has a premium then transfer it
            match tournament.entry_premium {
                Option::Some(premium) => {
                    let premium_dispatcher = IERC20Dispatcher { contract_address: premium.token };
                    premium_dispatcher
                        .transfer_from(
                            get_caller_address(),
                            get_contract_address(),
                            entries.into() * premium.token_amount.into()
                        );
                },
                Option::None => {},
            };
            let address_entries = self.get_address_entries(tournament_id, get_caller_address());
            // if caller not currently stored append their address
            if (address_entries.entry_count == 0) {
                self.append_tournament_address_list(tournament_id, get_caller_address());
            }
            // increment both entries by address and total entries
            self.increment_entries(tournament_id, entries);
            // TODO: can store multiple game ids in single felt with merkle tree?
        }

        fn start_tournament(
            ref self: ComponentState<TContractState>,
            tournament_id: u64,
            start_all: bool,
            start_count: Option<u64>,
        ) {
            // assert tournament is active
            self._assert_tournament_active(tournament_id);
            // if starting all games, assert the tournament period is within max
            if (start_all) {
                self._assert_tournament_period_within_max(tournament_id);
            }

            let total_entries = self.get_total_entries(tournament_id);

            // handle formatiing of premium config into prize keys
            if (!total_entries.premiums_formatted) {
                self._format_premium_config_into_prize_keys(tournament_id);
            }

            let mut entries = 0;

            if start_all {
                // if starting all games, assert there are entries that haven't started
                // get the total number of entries to mint
                let addresses = self.get_tournament_entry_addresses(tournament_id).addresses;
                assert(addresses.len() > 0, Errors::ALL_ENTRIES_STARTED);
                entries = self._calculate_total_entries(tournament_id, addresses);
            } else {
                let address_entries = self
                    .get_address_entries(tournament_id, get_caller_address())
                    .entry_count;
                assert(address_entries > 0, Errors::ALL_ENTRIES_STARTED);
                match start_count {
                    Option::Some(start_count) => {
                        assert(address_entries >= start_count, Errors::START_COUNT_TOO_LARGE);
                        entries = start_count;
                    },
                    Option::None => {
                        assert(address_entries > 0, Errors::ADDRESS_ENTRIES_STARTED);
                        entries = address_entries;
                    },
                };
            }

            // define contract interfaces
            let tournament_contracts = self.get_tournament_contracts();
            let mut ls_dispatcher = ILootSurvivorDispatcher {
                contract_address: tournament_contracts.loot_survivor
            };
            let lords_dispatcher: IERC20Dispatcher = IERC20Dispatcher {
                contract_address: tournament_contracts.lords
            };
            let eth_dispatcher: IERC20Dispatcher = IERC20Dispatcher {
                contract_address: tournament_contracts.eth
            };

            // get current game cost
            let cost_to_play = ls_dispatcher.get_cost_to_play();

            // transfer base game cost
            lords_dispatcher
                .transfer_from(
                    get_caller_address(),
                    get_contract_address(),
                    entries.into() * cost_to_play.into()
                );

            // transfer VRF cost
            let vrf_cost = self._convert_usd_to_wei(entries.into() * VRF_COST_PER_GAME.into());
            eth_dispatcher
                .transfer_from(get_caller_address(), get_contract_address(), vrf_cost.into());

            // set the approvals according to entries
            lords_dispatcher
                .approve(tournament_contracts.loot_survivor, entries.into() * cost_to_play.into());
            eth_dispatcher.approve(tournament_contracts.loot_survivor, vrf_cost.into());

            let tournament = self.get_tournament(tournament_id);

            // to avoid extra storage we are just providing defualt configs for the adventurers
            if start_all {
                // if start all then we need to loop through stored  addresses and mint games
                // for each
                let addresses = self.get_tournament_entry_addresses(tournament_id).addresses;
                let mut address_index = 0;
                loop {
                    if address_index == addresses.len() {
                        break;
                    }
                    let address = *addresses.at(address_index);
                    let address_entries = self
                        .get_address_entries(tournament_id, address)
                        .entry_count;
                    let mut entry_index = 0;
                    let mut game_ids = ArrayTrait::<u64>::new();
                    loop {
                        if entry_index == address_entries {
                            break;
                        }
                        let game_id = ls_dispatcher
                            .new_game(
                                get_contract_address(),
                                12, // wand
                                tournament.name,
                                0,
                                true,
                                contract_address_const::<0>(),
                                0,
                                address
                            );
                        game_ids.append(game_id.try_into().unwrap());
                        set!(
                            self.get_contract().world(),
                            TournamentEntryModel {
                                tournament_id,
                                game_id: game_id.try_into().unwrap(),
                                address: address,
                                status: EntryStatus::Started
                            }
                        );
                        entry_index += 1;
                    };
                    self.set_tournament_starts(tournament_id, address, game_ids);
                    // set entries to 0
                    self.set_tournament_entries(tournament_id, address, 0);
                    address_index += 1;
                };
                // set stored addresses to empty
                let mut addresses = ArrayTrait::<ContractAddress>::new();
                self.set_tournament_address_list(tournament_id, addresses);
            } else {
                let mut entry_index = 0;
                let mut game_ids = ArrayTrait::<u64>::new();
                loop {
                    if entry_index == entries {
                        break;
                    }
                    let game_id = ls_dispatcher
                        .new_game(
                            get_contract_address(),
                            12, // wand
                            tournament.name,
                            0,
                            true,
                            contract_address_const::<0>(),
                            0,
                            get_caller_address()
                        );
                    game_ids.append(game_id.try_into().unwrap());
                    set!(
                        self.get_contract().world(),
                        TournamentEntryModel {
                            tournament_id,
                            game_id: game_id.try_into().unwrap(),
                            address: get_caller_address(),
                            status: EntryStatus::Started
                        }
                    );
                    entry_index += 1;
                };
                // set stored started game ids and new entries (if no start count provided then
                // entries - entry_index will be 0)
                self.set_tournament_starts(tournament_id, get_caller_address(), game_ids);
                self
                    .set_tournament_entries(
                        tournament_id, get_caller_address(), entries - entry_index
                    );
            }
        }

        // for more efficient gas we assume that the game ids are in order of highest score
        fn submit_scores(
            ref self: ComponentState<TContractState>, tournament_id: u64, game_ids: Array<felt252>
        ) {
            // assert tournament ended but not settled
            self._assert_tournament_ended(tournament_id);
            // assert the submitted scores are less than or equal to the winners count
            self._assert_scores_count_valid(tournament_id, game_ids.len());
            // assert submission period is not over
            self._assert_tournament_not_settled(tournament_id);

            let contracts = self.get_tournament_contracts();
            let mut ls_dispatcher = ILootSurvivorDispatcher {
                contract_address: contracts.loot_survivor
            };

            // loop through game ids and update scores
            let mut num_games = game_ids.len();
            let mut game_index = 0;
            let mut new_score_ids = ArrayTrait::<u64>::new();
            loop {
                if game_index == num_games {
                    break;
                }
                let game_id = *game_ids.at(game_index);
                self._assert_game_started_or_submitted(tournament_id, game_id);

                let adventurer = ls_dispatcher.get_adventurer(game_id.try_into().unwrap());
                let death_date = self.get_death_date_from_id(game_id);

                self._assert_valid_score(adventurer);

                self
                    ._update_tournament_scores(
                        tournament_id,
                        game_id,
                        adventurer.xp,
                        death_date,
                        ref new_score_ids,
                        game_index
                    );

                self.set_submitted_score(tournament_id, game_id, adventurer.xp);
                game_index += 1;
            };
            set!(
                self.get_contract().world(),
                (TournamentScoresModel { tournament_id, top_score_ids: new_score_ids })
            );
        }

        fn add_prize(
            ref self: ComponentState<TContractState>,
            tournament_id: u64,
            token: ContractAddress,
            token_data_type: TokenDataType,
            position: u8
        ) {
            // assert tournament has not started
            self._assert_tournament_not_started(tournament_id);

            self._deposit_prize(tournament_id, token, token_data_type, position);
        }

        fn distribute_prizes(
            ref self: ComponentState<TContractState>, tournament_id: u64, prize_keys: Array<u64>,
        ) {
            // assert tournament settled
            self._assert_tournament_settled(tournament_id);
            self._assert_prize_keys_not_empty(prize_keys.span());

            let total_entries = self.get_total_entries(tournament_id);

            // if noone has started the tournament already, then we need to create the prize keys
            // (this should already be taken into account in the provided list)
            if (!total_entries.premiums_formatted) {
                self._format_premium_config_into_prize_keys(tournament_id);
            }

            let top_score_ids = self.get_tournament_scores(tournament_id).top_score_ids;
            // check if top scores empty then refund prizes and premiums
            // else, distribute to top scores
            if top_score_ids.len() == 0 {
                self._assert_distribute_has_not_been_called(tournament_id);
                self._distribute_prizes_to_address(tournament_id, prize_keys, get_caller_address());
                self.set_tournament_distribute_called(tournament_id);
            } else {
                self
                    ._distribute_prizes_to_top_scores(
                        tournament_id, prize_keys, top_score_ids.span()
                    );
            };
        }
    }


    #[generate_trait]
    impl InternalImpl<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        +Drop<TContractState>
    > of InternalTrait<TContractState> {
        //
        // INITIALIZE
        //
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

        //
        // GETTERS
        //

        fn get_tournament_contracts(self: @ComponentState<TContractState>) -> TournamentContracts {
            get!(self.get_contract().world(), (get_contract_address()), (TournamentContracts))
        }

        fn get_totals(self: @ComponentState<TContractState>) -> TournamentTotalsModel {
            get!(self.get_contract().world(), (get_contract_address()), (TournamentTotalsModel))
        }

        fn get_tournament(
            self: @ComponentState<TContractState>, tournament_id: u64
        ) -> TournamentModel {
            get!(self.get_contract().world(), (tournament_id), (TournamentModel))
        }

        fn get_tournament_entry(
            self: @ComponentState<TContractState>, tournament_id: u64, game_id: felt252
        ) -> TournamentEntryModel {
            let game_id: u64 = game_id.try_into().unwrap();
            get!(self.get_contract().world(), (tournament_id, game_id), (TournamentEntryModel))
        }

        fn get_tournament_entry_addresses(
            self: @ComponentState<TContractState>, tournament_id: u64
        ) -> TournamentEntryAddressesModel {
            get!(self.get_contract().world(), (tournament_id), (TournamentEntryAddressesModel))
        }

        fn get_address_entries(
            self: @ComponentState<TContractState>, tournament_id: u64, address: ContractAddress
        ) -> TournamentEntriesAddressModel {
            get!(
                self.get_contract().world(),
                (tournament_id, address),
                (TournamentEntriesAddressModel)
            )
        }

        fn get_total_entries(
            self: @ComponentState<TContractState>, tournament_id: u64
        ) -> TournamentEntriesModel {
            get!(self.get_contract().world(), (tournament_id), (TournamentEntriesModel))
        }

        fn get_address_started_game_ids(
            self: @ComponentState<TContractState>, tournament_id: u64, address: ContractAddress
        ) -> TournamentStartIdsModel {
            get!(self.get_contract().world(), (tournament_id, address), (TournamentStartIdsModel))
        }

        fn get_tournament_scores(
            self: @ComponentState<TContractState>, tournament_id: u64
        ) -> TournamentScoresModel {
            get!(self.get_contract().world(), (tournament_id), (TournamentScoresModel))
        }

        fn get_score_from_id(self: @ComponentState<TContractState>, game_id: felt252) -> u16 {
            let ls_dispatcher = ILootSurvivorDispatcher {
                contract_address: self.get_tournament_contracts().loot_survivor
            };
            ls_dispatcher.get_adventurer(game_id).xp
        }

        fn get_death_date_from_id(self: @ComponentState<TContractState>, game_id: felt252) -> u64 {
            let ls_dispatcher = ILootSurvivorDispatcher {
                contract_address: self.get_tournament_contracts().loot_survivor
            };
            ls_dispatcher.get_adventurer_meta(game_id).death_date
        }

        fn get_prize_keys(
            self: @ComponentState<TContractState>, tournament_id: u64
        ) -> TournamentPrizeKeysModel {
            get!(self.get_contract().world(), (tournament_id), (TournamentPrizeKeysModel))
        }

        fn get_prize(
            self: @ComponentState<TContractState>, prize_key: u64
        ) -> PrizesModel {
            get!(self.get_contract().world(), (prize_key), (PrizesModel))
        }

        fn _get_owner(
            self: @ComponentState<TContractState>, token: ContractAddress, token_id: u256
        ) -> ContractAddress {
            IERC721Dispatcher { contract_address: token }.owner_of(token_id)
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
                let last_place_score = self.get_score_from_id(last_place_id.try_into().unwrap());
                score >= last_place_score
            }
        }

        fn _is_token_registered(
            self: @ComponentState<TContractState>, token: ContractAddress
        ) -> bool {
            let stored_token = get!(self.get_contract().world(), (token), (TokenModel));
            stored_token.is_registered
        }

        fn _is_gated_token_registered(
            self: @ComponentState<TContractState>, gated_type: Option<GatedType>
        ) -> bool {
            match gated_type {
                Option::Some(token) => {
                    match token {
                        GatedType::token(token) => { self._is_token_registered(token.token) },
                        GatedType::tournament(_) => { true },
                    }
                },
                Option::None => true,
            }
        }

        //
        // SETTERS
        //

        fn set_total_tournaments(self: @ComponentState<TContractState>, total_tournaments: u64) {
            let mut totals = self.get_totals();
            totals.total_tournaments = total_tournaments;
            set!(self.get_contract().world(), (totals));
        }

        fn set_tournament_entries(
            self: @ComponentState<TContractState>,
            tournament_id: u64,
            address: ContractAddress,
            entries: u64
        ) {
            set!(
                self.get_contract().world(),
                TournamentEntriesAddressModel { tournament_id, address, entry_count: entries }
            );
        }

        fn increment_entries(
            self: @ComponentState<TContractState>, tournament_id: u64, entries: u64
        ) {
            let address_entries = self.get_address_entries(tournament_id, get_caller_address());
            set!(
                self.get_contract().world(),
                TournamentEntriesAddressModel {
                    tournament_id,
                    address: get_caller_address(),
                    entry_count: address_entries.entry_count + entries
                }
            );
            let total_entries = self.get_total_entries(tournament_id);
            set!(
                self.get_contract().world(),
                TournamentEntriesModel {
                    tournament_id,
                    entry_count: total_entries.entry_count + entries,
                    premiums_formatted: total_entries.premiums_formatted,
                    distribute_called: total_entries.distribute_called
                }
            );
        }

        fn set_tournament_starts(
            self: @ComponentState<TContractState>,
            tournament_id: u64,
            address: ContractAddress,
            game_ids: Array<u64>,
        ) {
            set!(
                self.get_contract().world(),
                TournamentStartIdsModel { tournament_id, address, game_ids }
            );
        }

        fn append_tournament_address_list(
            self: @ComponentState<TContractState>, tournament_id: u64, address: ContractAddress
        ) {
            let mut tournament_addresses = self
                .get_tournament_entry_addresses(tournament_id)
                .addresses;
            tournament_addresses.append(address);
            set!(
                self.get_contract().world(),
                TournamentEntryAddressesModel { tournament_id, addresses: tournament_addresses }
            );
        }

        fn set_tournament_address_list(
            self: @ComponentState<TContractState>,
            tournament_id: u64,
            addresses: Array<ContractAddress>
        ) {
            set!(
                self.get_contract().world(),
                TournamentEntryAddressesModel { tournament_id, addresses }
            );
        }

        fn set_submitted_score(
            ref self: ComponentState<TContractState>,
            tournament_id: u64,
            game_id: felt252,
            score: u16
        ) {
            let entry = self.get_tournament_entry(tournament_id, game_id);
            set!(
                self.get_contract().world(),
                TournamentEntryModel {
                    tournament_id,
                    game_id: game_id.try_into().unwrap(),
                    address: entry.address,
                    status: EntryStatus::Submitted
                }
            );
            let submit_score_event = SubmitScore { tournament_id, game_id, score };
            self.emit(submit_score_event.clone());
            emit!(self.get_contract().world(), (Event::SubmitScore(submit_score_event)));
        }

        fn set_tournament_distribute_called(
            self: @ComponentState<TContractState>, tournament_id: u64
        ) {
            let mut entries = self.get_total_entries(tournament_id);
            entries.distribute_called = true;
            set!(self.get_contract().world(), (entries));
        }

        //
        // ASSERTIONS
        //

        fn _assert_start_time_after_min_registration(
            self: @ComponentState<TContractState>, start_time: u64
        ) {
            assert(
                start_time >= get_block_timestamp() + MIN_REGISTRATION_PERIOD.into(),
                Errors::START_TIME_NOT_AFTER_MIN_REGISTRATION
            );
        }

        fn _assert_start_time_before_max_registration(
            self: @ComponentState<TContractState>, start_time: u64
        ) {
            assert(
                start_time <= get_block_timestamp() + MAX_REGISTRATION_PERIOD.into(),
                Errors::START_TIME_NOT_BEFORE_MAX_REGISTRATION
            );
        }


        fn _assert_tournament_length_not_too_short(
            self: @ComponentState<TContractState>, end_time: u64, start_time: u64
        ) {
            assert(
                end_time - start_time >= MIN_TOURNAMENT_LENGTH.into(), Errors::TOURNAMENT_TOO_SHORT
            );
        }

        fn _assert_tournament_length_not_too_long(
            self: @ComponentState<TContractState>, end_time: u64, start_time: u64
        ) {
            assert(
                end_time - start_time <= MAX_TOURNAMENT_LENGTH.into(), Errors::TOURNAMENT_TOO_LONG
            );
        }


        fn _assert_submission_period_larger_than_minimum(
            self: @ComponentState<TContractState>, submission_period: u64
        ) {
            assert(
                submission_period >= MIN_SUBMISSION_PERIOD.into(),
                Errors::SUBMISSION_PERIOD_TOO_SHORT
            );
        }

        fn _assert_submission_period_less_than_maximum(
            self: @ComponentState<TContractState>, submission_period: u64
        ) {
            assert(
                submission_period <= MAX_SUBMISSION_PERIOD.into(),
                Errors::SUBMISSION_PERIOD_TOO_LONG
            );
        }

        fn _assert_winners_count_greater_than_zero(
            self: @ComponentState<TContractState>, winners_count: u8
        ) {
            assert(winners_count > 0, Errors::ZERO_WINNERS_COUNT);
        }

        fn _assert_premium_token_registered_and_distribution_valid(
            self: @ComponentState<TContractState>, premium: Option<Premium>, winners_count: u8
        ) {
            match premium {
                Option::Some(token) => {
                    self._assert_premium_token_registered(token.token);
                    self
                        ._assert_premium_token_distribution_length_not_too_long(
                            token.token_distribution.len(), winners_count.into()
                        );
                    // check the sum of distributions is equal to 100%
                    let mut distribution_sum: u8 = 0;
                    let mut distribution_index: u32 = 0;
                    loop {
                        if distribution_index == token.token_distribution.len() {
                            break;
                        }
                        let distribution = *token.token_distribution.at(distribution_index);
                        distribution_sum += distribution;
                        distribution_index += 1;
                    };
                    self._assert_premium_token_distribution_sum_is_100(distribution_sum);
                },
                Option::None => {},
            }
        }

        fn _assert_premium_token_registered(
            self: @ComponentState<TContractState>, token: ContractAddress
        ) {
            assert(self._is_token_registered(token), Errors::PREMIUM_TOKEN_NOT_REGISTERED);
        }

        fn _assert_premium_token_distribution_length_not_too_long(
            self: @ComponentState<TContractState>, distribution_length: u32, winners_count: u32
        ) {
            assert(distribution_length <= winners_count, Errors::PREMIUM_DISTRIBUTIONS_TOO_LONG);
        }

        fn _assert_premium_token_distribution_sum_is_100(
            self: @ComponentState<TContractState>, sum: u8
        ) {
            assert(sum == 100, Errors::PREMIUM_DISTRIBUTIONS_NOT_100);
        }

        fn _assert_prize_token_registered(
            self: @ComponentState<TContractState>, token: ContractAddress
        ) {
            assert(self._is_token_registered(token), Errors::PRIZE_TOKEN_NOT_REGISTERED);
        }

        fn _assert_tournament_started(self: @ComponentState<TContractState>, tournament_id: u64) {
            let tournament = get!(self.get_contract().world(), (tournament_id), (TournamentModel));
            assert(tournament.start_time <= get_block_timestamp(), Errors::TOURNAMENT_NOT_STARTED);
        }

        fn _assert_tournament_not_started(
            self: @ComponentState<TContractState>, tournament_id: u64
        ) {
            let tournament = get!(self.get_contract().world(), (tournament_id), (TournamentModel));
            assert(
                tournament.start_time > get_block_timestamp(), Errors::TOURNAMENT_ALREADY_STARTED
            );
        }

        fn _assert_game_started_or_submitted(
            self: @ComponentState<TContractState>, tournament_id: u64, game_id: felt252
        ) {
            let entry = self.get_tournament_entry(tournament_id, game_id);
            assert(
                entry.status == EntryStatus::Started || entry.status == EntryStatus::Submitted,
                Errors::GAME_NOT_STARTED
            );
        }

        fn _assert_tournament_active(self: @ComponentState<TContractState>, tournament_id: u64) {
            let is_active = self._is_tournament_active(tournament_id);
            assert(is_active, Errors::TOURNAMENT_NOT_ACTIVE);
        }

        fn _assert_tournament_ended(self: @ComponentState<TContractState>, tournament_id: u64) {
            let tournament = self.get_tournament(tournament_id);
            assert(tournament.end_time <= get_block_timestamp(), Errors::TOURNAMENT_NOT_ENDED);
        }

        fn _assert_tournament_period_within_max(
            self: @ComponentState<TContractState>, tournament_id: u64
        ) {
            let tournament = self.get_tournament(tournament_id);
            assert(
                tournament.end_time - tournament.start_time < GAME_EXPIRATION_PERIOD.into(),
                Errors::TOURNAMENT_PERIOD_TOO_LONG
            );
        }

        fn _assert_scores_count_valid(
            self: @ComponentState<TContractState>, tournament_id: u64, scores_count: u32
        ) {
            let tournament = self.get_tournament(tournament_id);
            assert(
                scores_count <= tournament.winners_count.into(), Errors::INVALID_SCORES_SUBMISSION
            );
        }

        fn _assert_prize_position_less_than_winners_count(
            self: @ComponentState<TContractState>, tournament_id: u64, position: u8
        ) {
            let tournament = self.get_tournament(tournament_id);
            assert(position <= tournament.winners_count, Errors::PRIZE_POSITION_TOO_LARGE);
        }

        fn _assert_prize_exists(self: @ComponentState<TContractState>, token: ContractAddress) {
            assert(!token.is_zero(), Errors::PRIZE_DOES_NOT_EXIST);
        }

        fn _assert_prize_not_claimed(self: @ComponentState<TContractState>, claimed: bool) {
            assert(!claimed, Errors::PRIZE_ALREADY_CLAIMED);
        }

        fn _assert_gated_token_owner(
            self: @ComponentState<TContractState>,
            token: ContractAddress,
            token_id: u256,
            account: ContractAddress
        ) {
            let owner = self._get_owner(token, token_id);
            assert(owner == account, Errors::NO_QUALIFYING_NFT);
        }

        fn _assert_game_token_owner(
            self: @ComponentState<TContractState>, game_id: u256, account: ContractAddress
        ) {
            let tournament_contracts = self.get_tournament_contracts();
            let owner = self._get_owner(tournament_contracts.loot_survivor, game_id);
            assert(owner == account, Errors::NOT_GAME_OWNER);
        }

        fn _assert_gated_type_validates(
            self: @ComponentState<TContractState>, gated_type: Option<GatedType>
        ) {
            match gated_type {
                Option::Some(gated_type) => {
                    match gated_type {
                        GatedType::token(token) => {
                            assert(
                                self._is_token_registered(token.token),
                                Errors::GATED_TOKEN_NOT_REGISTERED
                            )
                        },
                        GatedType::tournament(tournament_ids) => {
                            let mut loop_index = 0;
                            loop {
                                if loop_index == tournament_ids.len() {
                                    break;
                                }
                                self._assert_tournament_settled(*tournament_ids.at(loop_index));
                                loop_index += 1;
                            }
                        },
                    }
                },
                Option::None => {},
            }
        }

        fn _assert_valid_score(self: @ComponentState<TContractState>, adventurer: Adventurer) {
            assert(adventurer.health == 0, Errors::INVALID_SCORE);
        }

        fn _assert_tournament_settled(self: @ComponentState<TContractState>, tournament_id: u64) {
            let tournament = self.get_tournament(tournament_id);
            assert(
                tournament.end_time + tournament.submission_period <= get_block_timestamp(),
                Errors::TOURNAMENT_NOT_SETTLED
            );
        }

        fn _assert_tournament_not_settled(
            self: @ComponentState<TContractState>, tournament_id: u64
        ) {
            let tournament = self.get_tournament(tournament_id);
            assert(
                tournament.end_time + tournament.submission_period > get_block_timestamp(),
                Errors::TOURNAMENT_ALREADY_SETTLED
            );
        }

        fn _assert_distribute_has_not_been_called(
            self: @ComponentState<TContractState>, tournament_id: u64
        ) {
            let total_entries = self.get_total_entries(tournament_id);
            assert(!total_entries.distribute_called, Errors::DISTRIBUTE_ALREADY_CALLED);
        }

        fn _assert_prize_keys_not_empty(self: @ComponentState<TContractState>, prize_keys: Span<u64>) {
            assert(prize_keys.len() > 0, Errors::NO_PRIZE_KEYS);
        }

        fn _assert_gated_submission_qualifies(
            self: @ComponentState<TContractState>,
            gated_type: GatedType,
            gated_submission_type: Option<GatedSubmissionType>,
            address: ContractAddress,
            ref entries: u64
        ) {
            match gated_type {
                GatedType::token(token) => {
                    // assert the caller has a qualifying nft
                    self
                        ._assert_has_qualifying_nft(
                            token, gated_submission_type, address, ref entries
                        );
                },
                GatedType::tournament(tournament_ids) => {
                    // assert the owner owns game ids and has a top score in tournaments
                    self
                        ._assert_has_qualified_in_tournaments(
                            tournament_ids, gated_submission_type, address
                        );
                },
            }
        }

        fn _assert_has_qualifying_nft(
            self: @ComponentState<TContractState>,
            gated_token: GatedToken,
            gated_submission_type: Option<GatedSubmissionType>,
            address: ContractAddress,
            ref entries: u64
        ) {
            match gated_submission_type {
                Option::Some(submission) => {
                    match submission {
                        GatedSubmissionType::token_id(token_id) => {
                            self._assert_gated_token_owner(gated_token.token, token_id, address);
                            let entry_type = gated_token.entry_type;
                            match entry_type {
                                GatedEntryType::criteria(entry_criteria) => {
                                    let mut entry_count = 0;
                                    let num_criteria = entry_criteria.len();
                                    let mut criteria_index = 0;
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
                                    entries = entry_count;
                                },
                                GatedEntryType::uniform(entry_count) => { entries = entry_count; },
                            }
                        },
                        GatedSubmissionType::game_id(_) => {
                            assert(false, Errors::INVALID_GATED_SUBMISSION_TYPE)
                        },
                    }
                },
                Option::None => { assert(false, Errors::INVALID_GATED_SUBMISSION_TYPE); }
            }
        }

        fn _assert_has_qualified_in_tournaments(
            self: @ComponentState<TContractState>,
            tournament_ids: Span<u64>,
            gated_submission_type: Option<GatedSubmissionType>,
            address: ContractAddress
        ) {
            match gated_submission_type {
                Option::Some(submission) => {
                    match submission {
                        GatedSubmissionType::token_id(_) => {
                            assert(false, Errors::INVALID_GATED_SUBMISSION_TYPE)
                        },
                        GatedSubmissionType::game_id(game_ids) => {
                            assert(
                                game_ids.len() == tournament_ids.len(),
                                Errors::INVALID_SUBMITTED_GAMES_LENGTH
                            );
                            let tournament_contracts = self.get_tournament_contracts();
                            let ls_dispatcher = ILootSurvivorDispatcher {
                                contract_address: tournament_contracts.loot_survivor
                            };
                            let mut loop_index = 0;
                            loop {
                                if loop_index == tournament_ids.len() {
                                    break;
                                }
                                self
                                    ._assert_game_token_owner(
                                        (*game_ids.at(loop_index)).into(), address
                                    );
                                let adventurer = ls_dispatcher
                                    .get_adventurer(*game_ids.at(loop_index).try_into().unwrap());
                                assert(
                                    self
                                        ._is_top_score(
                                            *tournament_ids.at(loop_index), adventurer.xp
                                        ),
                                    Errors::SUBMITTED_GAME_NOT_TOP_SCORE
                                );
                                loop_index += 1;
                            }
                        }
                    }
                },
                Option::None => { assert(false, Errors::INVALID_GATED_SUBMISSION_TYPE); }
            }
        }

        //
        // INTERNALS
        //

        fn _create_tournament(
            ref self: ComponentState<TContractState>,
            name: felt252,
            description: ByteArray,
            creator: ContractAddress,
            start_time: u64,
            end_time: u64,
            submission_period: u64,
            winners_count: u8,
            gated_type: Option<GatedType>,
            entry_premium: Option<Premium>,
        ) -> u64 {
            let new_tournament_id = self.get_totals().total_tournaments + 1;
            set!(
                self.get_contract().world(),
                TournamentModel {
                    tournament_id: new_tournament_id,
                    name,
                    description,
                    creator,
                    gated_type,
                    start_time,
                    end_time,
                    submission_period,
                    winners_count,
                    entry_premium,
                }
            );
            let create_tournament_event = CreateTournament {
                creator, tournament_id: new_tournament_id
            };
            self.emit(create_tournament_event.clone());
            emit!(self.get_contract().world(), (Event::CreateTournament(create_tournament_event)));
            self.set_total_tournaments(new_tournament_id);
            new_tournament_id
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

                match token.token_data_type.into() {
                    TokenDataType::erc20(_) => {
                        let token_dispatcher = IERC20Dispatcher { contract_address: token.token };
                        let token_dispatcher_metadata = IERC20MetadataDispatcher {
                            contract_address: token.token
                        };
                        name = token_dispatcher_metadata._name();
                        symbol = token_dispatcher_metadata.symbol();
                        // check that the contract is approved for the minimal amount
                        let allowance = token_dispatcher
                            .allowance(get_caller_address(), get_contract_address());
                        assert(allowance == 1, Errors::INVALID_TOKEN_ALLOWANCES);
                        // take a reading of the current balance (incase contract has assets
                        // already)
                        let current_balance = token_dispatcher.balance_of(get_contract_address());
                        // trnsfer a minimal amount to the contract
                        token_dispatcher
                            .transfer_from(get_caller_address(), get_contract_address(), 1);
                        // take a reading of the new balance
                        let new_balance = token_dispatcher.balance_of(get_contract_address());
                        assert(new_balance == current_balance + 1, Errors::INVALID_TOKEN_BALANCES);
                        // transfer back the minimal amount
                        token_dispatcher.transfer(get_caller_address(), 1);
                        // check the total supply is legitimate
                        let total_supply = token_dispatcher.total_supply();
                        assert(total_supply < TWO_POW_128.into(), Errors::TOKEN_SUPPLY_TOO_LARGE);
                    },
                    TokenDataType::erc721(token_data_type) => {
                        let token_dispatcher = IERC721Dispatcher { contract_address: token.token };
                        let token_dispatcher_metadata = IERC721MetadataDispatcher {
                            contract_address: token.token
                        };
                        name = token_dispatcher_metadata._name();
                        symbol = token_dispatcher_metadata.symbol();
                        // check that the contract is approved for the specific id
                        let approved = token_dispatcher
                            .get_approved(token_data_type.token_id.into());
                        assert(approved == get_contract_address(), Errors::INVALID_TOKEN_APPROVALS);
                        // transfer a specific id to the contract
                        token_dispatcher
                            .transfer_from(
                                get_caller_address(),
                                get_contract_address(),
                                token_data_type.token_id.into()
                            );
                        // check the balance of the contract
                        let balance = token_dispatcher.balance_of(get_contract_address());
                        assert(balance == 1, Errors::INVALID_TOKEN_BALANCES);
                        let owner = token_dispatcher.owner_of(token_data_type.token_id.into());
                        assert(owner == get_contract_address(), Errors::INVALID_TOKEN_OWNER);
                        // transfer back the token
                        token_dispatcher
                            .transfer_from(
                                get_contract_address(),
                                get_caller_address(),
                                token_data_type.token_id.into()
                            );
                    },
                    TokenDataType::erc1155(token_data_type) => {
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
                        assert(approved, Errors::INVALID_TOKEN_APPROVALS);
                        // take a reading of the current balance (incase contract has assets
                        // already)
                        let current_balance = token_dispatcher
                            .balance_of(get_contract_address(), token_data_type.token_id.into());
                        // trnsfer a minimal amount to the contract
                        token_dispatcher
                            .safe_transfer_from(
                                get_caller_address(),
                                get_contract_address(),
                                token_data_type.token_id.into(),
                                1,
                                data.span()
                            );
                        // take a reading of the new balance
                        let new_balance = token_dispatcher
                            .balance_of(get_contract_address(), token_data_type.token_id.into());
                        assert(new_balance == current_balance + 1, Errors::INVALID_TOKEN_BALANCES);
                        // transfer back the minimal amount
                        token_dispatcher
                            .safe_transfer_from(
                                get_contract_address(),
                                get_caller_address(),
                                token_data_type.token_id.into(),
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
                        token_data_type: token.token_data_type,
                        is_registered: true
                    }
                );
                let register_token_event = RegisterToken {
                    token: token.token, token_data_type: token.token_data_type
                };
                self.emit(register_token_event.clone());
                emit!(self.get_contract().world(), (Event::RegisterToken(register_token_event)));
                token_index += 1;
            }
        }

        fn _format_premium_config_into_prize_keys(
            ref self: ComponentState<TContractState>, tournament_id: u64
        ) {
            let tournament = self.get_tournament(tournament_id);
            match tournament.entry_premium {
                Option::Some(premium) => {
                    let total_entries = self.get_total_entries(tournament_id);
                    // first pay the creator fee
                    let token_dispatcher = IERC20Dispatcher { contract_address: premium.token };
                    let creator_amount = self
                        ._calculate_payout(
                            premium.creator_fee.into(), total_entries.entry_count.into() * premium.token_amount
                        );
                    if creator_amount > 0 {
                        token_dispatcher.transfer(tournament.creator, creator_amount.into());
                    }

                    // then format the rest of the premium distributions into prize keys
                    let players_amount = (total_entries.entry_count.into() * premium.token_amount) - creator_amount;
                    let totals = self.get_totals();
                    let mut prize_key_total = totals.total_prizes;
                    let player_distributions = premium.token_distribution;
                    let num_distributions = player_distributions.len();
                    let mut distribution_index = 0;
                    loop {
                        if distribution_index == num_distributions {
                            break;
                        }
                        let distribution_percentage = *player_distributions.at(distribution_index);
                        let distribution_amount = self
                            ._calculate_payout(
                                distribution_percentage.into(), players_amount
                            );
                        // increment prize keys
                        prize_key_total += 1;
                        set!(
                            self.get_contract().world(),
                            TournamentTotalsModel {
                                contract: get_contract_address(),
                                total_tournaments: totals.total_tournaments,
                                total_prizes: prize_key_total,
                            }
                        );
                        // store prize against key, claimed is false
                        set!(
                            self.get_contract().world(),
                            PrizesModel {
                                prize_key: prize_key_total.into(),
                                token: premium.token,
                                token_data_type: TokenDataType::erc20(
                                    ERC20Data { token_amount: distribution_amount }
                                ),
                                payout_position: (distribution_index + 1).try_into().unwrap(),
                                claimed: false
                            }
                        );
                        let mut tournament_prizes = self.get_prize_keys(tournament_id).prize_keys;
                        tournament_prizes.append(prize_key_total.into());
                        // store appended prize key list
                        set!(
                            self.get_contract().world(),
                            TournamentPrizeKeysModel { tournament_id, prize_keys: tournament_prizes }
                        );
                        let add_new_prize_event = AddNewPrize {
                            tournament_id,
                            token: premium.token,
                            token_data_type: TokenDataType::erc20(
                                ERC20Data { token_amount: distribution_amount }
                            ),
                            payout_position: (distribution_index + 1).try_into().unwrap()
                        };
                        self.emit(add_new_prize_event.clone());
                        emit!(
                            self.get_contract().world(), (Event::AddNewPrize(add_new_prize_event))
                        );
                        distribution_index += 1;
                    };
                    // set premiums formatted true
                    set!(
                        self.get_contract().world(),
                        TournamentEntriesModel {
                            tournament_id,
                            entry_count: total_entries.entry_count,
                            premiums_formatted: true,
                            distribute_called: total_entries.distribute_called
                        }
                    );
                },
                Option::None => {}
            }
        }

        fn _update_tournament_scores(
            ref self: ComponentState<TContractState>,
            tournament_id: u64,
            game_id: felt252,
            score: u16,
            death_date: u64,
            ref new_score_ids: Array<u64>,
            game_index: u32
        ) {
            // get current scores which will be mutated as part of this function
            let top_score_ids = self.get_tournament_scores(tournament_id).top_score_ids;

            let num_scores = top_score_ids.len();

            let mut new_score_id: u64 = 0;
            let mut new_score: u16 = 0;

            if num_scores == 0 {
                new_score_id = game_id.try_into().unwrap();
                new_score = score;
            } else {
                if (game_index < num_scores) {
                    let top_score_id = *top_score_ids.at(game_index);
                    let top_score = self.get_score_from_id(top_score_id.try_into().unwrap());
                    if (score > top_score) {
                        new_score_id = game_id.try_into().unwrap();
                        new_score = score;
                    } else if (score == top_score) {
                        // if scores are the same then use death date as the deciding factor
                        let top_death_date = self
                            .get_death_date_from_id(top_score_id.try_into().unwrap());
                        if (death_date < top_death_date) {
                            new_score_id = game_id.try_into().unwrap();
                            new_score = score;
                        } else {
                            new_score_id = top_score_id;
                            new_score = top_score;
                        }
                    } else {
                        new_score_id = top_score_id;
                        new_score = top_score;
                    }
                } else {
                    new_score_id = game_id.try_into().unwrap();
                    new_score = score;
                }
            }
            new_score_ids.append(new_score_id);
            let new_high_score_event = NewHighScore {
                tournament_id, game_id, score: new_score, rank: (game_index + 1).try_into().unwrap()
            };
            self.emit(new_high_score_event.clone());
            emit!(self.get_contract().world(), (Event::NewHighScore(new_high_score_event)));
        }

        fn _convert_usd_to_wei(self: @ComponentState<TContractState>, usd: u128) -> u128 {
            let tournament_contracts = self.get_tournament_contracts();
            let oracle_dispatcher = IPragmaABIDispatcher {
                contract_address: tournament_contracts.oracle
            };
            let response = oracle_dispatcher.get_data_median(DataType::SpotEntry('ETH/USD'));
            assert(response.price > 0, Errors::FETCHING_ETH_PRICE_ERROR);
            (usd * pow(10, response.decimals.into()) * 1000000000000000000)
                / (response.price * 100000000)
        }

        fn _deposit_prize(
            ref self: ComponentState<TContractState>,
            tournament_id: u64,
            token: ContractAddress,
            token_data_type: TokenDataType,
            position: u8
        ) {
            self._assert_prize_token_registered(token);
            self._assert_prize_position_less_than_winners_count(tournament_id, position);
            match token_data_type {
                TokenDataType::erc20(token_data) => {
                    let token_dispatcher = IERC20Dispatcher { contract_address: token };
                    token_dispatcher
                        .transfer_from(
                            get_caller_address(),
                            get_contract_address(),
                            token_data.token_amount.into()
                        );
                },
                TokenDataType::erc721(token_data) => {
                    let token_dispatcher = IERC721Dispatcher { contract_address: token };
                    token_dispatcher
                        .transfer_from(
                            get_caller_address(), get_contract_address(), token_data.token_id.into()
                        );
                },
                TokenDataType::erc1155(token_data) => {
                    let token_dispatcher = IERC1155Dispatcher { contract_address: token };
                    let data = ArrayTrait::<felt252>::new();
                    token_dispatcher
                        .safe_transfer_from(
                            get_caller_address(),
                            get_contract_address(),
                            token_data.token_id.into(),
                            token_data.token_amount.into(),
                            data.span()
                        );
                },
            }
            let totals = self.get_totals();
            let next_prize_key = totals.total_prizes + 1;
            set!(
                self.get_contract().world(),
                TournamentTotalsModel {
                    contract: get_contract_address(),
                    total_tournaments: totals.total_tournaments,
                    total_prizes: next_prize_key,
                }
            );
            // store prize against key, claimed is false
            set!(
                self.get_contract().world(),
                PrizesModel {
                    prize_key: next_prize_key.into(),
                    token: token,
                    token_data_type: token_data_type,
                    payout_position: position,
                    claimed: false
                }
            );
            let mut tournament_prizes = self.get_prize_keys(tournament_id).prize_keys;
            tournament_prizes.append(next_prize_key.into());
            // store appended prize key list
            set!(
                self.get_contract().world(),
                TournamentPrizeKeysModel { tournament_id, prize_keys: tournament_prizes }
            );
            let add_new_prize_event = AddNewPrize {
                tournament_id,
                token: token,
                token_data_type: token_data_type,
                payout_position: position
            };
            self.emit(add_new_prize_event.clone());
            emit!(self.get_contract().world(), (Event::AddNewPrize(add_new_prize_event)));
        }

        fn _distribute_prizes_to_address(
            ref self: ComponentState<TContractState>,
            tournament_id: u64,
            prize_keys: Array<u64>,
            address: ContractAddress
        ) {
            let num_prizes = prize_keys.len();
            let mut prize_index = 0;
            loop {
                if prize_index == num_prizes {
                    break;
                }
                let prize_key = *prize_keys.at(prize_index);
                let mut prize = self.get_prize(prize_key);
                match prize.token_data_type {
                    TokenDataType::erc20(token_data) => {
                        let token_dispatcher = IERC20Dispatcher { contract_address: prize.token };
                        token_dispatcher.transfer(address, token_data.token_amount.into());
                    },
                    TokenDataType::erc721(token_data) => {
                        let token_dispatcher = IERC721Dispatcher { contract_address: prize.token };
                        token_dispatcher
                            .transfer_from(
                                get_contract_address(), address, token_data.token_id.into()
                            );
                    },
                    TokenDataType::erc1155(token_data) => {
                        let token_dispatcher = IERC1155Dispatcher { contract_address: prize.token };
                        let data = ArrayTrait::<felt252>::new();
                        token_dispatcher
                            .safe_transfer_from(
                                get_contract_address(),
                                address,
                                token_data.token_id.into(),
                                token_data.token_amount.into(),
                                data.span()
                            );
                    },
                }
                prize.claimed = true;
                set!(self.get_contract().world(), (prize));
                prize_index += 1;
            };
        }

        fn _distribute_prizes_to_top_scores(
            ref self: ComponentState<TContractState>,
            tournament_id: u64,
            prize_keys: Array<u64>,
            top_score_ids: Span<u64>
        ) {
            let tournament_contracts = self.get_tournament_contracts();
            let num_prizes = prize_keys.len();
            let mut prize_index = 0;
            loop {
                if prize_index == num_prizes {
                    break;
                }
                let mut prize = self.get_prize(*prize_keys.at(prize_index));
                // assert prize hasn't been claimed
                self._assert_prize_exists(prize.token);
                self._assert_prize_not_claimed(prize.claimed);
                let payout_position_is_top_score = prize
                    .payout_position
                    .into() <= top_score_ids
                    .len();
                // get payout position address
                let payout_position_id = *top_score_ids.at(prize.payout_position.into() - 1);
                let payout_position_address = self
                    ._get_owner(tournament_contracts.loot_survivor, payout_position_id.into());
                // get first place address
                let first_place_id = *top_score_ids.at(0);
                let first_place_address = self
                    ._get_owner(tournament_contracts.loot_survivor, first_place_id.into());
                // perform the distributions based on the token data type
                match prize.token_data_type {
                    TokenDataType::erc20(token_data) => {
                        let token_dispatcher = IERC20Dispatcher { contract_address: prize.token };
                        // check if the prize position is less than or equal to the number of top
                        // scores
                        if payout_position_is_top_score {
                            if (token_data.token_amount > 0) {
                                token_dispatcher
                                    .transfer(
                                        payout_position_address, token_data.token_amount.into()
                                    );
                            }
                        } else {
                            token_dispatcher
                                .transfer(first_place_address, token_data.token_amount.into());
                        }
                    },
                    TokenDataType::erc721(token_data) => {
                        let token_dispatcher = IERC721Dispatcher { contract_address: prize.token };
                        if payout_position_is_top_score {
                            token_dispatcher
                                .transfer_from(
                                    get_contract_address(),
                                    payout_position_address,
                                    token_data.token_id.into()
                                );
                        } else {
                            token_dispatcher
                                .transfer_from(
                                    get_contract_address(),
                                    first_place_address,
                                    token_data.token_id.into()
                                );
                        }
                    },
                    TokenDataType::erc1155(token_data) => {
                        let token_dispatcher = IERC1155Dispatcher { contract_address: prize.token };
                        let data = ArrayTrait::<felt252>::new();
                        // check if the prize position is less than or equal to the number of top
                        // scores
                        if payout_position_is_top_score {
                            if (token_data.token_amount > 0) {
                                token_dispatcher
                                    .safe_transfer_from(
                                        get_contract_address(),
                                        payout_position_address,
                                        token_data.token_id.into(),
                                        token_data.token_amount.into(),
                                        data.span()
                                    );
                            }
                        } else {
                            token_dispatcher
                                .safe_transfer_from(
                                    get_contract_address(),
                                    first_place_address,
                                    token_data.token_id.into(),
                                    token_data.token_amount.into(),
                                    data.span()
                                );
                        }
                    }
                }
                prize.claimed = true;
                set!(self.get_contract().world(), (prize));
                prize_index += 1;
            }
        }

        // fn _distribute_all_premiums(
        //     ref self: ComponentState<TContractState>,
        //     tournament_id: u64,
        //     premium: Premium,
        //     creator: ContractAddress,
        //     top_score_ids: Span<u64>
        // ) {
        //     let tournament_contracts = self.get_tournament_contracts();
        //     let token_dispatcher = IERC20Dispatcher { contract_address: premium.token };
        //     let entry_count = self.get_total_entries(tournament_id).entry_count;
        //     let creator_amount = self
        //         ._calculate_payout(
        //             premium.creator_fee.into(), entry_count.into() * premium.token_amount
        //         );
        //     if creator_amount > 0 {
        //         token_dispatcher.transfer(creator, creator_amount.into());
        //     }
        //     // distribute the remaining premium amount in accordance with the distributions
        //     let players_amount = (entry_count.into() * premium.token_amount) - creator_amount;
        //     let num_distributions = premium.token_distribution.len();
        //     let mut distribution_index = 0;
        //     loop {
        //         if distribution_index == num_distributions {
        //             break;
        //         }
        //         let distribution = *premium.token_distribution.at(distribution_index);
        //         let score_id = *top_score_ids.at(distribution_index);
        //         let amount = self._calculate_payout(distribution.into(), players_amount);
        //         if amount > 0 {
        //             let address = self
        //                 ._get_owner(tournament_contracts.loot_survivor, score_id.into());
        //             token_dispatcher.transfer(address, amount.into());
        //         }
        //         distribution_index += 1;
        //     }
        // }

        // fn _refund_prizes(self: @ComponentState<TContractState>, tournament_id: u64, prize_keys:
        // Array<u64>) {
        //     let num_prizes = prize_keys.len();
        //     let mut prize_index = 0;
        //     loop {
        //         if prize_index == num_prizes {
        //             break;
        //         }
        //         let prize_key = *prize_keys.at(prize_index);
        //         let mut prize = self.get_prize(tournament_id, prize_key);
        //         let depositer = prize.depositer;
        //         match prize.token_data_type {
        //             TokenDataType::erc20(token_data) => {
        //                 let token_dispatcher = IERC20Dispatcher { contract_address: prize.token
        //                 };
        //                 token_dispatcher.transfer(depositer, token_data.token_amount.into());
        //             },
        //             TokenDataType::erc721(token_data) => {
        //                 let token_dispatcher = IERC721Dispatcher { contract_address: prize.token
        //                 };
        //                 token_dispatcher.transfer_from(get_contract_address(), depositer,
        //                 token_data.token_id.into());
        //             },
        //             TokenDataType::erc1155(token_data) => {
        //                 let token_dispatcher = IERC1155Dispatcher { contract_address: prize.token
        //                 };
        //                 let data = ArrayTrait::<felt252>::new();
        //                 token_dispatcher.safe_transfer_from(get_contract_address(), depositer,
        //                 token_data.token_id.into(), token_data.token_amount.into(), data.span());
        //             },
        //         };
        //         prize.claimed = true;
        //         set!(self.get_contract().world(), (prize));
        //         prize_index += 1;
        //     }
        // }

        // fn _refund_premiums(ref self: ComponentState<TContractState>, tournament_id: u64,
        // premium: Premium, creator: ContractAddress) {
        //     // pay the creator fee as tournament still took place
        //     let token_dispatcher = IERC20Dispatcher { contract_address: premium.token };
        //     let total_entry_count = self.get_total_entries(tournament_id).entry_count;
        //     let creator_amount = self
        //         ._calculate_payout(
        //             premium.creator_fee.into(), total_entry_count.into() * premium.token_amount
        //         );
        //     if creator_amount > 0 {
        //         token_dispatcher.transfer(creator, creator_amount.into());
        //     }
        //     // refund the remaining premium amount to the players
        //     let players_amount = (total_entry_count.into() * premium.token_amount) -
        //     creator_amount;
        //     let amount_per_entry = players_amount / total_entry_count.into();
        //     // we have to also handle rounding errors
        //     let remainder_per_entry = players_amount % total_entry_count.into();
        //     // get the addresses that have entered
        //     let entry_addresses = self.get_tournament_entry_addresses(tournament_id).addresses;
        //     // loop through addresses and handle the refunds
        //     let num_addresses = entry_addresses.len();
        //     let mut address_index = 0;
        //     loop {
        //         if address_index == num_addresses {
        //             break;
        //         }
        //         let address = *entry_addresses.at(address_index);
        //         // first get the entries if they haven't yet started (this count is reduced on
        //         starting game)
        //         let address_entry_count = self.get_address_entries(tournament_id,
        //         address).entry_count;
        //         // then get the number of entries that were actually started
        //         let address_started_game_ids = self.get_address_started_game_ids(tournament_id,
        //         address).game_ids;
        //         let total_address_entries = address_entry_count +
        //         address_started_game_ids.len().into();
        //         // calculate the amount from player pool that this address is owed
        //         let address_amount = amount_per_entry * total_address_entries.into();

        //         // Handle rounding error (if exists)
        //         let remainder_amount = (remainder_per_entry * total_address_entries.into()) /
        //         total_entry_count.into();

        //         let total_transfer = address_amount + remainder_amount;
        //         if total_transfer > 0 {
        //             token_dispatcher.transfer(address, total_transfer.into());
        //         }
        //         address_index += 1;
        //     };
        // }

        fn _calculate_total_entries(
            self: @ComponentState<TContractState>,
            tournament_id: u64,
            addresses: Array<ContractAddress>
        ) -> u64 {
            let mut entries = 0;
            let num_addresses = addresses.len();
            let mut address_index = 0;
            loop {
                if address_index == num_addresses {
                    break;
                }
                let address = *addresses.at(address_index);
                let address_entries = self.get_address_entries(tournament_id, address);
                entries += address_entries.entry_count;
                address_index += 1;
            };
            entries
        }

        fn _calculate_payout(
            ref self: ComponentState<TContractState>, bp: u128, total_value: u128
        ) -> u128 {
            (bp * total_value) / 100
        }
    }
}
