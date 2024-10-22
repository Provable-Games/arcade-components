impl AdventurerModelIntrospect<> of dojo::model::introspect::Introspect<AdventurerModel<>> {
    #[inline(always)]
    fn size() -> Option<usize> {
        dojo::model::introspect::Introspect::<Adventurer>::size()
    }

    fn layout() -> dojo::model::Layout {
        dojo::model::Layout::Struct(
            array![
                dojo::model::FieldLayout {
                    selector: 749380586961727072018731206412639157887364770643871151114870710297486048416,
                    layout: dojo::model::introspect::Introspect::<Adventurer>::layout()
                }
            ]
                .span()
        )
    }

    #[inline(always)]
    fn ty() -> dojo::model::introspect::Ty {
        dojo::model::introspect::Ty::Struct(
            dojo::model::introspect::Struct {
                name: 'AdventurerModel',
                attrs: array![].span(),
                children: array![
                    dojo::model::introspect::Member {
                        name: 'adventurer_id',
                        attrs: array!['key'].span(),
                        ty: dojo::model::introspect::Introspect::<felt252>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'adventurer',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<Adventurer>::ty()
                    }
                ]
                    .span()
            }
        )
    }
}

#[derive(Drop, Serde)]
pub struct AdventurerModelEntity {
    __id: felt252, // private field
    pub adventurer: Adventurer,
}

#[generate_trait]
pub impl AdventurerModelEntityStoreImpl of AdventurerModelEntityStore {
    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> AdventurerModelEntity {
        AdventurerModelModelEntityImpl::get(world, entity_id)
    }

    fn update(self: @AdventurerModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<AdventurerModelEntity>::update_entity(self, world);
    }

    fn delete(self: @AdventurerModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<AdventurerModelEntity>::delete_entity(self, world);
    }


    fn get_adventurer(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> Adventurer {
        let mut values = dojo::model::ModelEntity::<
            AdventurerModelEntity
        >::get_member(
            world,
            entity_id,
            749380586961727072018731206412639157887364770643871151114870710297486048416
        );
        let field_value = core::serde::Serde::<Adventurer>::deserialize(ref values);

        if core::option::OptionTrait::<Adventurer>::is_none(@field_value) {
            panic!("Field `AdventurerModel::adventurer`: deserialization failed.");
        }

        core::option::OptionTrait::<Adventurer>::unwrap(field_value)
    }

    fn set_adventurer(
        self: @AdventurerModelEntity, world: dojo::world::IWorldDispatcher, value: Adventurer
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                749380586961727072018731206412639157887364770643871151114870710297486048416,
                serialized.span()
            );
    }
}

#[generate_trait]
pub impl AdventurerModelStoreImpl of AdventurerModelStore {
    fn entity_id_from_keys(adventurer_id: felt252) -> felt252 {
        let mut serialized = core::array::ArrayTrait::new();
        core::array::ArrayTrait::append(ref serialized, adventurer_id);

        core::poseidon::poseidon_hash_span(serialized.span())
    }

    fn from_values(ref keys: Span<felt252>, ref values: Span<felt252>) -> AdventurerModel {
        let mut serialized = core::array::ArrayTrait::new();
        serialized.append_span(keys);
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<AdventurerModel>::deserialize(ref serialized);

        if core::option::OptionTrait::<AdventurerModel>::is_none(@entity) {
            panic!(
                "Model `AdventurerModel`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<AdventurerModel>::unwrap(entity)
    }

    fn get(world: dojo::world::IWorldDispatcher, adventurer_id: felt252) -> AdventurerModel {
        let mut serialized = core::array::ArrayTrait::new();
        core::array::ArrayTrait::append(ref serialized, adventurer_id);

        dojo::model::Model::<AdventurerModel>::get(world, serialized.span())
    }

    fn set(self: @AdventurerModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<AdventurerModel>::set_model(self, world);
    }

    fn delete(self: @AdventurerModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<AdventurerModel>::delete_model(self, world);
    }


    fn get_adventurer(world: dojo::world::IWorldDispatcher, adventurer_id: felt252) -> Adventurer {
        let mut serialized = core::array::ArrayTrait::new();
        core::array::ArrayTrait::append(ref serialized, adventurer_id);

        let mut values = dojo::model::Model::<
            AdventurerModel
        >::get_member(
            world,
            serialized.span(),
            749380586961727072018731206412639157887364770643871151114870710297486048416
        );

        let field_value = core::serde::Serde::<Adventurer>::deserialize(ref values);

        if core::option::OptionTrait::<Adventurer>::is_none(@field_value) {
            panic!("Field `AdventurerModel::adventurer`: deserialization failed.");
        }

        core::option::OptionTrait::<Adventurer>::unwrap(field_value)
    }

    fn set_adventurer(
        self: @AdventurerModel, world: dojo::world::IWorldDispatcher, value: Adventurer
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                749380586961727072018731206412639157887364770643871151114870710297486048416,
                serialized.span()
            );
    }
}

pub impl AdventurerModelModelEntityImpl of dojo::model::ModelEntity<AdventurerModelEntity> {
    fn id(self: @AdventurerModelEntity) -> felt252 {
        *self.__id
    }

