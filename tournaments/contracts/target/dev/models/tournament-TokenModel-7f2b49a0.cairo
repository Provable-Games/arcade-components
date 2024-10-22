impl TokenModelIntrospect<> of dojo::model::introspect::Introspect<TokenModel<>> {
    #[inline(always)]
    fn size() -> Option<usize> {
        Option::None
    }

    fn layout() -> dojo::model::Layout {
        dojo::model::Layout::Struct(
            array![
                dojo::model::FieldLayout {
                    selector: 1528802474226268325865027367859591458315299653151958663884057507666229546336,
                    layout: dojo::model::introspect::Introspect::<ByteArray>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 944713526212149105522785400348068751682982210605126537021911324578866405028,
                    layout: dojo::model::introspect::Introspect::<ByteArray>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 1215478676157697533039883269464363673013265768584048190134506244680659683943,
                    layout: dojo::model::introspect::Introspect::<TokenType>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 987487477892071739885678087625628393443584938265845517311290340822738272931,
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
                name: 'TokenModel',
                attrs: array![].span(),
                children: array![
                    dojo::model::introspect::Member {
                        name: 'token',
                        attrs: array!['key'].span(),
                        ty: dojo::model::introspect::Introspect::<ContractAddress>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'name',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Ty::ByteArray
                    },
                    dojo::model::introspect::Member {
                        name: 'symbol',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Ty::ByteArray
                    },
                    dojo::model::introspect::Member {
                        name: 'token_type',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<TokenType>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'is_registered',
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
pub struct TokenModelEntity {
    __id: felt252, // private field
    pub name: ByteArray,
    pub symbol: ByteArray,
    pub token_type: TokenType,
    pub is_registered: bool,
}

#[generate_trait]
pub impl TokenModelEntityStoreImpl of TokenModelEntityStore {
    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> TokenModelEntity {
        TokenModelModelEntityImpl::get(world, entity_id)
    }

    fn update(self: @TokenModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<TokenModelEntity>::update_entity(self, world);
    }

    fn delete(self: @TokenModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<TokenModelEntity>::delete_entity(self, world);
    }


    fn get_name(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> ByteArray {
        let mut values = dojo::model::ModelEntity::<
            TokenModelEntity
        >::get_member(
            world,
            entity_id,
            1528802474226268325865027367859591458315299653151958663884057507666229546336
        );
        let field_value = core::serde::Serde::<ByteArray>::deserialize(ref values);

        if core::option::OptionTrait::<ByteArray>::is_none(@field_value) {
            panic!("Field `TokenModel::name`: deserialization failed.");
        }

        core::option::OptionTrait::<ByteArray>::unwrap(field_value)
    }

    fn set_name(self: @TokenModelEntity, world: dojo::world::IWorldDispatcher, value: ByteArray) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1528802474226268325865027367859591458315299653151958663884057507666229546336,
                serialized.span()
            );
    }

    fn get_symbol(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> ByteArray {
        let mut values = dojo::model::ModelEntity::<
            TokenModelEntity
        >::get_member(
            world,
            entity_id,
            944713526212149105522785400348068751682982210605126537021911324578866405028
        );
        let field_value = core::serde::Serde::<ByteArray>::deserialize(ref values);

        if core::option::OptionTrait::<ByteArray>::is_none(@field_value) {
            panic!("Field `TokenModel::symbol`: deserialization failed.");
        }

        core::option::OptionTrait::<ByteArray>::unwrap(field_value)
    }

    fn set_symbol(self: @TokenModelEntity, world: dojo::world::IWorldDispatcher, value: ByteArray) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                944713526212149105522785400348068751682982210605126537021911324578866405028,
                serialized.span()
            );
    }

    fn get_token_type(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> TokenType {
        let mut values = dojo::model::ModelEntity::<
            TokenModelEntity
        >::get_member(
            world,
            entity_id,
            1215478676157697533039883269464363673013265768584048190134506244680659683943
        );
        let field_value = core::serde::Serde::<TokenType>::deserialize(ref values);

        if core::option::OptionTrait::<TokenType>::is_none(@field_value) {
            panic!("Field `TokenModel::token_type`: deserialization failed.");
        }

        core::option::OptionTrait::<TokenType>::unwrap(field_value)
    }

    fn set_token_type(
        self: @TokenModelEntity, world: dojo::world::IWorldDispatcher, value: TokenType
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1215478676157697533039883269464363673013265768584048190134506244680659683943,
                serialized.span()
            );
    }

    fn get_is_registered(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> bool {
        let mut values = dojo::model::ModelEntity::<
            TokenModelEntity
        >::get_member(
            world,
            entity_id,
            987487477892071739885678087625628393443584938265845517311290340822738272931
        );
        let field_value = core::serde::Serde::<bool>::deserialize(ref values);

        if core::option::OptionTrait::<bool>::is_none(@field_value) {
            panic!("Field `TokenModel::is_registered`: deserialization failed.");
        }

        core::option::OptionTrait::<bool>::unwrap(field_value)
    }

    fn set_is_registered(
        self: @TokenModelEntity, world: dojo::world::IWorldDispatcher, value: bool
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                987487477892071739885678087625628393443584938265845517311290340822738272931,
                serialized.span()
            );
    }
}

#[generate_trait]
pub impl TokenModelStoreImpl of TokenModelStore {
    fn entity_id_from_keys(token: ContractAddress) -> felt252 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@token, ref serialized);

        core::poseidon::poseidon_hash_span(serialized.span())
    }

    fn from_values(ref keys: Span<felt252>, ref values: Span<felt252>) -> TokenModel {
        let mut serialized = core::array::ArrayTrait::new();
        serialized.append_span(keys);
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<TokenModel>::deserialize(ref serialized);

        if core::option::OptionTrait::<TokenModel>::is_none(@entity) {
            panic!(
                "Model `TokenModel`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<TokenModel>::unwrap(entity)
    }

    fn get(world: dojo::world::IWorldDispatcher, token: ContractAddress) -> TokenModel {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@token, ref serialized);

        dojo::model::Model::<TokenModel>::get(world, serialized.span())
    }

    fn set(self: @TokenModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<TokenModel>::set_model(self, world);
    }

    fn delete(self: @TokenModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<TokenModel>::delete_model(self, world);
    }


    fn get_name(world: dojo::world::IWorldDispatcher, token: ContractAddress) -> ByteArray {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@token, ref serialized);

        let mut values = dojo::model::Model::<
            TokenModel
        >::get_member(
            world,
            serialized.span(),
            1528802474226268325865027367859591458315299653151958663884057507666229546336
        );

        let field_value = core::serde::Serde::<ByteArray>::deserialize(ref values);

        if core::option::OptionTrait::<ByteArray>::is_none(@field_value) {
            panic!("Field `TokenModel::name`: deserialization failed.");
        }

        core::option::OptionTrait::<ByteArray>::unwrap(field_value)
    }

    fn set_name(self: @TokenModel, world: dojo::world::IWorldDispatcher, value: ByteArray) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1528802474226268325865027367859591458315299653151958663884057507666229546336,
                serialized.span()
            );
    }

    fn get_symbol(world: dojo::world::IWorldDispatcher, token: ContractAddress) -> ByteArray {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@token, ref serialized);

        let mut values = dojo::model::Model::<
            TokenModel
        >::get_member(
            world,
            serialized.span(),
            944713526212149105522785400348068751682982210605126537021911324578866405028
        );

        let field_value = core::serde::Serde::<ByteArray>::deserialize(ref values);

        if core::option::OptionTrait::<ByteArray>::is_none(@field_value) {
            panic!("Field `TokenModel::symbol`: deserialization failed.");
        }

        core::option::OptionTrait::<ByteArray>::unwrap(field_value)
    }

    fn set_symbol(self: @TokenModel, world: dojo::world::IWorldDispatcher, value: ByteArray) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                944713526212149105522785400348068751682982210605126537021911324578866405028,
                serialized.span()
            );
    }

    fn get_token_type(world: dojo::world::IWorldDispatcher, token: ContractAddress) -> TokenType {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@token, ref serialized);

        let mut values = dojo::model::Model::<
            TokenModel
        >::get_member(
            world,
            serialized.span(),
            1215478676157697533039883269464363673013265768584048190134506244680659683943
        );

        let field_value = core::serde::Serde::<TokenType>::deserialize(ref values);

        if core::option::OptionTrait::<TokenType>::is_none(@field_value) {
            panic!("Field `TokenModel::token_type`: deserialization failed.");
        }

        core::option::OptionTrait::<TokenType>::unwrap(field_value)
    }

    fn set_token_type(self: @TokenModel, world: dojo::world::IWorldDispatcher, value: TokenType) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1215478676157697533039883269464363673013265768584048190134506244680659683943,
                serialized.span()
            );
    }

    fn get_is_registered(world: dojo::world::IWorldDispatcher, token: ContractAddress) -> bool {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@token, ref serialized);

        let mut values = dojo::model::Model::<
            TokenModel
        >::get_member(
            world,
            serialized.span(),
            987487477892071739885678087625628393443584938265845517311290340822738272931
        );

        let field_value = core::serde::Serde::<bool>::deserialize(ref values);

        if core::option::OptionTrait::<bool>::is_none(@field_value) {
            panic!("Field `TokenModel::is_registered`: deserialization failed.");
        }

        core::option::OptionTrait::<bool>::unwrap(field_value)
    }

    fn set_is_registered(self: @TokenModel, world: dojo::world::IWorldDispatcher, value: bool) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                987487477892071739885678087625628393443584938265845517311290340822738272931,
                serialized.span()
            );
    }
}

