impl GameCountModelIntrospect<> of dojo::model::introspect::Introspect<GameCountModel<>> {
    #[inline(always)]
    fn size() -> Option<usize> {
        Option::Some(1)
    }

    fn layout() -> dojo::model::Layout {
        dojo::model::Layout::Struct(
            array![
                dojo::model::FieldLayout {
                    selector: 829306874407222910580480683155591308102630168947751474589341362978987384286,
                    layout: dojo::model::introspect::Introspect::<u128>::layout()
                }
            ]
                .span()
        )
    }

    #[inline(always)]
    fn ty() -> dojo::model::introspect::Ty {
        dojo::model::introspect::Ty::Struct(
            dojo::model::introspect::Struct {
                name: 'GameCountModel',
                attrs: array![].span(),
                children: array![
                    dojo::model::introspect::Member {
                        name: 'contract_address',
                        attrs: array!['key'].span(),
                        ty: dojo::model::introspect::Introspect::<ContractAddress>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'game_count',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<u128>::ty()
                    }
                ]
                    .span()
            }
        )
    }
}

#[derive(Drop, Serde)]
pub struct GameCountModelEntity {
    __id: felt252, // private field
    pub game_count: u128,
}

#[generate_trait]
pub impl GameCountModelEntityStoreImpl of GameCountModelEntityStore {
    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> GameCountModelEntity {
        GameCountModelModelEntityImpl::get(world, entity_id)
    }

    fn update(self: @GameCountModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<GameCountModelEntity>::update_entity(self, world);
    }

    fn delete(self: @GameCountModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<GameCountModelEntity>::delete_entity(self, world);
    }


    fn get_game_count(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> u128 {
        let mut values = dojo::model::ModelEntity::<
            GameCountModelEntity
        >::get_member(
            world,
            entity_id,
            829306874407222910580480683155591308102630168947751474589341362978987384286
        );
        let field_value = core::serde::Serde::<u128>::deserialize(ref values);

        if core::option::OptionTrait::<u128>::is_none(@field_value) {
            panic!("Field `GameCountModel::game_count`: deserialization failed.");
        }

        core::option::OptionTrait::<u128>::unwrap(field_value)
    }

    fn set_game_count(
        self: @GameCountModelEntity, world: dojo::world::IWorldDispatcher, value: u128
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                829306874407222910580480683155591308102630168947751474589341362978987384286,
                serialized.span()
            );
    }
}

#[generate_trait]
pub impl GameCountModelStoreImpl of GameCountModelStore {
    fn entity_id_from_keys(contract_address: ContractAddress) -> felt252 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@contract_address, ref serialized);

        core::poseidon::poseidon_hash_span(serialized.span())
    }

    fn from_values(ref keys: Span<felt252>, ref values: Span<felt252>) -> GameCountModel {
        let mut serialized = core::array::ArrayTrait::new();
        serialized.append_span(keys);
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<GameCountModel>::deserialize(ref serialized);

        if core::option::OptionTrait::<GameCountModel>::is_none(@entity) {
            panic!(
                "Model `GameCountModel`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<GameCountModel>::unwrap(entity)
    }

    fn get(
        world: dojo::world::IWorldDispatcher, contract_address: ContractAddress
    ) -> GameCountModel {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@contract_address, ref serialized);

        dojo::model::Model::<GameCountModel>::get(world, serialized.span())
    }

    fn set(self: @GameCountModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<GameCountModel>::set_model(self, world);
    }

    fn delete(self: @GameCountModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<GameCountModel>::delete_model(self, world);
    }


    fn get_game_count(
        world: dojo::world::IWorldDispatcher, contract_address: ContractAddress
    ) -> u128 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@contract_address, ref serialized);

        let mut values = dojo::model::Model::<
            GameCountModel
        >::get_member(
            world,
            serialized.span(),
            829306874407222910580480683155591308102630168947751474589341362978987384286
        );

        let field_value = core::serde::Serde::<u128>::deserialize(ref values);

        if core::option::OptionTrait::<u128>::is_none(@field_value) {
            panic!("Field `GameCountModel::game_count`: deserialization failed.");
        }

        core::option::OptionTrait::<u128>::unwrap(field_value)
    }

    fn set_game_count(self: @GameCountModel, world: dojo::world::IWorldDispatcher, value: u128) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                829306874407222910580480683155591308102630168947751474589341362978987384286,
                serialized.span()
            );
    }
}

pub impl GameCountModelModelEntityImpl of dojo::model::ModelEntity<GameCountModelEntity> {
    fn id(self: @GameCountModelEntity) -> felt252 {
        *self.__id
    }

