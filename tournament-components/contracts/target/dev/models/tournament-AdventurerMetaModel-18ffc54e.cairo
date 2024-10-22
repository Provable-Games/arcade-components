impl AdventurerMetaModelIntrospect<> of dojo::model::introspect::Introspect<AdventurerMetaModel<>> {
    #[inline(always)]
    fn size() -> Option<usize> {
        dojo::model::introspect::Introspect::<AdventurerMetadata>::size()
    }

    fn layout() -> dojo::model::Layout {
        dojo::model::Layout::Struct(
            array![
                dojo::model::FieldLayout {
                    selector: 1742387613454826467390028788373241378094498590410890675595565706426403809293,
                    layout: dojo::model::introspect::Introspect::<AdventurerMetadata>::layout()
                }
            ]
                .span()
        )
    }

    #[inline(always)]
    fn ty() -> dojo::model::introspect::Ty {
        dojo::model::introspect::Ty::Struct(
            dojo::model::introspect::Struct {
                name: 'AdventurerMetaModel',
                attrs: array![].span(),
                children: array![
                    dojo::model::introspect::Member {
                        name: 'adventurer_id',
                        attrs: array!['key'].span(),
                        ty: dojo::model::introspect::Introspect::<felt252>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'adventurer_meta',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<AdventurerMetadata>::ty()
                    }
                ]
                    .span()
            }
        )
    }
}

#[derive(Drop, Serde)]
pub struct AdventurerMetaModelEntity {
    __id: felt252, // private field
    pub adventurer_meta: AdventurerMetadata,
}

#[generate_trait]
pub impl AdventurerMetaModelEntityStoreImpl of AdventurerMetaModelEntityStore {
    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> AdventurerMetaModelEntity {
        AdventurerMetaModelModelEntityImpl::get(world, entity_id)
    }

    fn update(self: @AdventurerMetaModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<AdventurerMetaModelEntity>::update_entity(self, world);
    }

    fn delete(self: @AdventurerMetaModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<AdventurerMetaModelEntity>::delete_entity(self, world);
    }


    fn get_adventurer_meta(
        world: dojo::world::IWorldDispatcher, entity_id: felt252
    ) -> AdventurerMetadata {
        let mut values = dojo::model::ModelEntity::<
            AdventurerMetaModelEntity
        >::get_member(
            world,
            entity_id,
            1742387613454826467390028788373241378094498590410890675595565706426403809293
        );
        let field_value = core::serde::Serde::<AdventurerMetadata>::deserialize(ref values);

        if core::option::OptionTrait::<AdventurerMetadata>::is_none(@field_value) {
            panic!("Field `AdventurerMetaModel::adventurer_meta`: deserialization failed.");
        }

        core::option::OptionTrait::<AdventurerMetadata>::unwrap(field_value)
    }

    fn set_adventurer_meta(
        self: @AdventurerMetaModelEntity,
        world: dojo::world::IWorldDispatcher,
        value: AdventurerMetadata
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1742387613454826467390028788373241378094498590410890675595565706426403809293,
                serialized.span()
            );
    }
}

#[generate_trait]
pub impl AdventurerMetaModelStoreImpl of AdventurerMetaModelStore {
    fn entity_id_from_keys(adventurer_id: felt252) -> felt252 {
        let mut serialized = core::array::ArrayTrait::new();
        core::array::ArrayTrait::append(ref serialized, adventurer_id);

        core::poseidon::poseidon_hash_span(serialized.span())
    }

