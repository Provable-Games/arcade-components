impl TournamentEntryModelIntrospect<> of dojo::model::introspect::Introspect<
    TournamentEntryModel<>
> {
    #[inline(always)]
    fn size() -> Option<usize> {
        Option::Some(4)
    }

    fn layout() -> dojo::model::Layout {
        dojo::model::Layout::Struct(
            array![
                dojo::model::FieldLayout {
                    selector: 944407150971126289822123988889809430356945584469838657342381477018902384507,
                    layout: dojo::model::introspect::Introspect::<ContractAddress>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 882083491679563735264551539375234596690986461837360450045455843572485424637,
                    layout: dojo::model::introspect::Introspect::<bool>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 824573152059075885330203672871565437328152310567343827344126684668780733675,
                    layout: dojo::model::introspect::Introspect::<bool>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 1176465570499311615653836774867250828578828866704433274061376673685686272486,
                    layout: dojo::model::introspect::Introspect::<bool>::layout()
                }
            ]
                .span()
        )
    }

    #[inline(always)]
    fn ty() -> dojo::model::introspect::Ty {
        dojo::model::introspect::Ty::Struct(
            dojo::model::introspect::Struct {
                name: 'TournamentEntryModel',
                attrs: array![].span(),
                children: array![
                    dojo::model::introspect::Member {
                        name: 'tournament_id',
                        attrs: array!['key'].span(),
                        ty: dojo::model::introspect::Introspect::<u64>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'game_id',
                        attrs: array!['key'].span(),
                        ty: dojo::model::introspect::Introspect::<u128>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'address',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<ContractAddress>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'entered',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<bool>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'started',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<bool>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'submitted_score',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<bool>::ty()
                    }
                ]
                    .span()
            }
        )
    }
}

#[derive(Drop, Serde)]
pub struct TournamentEntryModelEntity {
    __id: felt252, // private field
    pub address: ContractAddress,
    pub entered: bool,
    pub started: bool,
    pub submitted_score: bool,
}

#[generate_trait]
pub impl TournamentEntryModelEntityStoreImpl of TournamentEntryModelEntityStore {
    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> TournamentEntryModelEntity {
        TournamentEntryModelModelEntityImpl::get(world, entity_id)
    }

    fn update(self: @TournamentEntryModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<TournamentEntryModelEntity>::update_entity(self, world);
    }

    fn delete(self: @TournamentEntryModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<TournamentEntryModelEntity>::delete_entity(self, world);
    }


    fn get_address(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> ContractAddress {
        let mut values = dojo::model::ModelEntity::<
            TournamentEntryModelEntity
        >::get_member(
            world,
            entity_id,
            944407150971126289822123988889809430356945584469838657342381477018902384507
        );
        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `TournamentEntryModel::address`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_address(
        self: @TournamentEntryModelEntity,
        world: dojo::world::IWorldDispatcher,
        value: ContractAddress
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                944407150971126289822123988889809430356945584469838657342381477018902384507,
                serialized.span()
            );
    }

    fn get_entered(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> bool {
        let mut values = dojo::model::ModelEntity::<
            TournamentEntryModelEntity
        >::get_member(
            world,
            entity_id,
            882083491679563735264551539375234596690986461837360450045455843572485424637
        );
        let field_value = core::serde::Serde::<bool>::deserialize(ref values);

        if core::option::OptionTrait::<bool>::is_none(@field_value) {
            panic!("Field `TournamentEntryModel::entered`: deserialization failed.");
        }

        core::option::OptionTrait::<bool>::unwrap(field_value)
    }

    fn set_entered(
        self: @TournamentEntryModelEntity, world: dojo::world::IWorldDispatcher, value: bool
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                882083491679563735264551539375234596690986461837360450045455843572485424637,
                serialized.span()
            );
    }

    fn get_started(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> bool {
        let mut values = dojo::model::ModelEntity::<
            TournamentEntryModelEntity
        >::get_member(
            world,
            entity_id,
            824573152059075885330203672871565437328152310567343827344126684668780733675
        );
        let field_value = core::serde::Serde::<bool>::deserialize(ref values);

        if core::option::OptionTrait::<bool>::is_none(@field_value) {
            panic!("Field `TournamentEntryModel::started`: deserialization failed.");
        }

        core::option::OptionTrait::<bool>::unwrap(field_value)
    }

    fn set_started(
        self: @TournamentEntryModelEntity, world: dojo::world::IWorldDispatcher, value: bool
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                824573152059075885330203672871565437328152310567343827344126684668780733675,
                serialized.span()
            );
    }

    fn get_submitted_score(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> bool {
        let mut values = dojo::model::ModelEntity::<
            TournamentEntryModelEntity
        >::get_member(
            world,
            entity_id,
            1176465570499311615653836774867250828578828866704433274061376673685686272486
        );
        let field_value = core::serde::Serde::<bool>::deserialize(ref values);

        if core::option::OptionTrait::<bool>::is_none(@field_value) {
            panic!("Field `TournamentEntryModel::submitted_score`: deserialization failed.");
        }

        core::option::OptionTrait::<bool>::unwrap(field_value)
    }

    fn set_submitted_score(
        self: @TournamentEntryModelEntity, world: dojo::world::IWorldDispatcher, value: bool
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1176465570499311615653836774867250828578828866704433274061376673685686272486,
                serialized.span()
            );
    }
}

#[generate_trait]
pub impl TournamentEntryModelStoreImpl of TournamentEntryModelStore {
    fn entity_id_from_keys(tournament_id: u64, game_id: u128) -> felt252 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);
        core::serde::Serde::serialize(@game_id, ref serialized);

