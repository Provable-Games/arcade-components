impl TournamentAddressesModelIntrospect<> of dojo::model::introspect::Introspect<
    TournamentAddressesModel<>
> {
    #[inline(always)]
    fn size() -> Option<usize> {
        Option::None
    }

    fn layout() -> dojo::model::Layout {
        dojo::model::Layout::Struct(
            array![
                dojo::model::FieldLayout {
                    selector: 934480653781223487392644099173472875957189838399670302818291585235615632923,
                    layout: dojo::model::introspect::Introspect::<Array<ContractAddress>>::layout()
                }
            ]
                .span()
        )
    }

    #[inline(always)]
    fn ty() -> dojo::model::introspect::Ty {
        dojo::model::introspect::Ty::Struct(
            dojo::model::introspect::Struct {
                name: 'TournamentAddressesModel',
                attrs: array![].span(),
                children: array![
                    dojo::model::introspect::Member {
                        name: 'tournament_id',
                        attrs: array!['key'].span(),
                        ty: dojo::model::introspect::Introspect::<u64>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'addresses',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Ty::Array(
                            array![dojo::model::introspect::Introspect::<ContractAddress>::ty()]
                                .span()
                        )
                    }
                ]
                    .span()
            }
        )
    }
}

#[derive(Drop, Serde)]
pub struct TournamentAddressesModelEntity {
    __id: felt252, // private field
    pub addresses: Array<ContractAddress>,
}

#[generate_trait]
pub impl TournamentAddressesModelEntityStoreImpl of TournamentAddressesModelEntityStore {
    fn get(
        world: dojo::world::IWorldDispatcher, entity_id: felt252
    ) -> TournamentAddressesModelEntity {
        TournamentAddressesModelModelEntityImpl::get(world, entity_id)
    }

    fn update(self: @TournamentAddressesModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<TournamentAddressesModelEntity>::update_entity(self, world);
    }

    fn delete(self: @TournamentAddressesModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<TournamentAddressesModelEntity>::delete_entity(self, world);
    }


    fn get_addresses(
        world: dojo::world::IWorldDispatcher, entity_id: felt252
    ) -> Array<ContractAddress> {
        let mut values = dojo::model::ModelEntity::<
            TournamentAddressesModelEntity
        >::get_member(
            world,
            entity_id,
            934480653781223487392644099173472875957189838399670302818291585235615632923
        );
        let field_value = core::serde::Serde::<Array<ContractAddress>>::deserialize(ref values);

        if core::option::OptionTrait::<Array<ContractAddress>>::is_none(@field_value) {
            panic!("Field `TournamentAddressesModel::addresses`: deserialization failed.");
        }

        core::option::OptionTrait::<Array<ContractAddress>>::unwrap(field_value)
    }

    fn set_addresses(
        self: @TournamentAddressesModelEntity,
        world: dojo::world::IWorldDispatcher,
        value: Array<ContractAddress>
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                934480653781223487392644099173472875957189838399670302818291585235615632923,
                serialized.span()
            );
    }
}