    fn from_values(ref keys: Span<felt252>, ref values: Span<felt252>) -> AdventurerMetaModel {
        let mut serialized = core::array::ArrayTrait::new();
        serialized.append_span(keys);
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<AdventurerMetaModel>::deserialize(ref serialized);

        if core::option::OptionTrait::<AdventurerMetaModel>::is_none(@entity) {
            panic!(
                "Model `AdventurerMetaModel`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<AdventurerMetaModel>::unwrap(entity)
    }

    fn get(world: dojo::world::IWorldDispatcher, adventurer_id: felt252) -> AdventurerMetaModel {
        let mut serialized = core::array::ArrayTrait::new();
        core::array::ArrayTrait::append(ref serialized, adventurer_id);

        dojo::model::Model::<AdventurerMetaModel>::get(world, serialized.span())
    }

    fn set(self: @AdventurerMetaModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<AdventurerMetaModel>::set_model(self, world);
    }

    fn delete(self: @AdventurerMetaModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<AdventurerMetaModel>::delete_model(self, world);
    }


    fn get_adventurer_meta(
        world: dojo::world::IWorldDispatcher, adventurer_id: felt252
    ) -> AdventurerMetadata {
        let mut serialized = core::array::ArrayTrait::new();
        core::array::ArrayTrait::append(ref serialized, adventurer_id);

        let mut values = dojo::model::Model::<
            AdventurerMetaModel
        >::get_member(
            world,
            serialized.span(),
            1742387613454826467390028788373241378094498590410890675595565706426403809293
        );

        let field_value = core::serde::Serde::<AdventurerMetadata>::deserialize(ref values);

        if core::option::OptionTrait::<AdventurerMetadata>::is_none(@field_value) {
            panic!("Field `AdventurerMetaModel::adventurer_meta`: deserialization failed.");
        }

        core::option::OptionTrait::<AdventurerMetadata>::unwrap(field_value)
    }

    fn set_adventurer_meta(
        self: @AdventurerMetaModel, world: dojo::world::IWorldDispatcher, value: AdventurerMetadata
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1742387613454826467390028788373241378094498590410890675595565706426403809293,
                serialized.span()
            );
    }
}

pub impl AdventurerMetaModelModelEntityImpl of dojo::model::ModelEntity<AdventurerMetaModelEntity> {
    fn id(self: @AdventurerMetaModelEntity) -> felt252 {
        *self.__id
    }

    fn values(self: @AdventurerMetaModelEntity) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.adventurer_meta, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    fn from_values(entity_id: felt252, ref values: Span<felt252>) -> AdventurerMetaModelEntity {
        let mut serialized = array![entity_id];
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity_values = core::serde::Serde::<
            AdventurerMetaModelEntity
        >::deserialize(ref serialized);
        if core::option::OptionTrait::<AdventurerMetaModelEntity>::is_none(@entity_values) {
            panic!("ModelEntity `AdventurerMetaModelEntity`: deserialization failed.");
        }
        core::option::OptionTrait::<AdventurerMetaModelEntity>::unwrap(entity_values)
    }

    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> AdventurerMetaModelEntity {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            dojo::model::Model::<AdventurerMetaModel>::selector(),
            dojo::model::ModelIndex::Id(entity_id),
            dojo::model::Model::<AdventurerMetaModel>::layout()
        );
        Self::from_values(entity_id, ref values)
    }

    fn update_entity(self: @AdventurerMetaModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            dojo::model::Model::<AdventurerMetaModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<AdventurerMetaModel>::layout()
        );
    }

    fn delete_entity(self: @AdventurerMetaModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world,
            dojo::model::Model::<AdventurerMetaModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<AdventurerMetaModel>::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, entity_id: felt252, member_id: felt252,
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<AdventurerMetaModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    dojo::model::Model::<AdventurerMetaModel>::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @AdventurerMetaModelEntity,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>,
    ) {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<AdventurerMetaModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    dojo::model::Model::<AdventurerMetaModel>::selector(),
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
pub impl AdventurerMetaModelModelEntityTestImpl of dojo::model::ModelEntityTest<
    AdventurerMetaModelEntity
> {
    fn update_test(self: @AdventurerMetaModelEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<AdventurerMetaModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<AdventurerMetaModel>::layout()
        );
    }

    fn delete_test(self: @AdventurerMetaModelEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<AdventurerMetaModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<AdventurerMetaModel>::layout()
        );
    }
}

pub impl AdventurerMetaModelModelImpl of dojo::model::Model<AdventurerMetaModel> {
    fn get(world: dojo::world::IWorldDispatcher, keys: Span<felt252>) -> AdventurerMetaModel {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(keys), Self::layout()
        );
        let mut _keys = keys;

