#!/bin/bash
set -e

GO_VERSION=go1.15.6.linux-amd64
GOPATH=/usr/local/go
GO_BIN=${GOPATH}/bin

PBC_VERSION=v0.2.0
CHAIN_ID=pio-testnet-1
DAEMON_HOME=/home/ubuntu/cosmovisor
PIO_CONFIG_HOME=/home/ubuntu/config
PIO_DATA_HOME=/home/ubuntu/data
PBC_VERSIONED_PATH=${DAEMON_HOME}/upgrades/${PBC_VERSION}

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y build-essential libsnappy-dev
sudo apt-get install -y supervisor
sudo apt-get install -y zip unzip

# stop supervisor since we're just creating an ami
sudo service supervisor stop
sudo mv /tmp/cosmovisor_provenanced.conf /etc/supervisor/conf.d/

echo "Downloading and installing go lang..."
wget "https://golang.org/dl/$GO_VERSION.tar.gz" -P /tmp
sudo tar -C /usr/local -xzf "/tmp/$GO_VERSION.tar.gz"

echo "Installing leveldb..."
wget "https://github.com/google/leveldb/archive/v1.20.tar.gz" -P /tmp
tar xvf /tmp/v1.20.tar.gz -C /tmp
cd /tmp/leveldb-1.20
make && sudo scp -r out-static/lib* out-shared/lib* "/usr/local/lib"
cd include && sudo scp -r leveldb /usr/local/include
sudo ldconfig
cd /home/ubuntu

# TODO https://github.com/provenance-io/cosmovisor
echo "Fetching and installing cosmovisor..."
$GO_BIN/go get github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor

mkdir -p ${PBC_VERSIONED_PATH}
mkdir -p ${PIO_CONFIG_HOME}
mkdir -p ${PIO_DATA_HOME}

echo "Downloading and installing provenance blockchain..."
wget "https://github.com/provenance-io/provenance/releases/download/$PBC_VERSION/provenance-linux-amd64-$PBC_VERSION.zip" -P /tmp
sudo unzip "/tmp/provenance-linux-amd64-$PBC_VERSION.zip" -d ${PBC_VERSIONED_PATH}
sudo ln -s ${PBC_VERSIONED_PATH} ${DAEMON_HOME}/current
sudo chown -R ubuntu:ubuntu $DAEMON_HOME

echo "Downloading configuration..."
# TODO can we download all config and stage somewhere? Let ec2 user data copy the correct config based on if it will
# be used as a sentinel or app node?
wget "https://raw.githubusercontent.com/provenance-io/testnet/main/$CHAIN_ID/config.toml" -P $PIO_CONFIG_HOME
wget "https://raw.githubusercontent.com/provenance-io/testnet/main/$CHAIN_ID/genesis.json" -P $PIO_CONFIG_HOME

echo "Installation completed!"

# TODO rotate var logs

## TODO
# PIO_HOME=/opt/dist/provenanance-blockchain provenanced init treestaker-test-1 --chain-id provenance-io-test
# PIO_HOME=/opt/dist/provenanance-blockchain provenanced start

# gaiad tx staking create-validator \
#   --amount=1000000uhash \
#   --pubkey=$(PIO_HOME=/home/ubuntu/provenanance-blockchain /usr/local/go/bin/provenanced tendermint show-validator) \
#   --moniker="treestaker-testnet" \
#   --chain-id=provenance-io-test \
#   --commission-rate="0.50" \
#   --commission-max-rate="0.90" \
#   --commission-max-change-rate="0.05" \
#   --min-self-delegation="1" \
#   --fees="5000vspn" \
#   --details="Tree staker test validator" \
#   --security-contact="scirner@figure.com"\
#   --broadcast-mode="block" \
#   --from=key1 \
#   --yes
