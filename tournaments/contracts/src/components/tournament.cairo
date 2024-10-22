use starknet::ContractAddress;
use tournament::interfaces::PrizeDistribution;

///
/// Model
///
///

#[dojo::model]
#[derive(Copy, Drop, Serde)]
struct TournamentModel {
    #[key]
    game_id: u64,
    #[key]
    tournament_id: u64,
    name: felt252,
    creator: ContractAddress,
    gated_token: ContractAddress,
    start_time: u64,
    end_time: u64,
    entry_premium_token: ContractAddress,
    entry_premium_amount: u128,
    prize_token: ContractAddress,
    prize_amount: u128,
    prize_distribution: PrizeDistribution,
    stat_requirements: Vec<StatRequirement>,
    loot_requirements: Vec<LootRequirement>,
    settled: bool,
}

#[dojo::model]
#[derive(Copy, Drop, Serde)]
struct TournamentEntryModel {
    #[key]
    game_id: u64,
    #[key]
    tournament_id: u64,
    #[key]
    character_id: u256,
    entered: bool,
    submitted_score: bool,
}

#[dojo::model]
#[derive(Copy, Drop, Serde)]
struct TournamentScoreModel {
    #[key]
    game_id: u64,
    #[key]
    tournament_id: u64,
    first: u256,
    second: u256,
    third: u256,
}


#[derive(Copy, Drop, Serde)]
#[dojo::model]
struct TournamentTotalModel {
    #[key]
    game_id: u64,
    total_tournaments: u128,
}

///
/// Interface
///

#[starknet::interface]
trait ITournament<TState> {
    fn register_tournament(self: @TState, account: ContractAddress) -> u256;
    fn enter_tournament(ref self: TState, account: ContractAddress, tournament_id: u64);
}

#[starknet::interface]
trait ITournamentCamel<TState> {
    fn registerTournament(self: @TState, account: ContractAddress) -> u256;
    fn enterTournament(ref self: TState, account: ContractAddress, tournament_id: u64);
}

///
/// Tournament Component
///
#[starknet::component]
mod tournament_component {
    use super::TournamentModel;
    use super::ITournament;
    use super::ITournamentCamel;

    use tournament::constants::{Adventurer, LOOT_SURVIVOR, QualificationRequirementEnum};
    use tournament::interfaces::{ILootSurvivor, ILootSurvivorDispatcher};

    use starknet::ContractAddress;
    use starknet::{get_contract_address, get_caller_address};
    use dojo::world::{
        IWorldProvider, IWorldProviderDispatcher, IWorldDispatcher, IWorldDispatcherTrait
    };
    use origami_token::components::introspection::src5::{ISRC5Dispatcher, ISRC5DispatcherTrait};
    use origami_token::components::token::erc20::interface::{IERC20Balance, IERC20Dispatcher};
    use origami_token::components::token::erc721::interface::{IERC721Balance, IERC721Dispatcher};

