impl TournamentModelIntrospect<> of dojo::model::introspect::Introspect<TournamentModel<>> {
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
                    selector: 507417100519034057008297464956665249334164166107291559563484601592847731467,
                    layout: dojo::model::introspect::Introspect::<ContractAddress>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 946621038190093806926132573647305759495551877776969264128327271781276578949,
                    layout: dojo::model::introspect::Introspect::<Option<GatedToken>>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 785777037704301877886393315168394225559039624990411656957207254314251612870,
                    layout: dojo::model::introspect::Introspect::<u64>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 895184732002713007960483689281102000291307368318839706515352948964191528370,
                    layout: dojo::model::introspect::Introspect::<u64>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 1476232782462511468943074306850598432332250002632943341406500179037811387538,
                    layout: dojo::model::introspect::Introspect::<u64>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 937823281162536085825944818956374019698216786171065666831383722466426249429,
                    layout: dojo::model::introspect::Introspect::<u8>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 141182857266598343731913385181938353047068823999760450503467915348315881520,
                    layout: dojo::model::introspect::Introspect::<Option<ContractAddress>>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 1299827507470723997411929187292623538046530657255099969485380823975940135987,
                    layout: dojo::model::introspect::Introspect::<u128>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 1610767268251580031902444025044066844391489207832088337103632250465414143792,
                    layout: dojo::model::introspect::Introspect::<Array<PrizeType>>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 37102906947465363001973208355994435376068959373096957017239192364588303888,
                    layout: dojo::model::introspect::Introspect::<Array<StatRequirement>>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 960691908768004669093520995937048422644348614966203532732485071168380871593,
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
                name: 'TournamentModel',
                attrs: array![].span(),
                children: array![
                    dojo::model::introspect::Member {
                        name: 'tournament_id',
                        attrs: array!['key'].span(),
                        ty: dojo::model::introspect::Introspect::<u64>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'name',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Ty::ByteArray
                    },
                    dojo::model::introspect::Member {
                        name: 'creator',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<ContractAddress>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'gated_token',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<Option<GatedToken>>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'start_time',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<u64>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'end_time',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<u64>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'submission_period',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<u64>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'leaderboard_size',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<u8>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'entry_premium_token',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<Option<ContractAddress>>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'entry_premium_amount',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<u128>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'prizes',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Ty::Array(
                            array![dojo::model::introspect::Introspect::<PrizeType>::ty()].span()
                        )
                    },
                    dojo::model::introspect::Member {
                        name: 'stat_requirements',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Ty::Array(
                            array![dojo::model::introspect::Introspect::<StatRequirement>::ty()]
                                .span()
                        )
                    },
                    dojo::model::introspect::Member {
                        name: 'claimed',
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
pub struct TournamentModelEntity {
    __id: felt252, // private field
    pub name: ByteArray,
    pub creator: ContractAddress,
    pub gated_token: Option<GatedToken>,
    pub start_time: u64,
    pub end_time: u64,
    pub submission_period: u64,
    pub leaderboard_size: u8,
    pub entry_premium_token: Option<ContractAddress>,
    pub entry_premium_amount: u128,
    pub prizes: Array<PrizeType>,
    pub stat_requirements: Array<StatRequirement>,
    pub claimed: bool,
}

#[generate_trait]
pub impl TournamentModelEntityStoreImpl of TournamentModelEntityStore {
    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> TournamentModelEntity {
        TournamentModelModelEntityImpl::get(world, entity_id)
    }

    fn update(self: @TournamentModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<TournamentModelEntity>::update_entity(self, world);
    }

    fn delete(self: @TournamentModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<TournamentModelEntity>::delete_entity(self, world);
    }


    fn get_name(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> ByteArray {
        let mut values = dojo::model::ModelEntity::<
            TournamentModelEntity
        >::get_member(
            world,
            entity_id,
            1528802474226268325865027367859591458315299653151958663884057507666229546336
        );
        let field_value = core::serde::Serde::<ByteArray>::deserialize(ref values);

        if core::option::OptionTrait::<ByteArray>::is_none(@field_value) {
            panic!("Field `TournamentModel::name`: deserialization failed.");
        }

        core::option::OptionTrait::<ByteArray>::unwrap(field_value)
    }

    fn set_name(
        self: @TournamentModelEntity, world: dojo::world::IWorldDispatcher, value: ByteArray
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1528802474226268325865027367859591458315299653151958663884057507666229546336,
                serialized.span()
            );
    }

    fn get_creator(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> ContractAddress {
        let mut values = dojo::model::ModelEntity::<
            TournamentModelEntity
        >::get_member(
            world,
            entity_id,
            507417100519034057008297464956665249334164166107291559563484601592847731467
        );
        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `TournamentModel::creator`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_creator(
        self: @TournamentModelEntity, world: dojo::world::IWorldDispatcher, value: ContractAddress
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                507417100519034057008297464956665249334164166107291559563484601592847731467,
                serialized.span()
            );
    }

    fn get_gated_token(
        world: dojo::world::IWorldDispatcher, entity_id: felt252
    ) -> Option<GatedToken> {
        let mut values = dojo::model::ModelEntity::<
            TournamentModelEntity
        >::get_member(
            world,
            entity_id,
            946621038190093806926132573647305759495551877776969264128327271781276578949
        );
        let field_value = core::serde::Serde::<Option<GatedToken>>::deserialize(ref values);

        if core::option::OptionTrait::<Option<GatedToken>>::is_none(@field_value) {
            panic!("Field `TournamentModel::gated_token`: deserialization failed.");
        }

        core::option::OptionTrait::<Option<GatedToken>>::unwrap(field_value)
    }

    fn set_gated_token(
        self: @TournamentModelEntity,
        world: dojo::world::IWorldDispatcher,
        value: Option<GatedToken>
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                946621038190093806926132573647305759495551877776969264128327271781276578949,
                serialized.span()
            );
    }

    fn get_start_time(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> u64 {
        let mut values = dojo::model::ModelEntity::<
            TournamentModelEntity
        >::get_member(
            world,
            entity_id,
            785777037704301877886393315168394225559039624990411656957207254314251612870
        );
        let field_value = core::serde::Serde::<u64>::deserialize(ref values);

        if core::option::OptionTrait::<u64>::is_none(@field_value) {
            panic!("Field `TournamentModel::start_time`: deserialization failed.");
        }

        core::option::OptionTrait::<u64>::unwrap(field_value)
    }

    fn set_start_time(
        self: @TournamentModelEntity, world: dojo::world::IWorldDispatcher, value: u64
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                785777037704301877886393315168394225559039624990411656957207254314251612870,
                serialized.span()
            );
    }

    fn get_end_time(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> u64 {
        let mut values = dojo::model::ModelEntity::<
            TournamentModelEntity
        >::get_member(
            world,
            entity_id,
            895184732002713007960483689281102000291307368318839706515352948964191528370
        );
        let field_value = core::serde::Serde::<u64>::deserialize(ref values);

        if core::option::OptionTrait::<u64>::is_none(@field_value) {
            panic!("Field `TournamentModel::end_time`: deserialization failed.");
        }

        core::option::OptionTrait::<u64>::unwrap(field_value)
    }

    fn set_end_time(
        self: @TournamentModelEntity, world: dojo::world::IWorldDispatcher, value: u64
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                895184732002713007960483689281102000291307368318839706515352948964191528370,
                serialized.span()
            );
    }

    fn get_submission_period(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> u64 {
        let mut values = dojo::model::ModelEntity::<
            TournamentModelEntity
        >::get_member(
            world,
            entity_id,
            1476232782462511468943074306850598432332250002632943341406500179037811387538
        );
        let field_value = core::serde::Serde::<u64>::deserialize(ref values);

        if core::option::OptionTrait::<u64>::is_none(@field_value) {
            panic!("Field `TournamentModel::submission_period`: deserialization failed.");
        }

        core::option::OptionTrait::<u64>::unwrap(field_value)
    }

    fn set_submission_period(
        self: @TournamentModelEntity, world: dojo::world::IWorldDispatcher, value: u64
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1476232782462511468943074306850598432332250002632943341406500179037811387538,
                serialized.span()
            );
    }

    fn get_leaderboard_size(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> u8 {
        let mut values = dojo::model::ModelEntity::<
            TournamentModelEntity
        >::get_member(
            world,
            entity_id,
            937823281162536085825944818956374019698216786171065666831383722466426249429
        );
        let field_value = core::serde::Serde::<u8>::deserialize(ref values);

        if core::option::OptionTrait::<u8>::is_none(@field_value) {
            panic!("Field `TournamentModel::leaderboard_size`: deserialization failed.");
        }

        core::option::OptionTrait::<u8>::unwrap(field_value)
    }

    fn set_leaderboard_size(
        self: @TournamentModelEntity, world: dojo::world::IWorldDispatcher, value: u8
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                937823281162536085825944818956374019698216786171065666831383722466426249429,
                serialized.span()
            );
    }

    fn get_entry_premium_token(
        world: dojo::world::IWorldDispatcher, entity_id: felt252
    ) -> Option<ContractAddress> {
        let mut values = dojo::model::ModelEntity::<
            TournamentModelEntity
        >::get_member(
            world,
            entity_id,
            141182857266598343731913385181938353047068823999760450503467915348315881520
        );
        let field_value = core::serde::Serde::<Option<ContractAddress>>::deserialize(ref values);

        if core::option::OptionTrait::<Option<ContractAddress>>::is_none(@field_value) {
            panic!("Field `TournamentModel::entry_premium_token`: deserialization failed.");
        }

        core::option::OptionTrait::<Option<ContractAddress>>::unwrap(field_value)
    }

    fn set_entry_premium_token(
        self: @TournamentModelEntity,
        world: dojo::world::IWorldDispatcher,
        value: Option<ContractAddress>
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                141182857266598343731913385181938353047068823999760450503467915348315881520,
                serialized.span()
            );
    }

    fn get_entry_premium_amount(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> u128 {
        let mut values = dojo::model::ModelEntity::<
            TournamentModelEntity
        >::get_member(
            world,
            entity_id,
            1299827507470723997411929187292623538046530657255099969485380823975940135987
        );
        let field_value = core::serde::Serde::<u128>::deserialize(ref values);

        if core::option::OptionTrait::<u128>::is_none(@field_value) {
            panic!("Field `TournamentModel::entry_premium_amount`: deserialization failed.");
        }

        core::option::OptionTrait::<u128>::unwrap(field_value)
    }

    fn set_entry_premium_amount(
        self: @TournamentModelEntity, world: dojo::world::IWorldDispatcher, value: u128
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1299827507470723997411929187292623538046530657255099969485380823975940135987,
                serialized.span()
            );
    }

    fn get_prizes(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> Array<PrizeType> {
        let mut values = dojo::model::ModelEntity::<
            TournamentModelEntity
        >::get_member(
            world,
            entity_id,
            1610767268251580031902444025044066844391489207832088337103632250465414143792
        );
        let field_value = core::serde::Serde::<Array<PrizeType>>::deserialize(ref values);

        if core::option::OptionTrait::<Array<PrizeType>>::is_none(@field_value) {
            panic!("Field `TournamentModel::prizes`: deserialization failed.");
        }

        core::option::OptionTrait::<Array<PrizeType>>::unwrap(field_value)
    }

    fn set_prizes(
        self: @TournamentModelEntity, world: dojo::world::IWorldDispatcher, value: Array<PrizeType>
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1610767268251580031902444025044066844391489207832088337103632250465414143792,
                serialized.span()
            );
    }

    fn get_stat_requirements(
        world: dojo::world::IWorldDispatcher, entity_id: felt252
    ) -> Array<StatRequirement> {
        let mut values = dojo::model::ModelEntity::<
            TournamentModelEntity
        >::get_member(
            world,
            entity_id,
            37102906947465363001973208355994435376068959373096957017239192364588303888
        );
        let field_value = core::serde::Serde::<Array<StatRequirement>>::deserialize(ref values);

        if core::option::OptionTrait::<Array<StatRequirement>>::is_none(@field_value) {
            panic!("Field `TournamentModel::stat_requirements`: deserialization failed.");
        }

        core::option::OptionTrait::<Array<StatRequirement>>::unwrap(field_value)
    }

    fn set_stat_requirements(
        self: @TournamentModelEntity,
        world: dojo::world::IWorldDispatcher,
        value: Array<StatRequirement>
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                37102906947465363001973208355994435376068959373096957017239192364588303888,
                serialized.span()
            );
    }

    fn get_claimed(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> bool {
        let mut values = dojo::model::ModelEntity::<
            TournamentModelEntity
        >::get_member(
            world,
            entity_id,
            960691908768004669093520995937048422644348614966203532732485071168380871593
        );
        let field_value = core::serde::Serde::<bool>::deserialize(ref values);

        if core::option::OptionTrait::<bool>::is_none(@field_value) {
            panic!("Field `TournamentModel::claimed`: deserialization failed.");
        }

        core::option::OptionTrait::<bool>::unwrap(field_value)
    }

    fn set_claimed(
        self: @TournamentModelEntity, world: dojo::world::IWorldDispatcher, value: bool
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                960691908768004669093520995937048422644348614966203532732485071168380871593,
                serialized.span()
            );
    }
}

#[generate_trait]
pub impl TournamentModelStoreImpl of TournamentModelStore {
    fn entity_id_from_keys(tournament_id: u64) -> felt252 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);

