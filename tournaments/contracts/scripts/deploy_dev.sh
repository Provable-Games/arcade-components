#-----------------
# build
#
echo "------------------------------------------------------------------------------"
echo "Cleaning..."
sozo clean
echo "Building..."
sozo build

#-----------------
# migrate
#
echo ">>> Migrate"
sozo migrate
echo "👍"

#-----------------
# get deployed addresses
#

export MANIFEST_FILE_PATH="./manifest_dev.json"

get_contract_address () {
  local TAG=$1
  local RESULT=$(cat $MANIFEST_FILE_PATH | jq -r ".contracts[] | select(.tag == \"$TAG\" ).address")
  if [[ -z "$RESULT" ]]; then
    >&2 echo "get_contract_address($TAG) not found! 👎"
  fi
  echo $RESULT
}

export ETH_ADDRESS=$(get_contract_address "tournament-eth_mock")
export LORDS_ADDRESS=$(get_contract_address "tournament-lords_mock")
export LOOT_SURVIVOR_ADDRESS=$(get_contract_address "tournament-loot_survivor_mock")
export ORACLE_ADDRESS=$(get_contract_address "tournament-pragma_mock")

#-----------------
# initialize tournament
#
echo ">>> Initialize tournament"
echo "ETH_ADDRESS: $ETH_ADDRESS"
echo "LORDS_ADDRESS: $LORDS_ADDRESS"
echo "LOOT_SURVIVOR_ADDRESS: $LOOT_SURVIVOR_ADDRESS"
echo "ORACLE_ADDRESS: $ORACLE_ADDRESS"

echo "Waiting 10 seconds before execution..."
sleep 10

sozo execute tournament_mock initializer --calldata $ETH_ADDRESS,$LORDS_ADDRESS,$LOOT_SURVIVOR_ADDRESS,$ORACLE_ADDRESS

#------------------
echo "--- DONE! 👍"