    use pragma_lib::abi::{IPragmaABIDispatcher, IPragmaABIDispatcherTrait};
    use pragma_lib::types::{AggregationMode, DataType, PragmaPricesResponse};

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
        score: u256,
    }

    #[derive(Copy, Drop, Serde, starknet::Event)]
    struct NewHighScore {
        tournament_id: u64,
        character_id: u256,
        score: u256,
        rank: u8,
    }

    #[derive(Copy, Drop, Serde, starknet::Event)]
    struct SettleTournament {
        tournament_id: u64,
        scores: TournamentScoreModel,
    }

    mod Errors {
        const INVALID_START_TIME: felt252 = 'Tournament: invalid start time';
        const INVALID_END_TIME: felt252 = 'Tournament: invalid end time';
        const NO_QUALIFYING_NFT: felt252 = 'Tournament: no qualifying nft';
        const TOURNAMENT_NOT_STARTED: felt252 = 'Tournament: tournament not started';
        const TOURNAMENT_NOT_ENDED: felt252 = 'Tournament: tournament not ended';
        const TOURNAMENT_NOT_ACTIVE: felt252 = 'Tournament: tournament not active';
        const NOT_OWNER: felt252 = 'Tournament: not owner';
        const NOT_ENTERED: felt252 = 'Tournament: not entered';
        const TOURNAMENT_ALREADY_SETTLED: felt252 = 'Tournament: tournament already settled';
    }

    #[embeddable_as(TournamentImpl)]
    impl Tournament<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        +Drop<TContractState>
    > of ITournament<ComponentState<TContractState>> {
        fn total_supply(self: @ComponentState<TContractState>) -> u256 {
            self.get_total_tournaments().total_tournaments.into()
        }

        fn get_tournament(
            self: @ComponentState<TContractState>, tournament_id: u64
        ) -> TournamentModel {
            self.get_tournament(tournament_id)
        }

        fn is_tournament_active(self: @ComponentState<TContractState>, tournament_id: u64) -> bool {
            _is_tournament_active(@self, tournament_id)
        }

        fn register_tournament(
            self: @ComponentState<TContractState>,
            game_id: u64,
            name: felt252,
            gated_token: ContractAddress,
            start_time: u64,
            end_time: u64,
            entry_fee: u128,
            entry_payment_token: ContractAddress,
            prize_token: ContractAddress,
            prize_amount: u128,
            prize_distribution: PrizeDistribution,
        ) -> u256 {
            // assert the start time is not in the past
            assert(start_time > get_block_timestamp(), Errors::INVALID_START_TIME);
            // assert the end time is larger than start_time
            assert(end_time > start_time(), Errors::INVALID_END_TIME);

            let prize_token_dispatcher = IERC20Dispatcher { contract_address: prize_token };
            prize_token_dispatcher
                .transfer_from(get_caller_address(), self.get_contract_address(), prize_amount);

            // get the current tournament count
            let tournament_count = get_total_tournaments(self).total_tournaments;

            // create a new tournament
            _register_tournament(
                self,
                name,
                get_caller_address(),
                tournament_count + 1,
                game_id,
                gated_token,
                start_time,
                end_time,
                entry_fee,
                entry_payment_token,
                prize_token,
                prize_amount,
                prize_distribution
            );

            set_total_tournaments(self, tournament_count + 1);
        }

        fn enter_tournament(
            ref self: ComponentState<TContractState>,
            tournament_id: u64,
            client_reward_address: ContractAddress,
            weapon: u8,
            name: felt252,
            delay_reveal: bool,
            custom_renderer: ContractAddress,
        ) {
            // assert game tournament end time has not been reached
            _assert_launch_tournament_is_active(@self, tournament_id);

            // assert the caller has a qualifying nft
            _assert_has_qualifying_nft(@self, get_caller_address());

            let tournament = self.get_tournament(tournament_id);

            // get current game cost
            let ls_dispatcher = ILootSurvivorDispatcher { contract_address: LOOT_SURVIVOR };
            let cost_to_play = ls_dispatcher.get_cost_to_play();

            // transfer base game cost
            let lords_dispatcher: IERC20Dispatcher = IERC20Dispatcher { contract_address: LORDS };
            lords_dispatcher
                .transfer_from(get_caller_address(), self.get_contract_address(), cost_to_play);

            // transfer VRF cost
            let eth_dispatcher: IERC20Dispatcher = IERC20Dispatcher { contract_address: ETH };
            let vrf_cost = _convert_usd_to_wei(self, VRF_COST_PER_GAME.into());
            eth_dispatcher
                .transfer_from(get_caller_address(), self.get_contract_address(), vrf_cost);

            // transfer tournament premium
            let prize_dispatcher = IERC20Dispatcher {
                contract_address: tournament.entry_premium_token
            };
            prize_dispatcher
                .transfer_from(
                    get_caller_address(), tournament.creator, tournament.entry_premium_amount
                );

            let character_id = ls_dispatcher
                .new_game(
                    tournament_id,
                    get_contract_address(),
                    weapon,
                    name,
                    0,
                    delay_reveal,
                    custom_renderer,
                    0,
                    get_caller_address()
                );

            _store_entry(self, tournament_id, character_id);
        }

        fn submit_score(
            ref self: ComponentState<TContractState>,
            game_id: u64,
            tournament_id: u64,
            character_id: u256
        ) {
            _assert_tournament_entry(@self, tournament_id, character_id);
            _assert_tournament_is_active(@self, tournament_id);
            _assert_token_owner(@self, tournament_id, character_id, get_caller_address());

            let ls_dispatcher = ILootSurvivorDispatcher { contract_address: LOOT_SURVIVOR };
            let adventurer = ls_dispatcher.get_adventurer(character_id);
            let bag = ls_dispatcher.get_bag(character_id);

            _assset_stat_requirements(@self, tournament_id, adventurer);
            _assset_loot_requirements(@self, tournament_id, adventurer, bag);

            if _is_top_score(@self, game_id, tournament_id, adventurer.xp) {
                _update_tournament_scores(ref self, game_id, tournament_id, adventurer.xp);
            }

            set_submitted_score(ref self, game_id, tournament_id, character_id, adventurer.xp);
        }

        fn settle_tournament(
            ref self: ComponentState<TContractState>, game_id: u64, tournament_id: u64
        ) {
            _assert_tournament_ended(@self, tournament_id);
            _assert_tournament_not_settled(@self, tournament_id);
            let prize_token_dispatcher = IERC20Dispatcher {
                contract_address: tournament.prize_token
            };
            let tournament_scores = get_tournament_scores(ref self, game_id, tournament_id);

            // if first place is not zero, transfer rewards
            if tournament_scores.first != 0 {
                payment_dispatcher
                    .transfer_from(
                        get_caller_address(), first_place_address, rewards.FIRST_PLACE.into()
                    );
            }

            // if second place is not zero, transfer rewards
            if tournament_scores.second != 0 {
                payment_dispatcher
                    .transfer_from(
                        get_caller_address(), second_place_address, rewards.SECOND_PLACE.into()
                    );
            }

            // if third place is not zero, transfer rewards
            if tournament_scores.third != 0 {
                payment_dispatcher
                    .transfer_from(
                        get_caller_address(), third_place_address, rewards.THIRD_PLACE.into()
                    );
            }

            let settle_tournament_event = SettleTournament { tournament_id };
            self.emit(settle_tournament_event.clone());
            emit!(self.get_contract().world(), (Event::SettleTournament(settle_tournament_event)));
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
            get!(self.get_contract().world(), (TournamentTotalModel))
        }

        fn get_tournament(
            self: @ComponentState<TContractState>, game_id: u64, tournament_id: u64
        ) -> TournamentModel {
            get!(self.get_contract().world(), (TournamentModel), game_id, tournament_id)
        }

        fn get_tournament_entry(
            self: @ComponentState<TContractState>,
            game_id: u64,
            tournament_id: u64,
            character_id: u256
        ) -> TournamentEntryModel {
            get!(
                self.get_contract().world(),
                (TournamentEntryModel),
                game_id,
                tournament_id,
                character_id
            )
        }

        fn get_tournament_scores(
            self: @ComponentState<TContractState>, game_id: u64, tournament_id: u64
        ) -> TournamentEntryModel {
            get!(self.get_contract().world(), (TournamentScoreModel), game_id, tournament_id)
        }


        fn _is_tournament_active(
            self: @ComponentState<TContractState>, game_id: u64, tournament_id: u64
        ) -> bool {
            let tournament = get!(
                self.get_contract().world(), (TournamentModel), game_id, tournament_id
            );
            tournament.start_time < get_block_timestamp()
                && tournament.end_time > get_block_timestamp()
        }

        fn _is_top_score(
            self: @ContractState, game_id: u64, tournament_id: u64, score: u16
        ) -> bool {
            let top_scores = self.get_tournament_scores(game_id, tournament_id);
            if score > top_scores.third {
                true
            } else {
                false
            }
        }


        fn set_total_tournaments(self: @ComponentState<TContractState>, total_tournaments: u128) {
            set!(
                self.get_contract().world(),
                TournamentTotalModel { total_tournaments: total_tournaments }
            );
        }

        fn set_submitted_score(
            self: @ComponentState<TContractState>,
            game_id: u64,
            tournament_id: u64,
            character_id: u256,
            score: u256
        ) {
            let tournament_entry = self.get_tournament_entry(game_id, tournament_id, character_id);
            set!(
                self.get_contract().world(),
                TournamentEntryModel {
                    game_id: game_id,
                    tournament_id: tournament_id,
                    character_id: character_id,
                    entered: true,
                    submitted_score: true
                }
            );
            let submit_score_event = SubmitScore { tournament_id, character_id, score };
            self.emit(submit_score_event.clone());
            emit!(self.get_contract().world(), (Event::SubmitScore(submit_score_event)));
        }

        fn _register_tournament(
            self: @ComponentState<TContractState>,
            game_id: u64,
            tournament_id: u64,
            name: felt252,
            gated_token: ContractAddress,
            start_time: u64,
            end_time: u64,
            entry_fee: u128,
            entry_payment_token: ContractAddress,
            prize_token: ContractAddress,
            prize_amount: u128,
            prize_distribution: PrizeDistribution,
        ) -> ERC721BalanceModel {
            set!(
                self.get_contract().world(),
                TournamentModel {
                    game_id: game_id,
                    tournament_id: tournament_id,
                    name: name,
                    gated_token: gated_token,
                    start_time: start_time,
                    end_time: end_time,
                    entry_fee: entry_fee,
                    entry_payment_token: entry_payment_token,
                    prize_token: prize_token,
                    prize_amount: prize_amount,
                    prize_distribution: prize_distribution,
                    settled: false
                }
            );
            let register_tournament_event = RegisterTournament { creator, tournament_id };
            self.emit(register_tournament_event.clone());
            emit!(
                self.get_contract().world(), (Event::RegisterTournament(register_tournament_event))
            );
        }

        fn _update_tournament_scores(
            self: @ComponentState<TContractState>,
            tournament_id: u64,
            character_id: u256,
            score: u256
        ) {
            // get current scores which will be mutated as part of this function
            let mut top_scores = self.get_tournament_scores(game_id, tournament_id);

            let mut player_rank = 0;

            // shift scores based on players placement
            if score.xp > top_scores.first.xp {
                top_scores.third = top_scores.second;
                top_scores.second = top_scores.first;
                leaderboard.first = player_score;
                player_rank = 1;
            } else if score.xp > top_scores.second.xp {
                top_scores.third = top_scores.second;
                top_scores.second = player_score;
                player_rank = 2;
            } else if score.xp > top_scores.third.xp {
                top_scores.third = player_score;
                player_rank = 3;
            }

            set!(
                self.get_contract().world(),
                (TournamentScoreModel),
                game_id,
                tournament_id,
                top_scores
            );

            let new_high_score_event = NewHighScore { tournament_id, character_id, score, rank };
            self.emit(new_high_score_event.clone());
            emit!(self.get_contract().world(), (Event::NewHighScore(new_high_score_event)));
        }

        fn _settle_tournament(
            self: @ComponentState<TContractState>, game_id: u64, tournament_id: u64
        ) {
            let mut tournament = self.get_tournament(game_id, tournament_id);
            tournament.settled = true;
            set!(self.get_contract().world(), tournament);
            let settle_tournament_event = SettleTournament { tournament_id };
            self.emit(settle_tournament_event.clone());
            emit!(self.get_contract().world(), (Event::SettleTournament(settle_tournament_event)));
        }

        fn _convert_usd_to_wei(self: @ContractState, usd: u128) -> u128 {
            let oracle_dispatcher = IPragmaABIDispatcher { contract_address: oracle_address };
            let response = oracle_dispatcher.get_data_median(DataType::SpotEntry('ETH/USD'));
            assert(response.price > 0, messages::FETCHING_ETH_PRICE_ERROR);
            (usd * pow(10, response.decimals.into()) * 1000000000000000000)
                / (response.price * 100000000)
        }

        fn _assert_has_qualifying_nft(
            self: @ComponentState<TContractState>,
            token: ContractAddress,
            account: ContractAddress,
            token_id: u256
        ) {
            let owner = IERC721BalanceDispatcher { contract_address: token }.owner_of(token_id);
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
            let token_dispatcher = IERC721Dispatcher { contract_address: LOOT_SURVIVOR };
            let owner = token_dispatcher.owner_of(character_id);
            assert(owner == account, Errors::NOT_OWNER);
        }

        fn _assert_stat_requirements(
            self: @ComponentState<TContractState>, tournament_id: u64, adventurer: Adventurer
        ) {
            let qualification_requirements = self.get_tournament(tournament_id).stat_requirements;

            let num_requirements = self.qualification_requirements.len();
            let mut requirement_index = 0;
            loop {
                if requirement_index == num_requirements {
                    break;
                }
                // get requirement
                let requirement = *qualification_requirements.at(requirement_index);
                // handle requirement stat
                match requirement.stat {
                    QualificationRequirementEnum::Xp => {
                        _assert_stat_operation(
                            self, adventurer.xp, requirement.value, requirement.operation
                        );
                    },
                    QualificationRequirementEnum::Gold => {
                        _assert_stat_operation(
                            self, adventurer.gold, requirement.value, requirement.operation
                        );
                    },
                    QualificationRequirementEnum::Strength => {
                        _assert_stat_operation(
                            self, adventurer.strength, requirement.value, requirement.operation
                        );
                    },
                    QualificationRequirementEnum::Dexterity => {
                        _assert_stat_operation(
                            self, adventurer.dexterity, requirement.value, requirement.operation
                        );
                    },
                    QualificationRequirementEnum::Vitality => {
                        _assert_stat_operation(
                            self, adventurer.vitality, requirement.value, requirement.operation
                        );
                    },
                    QualificationRequirementEnum::Intelligence => {
                        _assert_stat_operation(
                            self, adventurer.intelligence, requirement.value, requirement.operation
                        );
                    },
                    QualificationRequirementEnum::Wisdom => {
                        _assert_stat_operation(
                            self, adventurer.wisdom, requirement.value, requirement.operation
                        );
                    },
                    QualificationRequirementEnum::Charisma => {
                        _assert_stat_operation(
                            self, adventurer.charisma, requirement.value, requirement.operation
                        );
                    },
                    QualificationRequirementEnum::Luck => {
                        _assert_stat_operation(
                            self, adventurer.luck, requirement.value, requirement.operation
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
            let loot_requirements = self.get_tournament(tournament_id).loot_requirements;

            let equipment = adventurer.equipment;

            let mut item = 0;
            let mut xp = 0;

            let num_requirements = self.qualification_requirements.len();
            let mut requirement_index = 0;
            loop {
                if requirement_index == num_requirements {
                    break;
                }
                let item_id = *loot_requirements.at(requirement_index).loot;
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
                _assert_stat_operation(self, xp, requirement.value, requirement.operation);
                requirement_index += 1;
            }
        }

        fn _assert_stat_operation(
            self: @ComponentState<TContractState>, stat: u16, value: u16, operation: u8,
        ) {
            if operation == Operation::GreaterThan {
                assert(stat > value, 'Tournament: requirement not met');
            } else if operation == Operation::LessThan {
                assert(stat < value, 'Tournament: requirement not met');
            } else {
                assert(stat == value, 'Tournament: requirement not met');
            }
        }
    }
}