        core::poseidon::poseidon_hash_span(serialized.span())
    }

    fn from_values(ref keys: Span<felt252>, ref values: Span<felt252>) -> TournamentModel {
        let mut serialized = core::array::ArrayTrait::new();
        serialized.append_span(keys);
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<TournamentModel>::deserialize(ref serialized);

        if core::option::OptionTrait::<TournamentModel>::is_none(@entity) {
            panic!(
                "Model `TournamentModel`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<TournamentModel>::unwrap(entity)
    }

    fn get(world: dojo::world::IWorldDispatcher, tournament_id: u64) -> TournamentModel {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);

        dojo::model::Model::<TournamentModel>::get(world, serialized.span())
    }

    fn set(self: @TournamentModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<TournamentModel>::set_model(self, world);
    }

    fn delete(self: @TournamentModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<TournamentModel>::delete_model(self, world);
    }


    fn get_name(world: dojo::world::IWorldDispatcher, tournament_id: u64) -> ByteArray {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentModel
        >::get_member(
            world,
            serialized.span(),
            1528802474226268325865027367859591458315299653151958663884057507666229546336
        );

        let field_value = core::serde::Serde::<ByteArray>::deserialize(ref values);

        if core::option::OptionTrait::<ByteArray>::is_none(@field_value) {
            panic!("Field `TournamentModel::name`: deserialization failed.");
        }

        core::option::OptionTrait::<ByteArray>::unwrap(field_value)
    }

    fn set_name(self: @TournamentModel, world: dojo::world::IWorldDispatcher, value: ByteArray) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1528802474226268325865027367859591458315299653151958663884057507666229546336,
                serialized.span()
            );
    }

    fn get_creator(world: dojo::world::IWorldDispatcher, tournament_id: u64) -> ContractAddress {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentModel
        >::get_member(
            world,
            serialized.span(),
            507417100519034057008297464956665249334164166107291559563484601592847731467
        );

        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `TournamentModel::creator`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_creator(
        self: @TournamentModel, world: dojo::world::IWorldDispatcher, value: ContractAddress
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                507417100519034057008297464956665249334164166107291559563484601592847731467,
                serialized.span()
            );
    }

    fn get_gated_token(
        world: dojo::world::IWorldDispatcher, tournament_id: u64
    ) -> Option<GatedToken> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentModel
        >::get_member(
            world,
            serialized.span(),
            946621038190093806926132573647305759495551877776969264128327271781276578949
        );

        let field_value = core::serde::Serde::<Option<GatedToken>>::deserialize(ref values);

        if core::option::OptionTrait::<Option<GatedToken>>::is_none(@field_value) {
            panic!("Field `TournamentModel::gated_token`: deserialization failed.");
        }

        core::option::OptionTrait::<Option<GatedToken>>::unwrap(field_value)
    }

    fn set_gated_token(
        self: @TournamentModel, world: dojo::world::IWorldDispatcher, value: Option<GatedToken>
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                946621038190093806926132573647305759495551877776969264128327271781276578949,
                serialized.span()
            );
    }

    fn get_start_time(world: dojo::world::IWorldDispatcher, tournament_id: u64) -> u64 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentModel
        >::get_member(
            world,
            serialized.span(),
            785777037704301877886393315168394225559039624990411656957207254314251612870
        );

        let field_value = core::serde::Serde::<u64>::deserialize(ref values);

        if core::option::OptionTrait::<u64>::is_none(@field_value) {
            panic!("Field `TournamentModel::start_time`: deserialization failed.");
        }

        core::option::OptionTrait::<u64>::unwrap(field_value)
    }

    fn set_start_time(self: @TournamentModel, world: dojo::world::IWorldDispatcher, value: u64) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                785777037704301877886393315168394225559039624990411656957207254314251612870,
                serialized.span()
            );
    }

    fn get_end_time(world: dojo::world::IWorldDispatcher, tournament_id: u64) -> u64 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentModel
        >::get_member(
            world,
            serialized.span(),
            895184732002713007960483689281102000291307368318839706515352948964191528370
        );

        let field_value = core::serde::Serde::<u64>::deserialize(ref values);

        if core::option::OptionTrait::<u64>::is_none(@field_value) {
            panic!("Field `TournamentModel::end_time`: deserialization failed.");
        }

        core::option::OptionTrait::<u64>::unwrap(field_value)
    }

    fn set_end_time(self: @TournamentModel, world: dojo::world::IWorldDispatcher, value: u64) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                895184732002713007960483689281102000291307368318839706515352948964191528370,
                serialized.span()
            );
    }

    fn get_submission_period(world: dojo::world::IWorldDispatcher, tournament_id: u64) -> u64 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentModel
        >::get_member(
            world,
            serialized.span(),
            1476232782462511468943074306850598432332250002632943341406500179037811387538
        );

        let field_value = core::serde::Serde::<u64>::deserialize(ref values);

        if core::option::OptionTrait::<u64>::is_none(@field_value) {
            panic!("Field `TournamentModel::submission_period`: deserialization failed.");
        }

        core::option::OptionTrait::<u64>::unwrap(field_value)
    }

    fn set_submission_period(
        self: @TournamentModel, world: dojo::world::IWorldDispatcher, value: u64
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1476232782462511468943074306850598432332250002632943341406500179037811387538,
                serialized.span()
            );
    }

    fn get_leaderboard_size(world: dojo::world::IWorldDispatcher, tournament_id: u64) -> u8 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentModel
        >::get_member(
            world,
            serialized.span(),
            937823281162536085825944818956374019698216786171065666831383722466426249429
        );

        let field_value = core::serde::Serde::<u8>::deserialize(ref values);

        if core::option::OptionTrait::<u8>::is_none(@field_value) {
            panic!("Field `TournamentModel::leaderboard_size`: deserialization failed.");
        }

        core::option::OptionTrait::<u8>::unwrap(field_value)
    }

    fn set_leaderboard_size(
        self: @TournamentModel, world: dojo::world::IWorldDispatcher, value: u8
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                937823281162536085825944818956374019698216786171065666831383722466426249429,
                serialized.span()
            );
    }

    fn get_entry_premium_token(
        world: dojo::world::IWorldDispatcher, tournament_id: u64
    ) -> Option<ContractAddress> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentModel
        >::get_member(
            world,
            serialized.span(),
            141182857266598343731913385181938353047068823999760450503467915348315881520
        );

        let field_value = core::serde::Serde::<Option<ContractAddress>>::deserialize(ref values);

        if core::option::OptionTrait::<Option<ContractAddress>>::is_none(@field_value) {
            panic!("Field `TournamentModel::entry_premium_token`: deserialization failed.");
        }

        core::option::OptionTrait::<Option<ContractAddress>>::unwrap(field_value)
    }

    fn set_entry_premium_token(
        self: @TournamentModel, world: dojo::world::IWorldDispatcher, value: Option<ContractAddress>
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                141182857266598343731913385181938353047068823999760450503467915348315881520,
                serialized.span()
            );
    }

    fn get_entry_premium_amount(world: dojo::world::IWorldDispatcher, tournament_id: u64) -> u128 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentModel
        >::get_member(
            world,
            serialized.span(),
            1299827507470723997411929187292623538046530657255099969485380823975940135987
        );

        let field_value = core::serde::Serde::<u128>::deserialize(ref values);

        if core::option::OptionTrait::<u128>::is_none(@field_value) {
            panic!("Field `TournamentModel::entry_premium_amount`: deserialization failed.");
        }

        core::option::OptionTrait::<u128>::unwrap(field_value)
    }

    fn set_entry_premium_amount(
        self: @TournamentModel, world: dojo::world::IWorldDispatcher, value: u128
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1299827507470723997411929187292623538046530657255099969485380823975940135987,
                serialized.span()
            );
    }

    fn get_prizes(world: dojo::world::IWorldDispatcher, tournament_id: u64) -> Array<PrizeType> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentModel
        >::get_member(
            world,
            serialized.span(),
            1610767268251580031902444025044066844391489207832088337103632250465414143792
        );

        let field_value = core::serde::Serde::<Array<PrizeType>>::deserialize(ref values);

        if core::option::OptionTrait::<Array<PrizeType>>::is_none(@field_value) {
            panic!("Field `TournamentModel::prizes`: deserialization failed.");
        }

        core::option::OptionTrait::<Array<PrizeType>>::unwrap(field_value)
    }

    fn set_prizes(
        self: @TournamentModel, world: dojo::world::IWorldDispatcher, value: Array<PrizeType>
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1610767268251580031902444025044066844391489207832088337103632250465414143792,
                serialized.span()
            );
    }

    fn get_stat_requirements(
        world: dojo::world::IWorldDispatcher, tournament_id: u64
    ) -> Array<StatRequirement> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentModel
        >::get_member(
            world,
            serialized.span(),
            37102906947465363001973208355994435376068959373096957017239192364588303888
        );

        let field_value = core::serde::Serde::<Array<StatRequirement>>::deserialize(ref values);

        if core::option::OptionTrait::<Array<StatRequirement>>::is_none(@field_value) {
            panic!("Field `TournamentModel::stat_requirements`: deserialization failed.");
        }

        core::option::OptionTrait::<Array<StatRequirement>>::unwrap(field_value)
    }

    fn set_stat_requirements(
        self: @TournamentModel, world: dojo::world::IWorldDispatcher, value: Array<StatRequirement>
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                37102906947465363001973208355994435376068959373096957017239192364588303888,
                serialized.span()
            );
    }

    fn get_claimed(world: dojo::world::IWorldDispatcher, tournament_id: u64) -> bool {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@tournament_id, ref serialized);

        let mut values = dojo::model::Model::<
            TournamentModel
        >::get_member(
            world,
            serialized.span(),
            960691908768004669093520995937048422644348614966203532732485071168380871593
        );

        let field_value = core::serde::Serde::<bool>::deserialize(ref values);

        if core::option::OptionTrait::<bool>::is_none(@field_value) {
            panic!("Field `TournamentModel::claimed`: deserialization failed.");
        }

        core::option::OptionTrait::<bool>::unwrap(field_value)
    }

    fn set_claimed(self: @TournamentModel, world: dojo::world::IWorldDispatcher, value: bool) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                960691908768004669093520995937048422644348614966203532732485071168380871593,
                serialized.span()
            );
    }
}

