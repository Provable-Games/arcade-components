impl TournamentTotalModelIntrospect<> of dojo::model::introspect::Introspect<
    TournamentTotalModel<>
> {
    #[inline(always)]
    fn size() -> Option<usize> {
        Option::Some(1)
    }

    fn layout() -> dojo::model::Layout {
        dojo::model::Layout::Struct(
            array![
                dojo::model::FieldLayout {
                    selector: 559510955213358714698546189610160809396209083914393565039925946956508280213,
                    layout: dojo::model::introspect::Introspect::<u64>::layout()
                }
            ]
                .span()
        )
    }

    #[inline(always)]
    fn ty() -> dojo::model::introspect::Ty {
        dojo::model::introspect::Ty::Struct(
            dojo::model::introspect::Struct {
                name: 'TournamentTotalModel',
                attrs: array![].span(),
                children: array![
                    dojo::model::introspect::Member {
                        name: 'contract',
                        attrs: array!['key'].span(),
                        ty: dojo::model::introspect::Introspect::<ContractAddress>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'total_tournaments',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<u64>::ty()
                    }
                ]
                    .span()
            }
        )
    }
}

#[derive(Drop, Serde)]
pub struct TournamentTotalModelEntity {
    __id: felt252, // private field
    pub total_tournaments: u64,
}

#[generate_trait]
pub impl TournamentTotalModelEntityStoreImpl of TournamentTotalModelEntityStore {
    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> TournamentTotalModelEntity {
        TournamentTotalModelModelEntityImpl::get(world, entity_id)
    }

    fn update(self: @TournamentTotalModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<TournamentTotalModelEntity>::update_entity(self, world);
    }

    fn delete(self: @TournamentTotalModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<TournamentTotalModelEntity>::delete_entity(self, world);
    }


    fn get_total_tournaments(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> u64 {
        let mut values = dojo::model::ModelEntity::<
            TournamentTotalModelEntity
        >::get_member(
            world,
            entity_id,
            559510955213358714698546189610160809396209083914393565039925946956508280213
        );
        let field_value = core::serde::Serde::<u64>::deserialize(ref values);

        if core::option::OptionTrait::<u64>::is_none(@field_value) {
            panic!("Field `TournamentTotalModel::total_tournaments`: deserialization failed.");
        }

        core::option::OptionTrait::<u64>::unwrap(field_value)
    }

    fn set_total_tournaments(
        self: @TournamentTotalModelEntity, world: dojo::world::IWorldDispatcher, value: u64
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                559510955213358714698546189610160809396209083914393565039925946956508280213,
                serialized.span()
            );
    }
}

#[generate_trait]
pub impl TournamentTotalModelStoreImpl of TournamentTotalModelStore {
    fn entity_id_from_keys(contract: ContractAddress) -> felt252 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@contract, ref serialized);

        core::poseidon::poseidon_hash_span(serialized.span())
    }

    fn from_values(ref keys: Span<felt252>, ref values: Span<felt252>) -> TournamentTotalModel {
        let mut serialized = core::array::ArrayTrait::new();
        serialized.append_span(keys);
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<TournamentTotalModel>::deserialize(ref serialized);

        if core::option::OptionTrait::<TournamentTotalModel>::is_none(@entity) {
            panic!(
                "Model `TournamentTotalModel`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<TournamentTotalModel>::unwrap(entity)
    }

    fn get(
        world: dojo::world::IWorldDispatcher, contract: ContractAddress
    ) -> TournamentTotalModel {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@contract, ref serialized);

        dojo::model::Model::<TournamentTotalModel>::get(world, serialized.span())
    }

    fn set(self: @TournamentTotalModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<TournamentTotalModel>::set_model(self, world);
    }

    fn delete(self: @TournamentTotalModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<TournamentTotalModel>::delete_model(self, world);
    }


    fn get_total_tournaments(
        world: dojo::world::IWorldDispatcher, contract: ContractAddress
    ) -> u64 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@contract, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentTotalModel
        >::get_member(
            world,
            serialized.span(),
            559510955213358714698546189610160809396209083914393565039925946956508280213
        );

        let field_value = core::serde::Serde::<u64>::deserialize(ref values);

        if core::option::OptionTrait::<u64>::is_none(@field_value) {
            panic!("Field `TournamentTotalModel::total_tournaments`: deserialization failed.");
        }

        core::option::OptionTrait::<u64>::unwrap(field_value)
    }

    fn set_total_tournaments(
        self: @TournamentTotalModel, world: dojo::world::IWorldDispatcher, value: u64
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                559510955213358714698546189610160809396209083914393565039925946956508280213,
                serialized.span()
            );
    }
}

pub impl TournamentTotalModelModelEntityImpl of dojo::model::ModelEntity<
    TournamentTotalModelEntity