        AdventurerMetaModelStore::from_values(ref _keys, ref values)
    }

    fn set_model(self: @AdventurerMetaModel, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            Self::selector(),
            dojo::model::ModelIndex::Keys(Self::keys(self)),
            Self::values(self),
            Self::layout()
        );
    }

    fn delete_model(self: @AdventurerMetaModel, world: dojo::world::IWorldDispatcher) {
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
        self: @AdventurerMetaModel,
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
        "AdventurerMetaModel"
    }

    #[inline(always)]
    fn namespace() -> ByteArray {
        "tournament"
    }

    #[inline(always)]
    fn tag() -> ByteArray {
        "tournament-AdventurerMetaModel"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        706713508657115460451590445636458891998326624311601784205365677636977381644
    }

    #[inline(always)]
    fn instance_selector(self: @AdventurerMetaModel) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn name_hash() -> felt252 {
        1343290822537690278318854341244767891868730015503095362413451888649133500323
    }

    #[inline(always)]
    fn namespace_hash() -> felt252 {
        3513465382457774401660929656863894979351645367198604050918895380273858322651
    }

    #[inline(always)]
    fn entity_id(self: @AdventurerMetaModel) -> felt252 {
        core::poseidon::poseidon_hash_span(self.keys())
    }

    #[inline(always)]
    fn keys(self: @AdventurerMetaModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::array::ArrayTrait::append(ref serialized, *self.adventurer_id);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @AdventurerMetaModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.adventurer_meta, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::model::Layout {
        dojo::model::introspect::Introspect::<AdventurerMetaModel>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @AdventurerMetaModel) -> dojo::model::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        dojo::model::layout::compute_packed_size(Self::layout())
    }
}

#[cfg(target: "test")]
pub impl AdventurerMetaModelModelTestImpl of dojo::model::ModelTest<AdventurerMetaModel> {
    fn set_test(self: @AdventurerMetaModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<AdventurerMetaModel>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<AdventurerMetaModel>::keys(self)),
            dojo::model::Model::<AdventurerMetaModel>::values(self),
            dojo::model::Model::<AdventurerMetaModel>::layout()
        );
    }

    fn delete_test(self: @AdventurerMetaModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<AdventurerMetaModel>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<AdventurerMetaModel>::keys(self)),
            dojo::model::Model::<AdventurerMetaModel>::layout()
        );
    }
}

#[starknet::interface]
pub trait Iadventurer_meta_model<T> {
    fn ensure_abi(self: @T, model: AdventurerMetaModel);
}

#[starknet::contract]
pub mod adventurer_meta_model {
    use super::AdventurerMetaModel;
    use super::Iadventurer_meta_model;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            "AdventurerMetaModel"
        }

        fn namespace(self: @ContractState) -> ByteArray {
            "tournament"
        }

        fn tag(self: @ContractState) -> ByteArray {
            "tournament-AdventurerMetaModel"
        }

        fn version(self: @ContractState) -> u8 {
            1
        }

        fn selector(self: @ContractState) -> felt252 {
            706713508657115460451590445636458891998326624311601784205365677636977381644
        }

        fn name_hash(self: @ContractState) -> felt252 {
            1343290822537690278318854341244767891868730015503095362413451888649133500323
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            3513465382457774401660929656863894979351645367198604050918895380273858322651
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::model::introspect::Introspect::<AdventurerMetaModel>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<AdventurerMetaModel>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::model::Layout {
            dojo::model::Model::<AdventurerMetaModel>::layout()
        }

        fn schema(self: @ContractState) -> dojo::model::introspect::Ty {
            dojo::model::introspect::Introspect::<AdventurerMetaModel>::ty()
        }
    }

    #[abi(embed_v0)]
    impl adventurer_meta_modelImpl of Iadventurer_meta_model<ContractState> {
        fn ensure_abi(self: @ContractState, model: AdventurerMetaModel) {}
    }
}