        core::poseidon::poseidon_hash_span(serialized.span())
    }

    fn from_values(ref keys: Span<felt252>, ref values: Span<felt252>) -> TournamentEntryModel {
        let mut serialized = core::array::ArrayTrait::new();
        serialized.append_span(keys);
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<TournamentEntryModel>::deserialize(ref serialized);

        if core::option::OptionTrait::<TournamentEntryModel>::is_none(@entity) {
            panic!(
                "Model `TournamentEntryModel`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<TournamentEntryModel>::unwrap(entity)
    }

    fn get(
        world: dojo::world::IWorldDispatcher, tournament_id: u64, game_id: u128
    ) -> TournamentEntryModel {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);
        core::serde::Serde::serialize(@game_id, ref serialized);

        dojo::model::Model::<TournamentEntryModel>::get(world, serialized.span())
    }

    fn set(self: @TournamentEntryModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<TournamentEntryModel>::set_model(self, world);
    }

    fn delete(self: @TournamentEntryModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<TournamentEntryModel>::delete_model(self, world);
    }


    fn get_address(
        world: dojo::world::IWorldDispatcher, tournament_id: u64, game_id: u128
    ) -> ContractAddress {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);
        core::serde::Serde::serialize(@game_id, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentEntryModel
        >::get_member(
            world,
            serialized.span(),
            944407150971126289822123988889809430356945584469838657342381477018902384507
        );

        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `TournamentEntryModel::address`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_address(
        self: @TournamentEntryModel, world: dojo::world::IWorldDispatcher, value: ContractAddress
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                944407150971126289822123988889809430356945584469838657342381477018902384507,
                serialized.span()
            );
    }

    fn get_entered(
        world: dojo::world::IWorldDispatcher, tournament_id: u64, game_id: u128
    ) -> bool {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);
        core::serde::Serde::serialize(@game_id, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentEntryModel
        >::get_member(
            world,
            serialized.span(),
            882083491679563735264551539375234596690986461837360450045455843572485424637
        );

        let field_value = core::serde::Serde::<bool>::deserialize(ref values);

        if core::option::OptionTrait::<bool>::is_none(@field_value) {
            panic!("Field `TournamentEntryModel::entered`: deserialization failed.");
        }

        core::option::OptionTrait::<bool>::unwrap(field_value)
    }

    fn set_entered(self: @TournamentEntryModel, world: dojo::world::IWorldDispatcher, value: bool) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                882083491679563735264551539375234596690986461837360450045455843572485424637,
                serialized.span()
            );
    }

    fn get_started(
        world: dojo::world::IWorldDispatcher, tournament_id: u64, game_id: u128
    ) -> bool {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);
        core::serde::Serde::serialize(@game_id, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentEntryModel
        >::get_member(
            world,
            serialized.span(),
            824573152059075885330203672871565437328152310567343827344126684668780733675
        );

        let field_value = core::serde::Serde::<bool>::deserialize(ref values);

        if core::option::OptionTrait::<bool>::is_none(@field_value) {
            panic!("Field `TournamentEntryModel::started`: deserialization failed.");
        }

        core::option::OptionTrait::<bool>::unwrap(field_value)
    }

    fn set_started(self: @TournamentEntryModel, world: dojo::world::IWorldDispatcher, value: bool) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                824573152059075885330203672871565437328152310567343827344126684668780733675,
                serialized.span()
            );
    }

    fn get_submitted_score(
        world: dojo::world::IWorldDispatcher, tournament_id: u64, game_id: u128
    ) -> bool {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);
        core::serde::Serde::serialize(@game_id, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentEntryModel
        >::get_member(
            world,
            serialized.span(),
            1176465570499311615653836774867250828578828866704433274061376673685686272486
        );

        let field_value = core::serde::Serde::<bool>::deserialize(ref values);

        if core::option::OptionTrait::<bool>::is_none(@field_value) {
            panic!("Field `TournamentEntryModel::submitted_score`: deserialization failed.");
        }

        core::option::OptionTrait::<bool>::unwrap(field_value)
    }

    fn set_submitted_score(
        self: @TournamentEntryModel, world: dojo::world::IWorldDispatcher, value: bool
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1176465570499311615653836774867250828578828866704433274061376673685686272486,
                serialized.span()
            );
    }
}

