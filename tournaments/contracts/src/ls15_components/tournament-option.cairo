use starknet::ContractAddress;
use tournament::ls15_components::interfaces::{
    LootRequirement, Prize, PrizeToken, StatRequirement, GatedToken
};
use tournament::ls15_components::constants::{TokenType};

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
    name: ByteArray,
    creator: ContractAddress,
    gated_token: Option<GatedToken>,
    start_time: u64,
    end_time: u64,
    entry_premium_token: Option<ContractAddress>,
    entry_premium_amount: Option<u128>,
    prizes: Array<Prize>,
    stat_requirements: Array<StatRequirement>,
    loot_requirements: Array<LootRequirement>,
    settled: bool,
}

#[dojo::model]
#[derive(Copy, Drop, Serde)]
struct TournamentEntryModel {
    #[key]
    tournament_id: u64,
    #[key]
    character_id: u128,
    entered: bool,
    submitted_score: bool,
}

#[dojo::model]
#[derive(Copy, Drop, Serde)]
struct TournamentScoreModel {
    #[key]
    tournament_id: u64,
    first: u16,
    second: u16,
    third: u16,
}

#[dojo::model]
#[derive(Copy, Drop, Serde)]
struct PrizeTokenModel {
    #[key]
    token: ContractAddress,
    token_type: TokenType,
}

#[dojo::model]
#[derive(Copy, Drop, Serde)]
struct TournamentTotalModel {
    #[key]
    contract: ContractAddress,
    total_tournaments: u64,
}

///
/// Interface
///

#[starknet::interface]
trait ITournament<TState> {
    fn total_tournaments(self: @TState) -> u64;
    fn tournament(self: @TState, tournament_id: u64) -> TournamentModel;
    fn is_tournament_active(self: @TState, tournament_id: u64) -> bool;
    fn is_token_registered(self: @TState, token: ContractAddress) -> bool;
    fn register_tournament(
        ref self: TState,
        name: ByteArray,
        gated_token: Option<GatedToken>,
        start_time: u64,
        end_time: u64,
        entry_premium_token: Option<ContractAddress>,
        entry_premium_amount: Option<u256>,
        prizes: Array<Prize>,
        stat_requirements: Array<StatRequirement>,
        loot_requirements: Array<LootRequirement>
    ) -> u64;
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
    fn submit_score(ref self: TState, tournament_id: u64, character_id: u256);
    fn settle_tournament(ref self: TState, tournament_id: u64);
}

///
/// Tournament Component
///
#[starknet::component]
mod tournament_component {
    use super::TournamentModel;
    use super::TournamentEntryModel;
    use super::TournamentScoreModel;
    use super::PrizeTokenModel;
    use super::TournamentTotalModel;
    use super::ITournament;

    use super::pow;

    use tournament::ls15_components::constants::{
        LOOT_SURVIVOR, Operation, StatRequirementEnum, TokenType, LORDS, ETH, ORACLE,
        VRF_COST_PER_GAME, TWO_POW_128
    };
    use tournament::ls15_components::interfaces::{
        LootRequirement, Prize, PrizeToken, StatRequirement, ILootSurvivor, ILootSurvivorDispatcher,
        ILootSurvivorDispatcherTrait, IPragmaABI, IPragmaABIDispatcher, IPragmaABIDispatcherTrait,
        AggregationMode, DataType, PragmaPricesResponse, GatedToken
    };

    use starknet::{
        ContractAddress, get_block_timestamp, get_contract_address, get_caller_address,
        storage::MutableVecTrait
    };
    use dojo::world::{
        IWorldProvider, IWorldProviderDispatcher, IWorldDispatcher, IWorldDispatcherTrait
    };
    use origami_token::components::introspection::src5::{ISRC5Dispatcher, ISRC5DispatcherTrait};
    use openzeppelin_token::erc20::interface::{IERC20, IERC20Dispatcher, IERC20DispatcherTrait};
    use openzeppelin_token::erc721::interface::{IERC721, IERC721Dispatcher, IERC721DispatcherTrait};
    use openzeppelin_token::erc1155::interface::{
        IERC1155, IERC1155Dispatcher, IERC1155DispatcherTrait
    };

