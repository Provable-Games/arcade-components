impl TournamentEntriesModelIntrospect<> of dojo::model::introspect::Introspect<
    TournamentEntriesModel<>
> {
    #[inline(always)]
    fn size() -> Option<usize> {
        Option::None
    }

    fn layout() -> dojo::model::Layout {
        dojo::model::Layout::Struct(
            array![
                dojo::model::FieldLayout {
                    selector: 265866676642830162498721691547279957379484306165912539482818020839472807558,
                    layout: dojo::model::introspect::Introspect::<Array<u64>>::layout()
                }
            ]
                .span()
        )
    }

    #[inline(always)]
    fn ty() -> dojo::model::introspect::Ty {
        dojo::model::introspect::Ty::Struct(
            dojo::model::introspect::Struct {
                name: 'TournamentEntriesModel',
                attrs: array![].span(),
                children: array![
                    dojo::model::introspect::Member {
                        name: 'tournament_id',
                        attrs: array!['key'].span(),
                        ty: dojo::model::introspect::Introspect::<u64>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'game_ids',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Ty::Array(
                            array![dojo::model::introspect::Introspect::<u64>::ty()].span()
                        )
                    }
                ]
                    .span()
            }
        )
    }
}

#[derive(Drop, Serde)]
pub struct TournamentEntriesModelEntity {
    __id: felt252, // private field
    pub game_ids: Array<u64>,
}

#[generate_trait]
pub impl TournamentEntriesModelEntityStoreImpl of TournamentEntriesModelEntityStore {
    fn get(
        world: dojo::world::IWorldDispatcher, entity_id: felt252
    ) -> TournamentEntriesModelEntity {
        TournamentEntriesModelModelEntityImpl::get(world, entity_id)
    }

    fn update(self: @TournamentEntriesModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<TournamentEntriesModelEntity>::update_entity(self, world);
    }

    fn delete(self: @TournamentEntriesModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<TournamentEntriesModelEntity>::delete_entity(self, world);
    }


    fn get_game_ids(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> Array<u64> {
        let mut values = dojo::model::ModelEntity::<
            TournamentEntriesModelEntity
        >::get_member(
            world,
            entity_id,
            265866676642830162498721691547279957379484306165912539482818020839472807558
        );
        let field_value = core::serde::Serde::<Array<u64>>::deserialize(ref values);

        if core::option::OptionTrait::<Array<u64>>::is_none(@field_value) {
            panic!("Field `TournamentEntriesModel::game_ids`: deserialization failed.");
        }

        core::option::OptionTrait::<Array<u64>>::unwrap(field_value)
    }

    fn set_game_ids(
        self: @TournamentEntriesModelEntity, world: dojo::world::IWorldDispatcher, value: Array<u64>
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                265866676642830162498721691547279957379484306165912539482818020839472807558,
                serialized.span()
            );
    }
}

#[generate_trait]
pub impl TournamentEntriesModelStoreImpl of TournamentEntriesModelStore {
    fn entity_id_from_keys(tournament_id: u64) -> felt252 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);

        core::poseidon::poseidon_hash_span(serialized.span())
    }

    fn from_values(ref keys: Span<felt252>, ref values: Span<felt252>) -> TournamentEntriesModel {
        let mut serialized = core::array::ArrayTrait::new();
        serialized.append_span(keys);
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<TournamentEntriesModel>::deserialize(ref serialized);

        if core::option::OptionTrait::<TournamentEntriesModel>::is_none(@entity) {
            panic!(
                "Model `TournamentEntriesModel`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<TournamentEntriesModel>::unwrap(entity)
    }

    fn get(world: dojo::world::IWorldDispatcher, tournament_id: u64) -> TournamentEntriesModel {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);

        dojo::model::Model::<TournamentEntriesModel>::get(world, serialized.span())
    }

    fn set(self: @TournamentEntriesModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<TournamentEntriesModel>::set_model(self, world);
    }

    fn delete(self: @TournamentEntriesModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<TournamentEntriesModel>::delete_model(self, world);
    }


    fn get_game_ids(world: dojo::world::IWorldDispatcher, tournament_id: u64) -> Array<u64> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentEntriesModel
        >::get_member(
            world,
            serialized.span(),
            265866676642830162498721691547279957379484306165912539482818020839472807558
        );

        let field_value = core::serde::Serde::<Array<u64>>::deserialize(ref values);

        if core::option::OptionTrait::<Array<u64>>::is_none(@field_value) {
            panic!("Field `TournamentEntriesModel::game_ids`: deserialization failed.");
        }

        core::option::OptionTrait::<Array<u64>>::unwrap(field_value)
    }

    fn set_game_ids(
        self: @TournamentEntriesModel, world: dojo::world::IWorldDispatcher, value: Array<u64>
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                265866676642830162498721691547279957379484306165912539482818020839472807558,
                serialized.span()
            );
    }
}

