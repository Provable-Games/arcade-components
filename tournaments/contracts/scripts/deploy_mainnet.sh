export STARKNET_RPC_URL=""
export DOJO_ACCOUNT_ADDRESS=""
export DOJO_PRIVATE_KEY=""

#-----------------
# build
echo "------------------------------------------------------------------------------"
echo "Cleaning..."
sozo -P prod clean
echo "Building..."
# sozo -P $PROFILE build --typescript
sozo -P prod build

#-----------------
# migrate
#
echo "------------------------------------------------------------------------------"
echo ">>> Migrate plan..."
sozo -P prod migrate plan
# exit 0
echo ">>> Migrate apply..."
sozo -P prod migrate
echo "👍"

#------------------
echo "--- DONE! 👍"