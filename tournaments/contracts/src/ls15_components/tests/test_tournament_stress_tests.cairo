use starknet::testing;
use tournament::ls15_components::constants::{MIN_SUBMISSION_PERIOD};

use tournament::ls15_components::tests::erc20_mock::{IERC20MockDispatcherTrait};
use tournament::ls15_components::tests::loot_survivor_mock::{ILootSurvivorMockDispatcherTrait};
use tournament::ls15_components::tests::tournament_mock::{ITournamentMockDispatcherTrait};
use tournament::ls15_components::tests::test_tournament::setup;
use tournament::tests::{
    utils,
    constants::{OWNER, TOURNAMENT_NAME, TOURNAMENT_DESCRIPTION, TEST_START_TIME, TEST_END_TIME},
};
use tournament::ls15_components::tests::helpers::{create_dead_adventurer_with_xp};

#[test]
fn test_submit_multiple_scores_stress_test() {
    let (_world, mut tournament, mut loot_survivor, _pragma, mut eth, mut lords, _erc20, _erc721,) =
        setup();

    utils::impersonate(OWNER());

    let tournament_id = tournament
        .create_tournament(
            TOURNAMENT_NAME(),
            TOURNAMENT_DESCRIPTION(),
            TEST_START_TIME().into(),
            TEST_END_TIME().into(),
            MIN_SUBMISSION_PERIOD.into(),
            100, // 100 top scores
            Option::None, // zero gated type
            Option::None, // zero entry premium
        );

    utils::impersonate(OWNER());

    eth.mint(OWNER(), 100 * 200000000000000);
    lords.mint(OWNER(), 100 * 50000000000000000000);

    // Enter tournament 100 times
    let mut i: u64 = 0;
    loop {
        if i == 100 {
            break;
        }
        tournament.enter_tournament(tournament_id, Option::None);
        i += 1;
    };

    testing::set_block_timestamp(TEST_START_TIME().into());

    lords.approve(tournament.contract_address, 100 * 50000000000000000000);
    eth.approve(tournament.contract_address, 100 * 200000000000000);

    // Approve game costs and start tournament for all players (the default will start all games for
    // the address)
    tournament.start_tournament(tournament_id, false, Option::None);

    testing::set_block_timestamp(TEST_END_TIME().into());

    // Set data to adventurers with increasing XP
    let mut i: u64 = 0;
    loop {
        if i == 100 {
            break;
        }
        let submitted_adventurer = create_dead_adventurer_with_xp((i + 1).try_into().unwrap());
        loot_survivor.set_adventurer((i + 1).try_into().unwrap(), submitted_adventurer);
        i += 1;
    };

    // Submit scores in order of position
    let mut score_ids: Array<felt252> = array![];
    let mut i: u64 = 0;
    loop {
        if i == 100 {
            break;
        }
        score_ids.append((100 - i).try_into().unwrap());
        i += 1;
    };
    // tournament.submit_scores(tournament_id, score_ids);
// // Verify scores
// let scores = tournament.top_scores(tournament_id);
// assert(scores.len() == 100, 'Invalid scores length');
// let mut i: u64 = 0;
// loop {
//     if i == 100 {
//         break;
//     }
//     assert(*scores.at(i.try_into().unwrap()) == (100 - i).into(), 'Invalid score');
//     i += 1;
// };
}
