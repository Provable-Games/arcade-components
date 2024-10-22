mod ls15_components {
    mod constants;
    mod interfaces;
    mod loot_survivor;
    mod tournament;
    mod tests {
        mod erc20_mock;
        mod erc721_mock;
        mod erc1155_mock;
        mod loot_survivor_mock;
        mod pragma_mock;
        mod tournament_mock;
        #[cfg(test)]
        mod test_tournament;
    }
}

#[cfg(test)]
mod tests {
    mod constants;
    mod utils;
}