pub impl TournamentEntriesModelModelEntityImpl of dojo::model::ModelEntity<
    TournamentEntriesModelEntity
> {
    fn id(self: @TournamentEntriesModelEntity) -> felt252 {
        *self.__id
    }

    fn values(self: @TournamentEntriesModelEntity) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.game_ids, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    fn from_values(entity_id: felt252, ref values: Span<felt252>) -> TournamentEntriesModelEntity {
        let mut serialized = array![entity_id];
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity_values = core::serde::Serde::<
            TournamentEntriesModelEntity
        >::deserialize(ref serialized);
        if core::option::OptionTrait::<TournamentEntriesModelEntity>::is_none(@entity_values) {
            panic!("ModelEntity `TournamentEntriesModelEntity`: deserialization failed.");
        }
        core::option::OptionTrait::<TournamentEntriesModelEntity>::unwrap(entity_values)
    }

    fn get(
        world: dojo::world::IWorldDispatcher, entity_id: felt252
    ) -> TournamentEntriesModelEntity {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            dojo::model::Model::<TournamentEntriesModel>::selector(),
            dojo::model::ModelIndex::Id(entity_id),
            dojo::model::Model::<TournamentEntriesModel>::layout()
        );
        Self::from_values(entity_id, ref values)
    }

    fn update_entity(self: @TournamentEntriesModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            dojo::model::Model::<TournamentEntriesModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<TournamentEntriesModel>::layout()
        );
    }

    fn delete_entity(self: @TournamentEntriesModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world,
            dojo::model::Model::<TournamentEntriesModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<TournamentEntriesModel>::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, entity_id: felt252, member_id: felt252,
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<TournamentEntriesModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    dojo::model::Model::<TournamentEntriesModel>::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @TournamentEntriesModelEntity,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>,
    ) {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<TournamentEntriesModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    dojo::model::Model::<TournamentEntriesModel>::selector(),
                    dojo::model::ModelIndex::MemberId((self.id(), member_id)),
                    values,
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }
}

#[cfg(target: "test")]
pub impl TournamentEntriesModelModelEntityTestImpl of dojo::model::ModelEntityTest<
    TournamentEntriesModelEntity
> {
    fn update_test(self: @TournamentEntriesModelEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<TournamentEntriesModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<TournamentEntriesModel>::layout()
        );
    }

    fn delete_test(self: @TournamentEntriesModelEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<TournamentEntriesModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<TournamentEntriesModel>::layout()
        );
    }
}

pub impl TournamentEntriesModelModelImpl of dojo::model::Model<TournamentEntriesModel> {
    fn get(world: dojo::world::IWorldDispatcher, keys: Span<felt252>) -> TournamentEntriesModel {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(keys), Self::layout()
        );
        let mut _keys = keys;

