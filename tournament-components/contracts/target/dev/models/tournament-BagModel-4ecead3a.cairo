impl BagModelIntrospect<> of dojo::model::introspect::Introspect<BagModel<>> {
    #[inline(always)]
    fn size() -> Option<usize> {
        dojo::model::introspect::Introspect::<Bag>::size()
    }

    fn layout() -> dojo::model::Layout {
        dojo::model::Layout::Struct(
            array![
                dojo::model::FieldLayout {
                    selector: 545531532991304608383932897003934692363110152089709156396610148412800323451,
                    layout: dojo::model::introspect::Introspect::<Bag>::layout()
                }
            ]
                .span()
        )
    }

    #[inline(always)]
    fn ty() -> dojo::model::introspect::Ty {
        dojo::model::introspect::Ty::Struct(
            dojo::model::introspect::Struct {
                name: 'BagModel',
                attrs: array![].span(),
                children: array![
                    dojo::model::introspect::Member {
                        name: 'adventurer_id',
                        attrs: array!['key'].span(),
                        ty: dojo::model::introspect::Introspect::<felt252>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'bag',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<Bag>::ty()
                    }
                ]
                    .span()
            }
        )
    }
}

#[derive(Drop, Serde)]
pub struct BagModelEntity {
    __id: felt252, // private field
    pub bag: Bag,
}

#[generate_trait]
pub impl BagModelEntityStoreImpl of BagModelEntityStore {
    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> BagModelEntity {
        BagModelModelEntityImpl::get(world, entity_id)
    }

    fn update(self: @BagModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<BagModelEntity>::update_entity(self, world);
    }

    fn delete(self: @BagModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<BagModelEntity>::delete_entity(self, world);
    }


    fn get_bag(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> Bag {
        let mut values = dojo::model::ModelEntity::<
            BagModelEntity
        >::get_member(
            world,
            entity_id,
            545531532991304608383932897003934692363110152089709156396610148412800323451
        );
        let field_value = core::serde::Serde::<Bag>::deserialize(ref values);

        if core::option::OptionTrait::<Bag>::is_none(@field_value) {
            panic!("Field `BagModel::bag`: deserialization failed.");
        }

        core::option::OptionTrait::<Bag>::unwrap(field_value)
    }

    fn set_bag(self: @BagModelEntity, world: dojo::world::IWorldDispatcher, value: Bag) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                545531532991304608383932897003934692363110152089709156396610148412800323451,
                serialized.span()
            );
    }
}

#[generate_trait]
pub impl BagModelStoreImpl of BagModelStore {
    fn entity_id_from_keys(adventurer_id: felt252) -> felt252 {
        let mut serialized = core::array::ArrayTrait::new();
        core::array::ArrayTrait::append(ref serialized, adventurer_id);

        core::poseidon::poseidon_hash_span(serialized.span())
    }

    fn from_values(ref keys: Span<felt252>, ref values: Span<felt252>) -> BagModel {
        let mut serialized = core::array::ArrayTrait::new();
        serialized.append_span(keys);
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<BagModel>::deserialize(ref serialized);

        if core::option::OptionTrait::<BagModel>::is_none(@entity) {
            panic!(
                "Model `BagModel`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<BagModel>::unwrap(entity)
    }

    fn get(world: dojo::world::IWorldDispatcher, adventurer_id: felt252) -> BagModel {
        let mut serialized = core::array::ArrayTrait::new();
        core::array::ArrayTrait::append(ref serialized, adventurer_id);

        dojo::model::Model::<BagModel>::get(world, serialized.span())
    }

    fn set(self: @BagModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<BagModel>::set_model(self, world);
    }

    fn delete(self: @BagModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<BagModel>::delete_model(self, world);
    }


    fn get_bag(world: dojo::world::IWorldDispatcher, adventurer_id: felt252) -> Bag {
        let mut serialized = core::array::ArrayTrait::new();
        core::array::ArrayTrait::append(ref serialized, adventurer_id);

        let mut values = dojo::model::Model::<
            BagModel
        >::get_member(
            world,
            serialized.span(),
            545531532991304608383932897003934692363110152089709156396610148412800323451
        );

        let field_value = core::serde::Serde::<Bag>::deserialize(ref values);

        if core::option::OptionTrait::<Bag>::is_none(@field_value) {
            panic!("Field `BagModel::bag`: deserialization failed.");
        }

        core::option::OptionTrait::<Bag>::unwrap(field_value)
    }

    fn set_bag(self: @BagModel, world: dojo::world::IWorldDispatcher, value: Bag) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                545531532991304608383932897003934692363110152089709156396610148412800323451,
                serialized.span()
            );
    }
}

pub impl BagModelModelEntityImpl of dojo::model::ModelEntity<BagModelEntity> {
    fn id(self: @BagModelEntity) -> felt252 {
        *self.__id
    }

