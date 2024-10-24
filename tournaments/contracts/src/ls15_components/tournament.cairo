use starknet::ContractAddress;
use tournament::ls15_components::interfaces::{
    LootRequirement, Token, StatRequirement, GatedToken, Premium
};
use tournament::ls15_components::constants::{
    TokenType, PrizeType, EntryStatus, GatedType, GatedSubmissionType
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

// TODO: add previous tournament ids for qualification as a different type to GatedTokens
// TODO: condense the model to consist of type enums
#[dojo::model]
#[derive(Drop, Serde)]
struct TournamentModel {
    #[key]
    tournament_id: u64,
    name: ByteArray,
    creator: ContractAddress,
    start_time: u64,
    end_time: u64,
    submission_period: u64,
    winners_count: u8,
    gated_type: Option<GatedType>,
    entry_premium: Option<Premium>,
    stat_requirements: Array<StatRequirement>,
    claimed: bool,
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
struct TournamentAddressesModel {
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
    entry_count: u8,
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
    entry_count: u8,
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
struct TournamentTotalModel {
    #[key]
    contract: ContractAddress,
    total_tournaments: u64,
}

#[dojo::model]
#[derive(Drop, Serde)]
struct TournamentPrizesModel {
    #[key]
    tournament_id: u64,
    prizes: Array<PrizeType>,
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
    fn top_scores(self: @TState, tournament_id: u64) -> Array<u64>;
    fn is_tournament_active(self: @TState, tournament_id: u64) -> bool;
    fn is_token_registered(self: @TState, token: ContractAddress) -> bool;
    fn create_tournament(
        ref self: TState,
        name: ByteArray,
        gated_type: Option<GatedType>,
        start_time: u64,
        end_time: u64,
        submission_period: u64,
        winners_count: u8,
        entry_premium: Option<Premium>,
        stat_requirements: Array<StatRequirement>,
    ) -> u64;
    fn register_tokens(ref self: TState, tokens: Array<Token>);
    fn enter_tournament(
        ref self: TState, tournament_id: u64, gated_submission_type: Option<GatedSubmissionType>
    );
    fn start_tournament(ref self: TState, tournament_id: u64, start_all: bool);
    fn submit_scores(ref self: TState, tournament_id: u64, game_ids: Array<felt252>);
    fn add_prizes(ref self: TState, tournament_id: u64, prizes: Array<PrizeType>);
    fn claim_prizes(ref self: TState, tournament_id: u64, game_ids: Option<Array<felt252>>);
}

///
/// Tournament Component
///
#[starknet::component]
mod tournament_component {
    use super::TournamentModel;
    use super::TournamentEntryModel;
    use super::TournamentAddressesModel;
    use super::TournamentEntriesAddressModel;
    use super::TournamentStartIdsModel;
    use super::TournamentEntriesModel;
    use super::TournamentScoresModel;
    use super::TournamentTotalModel;
    use super::TournamentPrizesModel;
    use super::TokenModel;
    use super::TournamentContracts;
    use super::ITournament;

    use super::pow;

    use tournament::ls15_components::constants::{
        LOOT_SURVIVOR, Operation, StatRequirementEnum, TokenType, LORDS, ETH, ORACLE,
        VRF_COST_PER_GAME, TWO_POW_128, MIN_REGISTRATION_PERIOD, MIN_SUBMISSION_PERIOD,
        MAX_SUBMISSION_PERIOD, GAME_EXPIRATION_PERIOD, PrizeType, EntryStatus, GatedType,
        GatedSubmissionType
    };
    use tournament::ls15_components::interfaces::{
        LootRequirement, Token, StatRequirement, ILootSurvivor, ILootSurvivorDispatcher,
        ILootSurvivorDispatcherTrait, IPragmaABI, IPragmaABIDispatcher, IPragmaABIDispatcherTrait,
        AggregationMode, DataType, PragmaPricesResponse, GatedToken, Premium
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
        // AddNewPrize: AddNewPrize,
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

    // #[derive(Copy, Drop, Serde, starknet::Event)]
    // struct AddNewPrize {
    //     tournament_id: u64,
    //     prize: PrizeType,
    // }

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
        const INVALID_WINNERS_COUNT: felt252 = 'invalid winners count';
        const NO_QUALIFYING_NFT: felt252 = 'no qualifying nft';
        const TOURNAMENT_ALREADY_STARTED: felt252 = 'tournament already started';
        const TOURNAMENT_NOT_STARTED: felt252 = 'tournament not started';
        const TOURNAMENT_NOT_ENDED: felt252 = 'tournament not ended';
        const TOURNAMENT_NOT_ACTIVE: felt252 = 'tournament not active';
        const TOURNAMENT_NOT_SETTLED: felt252 = 'tournament not settled';
        const TOURNAMENT_NOT_CLAIMED: felt252 = 'tournament not claimed';
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
        const ALL_ENTRIES_STARTED: felt252 = 'all entries started';
        const INVALID_SUBMISSION_PERIOD: felt252 = 'invalid submission period';
        const TOURNAMENT_PERIOD_TOO_LONG: felt252 = 'tournament period too long';
        const INVALID_GATED_SUBMISSION_TYPE: felt252 = 'invalid gated submission type';
        const INVALID_SUBMITTED_GAMES_LENGTH: felt252 = 'invalid submitted games length';
        const NOT_OWNER_OF_SUBMITTED_GAME_ID: felt252 = 'not owner of submitted game';
        const SUBMITTED_GAME_NOT_TOP_SCORE: felt252 = 'submitted game not top score';
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
            name: ByteArray,
            gated_type: Option<GatedType>,
            start_time: u64,
            end_time: u64,
            submission_period: u64,
            winners_count: u8,
            entry_premium: Option<Premium>,
            stat_requirements: Array<StatRequirement>,
        ) -> u64 {
            // assert the start time is not in the past and is larger the minimum registration
            // period
            assert(
                start_time >= get_block_timestamp() + MIN_REGISTRATION_PERIOD.into(),
                Errors::INVALID_START_TIME
            );
            // assert the end time is larger than start_time
            assert(end_time > start_time, Errors::INVALID_END_TIME);
            // assert the submission period is larger than minimum
            assert(
                submission_period >= MIN_SUBMISSION_PERIOD.into(), Errors::INVALID_SUBMISSION_PERIOD
            );
            // assert the submission period is less than the maximum
            assert(
                submission_period <= MAX_SUBMISSION_PERIOD.into(), Errors::INVALID_SUBMISSION_PERIOD
            );
            // assert winners count is bigger than 0
            assert(winners_count > 0, Errors::INVALID_WINNERS_COUNT);

            // assert the gated type validates
            self._assert_gated_type_validates(gated_type);

            // assert premium distribution is valid
            assert(
                self._is_premium_token_registered(entry_premium.clone()),
                Errors::TOKEN_NOT_REGISTERED
            );
            assert(
                self._is_token_distribution_valid(entry_premium.clone(), winners_count),
                Errors::INVALID_DISTRIBUTION
            );

            // create a new tournament
            self
                ._create_tournament(
                    name,
                    get_caller_address(),
                    gated_type,
                    start_time,
                    end_time,
                    submission_period,
                    winners_count,
                    entry_premium,
                    stat_requirements,
                )
        }

        fn register_tokens(ref self: ComponentState<TContractState>, tokens: Array<Token>) {
            self._register_tokens(tokens);
        }

        // gated entries must register all
        fn enter_tournament(
            ref self: ComponentState<TContractState>,
            tournament_id: u64,
            gated_submission_type: Option<GatedSubmissionType>,
        ) {
            // assert game tournament has not started
            assert(!self._is_tournament_started(tournament_id), Errors::TOURNAMENT_ALREADY_STARTED);

            let tournament = self.get_tournament(tournament_id);

            let mut entries: u8 = 1;

            match tournament.gated_type {
                Option::Some(gated_type) => {
                    self
                        ._assert_gated_submission_qualifies(
                            gated_type, gated_submission_type, get_caller_address(), ref entries
                        );
                },
                Option::None => {},
            };

            match tournament.entry_premium {
                Option::Some(premium) => {
                    // transfer tournament premium
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
            // store the addresses and entries count
            if (address_entries.entry_count == 0) {
                self.append_tournament_address_list(tournament_id, get_caller_address());
            }
            // store individual entries and append to list of entries by address
            self.increment_entries(tournament_id, entries);
            // TODO: can store multiple game ids in single felt with merkle tree?
        }

        // TODO: check there are enough entries to cover the top scores size
        // TODO: if start all, caller pays for all base costs
        fn start_tournament(
            ref self: ComponentState<TContractState>, tournament_id: u64, start_all: bool
        ) {
            assert(self._is_tournament_active(tournament_id), Errors::TOURNAMENT_NOT_ACTIVE);
            // if starting all games assert tournament period is within max
            if (start_all) {
                self._assert_tournament_period_within_max(tournament_id);
            }

            let mut entries = 0;

            if start_all {
                let addresses = self.get_tournament_addresses(tournament_id).addresses;
                assert(addresses.len() > 0, Errors::ALL_ENTRIES_STARTED);
                entries = self._calculate_total_entries(tournament_id, addresses);
            } else {
                entries = self.get_address_entries(tournament_id, get_caller_address()).entry_count;
                assert(entries > 0, Errors::ALL_ENTRIES_STARTED);
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

            // to avoid extra storage we are just providing defualt configs for the adventurers
            if start_all {
                // if start all then we need to loop through stored  addresses and mint games for
                // each
                let addresses = self.get_tournament_addresses(tournament_id).addresses;
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
                                'test',
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
                let address_entries = self
                    .get_address_entries(tournament_id, get_caller_address())
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
                            'test',
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
                // set stored addresses
                self.set_tournament_starts(tournament_id, get_caller_address(), game_ids);
                // set entries to 0
                self.set_tournament_entries(tournament_id, get_caller_address(), 0);
            }
        }

        // for more efficient gas we assume that the game ids are in order of highest score
        fn submit_scores(
            ref self: ComponentState<TContractState>, tournament_id: u64, game_ids: Array<felt252>
        ) {
            let tournament = self.get_tournament(tournament_id);
            // assert tournament ended but not settled
            self._assert_tournament_ended(tournament_id);
            // assert the submitted scores are less than or equal to leaderboard size
            assert(
                game_ids.len() <= tournament.winners_count.into(), Errors::INVALID_SCORES_SUBMISSION
            );
            assert(
                tournament.end_time + tournament.submission_period > get_block_timestamp(),
                Errors::TOURNAMENT_ALREADY_SETTLED
            );

            let contracts = self.get_tournament_contracts();
            let mut ls_dispatcher = ILootSurvivorDispatcher {
                contract_address: contracts.loot_survivor
            };
            let mut num_games = game_ids.len();
            let mut game_index = 0;
            let mut new_score_ids = ArrayTrait::<u64>::new();
            loop {
                if game_index == num_games {
                    break;
                }
                let game_id = *game_ids.at(game_index);
                self._assert_tournament_started(tournament_id, game_id);
                self._assert_tournament_not_submitted(tournament_id, game_id);

                let adventurer = ls_dispatcher.get_adventurer(game_id.try_into().unwrap());
                let death_date = self.get_death_date_from_id(game_id);

                self._assert_valid_score(adventurer);
                // // TODO: look into for v2
                // // self._assert_stat_requirements(tournament_id, adventurer);

                if self._is_top_score(tournament_id, adventurer.xp) {
                    self
                        ._update_tournament_scores(
                            tournament_id,
                            game_id,
                            adventurer.xp,
                            death_date,
                            ref new_score_ids,
                            game_index
                        );
                }

                self.set_submitted_score(tournament_id, game_id, adventurer.xp);
                game_index += 1;
            };
            set!(
                self.get_contract().world(),
                (TournamentScoresModel { tournament_id, top_score_ids: new_score_ids })
            );
        }

        fn add_prizes(
            ref self: ComponentState<TContractState>, tournament_id: u64, prizes: Array<PrizeType>
        ) {
            // add prizes to the contract
            self._deposit_prizes(tournament_id, prizes.span());
            // TODO: look into fixing non copyable array when trying to append
            // self._add_prizes(tournament_id, prizes);
        }

        fn claim_prizes(ref self: ComponentState<TContractState>, tournament_id: u64, game_ids: Option<Array<felt252>>) {
            let tournament = get!(self.get_contract().world(), (tournament_id), (TournamentModel));
            assert(
                tournament.end_time + tournament.submission_period <= get_block_timestamp(),
                Errors::TOURNAMENT_NOT_SETTLED
            );
            self._assert_tournament_not_claimed(tournament_id);

            let mut top_score_ids = self.get_tournament_scores(tournament_id).top_score_ids;
            let tournament = self.get_tournament(tournament_id);
            let tournament_prizes = self.get_prizes(tournament_id);

            self._distribute_prizes(tournament_prizes, ref top_score_ids, true);
            match tournament.entry_premium {
                Option::Some(premium) => {
                    self
                        ._distribute_premium(
                            tournament_id, premium, tournament.creator, ref top_score_ids
                        );
                },
                Option::None => {},
            };

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

        fn get_tournament_contracts(self: @ComponentState<TContractState>) -> TournamentContracts {
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
            self: @ComponentState<TContractState>, tournament_id: u64, game_id: felt252
        ) -> TournamentEntryModel {
            let game_id: u64 = game_id.try_into().unwrap();
            get!(self.get_contract().world(), (tournament_id, game_id), (TournamentEntryModel))
        }

        fn get_tournament_addresses(
            self: @ComponentState<TContractState>, tournament_id: u64
        ) -> TournamentAddressesModel {
            get!(self.get_contract().world(), (tournament_id), (TournamentAddressesModel))
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

        fn get_prizes(
            ref self: ComponentState<TContractState>, tournament_id: u64
        ) -> Array<PrizeType> {
            get!(self.get_contract().world(), (tournament_id), (TournamentPrizesModel)).prizes
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

        fn _is_tournament_claimed(
            self: @ComponentState<TContractState>, tournament_id: u64
        ) -> bool {
            let tournament = get!(self.get_contract().world(), (tournament_id), (TournamentModel));
            tournament.claimed
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

        fn _is_premium_token_registered(
            self: @ComponentState<TContractState>, premium: Option<Premium>
        ) -> bool {
            match premium {
                Option::Some(token) => { self._is_token_registered(token.token) },
                Option::None => true,
            }
        }

        fn _is_token_distribution_valid(
            self: @ComponentState<TContractState>, premium: Option<Premium>, winners_count: u8
        ) -> bool {
            match premium {
                Option::Some(token) => {
                    // TODO: check that the distribution sums to 100%
                    token.token_distribution.len() == winners_count.into()
                },
                Option::None => true,
            }
        }

        fn set_total_tournaments(self: @ComponentState<TContractState>, total_tournaments: u64) {
            set!(
                self.get_contract().world(),
                TournamentTotalModel { contract: get_contract_address(), total_tournaments }
            );
        }

        fn set_tournament_entries(
            self: @ComponentState<TContractState>,
            tournament_id: u64,
            address: ContractAddress,
            entries: u8
        ) {
            set!(
                self.get_contract().world(),
                TournamentEntriesAddressModel { tournament_id, address, entry_count: entries }
            );
        }

        fn increment_entries(
            self: @ComponentState<TContractState>, tournament_id: u64, entries: u8
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
                    tournament_id, entry_count: total_entries.entry_count + entries
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
            let mut tournament_addresses = self.get_tournament_addresses(tournament_id).addresses;
            tournament_addresses.append(address);
            set!(
                self.get_contract().world(),
                TournamentAddressesModel { tournament_id, addresses: tournament_addresses }
            );
        }

        fn set_tournament_address_list(
            self: @ComponentState<TContractState>,
            tournament_id: u64,
            addresses: Array<ContractAddress>
        ) {
            set!(
                self.get_contract().world(), TournamentAddressesModel { tournament_id, addresses }
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

        // fn _add_prizes(
        //     ref self: ComponentState<TContractState>, tournament_id: u64, prizes: Array<PrizeType>
        // ) {
        //     let mut tournament_prizes = self.get_prizes(tournament_id);
        //     let num_prizes = prizes.len();
        //     let mut prize_index = 0;
        //     loop {
        //         if prize_index == num_prizes {
        //             break;
        //         }
        //         let prize = *prizes.at(prize_index);
        //         tournament_prizes.append(prize);
        //         // let add_prize_event = AddNewPrize { tournament_id, prize };
        //         // self.emit(add_prize_event.clone());
        //         // emit!(self.get_contract().world(), (Event::AddNewPrize(add_prize_event)));
        //         prize_index += 1;
        //     };
        //     set!(
        //         self.get_contract().world(),
        //         TournamentPrizesModel { tournament_id, prizes: tournament_prizes }
        //     );
        // }

        fn _create_tournament(
            ref self: ComponentState<TContractState>,
            name: ByteArray,
            creator: ContractAddress,
            gated_type: Option<GatedType>,
            start_time: u64,
            end_time: u64,
            submission_period: u64,
            winners_count: u8,
            entry_premium: Option<Premium>,
            stat_requirements: Array<StatRequirement>,
        ) -> u64 {
            let new_tournament_id = self.get_total_tournaments().total_tournaments + 1;
            set!(
                self.get_contract().world(),
                TournamentModel {
                    tournament_id: new_tournament_id,
                    name,
                    creator,
                    gated_type,
                    start_time,
                    end_time,
                    submission_period,
                    winners_count,
                    entry_premium,
                    stat_requirements,
                    claimed: false
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
            ref self: ComponentState<TContractState>,
            tournament_id: u64,
            game_id: felt252,
            score: u16,
            death_date: u64,
            ref new_score_ids: Array<u64>,
            game_index: u32
        ) {
            // get current scores which will be mutated as part of this function
            let mut top_score_ids = self.get_tournament_scores(tournament_id).top_score_ids;
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

        fn _claimed(
            ref self: ComponentState<TContractState>, tournament_id: u64, scores: Array<u64>
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
            let tournament_contracts = self.get_tournament_contracts();
            let oracle_dispatcher = IPragmaABIDispatcher {
                contract_address: tournament_contracts.oracle
            };
            let response = oracle_dispatcher.get_data_median(DataType::SpotEntry('ETH/USD'));
            assert(response.price > 0, Errors::FETCHING_ETH_PRICE_ERROR);
            (usd * pow(10, response.decimals.into()) * 1000000000000000000)
                / (response.price * 100000000)
        }

        fn _deposit_prizes(
            ref self: ComponentState<TContractState>, tournament_id: u64, prizes: Span<PrizeType>
        ) {
            let winners_count = self.get_tournament(tournament_id).winners_count;
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
                        // TODO: support that it can be less than leaderboard size
                        assert(
                            prize.token_distribution.len() == winners_count.into(),
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
                        // check that the position is less than or equal to the leaderboard size
                        assert(
                            *prize.position <= winners_count.into(), Errors::INVALID_DISTRIBUTION
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
                        // TODO: support that it can be less than leaderboard size
                        assert(
                            prize.token_distribution.len() == winners_count.into(),
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
            ref top_score_ids: Array<u64>,
            distribute_all: bool
        ) {
            let tournament_contracts = self.get_tournament_contracts();
            let num_prizes = prizes.len();
            let mut prize_index = 0;
            loop {
                if prize_index == num_prizes {
                    break;
                }
                let prize = prizes.at(prize_index);
                // TODO: loop through scores and payout based on distributions. If the length of
                // scores is less than the length of distributions, then payout the remaining scores
                // back to the creator.
                // Do the same based on position of the prize NFT
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
                            let amount = self
                                ._calculate_payout(distribution.into(), *prize.token_amount);
                            if (amount > 0) {
                                let address = self
                                    ._get_owner(
                                        tournament_contracts.loot_survivor, score_id.into()
                                    );
                                token_dispatcher.transfer(address, amount.into());
                            }
                            distribution_index += 1;
                        };
                    },
                    PrizeType::erc721(prize) => {
                        let token_dispatcher = IERC721Dispatcher { contract_address: *prize.token };
                        let distribution_position = *prize.position;
                        let score_id = *top_score_ids.at(distribution_position.into() - 1);
                        let address = self
                            ._get_owner(tournament_contracts.loot_survivor, score_id.into());
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
                            let amount = self
                                ._calculate_payout(distribution.into(), *prize.token_amount);
                            if (amount > 0) {
                                let address = self
                                    ._get_owner(
                                        tournament_contracts.loot_survivor, score_id.into()
                                    );
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

        fn _distribute_premium(
            ref self: ComponentState<TContractState>,
            tournament_id: u64,
            premium: Premium,
            creator: ContractAddress,
            ref top_score_ids: Array<u64>
        ) {
            let tournament_contracts = self.get_tournament_contracts();
            let token_dispatcher = IERC20Dispatcher { contract_address: premium.token };
            // calculate fee for creator
            let creator_fee = premium.creator_fee;
            let entry_count = self.get_total_entries(tournament_id).entry_count;
            let creator_amount = self
                ._calculate_payout(creator_fee.into(), entry_count.into() * premium.token_amount);
            if creator_amount > 0 {
                token_dispatcher.transfer(creator, creator_amount.into());
            }
            // distribute the remaining premium amount in accordance with the distributions
            let players_amount = premium.token_amount - creator_amount;
            let num_distributions = premium.token_distribution.len();
            let mut distribution_index = 0;
            loop {
                if distribution_index == num_distributions {
                    break;
                }
                let distribution = *premium.token_distribution.at(distribution_index);
                let score_id = *top_score_ids.at(distribution_index);
                let amount = self._calculate_payout(distribution.into(), players_amount);
                if amount > 0 {
                    let address = self
                        ._get_owner(tournament_contracts.loot_survivor, score_id.into());
                    token_dispatcher.transfer(address, amount.into());
                }
                distribution_index += 1;
            }
        }

        fn _assert_gated_submission_qualifies(
            self: @ComponentState<TContractState>,
            gated_type: GatedType,
            gated_submission_type: Option<GatedSubmissionType>,
            address: ContractAddress,
            ref entries: u8
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
            ref entries: u8
        ) {
            match gated_submission_type {
                Option::Some(submission) => {
                    match submission {
                        GatedSubmissionType::token_id(token_id) => {
                            let owner = self._get_owner(gated_token.token, token_id);
                            assert(owner == address, Errors::NO_QUALIFYING_NFT);
                            let entry_criteria = gated_token.entry_criteria;

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
                                let owner = self
                                    ._get_owner(
                                        tournament_contracts.loot_survivor,
                                        (*game_ids.at(loop_index)).try_into().unwrap()
                                    );
                                assert(owner == address, Errors::NO_QUALIFYING_NFT);
                                let adventurer = ls_dispatcher
                                    .get_adventurer(*game_ids.at(loop_index).try_into().unwrap());
                                assert(
                                    self
                                        ._is_top_score(
                                            *tournament_ids.at(loop_index), adventurer.xp
                                        ),
                                    Errors::SUBMITTED_GAME_NOT_TOP_SCORE
                                );
                            }
                        }
                    }
                },
                Option::None => { assert(false, Errors::INVALID_GATED_SUBMISSION_TYPE); }
            }
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

        fn _assert_tournament_started(
            self: @ComponentState<TContractState>, tournament_id: u64, game_id: felt252
        ) {
            let entry = self.get_tournament_entry(tournament_id, game_id);
            assert(entry.status == EntryStatus::Started, Errors::TOURNAMENT_NOT_STARTED);
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

        fn _assert_tournament_not_submitted(
            self: @ComponentState<TContractState>, tournament_id: u64, game_id: felt252
        ) {
            let entry = self.get_tournament_entry(tournament_id, game_id);
            assert(
                entry.status != EntryStatus::Submitted, Errors::TOURNAMENT_ENTRY_ALREADY_SUBMITTED
            );
        }

        fn _assert_token_owner(
            self: @ComponentState<TContractState>,
            tournament_id: u64,
            game_id: u256,
            account: ContractAddress
        ) {
            let tournament_contracts = self.get_tournament_contracts();
            let owner = self._get_owner(tournament_contracts.loot_survivor, game_id);
            assert(owner == account, Errors::NOT_OWNER);
        }

        fn _assert_gated_type_validates(
            self: @ComponentState<TContractState>, gated_type: Option<GatedType>
        ) {
            match gated_type {
                Option::Some(gated_type) => {
                    match gated_type {
                        GatedType::token(token) => {
                            assert(
                                self._is_token_registered(token.token), Errors::TOKEN_NOT_REGISTERED
                            )
                        },
                        GatedType::tournament(tournament_ids) => {
                            let mut loop_index = 0;
                            loop {
                                if loop_index == tournament_ids.len() {
                                    break;
                                }
                                assert(
                                    self._is_tournament_claimed(*tournament_ids.at(loop_index)),
                                    Errors::TOURNAMENT_NOT_CLAIMED
                                );
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
            self: @ComponentState<TContractState>, gated_token: GatedToken, token_id: Option<u256>
        ) -> u8 {
            match token_id {
                Option::Some(token_id) => {
                    let entry_criteria = gated_token.entry_criteria;

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
                    entry_count
                },
                Option::None => { 0 }
            }
        }

        fn _calculate_total_entries(
            self: @ComponentState<TContractState>,
            tournament_id: u64,
            addresses: Array<ContractAddress>
        ) -> u8 {
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