pub impl TokenModelModelEntityImpl of dojo::model::ModelEntity<TokenModelEntity> {
    fn id(self: @TokenModelEntity) -> felt252 {
        *self.__id
    }

    fn values(self: @TokenModelEntity) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.name, ref serialized);
        core::serde::Serde::serialize(self.symbol, ref serialized);
        core::serde::Serde::serialize(self.token_type, ref serialized);
        core::serde::Serde::serialize(self.is_registered, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    fn from_values(entity_id: felt252, ref values: Span<felt252>) -> TokenModelEntity {
        let mut serialized = array![entity_id];
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity_values = core::serde::Serde::<TokenModelEntity>::deserialize(ref serialized);
        if core::option::OptionTrait::<TokenModelEntity>::is_none(@entity_values) {
            panic!("ModelEntity `TokenModelEntity`: deserialization failed.");
        }
        core::option::OptionTrait::<TokenModelEntity>::unwrap(entity_values)
    }

    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> TokenModelEntity {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            dojo::model::Model::<TokenModel>::selector(),
            dojo::model::ModelIndex::Id(entity_id),
            dojo::model::Model::<TokenModel>::layout()
        );
        Self::from_values(entity_id, ref values)
    }

    fn update_entity(self: @TokenModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            dojo::model::Model::<TokenModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<TokenModel>::layout()
        );
    }

    fn delete_entity(self: @TokenModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world,
            dojo::model::Model::<TokenModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<TokenModel>::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, entity_id: felt252, member_id: felt252,
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<TokenModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    dojo::model::Model::<TokenModel>::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @TokenModelEntity,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>,
    ) {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<TokenModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    dojo::model::Model::<TokenModel>::selector(),
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
pub impl TokenModelModelEntityTestImpl of dojo::model::ModelEntityTest<TokenModelEntity> {
    fn update_test(self: @TokenModelEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<TokenModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<TokenModel>::layout()
        );
    }

    fn delete_test(self: @TokenModelEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<TokenModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<TokenModel>::layout()
        );
    }
}

