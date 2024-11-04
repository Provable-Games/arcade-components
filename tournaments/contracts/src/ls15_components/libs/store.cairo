use dojo::world::{WorldStorage, WorldStorageTrait};
use dojo::model::{
    ModelStorage, ModelValueStorage,
};

use tournament::ls15_components::models::loot_survivor::{AdventurerModel, Contracts};

#[derive(Copy, Drop)]
pub struct Store {
    world: WorldStorage,
}

#[generate_trait]
pub impl StoreImpl of StoreTrait {
    #[inline(always)]
    fn new(world: WorldStorage) -> Store {
        (Store { world })
    }

    //
    // Getters
    //

    #[inline(always)]
    fn get_adventurer(
        ref self: Store, adventurer_id: felt252
    ) -> AdventurerModel {
        (self.world.read_model(adventurer_id))
    }

    //
    // Setters
    //

    #[inline(always)]
    fn set_contracts(ref self: Store, model: @Contracts) {
        self.world.write_model(model);
    }
}