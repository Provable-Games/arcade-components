#!/bin/bash

# Define an array of addresses
models=(
    "ClientDeveloperModel"
    "ClientPlayTotalModel"
    "ClientPlayPlayerModel"
    "ClientRatingTotalModel"
    "ClientRatingPlayerModel",
    "ClientRegistrationModel",
    "ClientTotalModel",
    "ERC721TokenApprovalModel",
    "ERC721BalanceModel",
    "ERC721EnumerableTotalModel",
    "ERC721MetaModel",
    "ERC721OwnerModel"
)

# Loop through the array
for addr in "${models[@]}"
do
   sozo auth grant writer $model,0x438rh234hrf23r4
done