#[generate_trait]
pub impl TournamentAddressesModelStoreImpl of TournamentAddressesModelStore {
    fn entity_id_from_keys(tournament_id: u64) -> felt252 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);

        core::poseidon::poseidon_hash_span(serialized.span())
    }

    fn from_values(ref keys: Span<felt252>, ref values: Span<felt252>) -> TournamentAddressesModel {
        let mut serialized = core::array::ArrayTrait::new();
        serialized.append_span(keys);
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<TournamentAddressesModel>::deserialize(ref serialized);

        if core::option::OptionTrait::<TournamentAddressesModel>::is_none(@entity) {
            panic!(
                "Model `TournamentAddressesModel`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<TournamentAddressesModel>::unwrap(entity)
    }

    fn get(world: dojo::world::IWorldDispatcher, tournament_id: u64) -> TournamentAddressesModel {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);

        dojo::model::Model::<TournamentAddressesModel>::get(world, serialized.span())
    }

    fn set(self: @TournamentAddressesModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<TournamentAddressesModel>::set_model(self, world);
    }

    fn delete(self: @TournamentAddressesModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<TournamentAddressesModel>::delete_model(self, world);
    }


    fn get_addresses(
        world: dojo::world::IWorldDispatcher, tournament_id: u64
    ) -> Array<ContractAddress> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentAddressesModel
        >::get_member(
            world,
            serialized.span(),
            934480653781223487392644099173472875957189838399670302818291585235615632923
        );

        let field_value = core::serde::Serde::<Array<ContractAddress>>::deserialize(ref values);

        if core::option::OptionTrait::<Array<ContractAddress>>::is_none(@field_value) {
            panic!("Field `TournamentAddressesModel::addresses`: deserialization failed.");
        }

        core::option::OptionTrait::<Array<ContractAddress>>::unwrap(field_value)
    }

    fn set_addresses(
        self: @TournamentAddressesModel,
        world: dojo::world::IWorldDispatcher,
        value: Array<ContractAddress>
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                934480653781223487392644099173472875957189838399670302818291585235615632923,
                serialized.span()
            );
    }
}

pub impl TournamentAddressesModelModelEntityImpl of dojo::model::ModelEntity<
    TournamentAddressesModelEntity
> {
    fn id(self: @TournamentAddressesModelEntity) -> felt252 {
        *self.__id
    }

    fn values(self: @TournamentAddressesModelEntity) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.addresses, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    fn from_values(
        entity_id: felt252, ref values: Span<felt252>
    ) -> TournamentAddressesModelEntity {
        let mut serialized = array![entity_id];
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity_values = core::serde::Serde::<
            TournamentAddressesModelEntity
        >::deserialize(ref serialized);
        if core::option::OptionTrait::<TournamentAddressesModelEntity>::is_none(@entity_values) {
            panic!("ModelEntity `TournamentAddressesModelEntity`: deserialization failed.");
        }
        core::option::OptionTrait::<TournamentAddressesModelEntity>::unwrap(entity_values)
    }

    fn get(
        world: dojo::world::IWorldDispatcher, entity_id: felt252
    ) -> TournamentAddressesModelEntity {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            dojo::model::Model::<TournamentAddressesModel>::selector(),
            dojo::model::ModelIndex::Id(entity_id),
            dojo::model::Model::<TournamentAddressesModel>::layout()
        );
        Self::from_values(entity_id, ref values)
    }

    fn update_entity(self: @TournamentAddressesModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            dojo::model::Model::<TournamentAddressesModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<TournamentAddressesModel>::layout()
        );
    }

    fn delete_entity(self: @TournamentAddressesModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world,
            dojo::model::Model::<TournamentAddressesModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<TournamentAddressesModel>::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, entity_id: felt252, member_id: felt252,
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<TournamentAddressesModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    dojo::model::Model::<TournamentAddressesModel>::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @TournamentAddressesModelEntity,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>,
    ) {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<TournamentAddressesModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    dojo::model::Model::<TournamentAddressesModel>::selector(),
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
pub impl TournamentAddressesModelModelEntityTestImpl of dojo::model::ModelEntityTest<
    TournamentAddressesModelEntity
> {
    fn update_test(self: @TournamentAddressesModelEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<TournamentAddressesModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<TournamentAddressesModel>::layout()
        );
    }

    fn delete_test(self: @TournamentAddressesModelEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<TournamentAddressesModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<TournamentAddressesModel>::layout()
        );
    }
}

pub impl TournamentAddressesModelModelImpl of dojo::model::Model<TournamentAddressesModel> {
    fn get(world: dojo::world::IWorldDispatcher, keys: Span<felt252>) -> TournamentAddressesModel {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(keys), Self::layout()
        );
        let mut _keys = keys;