    use adventurer::{adventurer::Adventurer, adventurer_meta::AdventurerMetadata, bag::Bag};

    #[storage]
    struct Storage {}

    #[event]
    #[derive(Copy, Drop, Serde, starknet::Event)]
    enum Event {
        RegisterTournament: RegisterTournament,
        EnterTournament: EnterTournament,
        SubmitScore: SubmitScore,
        NewHighScore: NewHighScore,
        SettleTournament: SettleTournament,
        RegisterToken: RegisterToken,
    }

    #[derive(Copy, Drop, Serde, starknet::Event)]
    struct RegisterTournament {
        creator: ContractAddress,
        tournament_id: u64,
    }

    #[derive(Copy, Drop, Serde, starknet::Event)]
    struct EnterTournament {
        account: ContractAddress,
        tournament_id: u64,
    }

    #[derive(Copy, Drop, Serde, starknet::Event)]
    struct SubmitScore {
        tournament_id: u64,
        character_id: u256,
        score: u16,
    }

    #[derive(Copy, Drop, Serde, starknet::Event)]
    struct NewHighScore {
        tournament_id: u64,
        character_id: u256,
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
        const INVALID_START_TIME: felt252 = 'Tournament: invalid start time';
        const INVALID_END_TIME: felt252 = 'Tournament: invalid end time';
        const NO_QUALIFYING_NFT: felt252 = 'Tournament: no qualifying nft';
        const TOURNAMENT_NOT_STARTED: felt252 = 'Tournament: not started';
        const TOURNAMENT_NOT_ENDED: felt252 = 'Tournament: not ended';
        const TOURNAMENT_NOT_ACTIVE: felt252 = 'Tournament: not active';
        const NOT_OWNER: felt252 = 'Tournament: not owner';
        const NOT_ENTERED: felt252 = 'Tournament: not entered';
        const TOURNAMENT_ALREADY_SETTLED: felt252 = 'Tournament: already settled';
        const TOKEN_ALREADY_REGISTERED: felt252 = 'Tournament: already registered';
        const TOKEN_TRANSFER_FAILED: felt252 = 'Tournament: transfer failed';
        const TOKEN_BALANCE_TOO_HIGH: felt252 = 'Tournament: supply too high';
        const TOKEN_NOT_REGISTERED: felt252 = 'Tournament: not registered';
        const FETCHING_ETH_PRICE_ERROR: felt252 = 'error fetching eth price';
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

        fn is_tournament_active(self: @ComponentState<TContractState>, tournament_id: u64) -> bool {
            self._is_tournament_active(tournament_id)
        }

        fn is_token_registered(
            self: @ComponentState<TContractState>, token: ContractAddress
        ) -> bool {
            self._is_token_registered(token)
        }

        fn register_tournament(
            ref self: ComponentState<TContractState>,
            name: ByteArray,
            gated_token: Option<GatedToken>,
            start_time: u64,
            end_time: u64,
            entry_premium_token: Option<ContractAddress>,
            entry_premium_amount: Option<u256>,
            prizes: Array<Prize>,
            stat_requirements: Array<StatRequirement>,
            loot_requirements: Array<LootRequirement>,
        ) -> u64 {
            // assert the start time is not in the past
            assert(start_time > get_block_timestamp(), Errors::INVALID_START_TIME);
            // assert the end time is larger than start_time
            assert(end_time > start_time, Errors::INVALID_END_TIME);

            // Clone the prizes if necessary
            let prizes_clone = prizes.clone();

            // add prizes to the contract
            self._deposit_prizes(prizes_clone);

            // get the current tournament count
            let tournament_count = self.get_total_tournaments().total_tournaments;

            let mut entry_amount = 0;

            match entry_premium_amount {
                Option::Some(amount) => entry_amount = Option::some(amount.low),
                Option::None => entry_amount = 0,
            }

            // create a new tournament
            self
                ._register_tournament(
                    tournament_count + 1,
                    name,
                    get_caller_address(),
                    gated_token,
                    start_time,
                    end_time,
                    entry_premium_token,
                    entry_premium_amount.low,
                    prizes,
                    stat_requirements,
                    loot_requirements,
                );

            self.set_total_tournaments(tournament_count + 1);
            tournament_count + 1
        }

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
            // assert game tournament end time has not been reached
            assert(self.is_tournament_active(tournament_id), Errors::TOURNAMENT_NOT_ACTIVE);