        TournamentEntriesModelStore::from_values(ref _keys, ref values)
    }

    fn set_model(self: @TournamentEntriesModel, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            Self::selector(),
            dojo::model::ModelIndex::Keys(Self::keys(self)),
            Self::values(self),
            Self::layout()
        );
    }

    fn delete_model(self: @TournamentEntriesModel, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(Self::keys(self)), Self::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, keys: Span<felt252>, member_id: felt252
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(Self::layout(), member_id) {
            Option::Some(field_layout) => {
                let entity_id = dojo::utils::entity_id_from_keys(keys);
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    Self::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @TournamentEntriesModel,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>
    ) {
        match dojo::utils::find_model_field_layout(Self::layout(), member_id) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    Self::selector(),
                    dojo::model::ModelIndex::MemberId((self.entity_id(), member_id)),
                    values,
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    #[inline(always)]
    fn name() -> ByteArray {
        "TournamentEntriesModel"
    }

    #[inline(always)]
    fn namespace() -> ByteArray {
        "tournament"
    }

    #[inline(always)]
    fn tag() -> ByteArray {
        "tournament-TournamentEntriesModel"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        3405964199345371652566784708652785911539656439044567812859280477940265167958
    }

    #[inline(always)]
    fn instance_selector(self: @TournamentEntriesModel) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn name_hash() -> felt252 {
        1451925231007600780762019957633412304209262945927093331402298756814238478912
    }

    #[inline(always)]
    fn namespace_hash() -> felt252 {
        3513465382457774401660929656863894979351645367198604050918895380273858322651
    }

    #[inline(always)]
    fn entity_id(self: @TournamentEntriesModel) -> felt252 {
        core::poseidon::poseidon_hash_span(self.keys())
    }

    #[inline(always)]
    fn keys(self: @TournamentEntriesModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.tournament_id, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @TournamentEntriesModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.game_ids, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::model::Layout {
        dojo::model::introspect::Introspect::<TournamentEntriesModel>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @TournamentEntriesModel) -> dojo::model::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        dojo::model::layout::compute_packed_size(Self::layout())
    }
}

#[cfg(target: "test")]
pub impl TournamentEntriesModelModelTestImpl of dojo::model::ModelTest<TournamentEntriesModel> {
    fn set_test(self: @TournamentEntriesModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<TournamentEntriesModel>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<TournamentEntriesModel>::keys(self)),
            dojo::model::Model::<TournamentEntriesModel>::values(self),
            dojo::model::Model::<TournamentEntriesModel>::layout()
        );
    }

    fn delete_test(self: @TournamentEntriesModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<TournamentEntriesModel>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<TournamentEntriesModel>::keys(self)),
            dojo::model::Model::<TournamentEntriesModel>::layout()
        );
    }
}

#[starknet::interface]
pub trait Itournament_entries_model<T> {
    fn ensure_abi(self: @T, model: TournamentEntriesModel);
}

#[starknet::contract]
pub mod tournament_entries_model {
    use super::TournamentEntriesModel;
    use super::Itournament_entries_model;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            "TournamentEntriesModel"
        }

        fn namespace(self: @ContractState) -> ByteArray {
            "tournament"
        }

        fn tag(self: @ContractState) -> ByteArray {
            "tournament-TournamentEntriesModel"
        }

        fn version(self: @ContractState) -> u8 {
            1
        }

        fn selector(self: @ContractState) -> felt252 {
            3405964199345371652566784708652785911539656439044567812859280477940265167958
        }

        fn name_hash(self: @ContractState) -> felt252 {
            1451925231007600780762019957633412304209262945927093331402298756814238478912
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            3513465382457774401660929656863894979351645367198604050918895380273858322651
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::model::introspect::Introspect::<TournamentEntriesModel>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<TournamentEntriesModel>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::model::Layout {
            dojo::model::Model::<TournamentEntriesModel>::layout()
        }

        fn schema(self: @ContractState) -> dojo::model::introspect::Ty {
            dojo::model::introspect::Introspect::<TournamentEntriesModel>::ty()
        }
    }

    #[abi(embed_v0)]
    impl tournament_entries_modelImpl of Itournament_entries_model<ContractState> {
        fn ensure_abi(self: @ContractState, model: TournamentEntriesModel) {}
    }
}
