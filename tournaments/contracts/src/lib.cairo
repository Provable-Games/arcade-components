mod ls15_components {
    pub mod constants;
    mod interfaces;
    mod loot_survivor;
    mod libs {
        pub mod store;
        pub mod utils;
    }
    pub mod models {
        pub mod loot_survivor;
        pub mod tournament;
    }
    pub mod tournament;
    mod tests {
        pub mod eth_mock;
        pub mod lords_mock;
        pub mod erc20_mock;
        pub mod erc721_mock;
        #[cfg(test)]
        mod helpers;
        pub mod loot_survivor_mock;
        pub mod pragma_mock;
        pub mod tournament_mock;
        #[cfg(test)]
        mod test_tournament;
        pub mod interfaces;
        // #[cfg(test)]
    // mod test_tournament_stress_tests;
    }
}
// mod presets {
//     mod ls_tournament;
// }

#[cfg(test)]
mod tests {
    pub mod constants;
    pub mod utils;
}

