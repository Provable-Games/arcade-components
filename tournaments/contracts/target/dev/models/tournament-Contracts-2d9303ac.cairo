impl ContractsIntrospect<> of dojo::model::introspect::Introspect<Contracts<>> {
    #[inline(always)]
    fn size() -> Option<usize> {
        Option::Some(3)
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
                name: 'Contracts',
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
pub struct ContractsEntity {
    __id: felt252, // private field
    pub eth: ContractAddress,
    pub lords: ContractAddress,
    pub oracle: ContractAddress,
}

#[generate_trait]
pub impl ContractsEntityStoreImpl of ContractsEntityStore {
    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> ContractsEntity {
        ContractsModelEntityImpl::get(world, entity_id)
    }

    fn update(self: @ContractsEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<ContractsEntity>::update_entity(self, world);
    }

    fn delete(self: @ContractsEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<ContractsEntity>::delete_entity(self, world);
    }


    fn get_eth(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> ContractAddress {
        let mut values = dojo::model::ModelEntity::<
            ContractsEntity
        >::get_member(
            world,
            entity_id,
            1518613019892893829655483854420872954822463890754671513613512612836480899056
        );
        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `Contracts::eth`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_eth(
        self: @ContractsEntity, world: dojo::world::IWorldDispatcher, value: ContractAddress
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
            ContractsEntity
        >::get_member(
            world,
            entity_id,
            482710145751170347711455300901333809812816550494350696898839501117878745597
        );
        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `Contracts::lords`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_lords(
        self: @ContractsEntity, world: dojo::world::IWorldDispatcher, value: ContractAddress
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

    fn get_oracle(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> ContractAddress {
        let mut values = dojo::model::ModelEntity::<
            ContractsEntity
        >::get_member(
            world,
            entity_id,
            812678450777384149983470903664690389400339010978415984352331906886657359542
        );
        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `Contracts::oracle`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_oracle(
        self: @ContractsEntity, world: dojo::world::IWorldDispatcher, value: ContractAddress
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
pub impl ContractsStoreImpl of ContractsStore {
    fn entity_id_from_keys(contract: ContractAddress) -> felt252 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@contract, ref serialized);

        core::poseidon::poseidon_hash_span(serialized.span())
    }

    fn from_values(ref keys: Span<felt252>, ref values: Span<felt252>) -> Contracts {
        let mut serialized = core::array::ArrayTrait::new();
        serialized.append_span(keys);
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<Contracts>::deserialize(ref serialized);

        if core::option::OptionTrait::<Contracts>::is_none(@entity) {
            panic!(
                "Model `Contracts`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<Contracts>::unwrap(entity)
    }

    fn get(world: dojo::world::IWorldDispatcher, contract: ContractAddress) -> Contracts {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@contract, ref serialized);

        dojo::model::Model::<Contracts>::get(world, serialized.span())
    }

    fn set(self: @Contracts, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<Contracts>::set_model(self, world);
    }

    fn delete(self: @Contracts, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<Contracts>::delete_model(self, world);
    }


    fn get_eth(world: dojo::world::IWorldDispatcher, contract: ContractAddress) -> ContractAddress {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@contract, ref serialized);

        let mut values = dojo::model::Model::<
            Contracts
        >::get_member(
            world,
            serialized.span(),
            1518613019892893829655483854420872954822463890754671513613512612836480899056
        );

        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `Contracts::eth`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_eth(self: @Contracts, world: dojo::world::IWorldDispatcher, value: ContractAddress) {
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
            Contracts
        >::get_member(
            world,
            serialized.span(),
            482710145751170347711455300901333809812816550494350696898839501117878745597
        );

        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `Contracts::lords`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_lords(self: @Contracts, world: dojo::world::IWorldDispatcher, value: ContractAddress) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                482710145751170347711455300901333809812816550494350696898839501117878745597,
                serialized.span()
            );
    }

    fn get_oracle(
        world: dojo::world::IWorldDispatcher, contract: ContractAddress
    ) -> ContractAddress {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@contract, ref serialized);

        let mut values = dojo::model::Model::<
            Contracts
        >::get_member(
            world,
            serialized.span(),
            812678450777384149983470903664690389400339010978415984352331906886657359542
        );

        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `Contracts::oracle`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_oracle(self: @Contracts, world: dojo::world::IWorldDispatcher, value: ContractAddress) {
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

pub impl ContractsModelEntityImpl of dojo::model::ModelEntity<ContractsEntity> {
    fn id(self: @ContractsEntity) -> felt252 {
        *self.__id
    }

    fn values(self: @ContractsEntity) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.eth, ref serialized);
        core::serde::Serde::serialize(self.lords, ref serialized);
        core::serde::Serde::serialize(self.oracle, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    fn from_values(entity_id: felt252, ref values: Span<felt252>) -> ContractsEntity {
        let mut serialized = array![entity_id];
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity_values = core::serde::Serde::<ContractsEntity>::deserialize(ref serialized);
        if core::option::OptionTrait::<ContractsEntity>::is_none(@entity_values) {
            panic!("ModelEntity `ContractsEntity`: deserialization failed.");
        }
        core::option::OptionTrait::<ContractsEntity>::unwrap(entity_values)
    }

    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> ContractsEntity {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            dojo::model::Model::<Contracts>::selector(),
            dojo::model::ModelIndex::Id(entity_id),
            dojo::model::Model::<Contracts>::layout()
        );
        Self::from_values(entity_id, ref values)
    }

    fn update_entity(self: @ContractsEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            dojo::model::Model::<Contracts>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<Contracts>::layout()
        );
    }

    fn delete_entity(self: @ContractsEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world,
            dojo::model::Model::<Contracts>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<Contracts>::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, entity_id: felt252, member_id: felt252,
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<Contracts>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    dojo::model::Model::<Contracts>::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @ContractsEntity,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>,
    ) {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<Contracts>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    dojo::model::Model::<Contracts>::selector(),
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
pub impl ContractsModelEntityTestImpl of dojo::model::ModelEntityTest<ContractsEntity> {
    fn update_test(self: @ContractsEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<Contracts>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<Contracts>::layout()
        );
    }

    fn delete_test(self: @ContractsEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<Contracts>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<Contracts>::layout()
        );
    }
}

pub impl ContractsModelImpl of dojo::model::Model<Contracts> {
    fn get(world: dojo::world::IWorldDispatcher, keys: Span<felt252>) -> Contracts {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(keys), Self::layout()
        );
        let mut _keys = keys;

        ContractsStore::from_values(ref _keys, ref values)
    }

    fn set_model(self: @Contracts, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            Self::selector(),
            dojo::model::ModelIndex::Keys(Self::keys(self)),
            Self::values(self),
            Self::layout()
        );
    }

    fn delete_model(self: @Contracts, world: dojo::world::IWorldDispatcher) {
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
        self: @Contracts,
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
        "Contracts"
    }

    #[inline(always)]
    fn namespace() -> ByteArray {
        "tournament"
    }

    #[inline(always)]
    fn tag() -> ByteArray {
        "tournament-Contracts"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        1288364379163041589372153651941796144155305524426703405308919360303251325301
    }

    #[inline(always)]
    fn instance_selector(self: @Contracts) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn name_hash() -> felt252 {
        1233096989854894658436491556864571463442530211031733052177878135634227984296
    }

    #[inline(always)]
    fn namespace_hash() -> felt252 {
        3513465382457774401660929656863894979351645367198604050918895380273858322651
    }

    #[inline(always)]
    fn entity_id(self: @Contracts) -> felt252 {
        core::poseidon::poseidon_hash_span(self.keys())
    }

    #[inline(always)]
    fn keys(self: @Contracts) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.contract, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @Contracts) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.eth, ref serialized);
        core::serde::Serde::serialize(self.lords, ref serialized);
        core::serde::Serde::serialize(self.oracle, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::model::Layout {
        dojo::model::introspect::Introspect::<Contracts>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @Contracts) -> dojo::model::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        dojo::model::layout::compute_packed_size(Self::layout())
    }
}

#[cfg(target: "test")]
pub impl ContractsModelTestImpl of dojo::model::ModelTest<Contracts> {
    fn set_test(self: @Contracts, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<Contracts>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<Contracts>::keys(self)),
            dojo::model::Model::<Contracts>::values(self),
            dojo::model::Model::<Contracts>::layout()
        );
    }

    fn delete_test(self: @Contracts, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<Contracts>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<Contracts>::keys(self)),
            dojo::model::Model::<Contracts>::layout()
        );
    }
}