pub impl TournamentModelModelEntityImpl of dojo::model::ModelEntity<TournamentModelEntity> {
    fn id(self: @TournamentModelEntity) -> felt252 {
        *self.__id
    }

    fn values(self: @TournamentModelEntity) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.name, ref serialized);
        core::serde::Serde::serialize(self.creator, ref serialized);
        core::serde::Serde::serialize(self.gated_token, ref serialized);
        core::serde::Serde::serialize(self.start_time, ref serialized);
        core::serde::Serde::serialize(self.end_time, ref serialized);
        core::serde::Serde::serialize(self.submission_period, ref serialized);
        core::serde::Serde::serialize(self.leaderboard_size, ref serialized);
        core::serde::Serde::serialize(self.entry_premium_token, ref serialized);
        core::serde::Serde::serialize(self.entry_premium_amount, ref serialized);
        core::serde::Serde::serialize(self.prizes, ref serialized);
        core::serde::Serde::serialize(self.stat_requirements, ref serialized);
        core::serde::Serde::serialize(self.claimed, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    fn from_values(entity_id: felt252, ref values: Span<felt252>) -> TournamentModelEntity {
        let mut serialized = array![entity_id];
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity_values = core::serde::Serde::<
            TournamentModelEntity
        >::deserialize(ref serialized);
        if core::option::OptionTrait::<TournamentModelEntity>::is_none(@entity_values) {
            panic!("ModelEntity `TournamentModelEntity`: deserialization failed.");
        }
        core::option::OptionTrait::<TournamentModelEntity>::unwrap(entity_values)
    }

    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> TournamentModelEntity {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            dojo::model::Model::<TournamentModel>::selector(),
            dojo::model::ModelIndex::Id(entity_id),
            dojo::model::Model::<TournamentModel>::layout()
        );
        Self::from_values(entity_id, ref values)
    }

    fn update_entity(self: @TournamentModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            dojo::model::Model::<TournamentModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<TournamentModel>::layout()
        );
    }

    fn delete_entity(self: @TournamentModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world,
            dojo::model::Model::<TournamentModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<TournamentModel>::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, entity_id: felt252, member_id: felt252,
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<TournamentModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    dojo::model::Model::<TournamentModel>::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @TournamentModelEntity,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>,
    ) {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<TournamentModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    dojo::model::Model::<TournamentModel>::selector(),
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
pub impl TournamentModelModelEntityTestImpl of dojo::model::ModelEntityTest<TournamentModelEntity> {
    fn update_test(self: @TournamentModelEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<TournamentModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<TournamentModel>::layout()
        );
    }

    fn delete_test(self: @TournamentModelEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<TournamentModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<TournamentModel>::layout()
        );
    }
}

