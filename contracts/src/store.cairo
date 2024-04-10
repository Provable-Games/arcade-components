// Dojo imports
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

// LS imports
use ls::models::client::Client;
use ls::models::config::Config;

/// Store struct.
#[derive(Copy, Drop)]
struct Store {
    world: IWorldDispatcher,
}

/// Implementation of the `StoreTrait` trait for the `Store` struct.
#[generate_trait]
impl StoreImpl of StoreTrait {
    #[inline(always)]
    fn new(world: IWorldDispatcher) -> Store {
        Store { world: world }
    }

    #[inline(always)]
    fn config(self: Store) -> Config {
        get!(self.world, 1, (Config))
    }

    #[inline(always)]
    fn client(self: Store, id: felt252) -> Client {
        get!(self.world, id, (Client))
    }

    #[inline(always)]
    fn set_config(self: Store, config: Config) {
        set!(self.world, (config))
    }

    #[inline(always)]
    fn set_client(self: Store, client: Client) {
        set!(self.world, (client))
    }

    #[inline(always)]
    fn set_url(self: Store, id: felt252, url: felt252) {
        let mut client = get!(self.world, id, (Client));
        client.url = url;
        set!(self.world, (client))
    }

    #[inline(always)]
    fn set_rating(self: Store, id: felt252, rating: u8) {
        let mut client = get!(self.world, id, (Client));
        client.rating = rating;
        set!(self.world, (client))
    }
}