pub impl TokenModelModelImpl of dojo::model::Model<TokenModel> {
    fn get(world: dojo::world::IWorldDispatcher, keys: Span<felt252>) -> TokenModel {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(keys), Self::layout()
        );
        let mut _keys = keys;

        TokenModelStore::from_values(ref _keys, ref values)
    }

    fn set_model(self: @TokenModel, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            Self::selector(),
            dojo::model::ModelIndex::Keys(Self::keys(self)),
            Self::values(self),
            Self::layout()
        );
    }

    fn delete_model(self: @TokenModel, world: dojo::world::IWorldDispatcher) {
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
        self: @TokenModel,
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
        "TokenModel"
    }

    #[inline(always)]
    fn namespace() -> ByteArray {
        "tournament"
    }

    #[inline(always)]
    fn tag() -> ByteArray {
        "tournament-TokenModel"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        3595013396693278436954482917228889422158342974571560033417915084062609876866
    }

    #[inline(always)]
    fn instance_selector(self: @TokenModel) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn name_hash() -> felt252 {
        3332488950331425071909086961072866762580749454324531126181899255362438896313
    }

    #[inline(always)]
    fn namespace_hash() -> felt252 {
        3513465382457774401660929656863894979351645367198604050918895380273858322651
    }

    #[inline(always)]
    fn entity_id(self: @TokenModel) -> felt252 {
        core::poseidon::poseidon_hash_span(self.keys())
    }

    #[inline(always)]
    fn keys(self: @TokenModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.token, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @TokenModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.name, ref serialized);
        core::serde::Serde::serialize(self.symbol, ref serialized);
        core::serde::Serde::serialize(self.token_type, ref serialized);
        core::serde::Serde::serialize(self.is_registered, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::model::Layout {
        dojo::model::introspect::Introspect::<TokenModel>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @TokenModel) -> dojo::model::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        dojo::model::layout::compute_packed_size(Self::layout())
    }
}