pub impl TournamentModelModelImpl of dojo::model::Model<TournamentModel> {
    fn get(world: dojo::world::IWorldDispatcher, keys: Span<felt252>) -> TournamentModel {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(keys), Self::layout()
        );
        let mut _keys = keys;

        TournamentModelStore::from_values(ref _keys, ref values)
    }

    fn set_model(self: @TournamentModel, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            Self::selector(),
            dojo::model::ModelIndex::Keys(Self::keys(self)),
            Self::values(self),
            Self::layout()
        );
    }

    fn delete_model(self: @TournamentModel, world: dojo::world::IWorldDispatcher) {
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
        self: @TournamentModel,
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
        "TournamentModel"
    }

    #[inline(always)]
    fn namespace() -> ByteArray {
        "tournament"
    }

    #[inline(always)]
    fn tag() -> ByteArray {
        "tournament-TournamentModel"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        1954606086950386751252458304451745078955960311759396780792780757442087011588
    }

    #[inline(always)]
    fn instance_selector(self: @TournamentModel) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn name_hash() -> felt252 {
        935524272983398336761596424682011774472756147174361771321868996956555446282
    }

    #[inline(always)]
    fn namespace_hash() -> felt252 {
        3513465382457774401660929656863894979351645367198604050918895380273858322651
    }

    #[inline(always)]
    fn entity_id(self: @TournamentModel) -> felt252 {
        core::poseidon::poseidon_hash_span(self.keys())
    }

    #[inline(always)]
    fn keys(self: @TournamentModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.tournament_id, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @TournamentModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.name, ref serialized);
        core::serde::Serde::serialize(self.creator, ref serialized);
        core::serde::Serde::serialize(self.gated_token, ref serialized);
        core::serde::Serde::serialize(self.start_time, ref serialized);
        core::serde::Serde::serialize(self.end_time, ref serialized);
        core::serde::Serde::serialize(self.submission_period, ref serialized);
        core::serde::Serde::serialize(self.leaderboard_size, ref serialized);
        core::serde::Serde::serialize(self.entry_premium_token, ref serialized);
        core::serde::Serde::serialize(self.entry_premium_amount, ref serialized);
        core::serde::Serde::serialize(self.prizes, ref serialized);
        core::serde::Serde::serialize(self.stat_requirements, ref serialized);
        core::serde::Serde::serialize(self.claimed, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::model::Layout {
        dojo::model::introspect::Introspect::<TournamentModel>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @TournamentModel) -> dojo::model::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        dojo::model::layout::compute_packed_size(Self::layout())
    }
}

