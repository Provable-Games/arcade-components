mod constants;
mod store;

mod models {
    mod client;
    mod config;
}

mod systems {
    mod client;
}

// TODO: remove for origami lib
mod token {
    mod components {
        mod token {
            mod erc721 {
                mod erc721_approval;
                mod erc721_balance;
                mod erc721_burnable;
                mod erc721_metadata;
                mod erc721_mintable;
                mod erc721_owner;
            }
        }
    }
}