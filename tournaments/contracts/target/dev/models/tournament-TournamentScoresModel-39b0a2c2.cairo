impl TournamentScoresModelIntrospect<> of dojo::model::introspect::Introspect<
    TournamentScoresModel<>
> {
    #[inline(always)]
    fn size() -> Option<usize> {
        Option::None
    }

    fn layout() -> dojo::model::Layout {
        dojo::model::Layout::Struct(
            array![
                dojo::model::FieldLayout {
                    selector: 657485287730502460094033123982202086350056806678047449621367289642428793093,
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
                name: 'TournamentScoresModel',
                attrs: array![].span(),
                children: array![
                    dojo::model::introspect::Member {
                        name: 'tournament_id',
                        attrs: array!['key'].span(),
                        ty: dojo::model::introspect::Introspect::<u64>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'top_score_ids',
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
pub struct TournamentScoresModelEntity {
    __id: felt252, // private field
    pub top_score_ids: Array<u64>,
}

#[generate_trait]
pub impl TournamentScoresModelEntityStoreImpl of TournamentScoresModelEntityStore {
    fn get(
        world: dojo::world::IWorldDispatcher, entity_id: felt252
    ) -> TournamentScoresModelEntity {
        TournamentScoresModelModelEntityImpl::get(world, entity_id)
    }

    fn update(self: @TournamentScoresModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<TournamentScoresModelEntity>::update_entity(self, world);
    }

    fn delete(self: @TournamentScoresModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<TournamentScoresModelEntity>::delete_entity(self, world);
    }


    fn get_top_score_ids(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> Array<u64> {
        let mut values = dojo::model::ModelEntity::<
            TournamentScoresModelEntity
        >::get_member(
            world,
            entity_id,
            657485287730502460094033123982202086350056806678047449621367289642428793093
        );
        let field_value = core::serde::Serde::<Array<u64>>::deserialize(ref values);

        if core::option::OptionTrait::<Array<u64>>::is_none(@field_value) {
            panic!("Field `TournamentScoresModel::top_score_ids`: deserialization failed.");
        }

        core::option::OptionTrait::<Array<u64>>::unwrap(field_value)
    }

    fn set_top_score_ids(
        self: @TournamentScoresModelEntity, world: dojo::world::IWorldDispatcher, value: Array<u64>
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                657485287730502460094033123982202086350056806678047449621367289642428793093,
                serialized.span()
            );
    }
}

#[generate_trait]
pub impl TournamentScoresModelStoreImpl of TournamentScoresModelStore {
    fn entity_id_from_keys(tournament_id: u64) -> felt252 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);

        core::poseidon::poseidon_hash_span(serialized.span())
    }

    fn from_values(ref keys: Span<felt252>, ref values: Span<felt252>) -> TournamentScoresModel {
        let mut serialized = core::array::ArrayTrait::new();
        serialized.append_span(keys);
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<TournamentScoresModel>::deserialize(ref serialized);

        if core::option::OptionTrait::<TournamentScoresModel>::is_none(@entity) {
            panic!(
                "Model `TournamentScoresModel`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<TournamentScoresModel>::unwrap(entity)
    }

    fn get(world: dojo::world::IWorldDispatcher, tournament_id: u64) -> TournamentScoresModel {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);

        dojo::model::Model::<TournamentScoresModel>::get(world, serialized.span())
    }

    fn set(self: @TournamentScoresModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<TournamentScoresModel>::set_model(self, world);
    }

    fn delete(self: @TournamentScoresModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<TournamentScoresModel>::delete_model(self, world);
    }


    fn get_top_score_ids(world: dojo::world::IWorldDispatcher, tournament_id: u64) -> Array<u64> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentScoresModel
        >::get_member(
            world,
            serialized.span(),
            657485287730502460094033123982202086350056806678047449621367289642428793093
        );

        let field_value = core::serde::Serde::<Array<u64>>::deserialize(ref values);

        if core::option::OptionTrait::<Array<u64>>::is_none(@field_value) {
            panic!("Field `TournamentScoresModel::top_score_ids`: deserialization failed.");
        }

        core::option::OptionTrait::<Array<u64>>::unwrap(field_value)
    }

    fn set_top_score_ids(
        self: @TournamentScoresModel, world: dojo::world::IWorldDispatcher, value: Array<u64>
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                657485287730502460094033123982202086350056806678047449621367289642428793093,
                serialized.span()
            );
    }
}

pub impl TournamentScoresModelModelEntityImpl of dojo::model::ModelEntity<
    TournamentScoresModelEntity
> {
    fn id(self: @TournamentScoresModelEntity) -> felt252 {
        *self.__id
    }

    fn values(self: @TournamentScoresModelEntity) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.top_score_ids, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    fn from_values(entity_id: felt252, ref values: Span<felt252>) -> TournamentScoresModelEntity {
        let mut serialized = array![entity_id];
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity_values = core::serde::Serde::<
            TournamentScoresModelEntity
        >::deserialize(ref serialized);
        if core::option::OptionTrait::<TournamentScoresModelEntity>::is_none(@entity_values) {
            panic!("ModelEntity `TournamentScoresModelEntity`: deserialization failed.");
        }
        core::option::OptionTrait::<TournamentScoresModelEntity>::unwrap(entity_values)
    }

    fn get(
        world: dojo::world::IWorldDispatcher, entity_id: felt252
    ) -> TournamentScoresModelEntity {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            dojo::model::Model::<TournamentScoresModel>::selector(),
            dojo::model::ModelIndex::Id(entity_id),
            dojo::model::Model::<TournamentScoresModel>::layout()
        );
        Self::from_values(entity_id, ref values)
    }

    fn update_entity(self: @TournamentScoresModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            dojo::model::Model::<TournamentScoresModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<TournamentScoresModel>::layout()
        );
    }

    fn delete_entity(self: @TournamentScoresModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world,
            dojo::model::Model::<TournamentScoresModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<TournamentScoresModel>::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, entity_id: felt252, member_id: felt252,
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<TournamentScoresModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    dojo::model::Model::<TournamentScoresModel>::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @TournamentScoresModelEntity,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>,
    ) {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<TournamentScoresModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    dojo::model::Model::<TournamentScoresModel>::selector(),
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
pub impl TournamentScoresModelModelEntityTestImpl of dojo::model::ModelEntityTest<
    TournamentScoresModelEntity
> {
    fn update_test(self: @TournamentScoresModelEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<TournamentScoresModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<TournamentScoresModel>::layout()
        );
    }

    fn delete_test(self: @TournamentScoresModelEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<TournamentScoresModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<TournamentScoresModel>::layout()
        );
    }
}

pub impl TournamentScoresModelModelImpl of dojo::model::Model<TournamentScoresModel> {
    fn get(world: dojo::world::IWorldDispatcher, keys: Span<felt252>) -> TournamentScoresModel {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(keys), Self::layout()
        );
        let mut _keys = keys;

        TournamentScoresModelStore::from_values(ref _keys, ref values)
    }

    fn set_model(self: @TournamentScoresModel, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            Self::selector(),
            dojo::model::ModelIndex::Keys(Self::keys(self)),
            Self::values(self),
            Self::layout()
        );
    }

    fn delete_model(self: @TournamentScoresModel, world: dojo::world::IWorldDispatcher) {
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
        self: @TournamentScoresModel,
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
        "TournamentScoresModel"
    }

    #[inline(always)]
    fn namespace() -> ByteArray {
        "tournament"
    }

    #[inline(always)]
    fn tag() -> ByteArray {
        "tournament-TournamentScoresModel"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        1630870049467614158727963619921790471898255444742314158749436133940324241160
    }

    #[inline(always)]
    fn instance_selector(self: @TournamentScoresModel) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn name_hash() -> felt252 {
        3475470184584957882859677437089502101310293382526498366498040050432314917718
    }

    #[inline(always)]
    fn namespace_hash() -> felt252 {
        3513465382457774401660929656863894979351645367198604050918895380273858322651
    }

    #[inline(always)]
    fn entity_id(self: @TournamentScoresModel) -> felt252 {
        core::poseidon::poseidon_hash_span(self.keys())
    }

    #[inline(always)]
    fn keys(self: @TournamentScoresModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.tournament_id, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @TournamentScoresModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.top_score_ids, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::model::Layout {
        dojo::model::introspect::Introspect::<TournamentScoresModel>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @TournamentScoresModel) -> dojo::model::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        dojo::model::layout::compute_packed_size(Self::layout())
    }
}