#[starknet::interface]
pub trait Icontracts<T> {
    fn ensure_abi(self: @T, model: Contracts);
}

#[starknet::contract]
pub mod contracts {
    use super::Contracts;
    use super::Icontracts;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            "Contracts"
        }

        fn namespace(self: @ContractState) -> ByteArray {
            "tournament"
        }

        fn tag(self: @ContractState) -> ByteArray {
            "tournament-Contracts"
        }

        fn version(self: @ContractState) -> u8 {
            1
        }

        fn selector(self: @ContractState) -> felt252 {
            1288364379163041589372153651941796144155305524426703405308919360303251325301
        }

        fn name_hash(self: @ContractState) -> felt252 {
            1233096989854894658436491556864571463442530211031733052177878135634227984296
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            3513465382457774401660929656863894979351645367198604050918895380273858322651
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::model::introspect::Introspect::<Contracts>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<Contracts>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::model::Layout {
            dojo::model::Model::<Contracts>::layout()
        }

        fn schema(self: @ContractState) -> dojo::model::introspect::Ty {
            dojo::model::introspect::Introspect::<Contracts>::ty()
        }
    }

    #[abi(embed_v0)]
    impl contractsImpl of Icontracts<ContractState> {
        fn ensure_abi(self: @ContractState, model: Contracts) {}
    }
}
