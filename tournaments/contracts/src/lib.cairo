mod ls15_components {
    mod constants;
    mod interfaces;
    mod loot_survivor;
    mod libs {
        pub mod store;
        pub mod utils;
    }
    mod models {
        pub mod loot_survivor;
        pub mod tournament;
    }
    mod tournament;
    mod tests {
        mod erc20_mock;
        mod erc721_mock;
        #[cfg(test)]
        mod helpers;
        mod loot_survivor_mock;
        mod pragma_mock;
        mod tournament_mock;
        #[cfg(test)]
        mod test_tournament;
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

