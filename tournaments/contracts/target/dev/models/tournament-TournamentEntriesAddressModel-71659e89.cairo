impl TournamentEntriesAddressModelIntrospect<> of dojo::model::introspect::Introspect<
    TournamentEntriesAddressModel<>
> {
    #[inline(always)]
    fn size() -> Option<usize> {
        Option::None
    }

    fn layout() -> dojo::model::Layout {
        dojo::model::Layout::Struct(
            array![
                dojo::model::FieldLayout {
                    selector: 91831325443373165617951455578282973500253190082647686375302359183447320413,
                    layout: dojo::model::introspect::Introspect::<u8>::layout()
                },
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
                name: 'TournamentEntriesAddressModel',
                attrs: array![].span(),
                children: array![
                    dojo::model::introspect::Member {
                        name: 'tournament_id',
                        attrs: array!['key'].span(),
                        ty: dojo::model::introspect::Introspect::<u64>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'address',
                        attrs: array!['key'].span(),
                        ty: dojo::model::introspect::Introspect::<ContractAddress>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'entry_count',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<u8>::ty()
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
pub struct TournamentEntriesAddressModelEntity {
    __id: felt252, // private field
    pub entry_count: u8,
    pub game_ids: Array<u64>,
}

#[generate_trait]
pub impl TournamentEntriesAddressModelEntityStoreImpl of TournamentEntriesAddressModelEntityStore {
    fn get(
        world: dojo::world::IWorldDispatcher, entity_id: felt252
    ) -> TournamentEntriesAddressModelEntity {
        TournamentEntriesAddressModelModelEntityImpl::get(world, entity_id)
    }

    fn update(self: @TournamentEntriesAddressModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<TournamentEntriesAddressModelEntity>::update_entity(self, world);
    }

    fn delete(self: @TournamentEntriesAddressModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<TournamentEntriesAddressModelEntity>::delete_entity(self, world);
    }


    fn get_entry_count(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> u8 {
        let mut values = dojo::model::ModelEntity::<
            TournamentEntriesAddressModelEntity
        >::get_member(
            world,
            entity_id,
            91831325443373165617951455578282973500253190082647686375302359183447320413
        );
        let field_value = core::serde::Serde::<u8>::deserialize(ref values);

        if core::option::OptionTrait::<u8>::is_none(@field_value) {
            panic!("Field `TournamentEntriesAddressModel::entry_count`: deserialization failed.");
        }

        core::option::OptionTrait::<u8>::unwrap(field_value)
    }

    fn set_entry_count(
        self: @TournamentEntriesAddressModelEntity, world: dojo::world::IWorldDispatcher, value: u8
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                91831325443373165617951455578282973500253190082647686375302359183447320413,
                serialized.span()
            );
    }

    fn get_game_ids(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> Array<u64> {
        let mut values = dojo::model::ModelEntity::<
            TournamentEntriesAddressModelEntity
        >::get_member(
            world,
            entity_id,
            265866676642830162498721691547279957379484306165912539482818020839472807558
        );
        let field_value = core::serde::Serde::<Array<u64>>::deserialize(ref values);

        if core::option::OptionTrait::<Array<u64>>::is_none(@field_value) {
            panic!("Field `TournamentEntriesAddressModel::game_ids`: deserialization failed.");
        }

        core::option::OptionTrait::<Array<u64>>::unwrap(field_value)
    }

    fn set_game_ids(
        self: @TournamentEntriesAddressModelEntity,
        world: dojo::world::IWorldDispatcher,
        value: Array<u64>
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
pub impl TournamentEntriesAddressModelStoreImpl of TournamentEntriesAddressModelStore {
    fn entity_id_from_keys(tournament_id: u64, address: ContractAddress) -> felt252 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);
        core::serde::Serde::serialize(@address, ref serialized);

        core::poseidon::poseidon_hash_span(serialized.span())
    }

    fn from_values(
        ref keys: Span<felt252>, ref values: Span<felt252>
    ) -> TournamentEntriesAddressModel {
        let mut serialized = core::array::ArrayTrait::new();
        serialized.append_span(keys);
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<
            TournamentEntriesAddressModel
        >::deserialize(ref serialized);

        if core::option::OptionTrait::<TournamentEntriesAddressModel>::is_none(@entity) {
            panic!(
                "Model `TournamentEntriesAddressModel`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<TournamentEntriesAddressModel>::unwrap(entity)
    }

    fn get(
        world: dojo::world::IWorldDispatcher, tournament_id: u64, address: ContractAddress
    ) -> TournamentEntriesAddressModel {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);
        core::serde::Serde::serialize(@address, ref serialized);

        dojo::model::Model::<TournamentEntriesAddressModel>::get(world, serialized.span())
    }

    fn set(self: @TournamentEntriesAddressModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<TournamentEntriesAddressModel>::set_model(self, world);
    }

    fn delete(self: @TournamentEntriesAddressModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<TournamentEntriesAddressModel>::delete_model(self, world);
    }


    fn get_entry_count(
        world: dojo::world::IWorldDispatcher, tournament_id: u64, address: ContractAddress
    ) -> u8 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);
        core::serde::Serde::serialize(@address, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentEntriesAddressModel
        >::get_member(
            world,
            serialized.span(),
            91831325443373165617951455578282973500253190082647686375302359183447320413
        );

        let field_value = core::serde::Serde::<u8>::deserialize(ref values);

        if core::option::OptionTrait::<u8>::is_none(@field_value) {
            panic!("Field `TournamentEntriesAddressModel::entry_count`: deserialization failed.");
        }

        core::option::OptionTrait::<u8>::unwrap(field_value)
    }

    fn set_entry_count(
        self: @TournamentEntriesAddressModel, world: dojo::world::IWorldDispatcher, value: u8
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                91831325443373165617951455578282973500253190082647686375302359183447320413,
                serialized.span()
            );
    }

    fn get_game_ids(
        world: dojo::world::IWorldDispatcher, tournament_id: u64, address: ContractAddress
    ) -> Array<u64> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);
        core::serde::Serde::serialize(@address, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentEntriesAddressModel
        >::get_member(
            world,
            serialized.span(),
            265866676642830162498721691547279957379484306165912539482818020839472807558
        );

        let field_value = core::serde::Serde::<Array<u64>>::deserialize(ref values);

        if core::option::OptionTrait::<Array<u64>>::is_none(@field_value) {
            panic!("Field `TournamentEntriesAddressModel::game_ids`: deserialization failed.");
        }

        core::option::OptionTrait::<Array<u64>>::unwrap(field_value)
    }

    fn set_game_ids(
        self: @TournamentEntriesAddressModel,
        world: dojo::world::IWorldDispatcher,
        value: Array<u64>
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

pub impl TournamentEntriesAddressModelModelEntityImpl of dojo::model::ModelEntity<
    TournamentEntriesAddressModelEntity
> {
    fn id(self: @TournamentEntriesAddressModelEntity) -> felt252 {
        *self.__id
    }

    fn values(self: @TournamentEntriesAddressModelEntity) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.entry_count, ref serialized);
        core::serde::Serde::serialize(self.game_ids, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    fn from_values(
        entity_id: felt252, ref values: Span<felt252>
    ) -> TournamentEntriesAddressModelEntity {
        let mut serialized = array![entity_id];
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity_values = core::serde::Serde::<
            TournamentEntriesAddressModelEntity
        >::deserialize(ref serialized);
        if core::option::OptionTrait::<
            TournamentEntriesAddressModelEntity
        >::is_none(@entity_values) {
            panic!("ModelEntity `TournamentEntriesAddressModelEntity`: deserialization failed.");
        }
        core::option::OptionTrait::<TournamentEntriesAddressModelEntity>::unwrap(entity_values)
    }

    fn get(
        world: dojo::world::IWorldDispatcher, entity_id: felt252
    ) -> TournamentEntriesAddressModelEntity {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            dojo::model::Model::<TournamentEntriesAddressModel>::selector(),
            dojo::model::ModelIndex::Id(entity_id),
            dojo::model::Model::<TournamentEntriesAddressModel>::layout()
        );
        Self::from_values(entity_id, ref values)
    }

    fn update_entity(
        self: @TournamentEntriesAddressModelEntity, world: dojo::world::IWorldDispatcher
    ) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            dojo::model::Model::<TournamentEntriesAddressModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<TournamentEntriesAddressModel>::layout()
        );
    }

    fn delete_entity(
        self: @TournamentEntriesAddressModelEntity, world: dojo::world::IWorldDispatcher
    ) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world,
            dojo::model::Model::<TournamentEntriesAddressModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<TournamentEntriesAddressModel>::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, entity_id: felt252, member_id: felt252,
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<TournamentEntriesAddressModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    dojo::model::Model::<TournamentEntriesAddressModel>::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @TournamentEntriesAddressModelEntity,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>,
    ) {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<TournamentEntriesAddressModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    dojo::model::Model::<TournamentEntriesAddressModel>::selector(),
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
pub impl TournamentEntriesAddressModelModelEntityTestImpl of dojo::model::ModelEntityTest<
    TournamentEntriesAddressModelEntity
> {
    fn update_test(
        self: @TournamentEntriesAddressModelEntity, world: dojo::world::IWorldDispatcher
    ) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<TournamentEntriesAddressModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<TournamentEntriesAddressModel>::layout()
        );
    }

    fn delete_test(
        self: @TournamentEntriesAddressModelEntity, world: dojo::world::IWorldDispatcher
    ) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<TournamentEntriesAddressModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<TournamentEntriesAddressModel>::layout()
        );
    }
}

pub impl TournamentEntriesAddressModelModelImpl of dojo::model::Model<
    TournamentEntriesAddressModel
> {
    fn get(
        world: dojo::world::IWorldDispatcher, keys: Span<felt252>
    ) -> TournamentEntriesAddressModel {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(keys), Self::layout()
        );
        let mut _keys = keys;

        TournamentEntriesAddressModelStore::from_values(ref _keys, ref values)
    }

    fn set_model(self: @TournamentEntriesAddressModel, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            Self::selector(),
            dojo::model::ModelIndex::Keys(Self::keys(self)),
            Self::values(self),
            Self::layout()
        );
    }

    fn delete_model(self: @TournamentEntriesAddressModel, world: dojo::world::IWorldDispatcher) {
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
        self: @TournamentEntriesAddressModel,
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
        "TournamentEntriesAddressModel"
    }

    #[inline(always)]
    fn namespace() -> ByteArray {
        "tournament"
    }

    #[inline(always)]
    fn tag() -> ByteArray {
        "tournament-TournamentEntriesAddressModel"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        3205681102280966569724367441170219730507126185489832525289621341423179007761
    }

    #[inline(always)]
    fn instance_selector(self: @TournamentEntriesAddressModel) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn name_hash() -> felt252 {
        588282133972759378552485271034035025535963425970401042051143088248199569487
    }

    #[inline(always)]
    fn namespace_hash() -> felt252 {
        3513465382457774401660929656863894979351645367198604050918895380273858322651
    }

    #[inline(always)]
    fn entity_id(self: @TournamentEntriesAddressModel) -> felt252 {
        core::poseidon::poseidon_hash_span(self.keys())
    }

    #[inline(always)]
    fn keys(self: @TournamentEntriesAddressModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.tournament_id, ref serialized);
        core::serde::Serde::serialize(self.address, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @TournamentEntriesAddressModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.entry_count, ref serialized);
        core::serde::Serde::serialize(self.game_ids, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::model::Layout {
        dojo::model::introspect::Introspect::<TournamentEntriesAddressModel>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @TournamentEntriesAddressModel) -> dojo::model::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        dojo::model::layout::compute_packed_size(Self::layout())
    }
}