> {
    fn id(self: @TournamentTotalModelEntity) -> felt252 {
        *self.__id
    }

    fn values(self: @TournamentTotalModelEntity) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.total_tournaments, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    fn from_values(entity_id: felt252, ref values: Span<felt252>) -> TournamentTotalModelEntity {
        let mut serialized = array![entity_id];
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity_values = core::serde::Serde::<
            TournamentTotalModelEntity
        >::deserialize(ref serialized);
        if core::option::OptionTrait::<TournamentTotalModelEntity>::is_none(@entity_values) {
            panic!("ModelEntity `TournamentTotalModelEntity`: deserialization failed.");
        }
        core::option::OptionTrait::<TournamentTotalModelEntity>::unwrap(entity_values)
    }

    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> TournamentTotalModelEntity {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            dojo::model::Model::<TournamentTotalModel>::selector(),
            dojo::model::ModelIndex::Id(entity_id),
            dojo::model::Model::<TournamentTotalModel>::layout()
        );
        Self::from_values(entity_id, ref values)
    }

    fn update_entity(self: @TournamentTotalModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            dojo::model::Model::<TournamentTotalModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<TournamentTotalModel>::layout()
        );
    }

    fn delete_entity(self: @TournamentTotalModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world,
            dojo::model::Model::<TournamentTotalModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<TournamentTotalModel>::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, entity_id: felt252, member_id: felt252,
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<TournamentTotalModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    dojo::model::Model::<TournamentTotalModel>::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @TournamentTotalModelEntity,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>,
    ) {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<TournamentTotalModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    dojo::model::Model::<TournamentTotalModel>::selector(),
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
pub impl TournamentTotalModelModelEntityTestImpl of dojo::model::ModelEntityTest<
    TournamentTotalModelEntity
> {
    fn update_test(self: @TournamentTotalModelEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<TournamentTotalModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<TournamentTotalModel>::layout()
        );
    }

    fn delete_test(self: @TournamentTotalModelEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<TournamentTotalModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<TournamentTotalModel>::layout()
        );
    }
}

pub impl TournamentTotalModelModelImpl of dojo::model::Model<TournamentTotalModel> {
    fn get(world: dojo::world::IWorldDispatcher, keys: Span<felt252>) -> TournamentTotalModel {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(keys), Self::layout()
        );
        let mut _keys = keys;

        TournamentTotalModelStore::from_values(ref _keys, ref values)
    }

    fn set_model(self: @TournamentTotalModel, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            Self::selector(),
            dojo::model::ModelIndex::Keys(Self::keys(self)),
            Self::values(self),
            Self::layout()
        );
    }

    fn delete_model(self: @TournamentTotalModel, world: dojo::world::IWorldDispatcher) {
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
        self: @TournamentTotalModel,
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
        "TournamentTotalModel"
    }

    #[inline(always)]
    fn namespace() -> ByteArray {
        "tournament"
    }

    #[inline(always)]
    fn tag() -> ByteArray {
        "tournament-TournamentTotalModel"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        2188225662440389450207156171875979234675125152585847103833914675941254653897
    }

    #[inline(always)]
    fn instance_selector(self: @TournamentTotalModel) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn name_hash() -> felt252 {
        3069541861612005602722002267156343954080880052728853657679992975725773738564
    }

    #[inline(always)]
    fn namespace_hash() -> felt252 {
        3513465382457774401660929656863894979351645367198604050918895380273858322651
    }

    #[inline(always)]
    fn entity_id(self: @TournamentTotalModel) -> felt252 {
        core::poseidon::poseidon_hash_span(self.keys())
    }

    #[inline(always)]
    fn keys(self: @TournamentTotalModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.contract, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @TournamentTotalModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.total_tournaments, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::model::Layout {
        dojo::model::introspect::Introspect::<TournamentTotalModel>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @TournamentTotalModel) -> dojo::model::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        dojo::model::layout::compute_packed_size(Self::layout())
    }
}

#[cfg(target: "test")]
pub impl TournamentTotalModelModelTestImpl of dojo::model::ModelTest<TournamentTotalModel> {
    fn set_test(self: @TournamentTotalModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<TournamentTotalModel>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<TournamentTotalModel>::keys(self)),
            dojo::model::Model::<TournamentTotalModel>::values(self),
            dojo::model::Model::<TournamentTotalModel>::layout()
        );
    }

    fn delete_test(self: @TournamentTotalModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<TournamentTotalModel>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<TournamentTotalModel>::keys(self)),
            dojo::model::Model::<TournamentTotalModel>::layout()
        );
    }
}

#[starknet::interface]
pub trait Itournament_total_model<T> {
    fn ensure_abi(self: @T, model: TournamentTotalModel);
}

#[starknet::contract]
pub mod tournament_total_model {
    use super::TournamentTotalModel;
    use super::Itournament_total_model;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            "TournamentTotalModel"
        }

        fn namespace(self: @ContractState) -> ByteArray {
            "tournament"
        }

        fn tag(self: @ContractState) -> ByteArray {
            "tournament-TournamentTotalModel"
        }

        fn version(self: @ContractState) -> u8 {
            1
        }

        fn selector(self: @ContractState) -> felt252 {
            2188225662440389450207156171875979234675125152585847103833914675941254653897
        }

        fn name_hash(self: @ContractState) -> felt252 {
            3069541861612005602722002267156343954080880052728853657679992975725773738564
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            3513465382457774401660929656863894979351645367198604050918895380273858322651
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::model::introspect::Introspect::<TournamentTotalModel>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<TournamentTotalModel>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::model::Layout {
            dojo::model::Model::<TournamentTotalModel>::layout()
        }

        fn schema(self: @ContractState) -> dojo::model::introspect::Ty {
            dojo::model::introspect::Introspect::<TournamentTotalModel>::ty()
        }
    }

    #[abi(embed_v0)]
    impl tournament_total_modelImpl of Itournament_total_model<ContractState> {
        fn ensure_abi(self: @ContractState, model: TournamentTotalModel) {}
    }
}