#[cfg(target: "test")]
pub impl TokenModelModelTestImpl of dojo::model::ModelTest<TokenModel> {
    fn set_test(self: @TokenModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<TokenModel>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<TokenModel>::keys(self)),
            dojo::model::Model::<TokenModel>::values(self),
            dojo::model::Model::<TokenModel>::layout()
        );
    }

    fn delete_test(self: @TokenModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<TokenModel>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<TokenModel>::keys(self)),
            dojo::model::Model::<TokenModel>::layout()
        );
    }
}

#[starknet::interface]
pub trait Itoken_model<T> {
    fn ensure_abi(self: @T, model: TokenModel);
}

#[starknet::contract]
pub mod token_model {
    use super::TokenModel;
    use super::Itoken_model;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            "TokenModel"
        }

        fn namespace(self: @ContractState) -> ByteArray {
            "tournament"
        }

        fn tag(self: @ContractState) -> ByteArray {
            "tournament-TokenModel"
        }

        fn version(self: @ContractState) -> u8 {
            1
        }

        fn selector(self: @ContractState) -> felt252 {
            3595013396693278436954482917228889422158342974571560033417915084062609876866
        }

        fn name_hash(self: @ContractState) -> felt252 {
            3332488950331425071909086961072866762580749454324531126181899255362438896313
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            3513465382457774401660929656863894979351645367198604050918895380273858322651
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::model::introspect::Introspect::<TokenModel>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<TokenModel>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::model::Layout {
            dojo::model::Model::<TokenModel>::layout()
        }

        fn schema(self: @ContractState) -> dojo::model::introspect::Ty {
            dojo::model::introspect::Introspect::<TokenModel>::ty()
        }
    }

    #[abi(embed_v0)]
    impl token_modelImpl of Itoken_model<ContractState> {
        fn ensure_abi(self: @ContractState, model: TokenModel) {}
    }
}