    fn values(self: @GameCountModelEntity) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.game_count, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    fn from_values(entity_id: felt252, ref values: Span<felt252>) -> GameCountModelEntity {
        let mut serialized = array![entity_id];
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity_values = core::serde::Serde::<GameCountModelEntity>::deserialize(ref serialized);
        if core::option::OptionTrait::<GameCountModelEntity>::is_none(@entity_values) {
            panic!("ModelEntity `GameCountModelEntity`: deserialization failed.");
        }
        core::option::OptionTrait::<GameCountModelEntity>::unwrap(entity_values)
    }

    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> GameCountModelEntity {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            dojo::model::Model::<GameCountModel>::selector(),
            dojo::model::ModelIndex::Id(entity_id),
            dojo::model::Model::<GameCountModel>::layout()
        );
        Self::from_values(entity_id, ref values)
    }

    fn update_entity(self: @GameCountModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            dojo::model::Model::<GameCountModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<GameCountModel>::layout()
        );
    }

    fn delete_entity(self: @GameCountModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world,
            dojo::model::Model::<GameCountModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<GameCountModel>::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, entity_id: felt252, member_id: felt252,
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<GameCountModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    dojo::model::Model::<GameCountModel>::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @GameCountModelEntity,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>,
    ) {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<GameCountModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    dojo::model::Model::<GameCountModel>::selector(),
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
pub impl GameCountModelModelEntityTestImpl of dojo::model::ModelEntityTest<GameCountModelEntity> {
    fn update_test(self: @GameCountModelEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<GameCountModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<GameCountModel>::layout()
        );
    }

    fn delete_test(self: @GameCountModelEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<GameCountModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<GameCountModel>::layout()
        );
    }
}

pub impl GameCountModelModelImpl of dojo::model::Model<GameCountModel> {
    fn get(world: dojo::world::IWorldDispatcher, keys: Span<felt252>) -> GameCountModel {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(keys), Self::layout()
        );
        let mut _keys = keys;

        GameCountModelStore::from_values(ref _keys, ref values)
    }

    fn set_model(self: @GameCountModel, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            Self::selector(),
            dojo::model::ModelIndex::Keys(Self::keys(self)),
            Self::values(self),
            Self::layout()
        );
    }

    fn delete_model(self: @GameCountModel, world: dojo::world::IWorldDispatcher) {
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
        self: @GameCountModel,
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
        "GameCountModel"
    }

    #[inline(always)]
    fn namespace() -> ByteArray {
        "tournament"
    }

    #[inline(always)]
    fn tag() -> ByteArray {
        "tournament-GameCountModel"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        869363775289204304013086417859969876877963372341949990640601596615957361234
    }

    #[inline(always)]
    fn instance_selector(self: @GameCountModel) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn name_hash() -> felt252 {
        2230644100796133786026277018828535188415382694261100429674833699904156537026
    }

    #[inline(always)]
    fn namespace_hash() -> felt252 {
        3513465382457774401660929656863894979351645367198604050918895380273858322651
    }

    #[inline(always)]
    fn entity_id(self: @GameCountModel) -> felt252 {
        core::poseidon::poseidon_hash_span(self.keys())
    }

    #[inline(always)]
    fn keys(self: @GameCountModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.contract_address, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @GameCountModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.game_count, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::model::Layout {
        dojo::model::introspect::Introspect::<GameCountModel>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @GameCountModel) -> dojo::model::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        dojo::model::layout::compute_packed_size(Self::layout())
    }
}

#[cfg(target: "test")]
pub impl GameCountModelModelTestImpl of dojo::model::ModelTest<GameCountModel> {
    fn set_test(self: @GameCountModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<GameCountModel>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<GameCountModel>::keys(self)),
            dojo::model::Model::<GameCountModel>::values(self),
            dojo::model::Model::<GameCountModel>::layout()
        );
    }

    fn delete_test(self: @GameCountModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<GameCountModel>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<GameCountModel>::keys(self)),
            dojo::model::Model::<GameCountModel>::layout()
        );
    }
}

#[starknet::interface]
pub trait Igame_count_model<T> {
    fn ensure_abi(self: @T, model: GameCountModel);
}

#[starknet::contract]
pub mod game_count_model {
    use super::GameCountModel;
    use super::Igame_count_model;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            "GameCountModel"
        }

        fn namespace(self: @ContractState) -> ByteArray {
            "tournament"
        }

        fn tag(self: @ContractState) -> ByteArray {
            "tournament-GameCountModel"
        }

        fn version(self: @ContractState) -> u8 {
            1
        }

        fn selector(self: @ContractState) -> felt252 {
            869363775289204304013086417859969876877963372341949990640601596615957361234
        }

        fn name_hash(self: @ContractState) -> felt252 {
            2230644100796133786026277018828535188415382694261100429674833699904156537026
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            3513465382457774401660929656863894979351645367198604050918895380273858322651
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::model::introspect::Introspect::<GameCountModel>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<GameCountModel>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::model::Layout {
            dojo::model::Model::<GameCountModel>::layout()
        }

        fn schema(self: @ContractState) -> dojo::model::introspect::Ty {
            dojo::model::introspect::Introspect::<GameCountModel>::ty()
        }
    }

    #[abi(embed_v0)]
    impl game_count_modelImpl of Igame_count_model<ContractState> {
        fn ensure_abi(self: @ContractState, model: GameCountModel) {}
    }
}