            let tournament = self.get_tournament(tournament_id);

            // assert the caller has a qualifying nft
            self
                ._assert_has_qualifying_nft(
                    tournament.gated_token, get_caller_address(), gated_token_id
                );

            // get current game cost
            let ls_dispatcher = ILootSurvivorDispatcher { contract_address: LOOT_SURVIVOR() };
            let cost_to_play = ls_dispatcher.get_cost_to_play();

            // transfer base game cost
            let lords_dispatcher: IERC20Dispatcher = IERC20Dispatcher { contract_address: LORDS() };
            lords_dispatcher
                .transfer_from(get_caller_address(), get_contract_address(), cost_to_play.into());

            // transfer VRF cost
            let eth_dispatcher: IERC20Dispatcher = IERC20Dispatcher { contract_address: ETH() };
            let vrf_cost = self._convert_usd_to_wei(VRF_COST_PER_GAME.into());
            eth_dispatcher
                .transfer_from(get_caller_address(), get_contract_address(), vrf_cost.into());

            // transfer tournament premium
            let prize_dispatcher = IERC20Dispatcher {
                contract_address: tournament.entry_premium_token
            };
            prize_dispatcher
                .transfer_from(
                    get_caller_address(), tournament.creator, tournament.entry_premium_amount.into()
                );

            let character_id = ls_dispatcher
                .new_game(
                    get_contract_address(),
                    weapon,
                    name,
                    0,
                    delay_reveal,
                    custom_renderer,
                    0,
                    get_caller_address()
                );

            self.set_tournament_entry(tournament_id, character_id.into());
        }

        fn submit_score(
            ref self: ComponentState<TContractState>, tournament_id: u64, character_id: u256
        ) {
            self._assert_tournament_entry(tournament_id, character_id);
            self._assert_tournament_is_active(tournament_id);
            self._assert_token_owner(tournament_id, character_id, get_caller_address());

            let ls_dispatcher = ILootSurvivorDispatcher { contract_address: LOOT_SURVIVOR() };
            let adventurer = ls_dispatcher.get_adventurer(character_id);
            let bag = ls_dispatcher.get_bag(character_id);

            self._assert_stat_requirements(tournament_id, adventurer);
            self._assert_loot_requirements(tournament_id, adventurer, bag);

            if self._is_top_score(tournament_id, adventurer.xp) {
                self._update_tournament_scores(tournament_id, character_id, adventurer.xp);
            }

            self.set_submitted_score(tournament_id, character_id, adventurer.xp);
        }

