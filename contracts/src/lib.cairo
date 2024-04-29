mod constants;

// TODO: remove for origami lib
mod components {
    mod client {
        mod client_developer;
        mod client_play;
        mod client_rating;
        mod client_registration;
    }
    mod token {
        mod erc721 {
            mod erc721_approval;
            mod erc721_balance;
            mod erc721_burnable;
            mod erc721_enumerable;
            mod erc721_metadata;
            mod erc721_mintable;
            mod erc721_owner;
        }
    }

    mod tests;
}

#[cfg(test)]
mod tests {
    mod constants;
    mod utils;
}