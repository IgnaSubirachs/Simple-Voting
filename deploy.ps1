# Build the contract
Write-Host "Building contract..."
sc-meta all build

# Deploy the contract
Write-Host "Deploying contract..."
$deployOutput = mxpy contract deploy `
    --bytecode "output/simple-voting.wasm" `
    --pem "devnet.pem" `
    --gas-limit 60000000 `
    --proxy "https://devnet-gateway.multiversx.com" `
    --chain "D" `
    --arguments 10000000000000000 "str:Yes" "str:No" `
    --send `
    --outfile "deploy-test.interaction.json"

Write-Host "Deployment command finished."
Get-Content "deploy-test.interaction.json"