        fn settle_tournament(ref self: ComponentState<TContractState>, tournament_id: u64) {
            self._assert_tournament_ended(tournament_id);
            self._assert_tournament_not_settled(tournament_id);

            let tournament_scores = self.get_tournament_scores(tournament_id);
            let tournament = self.get_tournament(tournament_id);

            // Clone the prizes if necessary
            let tournament_scores_clone = tournament_scores.clone();

            self._distribute_prizes(tournament.prizes, tournament_scores_clone);

            self._settle_tournament(tournament_id, tournament_scores);
        }
    }


    #[generate_trait]
    impl InternalImpl<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        +Drop<TContractState>
    > of InternalTrait<TContractState> {
        fn get_total_tournaments(self: @ComponentState<TContractState>) -> TournamentTotalModel {
            get!(self.get_contract().world(), (get_contract_address()), (TournamentTotalModel))
        }

        fn get_tournament(
            self: @ComponentState<TContractState>, tournament_id: u64
        ) -> TournamentModel {
            get!(self.get_contract().world(), (tournament_id), (TournamentModel))
        }

        fn get_tournament_entry(
            self: @ComponentState<TContractState>, tournament_id: u64, character_id: u256
        ) -> TournamentEntryModel {
            get!(self.get_contract().world(), (tournament_id, character_id), (TournamentEntryModel))
        }

        fn get_tournament_scores(
            self: @ComponentState<TContractState>, tournament_id: u64
        ) -> TournamentScoreModel {
            get!(self.get_contract().world(), (tournament_id), (TournamentScoreModel))
        }


        fn _is_tournament_active(
            self: @ComponentState<TContractState>, tournament_id: u64
        ) -> bool {
            let tournament = get!(self.get_contract().world(), (tournament_id), (TournamentModel));
            tournament.start_time < get_block_timestamp()
                && tournament.end_time > get_block_timestamp()
        }

        fn _is_top_score(
            self: @ComponentState<TContractState>, tournament_id: u64, score: u16
        ) -> bool {
            let top_scores = self.get_tournament_scores(tournament_id);
            if score > top_scores.third {
                true
            } else {
                false
            }
        }

        fn _is_token_registered(
            self: @ComponentState<TContractState>, token: ContractAddress
        ) -> bool {
            let prize_token = get!(self.get_contract().world(), (token), (PrizeTokenModel));
            prize_token.token == token
        }


        fn set_total_tournaments(self: @ComponentState<TContractState>, total_tournaments: u64) {
            set!(
                self.get_contract().world(),
                TournamentTotalModel { contract: get_contract_address(), total_tournaments }
            );
        }

        fn set_tournament_entry(
            self: @ComponentState<TContractState>, tournament_id: u64, character_id: u256
        ) {
            set!(
                self.get_contract().world(),
                TournamentEntryModel {
                    tournament_id,
                    character_id: character_id.low,
                    entered: true,
                    submitted_score: false
                }
            );
        }

        fn set_submitted_score(
            ref self: ComponentState<TContractState>,
            tournament_id: u64,
            character_id: u256,
            score: u16
        ) {
            set!(
                self.get_contract().world(),
                TournamentEntryModel {
                    tournament_id,
                    character_id: character_id.low,
                    entered: true,
                    submitted_score: true
                }
            );
            let submit_score_event = SubmitScore { tournament_id, character_id, score };
            self.emit(submit_score_event.clone());
            emit!(self.get_contract().world(), (Event::SubmitScore(submit_score_event)));
        }

        fn _register_tournament(
            ref self: ComponentState<TContractState>,
            tournament_id: u64,
            name: ByteArray,
            creator: ContractAddress,
            gated_token: Option<GatedToken>,
            start_time: u64,
            end_time: u64,
            entry_premium_token: Option<ContractAddress>,
            entry_premium_amount: Option<u128>,
            prizes: Array<Prize>,
            stat_requirements: Array<StatRequirement>,
            loot_requirements: Array<LootRequirement>,
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
                    entry_premium_token: entry_premium_token,
                    entry_premium_amount: entry_premium_amount,
                    prizes: prizes,
                    stat_requirements: stat_requirements,
                    loot_requirements: loot_requirements,
                    settled: false
                }
            );
            let register_tournament_event = RegisterTournament { creator, tournament_id };
            self.emit(register_tournament_event.clone());
            emit!(
                self.get_contract().world(), (Event::RegisterTournament(register_tournament_event))
            );
        }

        fn _register_prizes(ref self: ComponentState<TContractState>, prizes: Array<PrizeToken>) {
            let num_prizes = prizes.len();
            let mut prize_index = 0;
            loop {
                if prize_index == num_prizes {
                    break;
                }
                let prize = *prizes.at(prize_index);

                assert(!self._is_token_registered(prize.token), Errors::TOKEN_ALREADY_REGISTERED);

                match prize.token_type.into() {
                    TokenType::ERC20(()) => {
                        let token_dispatcher = IERC20Dispatcher { contract_address: prize.token };
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
                        let token_dispatcher = IERC721Dispatcher { contract_address: prize.token };
                        // check that the contract is approved for the specific id
                        let approved = token_dispatcher.get_approved(prize.token_id.into());
                        assert(approved == get_contract_address(), Errors::TOKEN_TRANSFER_FAILED);
                        // transfer a specific id to the contract
                        token_dispatcher
                            .transfer_from(
                                get_caller_address(), get_contract_address(), prize.token_id.into()
                            );
                        // check the balance of the contract
                        let balance = token_dispatcher.balance_of(get_contract_address());
                        assert(balance == 1, Errors::TOKEN_TRANSFER_FAILED);
                        let owner = token_dispatcher.owner_of(prize.token_id.into());
                        assert(owner == get_contract_address(), Errors::TOKEN_TRANSFER_FAILED);
                        // transfer back the token
                        token_dispatcher
                            .transfer_from(
                                get_contract_address(), get_caller_address(), prize.token_id.into()
                            );
                    },
                    TokenType::ERC1155(()) => {
                        let token_dispatcher = IERC1155Dispatcher { contract_address: prize.token };
                        let data = ArrayTrait::<felt252>::new();
                        // check that the contract is approved for all ids
                        let approved = token_dispatcher
                            .is_approved_for_all(get_caller_address(), get_contract_address());
                        assert(approved, Errors::TOKEN_TRANSFER_FAILED);
                        // take a reading of the current balance (incase contract has assets
                        // already)
                        let current_balance = token_dispatcher
                            .balance_of(get_contract_address(), prize.token_id.into());
                        // trnsfer a minimal amount to the contract
                        token_dispatcher
                            .safe_transfer_from(
                                get_caller_address(),
                                get_contract_address(),
                                prize.token_id.into(),
                                1,
                                data.span()
                            );
                        // take a reading of the new balance
                        let new_balance = token_dispatcher
                            .balance_of(get_contract_address(), prize.token_id.into());
                        assert(new_balance == current_balance + 1, Errors::TOKEN_TRANSFER_FAILED);
                        // transfer back the minimal amount
                        token_dispatcher
                            .safe_transfer_from(
                                get_contract_address(),
                                get_caller_address(),
                                prize.token_id.into(),
                                1,
                                data.span()
                            );
                    }
                }
                set!(
                    self.get_contract().world(),
                    PrizeTokenModel { token: prize.token, token_type: prize.token_type }
                );
                let register_token_event = RegisterToken {
                    token: prize.token, token_type: prize.token_type
                };
                self.emit(register_token_event.clone());
                emit!(self.get_contract().world(), (Event::RegisterToken(register_token_event)));
                prize_index += 1;
            }
        }

        fn _update_tournament_scores(
            ref self: ComponentState<TContractState>,
            tournament_id: u64,
            character_id: u256,
            score: u16
        ) {
            // get current scores which will be mutated as part of this function
            let mut top_scores = self.get_tournament_scores(tournament_id);

            let mut rank = 0;

            // TODO: look into switching to array
            // shift scores based on players placement
            if score > top_scores.first {
                top_scores.third = top_scores.second;
                top_scores.second = top_scores.first;
                top_scores.first = score;
                rank = 1;
            } else if score > top_scores.second {
                top_scores.third = top_scores.second;
                top_scores.second = score;
                rank = 2;
            } else if score > top_scores.third {
                top_scores.third = score;
                rank = 3;
            }

            set!(self.get_contract().world(), (top_scores,));

            let new_high_score_event = NewHighScore { tournament_id, character_id, score, rank };
            self.emit(new_high_score_event.clone());
            emit!(self.get_contract().world(), (Event::NewHighScore(new_high_score_event)));
        }

        fn _settle_tournament(
            ref self: ComponentState<TContractState>,
            tournament_id: u64,
            scores: TournamentScoreModel
        ) {
            let mut tournament = self.get_tournament(tournament_id);
            tournament.settled = true;
            set!(self.get_contract().world(), (tournament,));
            let settle_tournament_event = SettleTournament {
                tournament_id, first: scores.first, second: scores.second, third: scores.third
            };
            self.emit(settle_tournament_event.clone());
            emit!(self.get_contract().world(), (Event::SettleTournament(settle_tournament_event)));
        }

        fn _convert_usd_to_wei(self: @ComponentState<TContractState>, usd: u128) -> u128 {
            let oracle_dispatcher = IPragmaABIDispatcher { contract_address: ORACLE() };
            let response = oracle_dispatcher.get_data_median(DataType::SpotEntry('ETH/USD'));
            assert(response.price > 0, Errors::FETCHING_ETH_PRICE_ERROR);
            (usd * pow(10, response.decimals.into()) * 1000000000000000000)
                / (response.price * 100000000)
        }

        fn _deposit_prizes(ref self: ComponentState<TContractState>, prizes: Array<Prize>) {
            let num_prizes = prizes.len();
            let mut prize_index = 0;
            loop {
                if prize_index == num_prizes {
                    break;
                }
                let prize = *prizes.at(prize_index);
                assert(self._is_token_registered(prize.token), Errors::TOKEN_NOT_REGISTERED);
                match prize.token_type {
                    TokenType::ERC20(()) => {
                        let token_dispatcher = IERC20Dispatcher { contract_address: prize.token };
                        token_dispatcher
                            .transfer_from(
                                get_caller_address(),
                                get_contract_address(),
                                prize.token_amount.into()
                            );
                    },
                    TokenType::ERC721(()) => {
                        let token_dispatcher = IERC721Dispatcher { contract_address: prize.token };
                        token_dispatcher
                            .transfer_from(
                                get_caller_address(), get_contract_address(), prize.token_id.into()
                            );
                    },
                    TokenType::ERC1155(()) => {
                        let token_dispatcher = IERC1155Dispatcher { contract_address: prize.token };
                        let data = ArrayTrait::<felt252>::new();
                        token_dispatcher
                            .safe_transfer_from(
                                get_caller_address(),
                                get_contract_address(),
                                prize.token_id.into(),
                                prize.token_amount.into(),
                                data.span()
                            );
                    },
                }
                prize_index += 1;
            }
        }

        fn _distribute_prizes(
            ref self: ComponentState<TContractState>,
            prizes: Array<Prize>,
            scores: TournamentScoreModel
        ) {
            let num_prizes = prizes.len();
            let mut prize_index = 0;
            loop {
                if prize_index == num_prizes {
                    break;
                }
                let prize: Prize = *prizes.at(prize_index);
                let prize_distribution = prize.token_distribution;
                let prize_token = prize.token;
                match prize.token_type {
                    TokenType::ERC20 => {
                        let token_dispatcher = IERC20Dispatcher { contract_address: prize_token };

                        let first_amount = self
                            ._calculate_payout(prize_distribution.first.into(), prize.token_amount);
                        let second_amount = self
                            ._calculate_payout(
                                prize_distribution.second.into(), prize.token_amount
                            );
                        let third_amount = self
                            ._calculate_payout(prize_distribution.third.into(), prize.token_amount);

                        let first_place_address = self
                            ._get_owner(LOOT_SURVIVOR(), scores.first.into());
                        let second_place_address = self
                            ._get_owner(LOOT_SURVIVOR(), scores.second.into());
                        let third_place_address = self
                            ._get_owner(LOOT_SURVIVOR(), scores.third.into());

                        token_dispatcher.transfer(first_place_address, first_amount.into());
                        token_dispatcher.transfer(second_place_address, second_amount.into());
                        token_dispatcher.transfer(third_place_address, third_amount.into());
                    },
                    TokenType::ERC721 => {
                        let token_dispatcher = IERC721Dispatcher { contract_address: prize_token };
                        if prize_distribution.first == 100 {
                            let address = self._get_owner(LOOT_SURVIVOR(), scores.first.into());
                            token_dispatcher
                                .transfer_from(
                                    get_contract_address(), address, prize.token_id.into()
                                );
                        } else if prize_distribution.second == 100 {
                            let address = self._get_owner(LOOT_SURVIVOR(), scores.second.into());
                            token_dispatcher
                                .transfer_from(
                                    get_contract_address(), address, prize.token_id.into()
                                );
                        } else if prize_distribution.third == 100 {
                            let address = self._get_owner(LOOT_SURVIVOR(), scores.third.into());
                            token_dispatcher
                                .transfer_from(
                                    get_contract_address(), address, prize.token_id.into()
                                );
                        } else {
                            break;
                        }
                    },
                    TokenType::ERC1155 => {
                        let token_dispatcher = IERC1155Dispatcher { contract_address: prize_token };
                        let data = ArrayTrait::<felt252>::new();

                        let first_amount = self
                            ._calculate_payout(prize_distribution.first.into(), prize.token_amount);
                        let second_amount = self
                            ._calculate_payout(
                                prize_distribution.second.into(), prize.token_amount
                            );
                        let third_amount = self
                            ._calculate_payout(prize_distribution.third.into(), prize.token_amount);

                        let first_place_address = self
                            ._get_owner(LOOT_SURVIVOR(), scores.first.into());
                        let second_place_address = self
                            ._get_owner(LOOT_SURVIVOR(), scores.second.into());
                        let third_place_address = self
                            ._get_owner(LOOT_SURVIVOR(), scores.third.into());

                        token_dispatcher
                            .safe_transfer_from(
                                get_contract_address(),
                                first_place_address,
                                prize.token_id.into(),
                                first_amount.into(),
                                data.span()
                            );
                        token_dispatcher
                            .safe_transfer_from(
                                get_contract_address(),
                                second_place_address,
                                prize.token_id.into(),
                                second_amount.into(),
                                data.span()
                            );
                        token_dispatcher
                            .safe_transfer_from(
                                get_contract_address(),
                                third_place_address,
                                prize.token_id.into(),
                                third_amount.into(),
                                data.span()
                            );
                    },
                }
                prize_index += 1;
            }
        }

        fn _assert_has_qualifying_nft(
            self: @ComponentState<TContractState>,
            token: ContractAddress,
            account: ContractAddress,
            token_id: u256
        ) {
            let owner = self._get_owner(token, token_id);
            assert(owner == account, Errors::NO_QUALIFYING_NFT);
        }

        fn _assert_tournament_is_active(self: @ComponentState<TContractState>, tournament_id: u64) {
            let is_active = self._is_tournament_active(tournament_id);
            assert(is_active, Errors::TOURNAMENT_NOT_STARTED);
        }

        fn _assert_tournament_ended(self: @ComponentState<TContractState>, tournament_id: u64) {
            let tournament = self.get_tournament(tournament_id);
            assert(tournament.end_time < get_block_timestamp(), Errors::TOURNAMENT_NOT_ENDED);
        }

        fn _assert_tournament_not_settled(
            self: @ComponentState<TContractState>, tournament_id: u64
        ) {
            let tournament = self.get_tournament(tournament_id);
            assert(!tournament.settled, Errors::TOURNAMENT_ALREADY_SETTLED);
        }

        fn _assert_tournament_entry(
            self: @ComponentState<TContractState>, tournament_id: u64, character_id: u256
        ) {
            let entry = self.get_tournament_entry(tournament_id, character_id);
            assert(entry.entered, Errors::TOURNAMENT_NOT_ACTIVE);
        }

        fn _assert_token_owner(
            self: @ComponentState<TContractState>,
            tournament_id: u64,
            character_id: u256,
            account: ContractAddress
        ) {
            let owner = self._get_owner(LOOT_SURVIVOR(), character_id);
            assert(owner == account, Errors::NOT_OWNER);
        }

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

        fn _assert_loot_requirements(
            self: @ComponentState<TContractState>,
            tournament_id: u64,
            adventurer: Adventurer,
            bag: Bag
        ) {
            let loot_requirements: Array<LootRequirement> = self
                .get_tournament(tournament_id)
                .loot_requirements;

            let equipment = adventurer.equipment;

            let mut item = 0;
            let mut xp = 0;

            let num_requirements = loot_requirements.len();
            let mut requirement_index = 0;
            loop {
                if requirement_index == num_requirements {
                    break;
                }
                let requirement: LootRequirement = *loot_requirements.at(requirement_index);
                let item_id = requirement.loot;
                if (equipment.weapon.id == item_id) {
                    item = equipment.weapon.id;
                    xp = equipment.weapon.xp;
                } else if (equipment.head.id == item_id) {
                    item = equipment.head.id;
                    xp = equipment.head.xp;
                } else if (equipment.waist.id == item_id) {
                    item = equipment.waist.id;
                    xp = equipment.waist.xp;
                } else if (equipment.foot.id == item_id) {
                    item = equipment.foot.id;
                    xp = equipment.foot.xp;
                } else if (equipment.hand.id == item_id) {
                    item = equipment.hand.id;
                    xp = equipment.hand.xp;
                } else if (equipment.neck.id == item_id) {
                    item = equipment.neck.id;
                    xp = equipment.neck.xp;
                } else if (equipment.ring.id == item_id) {
                    item = equipment.ring.id;
                    xp = equipment.ring.xp;
                } else if (bag.item_1.id == item_id) {
                    item = bag.item_1.id;
                    xp = bag.item_1.xp;
                } else if (bag.item_2.id == item_id) {
                    item = bag.item_2.id;
                    xp = bag.item_2.xp;
                } else if (bag.item_3.id == item_id) {
                    item = bag.item_3.id;
                    xp = bag.item_3.xp;
                } else if (bag.item_4.id == item_id) {
                    item = bag.item_4.id;
                    xp = bag.item_4.xp;
                } else if (bag.item_5.id == item_id) {
                    item = bag.item_5.id;
                    xp = bag.item_5.xp;
                } else if (bag.item_6.id == item_id) {
                    item = bag.item_6.id;
                    xp = bag.item_6.xp;
                } else if (bag.item_7.id == item_id) {
                    item = bag.item_7.id;
                    xp = bag.item_7.xp;
                } else if (bag.item_8.id == item_id) {
                    item = bag.item_8.id;
                    xp = bag.item_8.xp;
                } else if (bag.item_9.id == item_id) {
                    item = bag.item_9.id;
                    xp = bag.item_9.xp;
                } else if (bag.item_10.id == item_id) {
                    item = bag.item_10.id;
                    xp = bag.item_10.xp;
                } else if (bag.item_11.id == item_id) {
                    item = bag.item_11.id;
                    xp = bag.item_11.xp;
                } else if (bag.item_12.id == item_id) {
                    item = bag.item_12.id;
                    xp = bag.item_12.xp;
                } else if (bag.item_13.id == item_id) {
                    item = bag.item_13.id;
                    xp = bag.item_13.xp;
                } else if (bag.item_14.id == item_id) {
                    item = bag.item_14.id;
                    xp = bag.item_14.xp;
                } else if (bag.item_15.id == item_id) {
                    item = bag.item_15.id;
                    xp = bag.item_15.xp;
                } else {
                    item = 0;
                }

                assert(item == item_id, 'Tournament: requirement not met');
                self._assert_stat_operation(xp, requirement.xp, requirement.operation);
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

        fn _calculate_payout(
            ref self: ComponentState<TContractState>, bp: u128, price: u128
        ) -> u128 {
            (bp * price) / 100
        }
    }
}