#[cfg(target: "test")]
pub impl TournamentEntriesAddressModelModelTestImpl of dojo::model::ModelTest<
    TournamentEntriesAddressModel
> {
    fn set_test(self: @TournamentEntriesAddressModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<TournamentEntriesAddressModel>::selector(),
            dojo::model::ModelIndex::Keys(
                dojo::model::Model::<TournamentEntriesAddressModel>::keys(self)
            ),
            dojo::model::Model::<TournamentEntriesAddressModel>::values(self),
            dojo::model::Model::<TournamentEntriesAddressModel>::layout()
        );
    }

    fn delete_test(self: @TournamentEntriesAddressModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<TournamentEntriesAddressModel>::selector(),
            dojo::model::ModelIndex::Keys(
                dojo::model::Model::<TournamentEntriesAddressModel>::keys(self)
            ),
            dojo::model::Model::<TournamentEntriesAddressModel>::layout()
        );
    }
}

#[starknet::interface]
pub trait Itournament_entries_address_model<T> {
    fn ensure_abi(self: @T, model: TournamentEntriesAddressModel);
}

#[starknet::contract]
pub mod tournament_entries_address_model {
    use super::TournamentEntriesAddressModel;
    use super::Itournament_entries_address_model;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            "TournamentEntriesAddressModel"
        }

        fn namespace(self: @ContractState) -> ByteArray {
            "tournament"
        }

        fn tag(self: @ContractState) -> ByteArray {
            "tournament-TournamentEntriesAddressModel"
        }

        fn version(self: @ContractState) -> u8 {
            1
        }

        fn selector(self: @ContractState) -> felt252 {
            3205681102280966569724367441170219730507126185489832525289621341423179007761
        }

        fn name_hash(self: @ContractState) -> felt252 {
            588282133972759378552485271034035025535963425970401042051143088248199569487
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            3513465382457774401660929656863894979351645367198604050918895380273858322651
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::model::introspect::Introspect::<TournamentEntriesAddressModel>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<TournamentEntriesAddressModel>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::model::Layout {
            dojo::model::Model::<TournamentEntriesAddressModel>::layout()
        }

        fn schema(self: @ContractState) -> dojo::model::introspect::Ty {
            dojo::model::introspect::Introspect::<TournamentEntriesAddressModel>::ty()
        }
    }

    #[abi(embed_v0)]
    impl tournament_entries_address_modelImpl of Itournament_entries_address_model<ContractState> {
        fn ensure_abi(self: @ContractState, model: TournamentEntriesAddressModel) {}
    }
}
