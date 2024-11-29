pub const VRF_COST_PER_GAME: u32 = 50000000; // $0.50 with 8 decimals

//
// Tournament time constraints
//

// TEST VALUES
pub const MIN_REGISTRATION_PERIOD: u32 = 1; // 1 second
pub const MIN_TOURNAMENT_LENGTH: u32 = 1; // 1 second
pub const MIN_SUBMISSION_PERIOD: u32 = 1; // 1 second

// PRODUCTION VALUES
// pub const MIN_REGISTRATION_PERIOD: u32 = 300; // 5 minutes
pub const MAX_REGISTRATION_PERIOD: u32 = 2592000; // 1 month
// pub const MIN_TOURNAMENT_LENGTH: u32 = 3600; // 1 hour
pub const MAX_TOURNAMENT_LENGTH: u32 = 15552000; // 6 months
// pub const MIN_SUBMISSION_PERIOD: u32 = 1800; // 30 mins
pub const MAX_SUBMISSION_PERIOD: u32 = 1209600; // 2 weeks
pub const GAME_EXPIRATION_PERIOD: u32 = 864000; // 10 days

pub const TWO_POW_128: u128 = 100000000000000000000000000000000;
