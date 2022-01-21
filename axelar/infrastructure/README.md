# one-off-chain-infra
Repo that maintains all the AWS infrastructure files for different blockchains such as:

1) Axelar Mainnet/Testnet

### Terraform Axelar
In order to run the terraform contained in this repo it is required that you have access to the axelar-testnet and axelar-mainnet projects. A member of the DevOps team can create an account for you and get you programmatic access.

When you recieve your AWS credentials you will need to create profiles specific to these accounts

`vi ~/.aws/credentials`
Add in your creds following the example below:

[axelar-testnet]
aws_access_key_id = 
aws_secret_access_key = 
[axelar-mainnet]
aws_access_key_id = 
aws_secret_access_key = 

After having this in place you can now leverage the terraform file to manage state

### Terraform Workspaces

In order to access the axelar state you will need to use specific workspaces. These have been named after the aws account/profiles to make it simple for configuration

In order to create the necessarry workspaces run the following:

`terraform init`

`terraform workspace new axelar-testnet`

`terraform workspace new axelar-mainnet`


### Managing Axelar Nodes
Resources on installing axelar
https://github.com/axelarnetwork/validators
https://github.com/axelarnetwork/axelarate-community


###Common Commands to know####
To follow tofnd execution, run 'tail -f /home/axelard/.axelar_testnet/logs/tofnd.log'
To follow vald execution, run 'tail -f /home/axelard/.axelar_testnet/logs/vald.log'
To follow axelard logs, run 'tail -f /home/axelard/.axelar_testnet/logs/axelard.log'

To Kill running axelar processes
## Stop the axelar core validator (Part of the node.sh)
kill -9 $(pgrep -f "axelard start")

## Stop the axelar tofnd and vald process (Part of validator-tools.sh)
kill -9 $(pgrep tofnd)
kill -9 $(pgrep -f "axelard vald-start")

### Updating repo

## Testnet
`cd /home/ubuntu/git/axelarate-community`

`git pull`

## Mainnet, Requires Permission, username and token
`cd /home/ubuntu/git/validators`

`git pull`

### Commands to create validator nodes, tofnd and vald process

Below are the necessary commands to run the axelar validator nodes. Before running either of these scripts you must export your KEYRING_PASSWORD,
TOFND_PASSWORD, and set ulimit. Due to quickly putting these things together they are run as seperate users. For test, it is the axelard user, and mainnet it is root

These passwords can be found in KEYBASE and Bitwarden

node.sh script is specifically targeted to turn on the validator node and begin syncing/minting blocks

validator-tools-host.sh is specifically targeted to create the sub processes of broadcaster, but the core chain must be running first

additionally ensure that in `config.toml` that external_address is set to the public ip address of your validator node ie 1.1.1.1:26656

MAINNET CAUTION
Our mainnet axelar validator does not have its consensus key configured locally, we are currently using tmkms to ensure that the consensus key is secure.
If issues arise where the core process will not start with a message such as:

Error: error with private validator socket client: can't get pubkey: send: endpoint connection timed out

You may need to connect to the tmkms node and run the following command:

`systemctl restart tmkms`

Then try running the script again

## Testnet

`sudo su axelard`

`export KEYRING_PASSWORD=''`

`export TOFND_PASSWORD=''`

`ulimit -n 16384`

`/home/ubuntu/git/axelarate-community/scripts/node.sh -e host -a v0.13.2`

`/home/ubuntu/git/axelarate-community/scripts/validator-tools-host.sh -a v0.13.2`

Home Directory location

`home/axelard/.axelar_testnet`

## Mainnet

`sudo su`

`export KEYRING_PASSWORD=''`

`export TOFND_PASSWORD=''`

`ulimit -n 16384`

`/home/ubuntu/git/validators/scripts/node.sh -a v0.13.2 -n mainnet -d /axelar/ -e host`

`/home/ubuntu/git/validators/scripts/validator-tools-host.sh -a v0.13.2 -q v0.8.2 -d /axelar -n mainnet`

Home Directory location

`/axelard`

###MAINNET INFO#######

chain-id axelar-dojo-1

broadcaster address
axelar1f43gyh9fm98sffyzycs0f7ju0dcjpz8k0s53f6


validator address
axelar1w2pkh5p8a7kznxz97tpdmur48hagavmgjqr8xh

validator publickey
pubkey: '{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"eK5GZc45bJCT+ksy8vuHcnxNQOATsiewyc/ZfmEELq0="}'

axelarvalcons13xtsg62auggv08pyh6u89x77su6qnw2y2l5346

###TESTNET INFO#######

chain-id axelar-testnet-lisbon-2

broadcaster address
axelar1ayuaepfnrr7dtva835aymk0xnktr3d6ym7fr9z


validator address
axelar12q73kg80r97uszywep2gu47lczu7uucxt97euw

validator publickey
pubkey: '{"@type":"/cosmos.crypto.ed25519.PubKey","key":"aKxE7q5VcyZsgOUkAr+E4KDJAn90gDbrq4mGSBzSvDw="}'

axelarvalcons1ar0u772ws6688yf4sd25kklrzvjq389k4n4ehx