pub impl TournamentEntryModelModelEntityImpl of dojo::model::ModelEntity<
    TournamentEntryModelEntity
> {
    fn id(self: @TournamentEntryModelEntity) -> felt252 {
        *self.__id
    }

    fn values(self: @TournamentEntryModelEntity) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.address, ref serialized);
        core::serde::Serde::serialize(self.entered, ref serialized);
        core::serde::Serde::serialize(self.started, ref serialized);
        core::serde::Serde::serialize(self.submitted_score, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    fn from_values(entity_id: felt252, ref values: Span<felt252>) -> TournamentEntryModelEntity {
        let mut serialized = array![entity_id];
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity_values = core::serde::Serde::<
            TournamentEntryModelEntity
        >::deserialize(ref serialized);
        if core::option::OptionTrait::<TournamentEntryModelEntity>::is_none(@entity_values) {
            panic!("ModelEntity `TournamentEntryModelEntity`: deserialization failed.");
        }
        core::option::OptionTrait::<TournamentEntryModelEntity>::unwrap(entity_values)
    }

    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> TournamentEntryModelEntity {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            dojo::model::Model::<TournamentEntryModel>::selector(),
            dojo::model::ModelIndex::Id(entity_id),
            dojo::model::Model::<TournamentEntryModel>::layout()
        );
        Self::from_values(entity_id, ref values)
    }

    fn update_entity(self: @TournamentEntryModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            dojo::model::Model::<TournamentEntryModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<TournamentEntryModel>::layout()
        );
    }

    fn delete_entity(self: @TournamentEntryModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world,
            dojo::model::Model::<TournamentEntryModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<TournamentEntryModel>::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, entity_id: felt252, member_id: felt252,
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<TournamentEntryModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    dojo::model::Model::<TournamentEntryModel>::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @TournamentEntryModelEntity,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>,
    ) {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<TournamentEntryModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    dojo::model::Model::<TournamentEntryModel>::selector(),
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
pub impl TournamentEntryModelModelEntityTestImpl of dojo::model::ModelEntityTest<
    TournamentEntryModelEntity
> {
    fn update_test(self: @TournamentEntryModelEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<TournamentEntryModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<TournamentEntryModel>::layout()
        );
    }

    fn delete_test(self: @TournamentEntryModelEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<TournamentEntryModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<TournamentEntryModel>::layout()
        );
    }
}

