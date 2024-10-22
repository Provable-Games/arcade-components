impl TournamentContractsIntrospect<> of dojo::model::introspect::Introspect<TournamentContracts<>> {
    #[inline(always)]
    fn size() -> Option<usize> {
        Option::Some(4)
    }

    fn layout() -> dojo::model::Layout {
        dojo::model::Layout::Struct(
            array![
                dojo::model::FieldLayout {
                    selector: 1518613019892893829655483854420872954822463890754671513613512612836480899056,
                    layout: dojo::model::introspect::Introspect::<ContractAddress>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 482710145751170347711455300901333809812816550494350696898839501117878745597,
                    layout: dojo::model::introspect::Introspect::<ContractAddress>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 292291776214240095206047038157961695439218160724710681310793785387348269358,
                    layout: dojo::model::introspect::Introspect::<ContractAddress>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 812678450777384149983470903664690389400339010978415984352331906886657359542,
                    layout: dojo::model::introspect::Introspect::<ContractAddress>::layout()
                }
            ]
                .span()
        )
    }

    #[inline(always)]
    fn ty() -> dojo::model::introspect::Ty {
        dojo::model::introspect::Ty::Struct(
            dojo::model::introspect::Struct {
                name: 'TournamentContracts',
                attrs: array![].span(),
                children: array![
                    dojo::model::introspect::Member {
                        name: 'contract',
                        attrs: array!['key'].span(),
                        ty: dojo::model::introspect::Introspect::<ContractAddress>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'eth',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<ContractAddress>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'lords',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<ContractAddress>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'loot_survivor',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<ContractAddress>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'oracle',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<ContractAddress>::ty()
                    }
                ]
                    .span()
            }
        )
    }
}

#[derive(Drop, Serde)]
pub struct TournamentContractsEntity {
    __id: felt252, // private field
    pub eth: ContractAddress,
    pub lords: ContractAddress,
    pub loot_survivor: ContractAddress,
    pub oracle: ContractAddress,
}

#[generate_trait]
pub impl TournamentContractsEntityStoreImpl of TournamentContractsEntityStore {
    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> TournamentContractsEntity {
        TournamentContractsModelEntityImpl::get(world, entity_id)
    }

    fn update(self: @TournamentContractsEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<TournamentContractsEntity>::update_entity(self, world);
    }

    fn delete(self: @TournamentContractsEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<TournamentContractsEntity>::delete_entity(self, world);
    }


