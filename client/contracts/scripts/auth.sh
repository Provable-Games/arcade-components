#!/bin/bash

# Define an array of addresses
models=(
    "ClientCreatorModel"
    "ClientPlayTotalModel"
    "ClientPlayPlayerModel"
    "ClientRatingTotalModel"
    "ClientRatingPlayerModel"
    "ClientRegistrationModel"
    "ClientTotalModel"
    "ERC721OperatorApprovalModel"
    "ERC721TokenApprovalModel"
    "ERC721BalanceModel"
    "ERC721EnumerableIndexModel"
    "ERC721EnumerableOwnerIndexModel"
    "ERC721EnumerableOwnerTokenModel"
    "ERC721EnumerableOwnerTotalModel"
    "ERC721EnumerableTokenModel"
    "ERC721EnumerableTotalModel"
    "ERC721MetaModel"
    "ERC721OwnerModel"
)

# Loop through the array
for model in "${models[@]}"
do
   sozo auth grant writer $model,0x5c952db4dad7fc878f65787c2caf6aaa34340c26f5f5b73effe7876092402d
done