        TournamentAddressesModelStore::from_values(ref _keys, ref values)
    }

    fn set_model(self: @TournamentAddressesModel, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            Self::selector(),
            dojo::model::ModelIndex::Keys(Self::keys(self)),
            Self::values(self),
            Self::layout()
        );
    }

    fn delete_model(self: @TournamentAddressesModel, world: dojo::world::IWorldDispatcher) {
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
        self: @TournamentAddressesModel,
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
        "TournamentAddressesModel"
    }

    #[inline(always)]
    fn namespace() -> ByteArray {
        "tournament"
    }

    #[inline(always)]
    fn tag() -> ByteArray {
        "tournament-TournamentAddressesModel"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        3133618699491414289508365040578536817124937232192072977417909851181432430640
    }

    #[inline(always)]
    fn instance_selector(self: @TournamentAddressesModel) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn name_hash() -> felt252 {
        268352329999973955925060632570680770649793852814599683576674503566703222099
    }

    #[inline(always)]
    fn namespace_hash() -> felt252 {
        3513465382457774401660929656863894979351645367198604050918895380273858322651
    }

    #[inline(always)]
    fn entity_id(self: @TournamentAddressesModel) -> felt252 {
        core::poseidon::poseidon_hash_span(self.keys())
    }

    #[inline(always)]
    fn keys(self: @TournamentAddressesModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.tournament_id, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @TournamentAddressesModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.addresses, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::model::Layout {
        dojo::model::introspect::Introspect::<TournamentAddressesModel>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @TournamentAddressesModel) -> dojo::model::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        dojo::model::layout::compute_packed_size(Self::layout())
    }
}

#[cfg(target: "test")]
pub impl TournamentAddressesModelModelTestImpl of dojo::model::ModelTest<TournamentAddressesModel> {
    fn set_test(self: @TournamentAddressesModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<TournamentAddressesModel>::selector(),
            dojo::model::ModelIndex::Keys(
                dojo::model::Model::<TournamentAddressesModel>::keys(self)
            ),
            dojo::model::Model::<TournamentAddressesModel>::values(self),
            dojo::model::Model::<TournamentAddressesModel>::layout()
        );
    }

    fn delete_test(self: @TournamentAddressesModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<TournamentAddressesModel>::selector(),
            dojo::model::ModelIndex::Keys(
                dojo::model::Model::<TournamentAddressesModel>::keys(self)
            ),
            dojo::model::Model::<TournamentAddressesModel>::layout()
        );
    }
}

#[starknet::interface]
pub trait Itournament_addresses_model<T> {
    fn ensure_abi(self: @T, model: TournamentAddressesModel);
}

#[starknet::contract]
pub mod tournament_addresses_model {
    use super::TournamentAddressesModel;
    use super::Itournament_addresses_model;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            "TournamentAddressesModel"
        }

        fn namespace(self: @ContractState) -> ByteArray {
            "tournament"
        }

        fn tag(self: @ContractState) -> ByteArray {
            "tournament-TournamentAddressesModel"
        }

        fn version(self: @ContractState) -> u8 {
            1
        }

        fn selector(self: @ContractState) -> felt252 {
            3133618699491414289508365040578536817124937232192072977417909851181432430640
        }

        fn name_hash(self: @ContractState) -> felt252 {
            268352329999973955925060632570680770649793852814599683576674503566703222099
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            3513465382457774401660929656863894979351645367198604050918895380273858322651
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::model::introspect::Introspect::<TournamentAddressesModel>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<TournamentAddressesModel>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::model::Layout {
            dojo::model::Model::<TournamentAddressesModel>::layout()
        }

        fn schema(self: @ContractState) -> dojo::model::introspect::Ty {
            dojo::model::introspect::Introspect::<TournamentAddressesModel>::ty()
        }
    }

    #[abi(embed_v0)]
    impl tournament_addresses_modelImpl of Itournament_addresses_model<ContractState> {
        fn ensure_abi(self: @ContractState, model: TournamentAddressesModel) {}
    }
}