    fn get_eth(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> ContractAddress {
        let mut values = dojo::model::ModelEntity::<
            TournamentContractsEntity
        >::get_member(
            world,
            entity_id,
            1518613019892893829655483854420872954822463890754671513613512612836480899056
        );
        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `TournamentContracts::eth`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_eth(
        self: @TournamentContractsEntity,
        world: dojo::world::IWorldDispatcher,
        value: ContractAddress
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1518613019892893829655483854420872954822463890754671513613512612836480899056,
                serialized.span()
            );
    }

    fn get_lords(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> ContractAddress {
        let mut values = dojo::model::ModelEntity::<
            TournamentContractsEntity
        >::get_member(
            world,
            entity_id,
            482710145751170347711455300901333809812816550494350696898839501117878745597
        );
        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `TournamentContracts::lords`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_lords(
        self: @TournamentContractsEntity,
        world: dojo::world::IWorldDispatcher,
        value: ContractAddress
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                482710145751170347711455300901333809812816550494350696898839501117878745597,
                serialized.span()
            );
    }

    fn get_loot_survivor(
        world: dojo::world::IWorldDispatcher, entity_id: felt252
    ) -> ContractAddress {
        let mut values = dojo::model::ModelEntity::<
            TournamentContractsEntity
        >::get_member(
            world,
            entity_id,
            292291776214240095206047038157961695439218160724710681310793785387348269358
        );
        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `TournamentContracts::loot_survivor`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_loot_survivor(
        self: @TournamentContractsEntity,
        world: dojo::world::IWorldDispatcher,
        value: ContractAddress
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                292291776214240095206047038157961695439218160724710681310793785387348269358,
                serialized.span()
            );
    }

    fn get_oracle(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> ContractAddress {
        let mut values = dojo::model::ModelEntity::<
            TournamentContractsEntity
        >::get_member(
            world,
            entity_id,
            812678450777384149983470903664690389400339010978415984352331906886657359542
        );
        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `TournamentContracts::oracle`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_oracle(
        self: @TournamentContractsEntity,
        world: dojo::world::IWorldDispatcher,
        value: ContractAddress
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                812678450777384149983470903664690389400339010978415984352331906886657359542,
                serialized.span()
            );
    }
}

#[generate_trait]
pub impl TournamentContractsStoreImpl of TournamentContractsStore {
    fn entity_id_from_keys(contract: ContractAddress) -> felt252 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@contract, ref serialized);

        core::poseidon::poseidon_hash_span(serialized.span())
    }

    fn from_values(ref keys: Span<felt252>, ref values: Span<felt252>) -> TournamentContracts {
        let mut serialized = core::array::ArrayTrait::new();
        serialized.append_span(keys);
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<TournamentContracts>::deserialize(ref serialized);

        if core::option::OptionTrait::<TournamentContracts>::is_none(@entity) {
            panic!(
                "Model `TournamentContracts`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<TournamentContracts>::unwrap(entity)
    }

    fn get(world: dojo::world::IWorldDispatcher, contract: ContractAddress) -> TournamentContracts {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@contract, ref serialized);

        dojo::model::Model::<TournamentContracts>::get(world, serialized.span())
    }

    fn set(self: @TournamentContracts, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<TournamentContracts>::set_model(self, world);
    }

    fn delete(self: @TournamentContracts, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<TournamentContracts>::delete_model(self, world);
    }


    fn get_eth(world: dojo::world::IWorldDispatcher, contract: ContractAddress) -> ContractAddress {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@contract, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentContracts
        >::get_member(
            world,
            serialized.span(),
            1518613019892893829655483854420872954822463890754671513613512612836480899056
        );

        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `TournamentContracts::eth`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_eth(
        self: @TournamentContracts, world: dojo::world::IWorldDispatcher, value: ContractAddress
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1518613019892893829655483854420872954822463890754671513613512612836480899056,
                serialized.span()
            );
    }

    fn get_lords(
        world: dojo::world::IWorldDispatcher, contract: ContractAddress
    ) -> ContractAddress {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@contract, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentContracts
        >::get_member(
            world,
            serialized.span(),
            482710145751170347711455300901333809812816550494350696898839501117878745597
        );

        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `TournamentContracts::lords`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_lords(
        self: @TournamentContracts, world: dojo::world::IWorldDispatcher, value: ContractAddress
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                482710145751170347711455300901333809812816550494350696898839501117878745597,
                serialized.span()
            );
    }

    fn get_loot_survivor(
        world: dojo::world::IWorldDispatcher, contract: ContractAddress
    ) -> ContractAddress {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@contract, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentContracts
        >::get_member(
            world,
            serialized.span(),
            292291776214240095206047038157961695439218160724710681310793785387348269358
        );

        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `TournamentContracts::loot_survivor`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_loot_survivor(
        self: @TournamentContracts, world: dojo::world::IWorldDispatcher, value: ContractAddress
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                292291776214240095206047038157961695439218160724710681310793785387348269358,
                serialized.span()
            );
    }

    fn get_oracle(
        world: dojo::world::IWorldDispatcher, contract: ContractAddress
    ) -> ContractAddress {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@contract, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentContracts
        >::get_member(
            world,
            serialized.span(),
            812678450777384149983470903664690389400339010978415984352331906886657359542
        );

        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `TournamentContracts::oracle`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_oracle(
        self: @TournamentContracts, world: dojo::world::IWorldDispatcher, value: ContractAddress
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                812678450777384149983470903664690389400339010978415984352331906886657359542,
                serialized.span()
            );
    }
}

pub impl TournamentContractsModelEntityImpl of dojo::model::ModelEntity<TournamentContractsEntity> {
    fn id(self: @TournamentContractsEntity) -> felt252 {
        *self.__id
    }

    fn values(self: @TournamentContractsEntity) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.eth, ref serialized);
        core::serde::Serde::serialize(self.lords, ref serialized);
        core::serde::Serde::serialize(self.loot_survivor, ref serialized);
        core::serde::Serde::serialize(self.oracle, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    fn from_values(entity_id: felt252, ref values: Span<felt252>) -> TournamentContractsEntity {
        let mut serialized = array![entity_id];
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity_values = core::serde::Serde::<
            TournamentContractsEntity
        >::deserialize(ref serialized);
        if core::option::OptionTrait::<TournamentContractsEntity>::is_none(@entity_values) {
            panic!("ModelEntity `TournamentContractsEntity`: deserialization failed.");
        }
        core::option::OptionTrait::<TournamentContractsEntity>::unwrap(entity_values)
    }

    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> TournamentContractsEntity {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            dojo::model::Model::<TournamentContracts>::selector(),
            dojo::model::ModelIndex::Id(entity_id),
            dojo::model::Model::<TournamentContracts>::layout()
        );
        Self::from_values(entity_id, ref values)
    }

    fn update_entity(self: @TournamentContractsEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            dojo::model::Model::<TournamentContracts>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<TournamentContracts>::layout()
        );
    }