### Commands Used to create Mainnet Validator and Register Chains
`/axelar/bin/axelard tx snapshot --home /axelar/.core register-proxy axelar1f43gyh9fm98sffyzycs0f7ju0dcjpz8k0s53f6 --from validator --chain-id axelar-dojo-1`

```
/axelar/bin/axelard tx staking create-validator  \
    --home /axelar/.core  \
    --yes  \
    --amount 1000000uaxl  \
    --moniker "Provenance"  \
    --website "https://provenance.io"  \
    --commission-rate="0.10"  \
    --commission-max-rate="0.20"  \
    --commission-max-change-rate="0.01"  \
    --min-self-delegation="1"  \
    --pubkey='{"@type":"/cosmos.crypto.ed25519.PubKey","key":"eK5GZc45bJCT+ksy8vuHcnxNQOATsiewyc/ZfmEELq0="}'   \
    --chain-id axelar-dojo-1  \
    --identity 1312373CCEF401EB \
    --from validator  \
    -b block
```

If you need to edit the validator you can use commands similar to the following
```
/axelar/bin/axelard tx staking edit-validator  \
    --home /axelar/.core  \
    --identity 1312373CCEF401EB \
    --chain-id axelar-dojo-1  \
    --from validator  
```

Registering Chains

First you need to edit the config.toml file under /home/ubuntu/git/validators/configuration

```
[[axelar_bridge_evm]]
name = "Ethereum"
rpc_addr = "http://10.0.11.8:8545"
start-with-bridge = true

[[axelar_bridge_evm]]
name = "Avalanche"
rpc_addr = ""
start-with-bridge = false

[[axelar_bridge_evm]]
name = "Fantom"
rpc_addr = ""
start-with-bridge = false

[[axelar_bridge_evm]]
name = "Moonbeam"
rpc_addr = "http://10.0.1.30:9933"
start-with-bridge = true

```


```
/axelar/bin/axelard tx nexus register-chain-maintainer ethereum --from broadcaster --node http://localhost:26657 --home /axelar/.vald/ --chain-id axelar-dojo-1

/axelar/bin/axelard tx nexus register-chain-maintainer moonbeam --from broadcaster --node http://localhost:26657 --home /axelar/.vald/ --chain-id axelar-dojo-1

```

### Commands Used to create Testnet Validator and Register Chains

Register the broadcaster address

```
/axelar/bin/axelard tx snapshot --home /axelar/.core register-proxy axelar1ayuaepfnrr7dtva835aymk0xnktr3d6ym7fr9z --from validator --chain-id axelar-dojo-1
```


```
/home/axelard/.axelar_testnet/bin/axelard tx staking create-validator  \
    --home /home/axelard/.axelar_testnet/.core  \
    --yes  \
    --amount 1000000uaxl  \
    --moniker "provenance-io"  \
    --website "https://provenance.io"  \
    --commission-rate="0.10"  \
    --commission-max-rate="0.20"  \
    --commission-max-change-rate="0.01"  \
    --min-self-delegation="1"  \
    --pubkey='{"@type":"/cosmos.crypto.ed25519.PubKey","key":"aKxE7q5VcyZsgOUkAr+E4KDJAn90gDbrq4mGSBzSvDw="}'   \
    --chain-id axelar-testnet-lisbon-2  \
    --from validator  \
    -b block
```

###Registering External Chains
First you need to edit the config.toml file under /home/ubuntu/git/axelarate-community/configuration

```
[[axelar_bridge_evm]]
name = "Ethereum"
rpc_addr = "http://10.0.11.31:8545"
start-with-bridge = true

[[axelar_bridge_evm]]
name = "Avalanche"
rpc_addr = ""
start-with-bridge = false

[[axelar_bridge_evm]]
name = "Fantom"
rpc_addr = "http://10.0.0.30:18545"
start-with-bridge = true

[[axelar_bridge_evm]]
name = "Moonbeam"
rpc_addr = "http://10.0.1.30:9933"
start-with-bridge = true

```
Commands to register external chains

```
/home/axelard/.axelar_testnet/bin/axelard tx nexus register-chain-maintainer ethereum --from broadcaster --node http://localhost:26657 --home /home/axelard/.axelar_testnet/.vald/ --chain-id axelar-testnet-lisbon-2

/home/axelard/.axelar_testnet/bin/axelard tx nexus register-chain-maintainer fantom --from broadcaster --node http://localhost:26657 --home /home/axelard/.axelar_testnet/.vald/ --chain-id axelar-testnet-lisbon-2

/home/axelard/.axelar_testnet/bin/axelard tx nexus register-chain-maintainer moonbeam --from broadcaster --node http://localhost:26657 --home /home/axelard/.axelar_testnet/.vald/ --chain-id axelar-testnet-lisbon-2

/home/axelard/.axelar_testnet/bin/axelard tx nexus register-chain-maintainer avalanche --from broadcaster --node http://localhost:26657 --home /home/axelard/.axelar_testnet/.vald/ --chain-id axelar-testnet-lisbon-2
```


### Managing Fantom Nodes


### Managing Avalanche Nodes


### Managing Moonbeam Nodes


### Managing Ethereum Nodes