#[cfg(target: "test")]
pub impl TournamentScoresModelModelTestImpl of dojo::model::ModelTest<TournamentScoresModel> {
    fn set_test(self: @TournamentScoresModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<TournamentScoresModel>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<TournamentScoresModel>::keys(self)),
            dojo::model::Model::<TournamentScoresModel>::values(self),
            dojo::model::Model::<TournamentScoresModel>::layout()
        );
    }

    fn delete_test(self: @TournamentScoresModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<TournamentScoresModel>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<TournamentScoresModel>::keys(self)),
            dojo::model::Model::<TournamentScoresModel>::layout()
        );
    }
}

#[starknet::interface]
pub trait Itournament_scores_model<T> {
    fn ensure_abi(self: @T, model: TournamentScoresModel);
}

#[starknet::contract]
pub mod tournament_scores_model {
    use super::TournamentScoresModel;
    use super::Itournament_scores_model;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            "TournamentScoresModel"
        }

        fn namespace(self: @ContractState) -> ByteArray {
            "tournament"
        }

        fn tag(self: @ContractState) -> ByteArray {
            "tournament-TournamentScoresModel"
        }

        fn version(self: @ContractState) -> u8 {
            1
        }

        fn selector(self: @ContractState) -> felt252 {
            1630870049467614158727963619921790471898255444742314158749436133940324241160
        }

        fn name_hash(self: @ContractState) -> felt252 {
            3475470184584957882859677437089502101310293382526498366498040050432314917718
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            3513465382457774401660929656863894979351645367198604050918895380273858322651
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::model::introspect::Introspect::<TournamentScoresModel>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<TournamentScoresModel>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::model::Layout {
            dojo::model::Model::<TournamentScoresModel>::layout()
        }

        fn schema(self: @ContractState) -> dojo::model::introspect::Ty {
            dojo::model::introspect::Introspect::<TournamentScoresModel>::ty()
        }
    }

    #[abi(embed_v0)]
    impl tournament_scores_modelImpl of Itournament_scores_model<ContractState> {
        fn ensure_abi(self: @ContractState, model: TournamentScoresModel) {}
    }
}