    fn delete_entity(self: @TournamentContractsEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world,
            dojo::model::Model::<TournamentContracts>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<TournamentContracts>::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, entity_id: felt252, member_id: felt252,
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<TournamentContracts>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    dojo::model::Model::<TournamentContracts>::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @TournamentContractsEntity,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>,
    ) {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<TournamentContracts>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    dojo::model::Model::<TournamentContracts>::selector(),
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
pub impl TournamentContractsModelEntityTestImpl of dojo::model::ModelEntityTest<
    TournamentContractsEntity
> {
    fn update_test(self: @TournamentContractsEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<TournamentContracts>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<TournamentContracts>::layout()
        );
    }

    fn delete_test(self: @TournamentContractsEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<TournamentContracts>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<TournamentContracts>::layout()
        );
    }
}

pub impl TournamentContractsModelImpl of dojo::model::Model<TournamentContracts> {
    fn get(world: dojo::world::IWorldDispatcher, keys: Span<felt252>) -> TournamentContracts {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(keys), Self::layout()
        );
        let mut _keys = keys;

        TournamentContractsStore::from_values(ref _keys, ref values)
    }

    fn set_model(self: @TournamentContracts, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            Self::selector(),
            dojo::model::ModelIndex::Keys(Self::keys(self)),
            Self::values(self),
            Self::layout()
        );
    }

    fn delete_model(self: @TournamentContracts, world: dojo::world::IWorldDispatcher) {
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
        self: @TournamentContracts,
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
        "TournamentContracts"
    }

    #[inline(always)]
    fn namespace() -> ByteArray {
        "tournament"
    }

    #[inline(always)]
    fn tag() -> ByteArray {
        "tournament-TournamentContracts"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        1722584986404601086101760777809679525349246783965062600704151855108369510084
    }

    #[inline(always)]
    fn instance_selector(self: @TournamentContracts) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn name_hash() -> felt252 {
        2476620120161009884583750595911316067749331169660955558625200444293234186232
    }

    #[inline(always)]
    fn namespace_hash() -> felt252 {
        3513465382457774401660929656863894979351645367198604050918895380273858322651
    }

    #[inline(always)]
    fn entity_id(self: @TournamentContracts) -> felt252 {
        core::poseidon::poseidon_hash_span(self.keys())
    }

    #[inline(always)]
    fn keys(self: @TournamentContracts) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.contract, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @TournamentContracts) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.eth, ref serialized);
        core::serde::Serde::serialize(self.lords, ref serialized);
        core::serde::Serde::serialize(self.loot_survivor, ref serialized);
        core::serde::Serde::serialize(self.oracle, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::model::Layout {
        dojo::model::introspect::Introspect::<TournamentContracts>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @TournamentContracts) -> dojo::model::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        dojo::model::layout::compute_packed_size(Self::layout())
    }
}

#[cfg(target: "test")]
pub impl TournamentContractsModelTestImpl of dojo::model::ModelTest<TournamentContracts> {
    fn set_test(self: @TournamentContracts, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<TournamentContracts>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<TournamentContracts>::keys(self)),
            dojo::model::Model::<TournamentContracts>::values(self),
            dojo::model::Model::<TournamentContracts>::layout()
        );
    }

    fn delete_test(self: @TournamentContracts, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<TournamentContracts>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<TournamentContracts>::keys(self)),
            dojo::model::Model::<TournamentContracts>::layout()
        );
    }
}

#[starknet::interface]
pub trait Itournament_contracts<T> {
    fn ensure_abi(self: @T, model: TournamentContracts);
}

#[starknet::contract]
pub mod tournament_contracts {
    use super::TournamentContracts;
    use super::Itournament_contracts;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            "TournamentContracts"
        }

        fn namespace(self: @ContractState) -> ByteArray {
            "tournament"
        }

        fn tag(self: @ContractState) -> ByteArray {
            "tournament-TournamentContracts"
        }

        fn version(self: @ContractState) -> u8 {
            1
        }

        fn selector(self: @ContractState) -> felt252 {
            1722584986404601086101760777809679525349246783965062600704151855108369510084
        }

        fn name_hash(self: @ContractState) -> felt252 {
            2476620120161009884583750595911316067749331169660955558625200444293234186232
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            3513465382457774401660929656863894979351645367198604050918895380273858322651
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::model::introspect::Introspect::<TournamentContracts>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<TournamentContracts>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::model::Layout {
            dojo::model::Model::<TournamentContracts>::layout()
        }

        fn schema(self: @ContractState) -> dojo::model::introspect::Ty {
            dojo::model::introspect::Introspect::<TournamentContracts>::ty()
        }
    }

    #[abi(embed_v0)]
    impl tournament_contractsImpl of Itournament_contracts<ContractState> {
        fn ensure_abi(self: @ContractState, model: TournamentContracts) {}
    }
}