#[cfg(target: "test")]
pub impl TournamentModelModelTestImpl of dojo::model::ModelTest<TournamentModel> {
    fn set_test(self: @TournamentModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<TournamentModel>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<TournamentModel>::keys(self)),
            dojo::model::Model::<TournamentModel>::values(self),
            dojo::model::Model::<TournamentModel>::layout()
        );
    }

    fn delete_test(self: @TournamentModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<TournamentModel>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<TournamentModel>::keys(self)),
            dojo::model::Model::<TournamentModel>::layout()
        );
    }
}

#[starknet::interface]
pub trait Itournament_model<T> {
    fn ensure_abi(self: @T, model: TournamentModel);
}

#[starknet::contract]
pub mod tournament_model {
    use super::TournamentModel;
    use super::Itournament_model;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            "TournamentModel"
        }

        fn namespace(self: @ContractState) -> ByteArray {
            "tournament"
        }

        fn tag(self: @ContractState) -> ByteArray {
            "tournament-TournamentModel"
        }

        fn version(self: @ContractState) -> u8 {
            1
        }

        fn selector(self: @ContractState) -> felt252 {
            1954606086950386751252458304451745078955960311759396780792780757442087011588
        }

        fn name_hash(self: @ContractState) -> felt252 {
            935524272983398336761596424682011774472756147174361771321868996956555446282
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            3513465382457774401660929656863894979351645367198604050918895380273858322651
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::model::introspect::Introspect::<TournamentModel>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<TournamentModel>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::model::Layout {
            dojo::model::Model::<TournamentModel>::layout()
        }

        fn schema(self: @ContractState) -> dojo::model::introspect::Ty {
            dojo::model::introspect::Introspect::<TournamentModel>::ty()
        }
    }

    #[abi(embed_v0)]
    impl tournament_modelImpl of Itournament_model<ContractState> {
        fn ensure_abi(self: @ContractState, model: TournamentModel) {}
    }
}