    fn values(self: @AdventurerModelEntity) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.adventurer, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    fn from_values(entity_id: felt252, ref values: Span<felt252>) -> AdventurerModelEntity {
        let mut serialized = array![entity_id];
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity_values = core::serde::Serde::<
            AdventurerModelEntity
        >::deserialize(ref serialized);
        if core::option::OptionTrait::<AdventurerModelEntity>::is_none(@entity_values) {
            panic!("ModelEntity `AdventurerModelEntity`: deserialization failed.");
        }
        core::option::OptionTrait::<AdventurerModelEntity>::unwrap(entity_values)
    }

    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> AdventurerModelEntity {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            dojo::model::Model::<AdventurerModel>::selector(),
            dojo::model::ModelIndex::Id(entity_id),
            dojo::model::Model::<AdventurerModel>::layout()
        );
        Self::from_values(entity_id, ref values)
    }

    fn update_entity(self: @AdventurerModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            dojo::model::Model::<AdventurerModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<AdventurerModel>::layout()
        );
    }

    fn delete_entity(self: @AdventurerModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world,
            dojo::model::Model::<AdventurerModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<AdventurerModel>::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, entity_id: felt252, member_id: felt252,
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<AdventurerModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    dojo::model::Model::<AdventurerModel>::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @AdventurerModelEntity,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>,
    ) {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<AdventurerModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    dojo::model::Model::<AdventurerModel>::selector(),
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
pub impl AdventurerModelModelEntityTestImpl of dojo::model::ModelEntityTest<AdventurerModelEntity> {
    fn update_test(self: @AdventurerModelEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<AdventurerModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<AdventurerModel>::layout()
        );
    }

    fn delete_test(self: @AdventurerModelEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<AdventurerModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<AdventurerModel>::layout()
        );
    }
}

pub impl AdventurerModelModelImpl of dojo::model::Model<AdventurerModel> {
    fn get(world: dojo::world::IWorldDispatcher, keys: Span<felt252>) -> AdventurerModel {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(keys), Self::layout()
        );
        let mut _keys = keys;

        AdventurerModelStore::from_values(ref _keys, ref values)
    }

    fn set_model(self: @AdventurerModel, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            Self::selector(),
            dojo::model::ModelIndex::Keys(Self::keys(self)),
            Self::values(self),
            Self::layout()
        );
    }

    fn delete_model(self: @AdventurerModel, world: dojo::world::IWorldDispatcher) {
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
        self: @AdventurerModel,
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
        "AdventurerModel"
    }

    #[inline(always)]
    fn namespace() -> ByteArray {
        "tournament"
    }

    #[inline(always)]
    fn tag() -> ByteArray {
        "tournament-AdventurerModel"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        1240402834269421521307165714293129264009905265923178979522795132323019257654
    }

    #[inline(always)]
    fn instance_selector(self: @AdventurerModel) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn name_hash() -> felt252 {
        431856900631382166742990734271908474031771802066897489929165215566245942033
    }

    #[inline(always)]
    fn namespace_hash() -> felt252 {
        3513465382457774401660929656863894979351645367198604050918895380273858322651
    }

    #[inline(always)]
    fn entity_id(self: @AdventurerModel) -> felt252 {
        core::poseidon::poseidon_hash_span(self.keys())
    }

    #[inline(always)]
    fn keys(self: @AdventurerModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::array::ArrayTrait::append(ref serialized, *self.adventurer_id);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @AdventurerModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.adventurer, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::model::Layout {
        dojo::model::introspect::Introspect::<AdventurerModel>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @AdventurerModel) -> dojo::model::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        dojo::model::layout::compute_packed_size(Self::layout())
    }
}

#[cfg(target: "test")]
pub impl AdventurerModelModelTestImpl of dojo::model::ModelTest<AdventurerModel> {
    fn set_test(self: @AdventurerModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<AdventurerModel>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<AdventurerModel>::keys(self)),
            dojo::model::Model::<AdventurerModel>::values(self),
            dojo::model::Model::<AdventurerModel>::layout()
        );
    }

    fn delete_test(self: @AdventurerModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<AdventurerModel>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<AdventurerModel>::keys(self)),
            dojo::model::Model::<AdventurerModel>::layout()
        );
    }
}

#[starknet::interface]
pub trait Iadventurer_model<T> {
    fn ensure_abi(self: @T, model: AdventurerModel);
}

#[starknet::contract]
pub mod adventurer_model {
    use super::AdventurerModel;
    use super::Iadventurer_model;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            "AdventurerModel"
        }

        fn namespace(self: @ContractState) -> ByteArray {
            "tournament"
        }

        fn tag(self: @ContractState) -> ByteArray {
            "tournament-AdventurerModel"
        }

        fn version(self: @ContractState) -> u8 {
            1
        }

        fn selector(self: @ContractState) -> felt252 {
            1240402834269421521307165714293129264009905265923178979522795132323019257654
        }

        fn name_hash(self: @ContractState) -> felt252 {
            431856900631382166742990734271908474031771802066897489929165215566245942033
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            3513465382457774401660929656863894979351645367198604050918895380273858322651
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::model::introspect::Introspect::<AdventurerModel>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<AdventurerModel>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::model::Layout {
            dojo::model::Model::<AdventurerModel>::layout()
        }

        fn schema(self: @ContractState) -> dojo::model::introspect::Ty {
            dojo::model::introspect::Introspect::<AdventurerModel>::ty()
        }
    }

    #[abi(embed_v0)]
    impl adventurer_modelImpl of Iadventurer_model<ContractState> {
        fn ensure_abi(self: @ContractState, model: AdventurerModel) {}
    }
}