pub impl TournamentEntryModelModelImpl of dojo::model::Model<TournamentEntryModel> {
    fn get(world: dojo::world::IWorldDispatcher, keys: Span<felt252>) -> TournamentEntryModel {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(keys), Self::layout()
        );
        let mut _keys = keys;

        TournamentEntryModelStore::from_values(ref _keys, ref values)
    }

    fn set_model(self: @TournamentEntryModel, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            Self::selector(),
            dojo::model::ModelIndex::Keys(Self::keys(self)),
            Self::values(self),
            Self::layout()
        );
    }

    fn delete_model(self: @TournamentEntryModel, world: dojo::world::IWorldDispatcher) {
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
        self: @TournamentEntryModel,
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
        "TournamentEntryModel"
    }

    #[inline(always)]
    fn namespace() -> ByteArray {
        "tournament"
    }

    #[inline(always)]
    fn tag() -> ByteArray {
        "tournament-TournamentEntryModel"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        1117672652886996332324653360636148603395726779413593101391658156124120113331
    }

    #[inline(always)]
    fn instance_selector(self: @TournamentEntryModel) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn name_hash() -> felt252 {
        990850085444696299407333764556839041163326316251487172989664303898241654370
    }

    #[inline(always)]
    fn namespace_hash() -> felt252 {
        3513465382457774401660929656863894979351645367198604050918895380273858322651
    }

    #[inline(always)]
    fn entity_id(self: @TournamentEntryModel) -> felt252 {
        core::poseidon::poseidon_hash_span(self.keys())
    }

    #[inline(always)]
    fn keys(self: @TournamentEntryModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.tournament_id, ref serialized);
        core::serde::Serde::serialize(self.game_id, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @TournamentEntryModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.address, ref serialized);
        core::serde::Serde::serialize(self.entered, ref serialized);
        core::serde::Serde::serialize(self.started, ref serialized);
        core::serde::Serde::serialize(self.submitted_score, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::model::Layout {
        dojo::model::introspect::Introspect::<TournamentEntryModel>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @TournamentEntryModel) -> dojo::model::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        dojo::model::layout::compute_packed_size(Self::layout())
    }
}

#[cfg(target: "test")]
pub impl TournamentEntryModelModelTestImpl of dojo::model::ModelTest<TournamentEntryModel> {
    fn set_test(self: @TournamentEntryModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<TournamentEntryModel>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<TournamentEntryModel>::keys(self)),
            dojo::model::Model::<TournamentEntryModel>::values(self),
            dojo::model::Model::<TournamentEntryModel>::layout()
        );
    }

    fn delete_test(self: @TournamentEntryModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<TournamentEntryModel>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<TournamentEntryModel>::keys(self)),
            dojo::model::Model::<TournamentEntryModel>::layout()
        );
    }
}

#[starknet::interface]
pub trait Itournament_entry_model<T> {
    fn ensure_abi(self: @T, model: TournamentEntryModel);
}

#[starknet::contract]
pub mod tournament_entry_model {
    use super::TournamentEntryModel;
    use super::Itournament_entry_model;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            "TournamentEntryModel"
        }

        fn namespace(self: @ContractState) -> ByteArray {
            "tournament"
        }

        fn tag(self: @ContractState) -> ByteArray {
            "tournament-TournamentEntryModel"
        }

        fn version(self: @ContractState) -> u8 {
            1
        }

        fn selector(self: @ContractState) -> felt252 {
            1117672652886996332324653360636148603395726779413593101391658156124120113331
        }

        fn name_hash(self: @ContractState) -> felt252 {
            990850085444696299407333764556839041163326316251487172989664303898241654370
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            3513465382457774401660929656863894979351645367198604050918895380273858322651
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::model::introspect::Introspect::<TournamentEntryModel>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<TournamentEntryModel>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::model::Layout {
            dojo::model::Model::<TournamentEntryModel>::layout()
        }

        fn schema(self: @ContractState) -> dojo::model::introspect::Ty {
            dojo::model::introspect::Introspect::<TournamentEntryModel>::ty()
        }
    }

    #[abi(embed_v0)]
    impl tournament_entry_modelImpl of Itournament_entry_model<ContractState> {
        fn ensure_abi(self: @ContractState, model: TournamentEntryModel) {}
    }
}