    fn values(self: @BagModelEntity) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.bag, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    fn from_values(entity_id: felt252, ref values: Span<felt252>) -> BagModelEntity {
        let mut serialized = array![entity_id];
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity_values = core::serde::Serde::<BagModelEntity>::deserialize(ref serialized);
        if core::option::OptionTrait::<BagModelEntity>::is_none(@entity_values) {
            panic!("ModelEntity `BagModelEntity`: deserialization failed.");
        }
        core::option::OptionTrait::<BagModelEntity>::unwrap(entity_values)
    }

    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> BagModelEntity {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            dojo::model::Model::<BagModel>::selector(),
            dojo::model::ModelIndex::Id(entity_id),
            dojo::model::Model::<BagModel>::layout()
        );
        Self::from_values(entity_id, ref values)
    }

    fn update_entity(self: @BagModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            dojo::model::Model::<BagModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<BagModel>::layout()
        );
    }

    fn delete_entity(self: @BagModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world,
            dojo::model::Model::<BagModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<BagModel>::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, entity_id: felt252, member_id: felt252,
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<BagModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    dojo::model::Model::<BagModel>::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @BagModelEntity,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>,
    ) {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<BagModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    dojo::model::Model::<BagModel>::selector(),
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
pub impl BagModelModelEntityTestImpl of dojo::model::ModelEntityTest<BagModelEntity> {
    fn update_test(self: @BagModelEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<BagModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<BagModel>::layout()
        );
    }

    fn delete_test(self: @BagModelEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<BagModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<BagModel>::layout()
        );
    }
}

pub impl BagModelModelImpl of dojo::model::Model<BagModel> {
    fn get(world: dojo::world::IWorldDispatcher, keys: Span<felt252>) -> BagModel {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(keys), Self::layout()
        );
        let mut _keys = keys;

        BagModelStore::from_values(ref _keys, ref values)
    }

    fn set_model(self: @BagModel, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            Self::selector(),
            dojo::model::ModelIndex::Keys(Self::keys(self)),
            Self::values(self),
            Self::layout()
        );
    }

    fn delete_model(self: @BagModel, world: dojo::world::IWorldDispatcher) {
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
        self: @BagModel,
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
        "BagModel"
    }

    #[inline(always)]
    fn namespace() -> ByteArray {
        "tournament"
    }

    #[inline(always)]
    fn tag() -> ByteArray {
        "tournament-BagModel"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        2227848015705569351151019652416776761018659017484539931756360981832246114409
    }

    #[inline(always)]
    fn instance_selector(self: @BagModel) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn name_hash() -> felt252 {
        384721428353921392626154348399744964446102103000928068061870202229531467906
    }

    #[inline(always)]
    fn namespace_hash() -> felt252 {
        3513465382457774401660929656863894979351645367198604050918895380273858322651
    }

    #[inline(always)]
    fn entity_id(self: @BagModel) -> felt252 {
        core::poseidon::poseidon_hash_span(self.keys())
    }

    #[inline(always)]
    fn keys(self: @BagModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::array::ArrayTrait::append(ref serialized, *self.adventurer_id);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @BagModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.bag, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::model::Layout {
        dojo::model::introspect::Introspect::<BagModel>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @BagModel) -> dojo::model::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        dojo::model::layout::compute_packed_size(Self::layout())
    }
}

#[cfg(target: "test")]
pub impl BagModelModelTestImpl of dojo::model::ModelTest<BagModel> {
    fn set_test(self: @BagModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<BagModel>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<BagModel>::keys(self)),
            dojo::model::Model::<BagModel>::values(self),
            dojo::model::Model::<BagModel>::layout()
        );
    }

    fn delete_test(self: @BagModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<BagModel>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<BagModel>::keys(self)),
            dojo::model::Model::<BagModel>::layout()
        );
    }
}

#[starknet::interface]
pub trait Ibag_model<T> {
    fn ensure_abi(self: @T, model: BagModel);
}

#[starknet::contract]
pub mod bag_model {
    use super::BagModel;
    use super::Ibag_model;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            "BagModel"
        }

        fn namespace(self: @ContractState) -> ByteArray {
            "tournament"
        }

        fn tag(self: @ContractState) -> ByteArray {
            "tournament-BagModel"
        }

        fn version(self: @ContractState) -> u8 {
            1
        }

        fn selector(self: @ContractState) -> felt252 {
            2227848015705569351151019652416776761018659017484539931756360981832246114409
        }

        fn name_hash(self: @ContractState) -> felt252 {
            384721428353921392626154348399744964446102103000928068061870202229531467906
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            3513465382457774401660929656863894979351645367198604050918895380273858322651
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::model::introspect::Introspect::<BagModel>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<BagModel>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::model::Layout {
            dojo::model::Model::<BagModel>::layout()
        }

        fn schema(self: @ContractState) -> dojo::model::introspect::Ty {
            dojo::model::introspect::Introspect::<BagModel>::ty()
        }
    }

    #[abi(embed_v0)]
    impl bag_modelImpl of Ibag_model<ContractState> {
        fn ensure_abi(self: @ContractState, model: BagModel) {}
    }
}
