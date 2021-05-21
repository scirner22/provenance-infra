#!/bin/bash
set -e

GO_VERSION=go1.15.6.linux-amd64
GOPATH=/usr/local/go
GO_BIN=${GOPATH}/bin

PBC_VERSION=$GENESIS_VERSION
DAEMON_HOME=/home/ubuntu/cosmovisor
PIO_CONFIG_HOME=/home/ubuntu/config
PIO_DATA_HOME=/home/ubuntu/data
PBC_GENESIS_PATH=${DAEMON_HOME}/genesis

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
cd /usr/local/lib
sudo ln -s libleveldb.so.1.20 libleveldb.so.1d
sudo ldconfig
cd /home/ubuntu

# TODO https://github.com/provenance-io/cosmovisor
echo "Fetching and installing provenance cosmovisor..."
$GO_BIN/go get github.com/provenance-io/cosmovisor/cmd/cosmovisor

mkdir -p ${PBC_GENESIS_PATH}
mkdir -p ${DAEMON_HOME}/upgrades
mkdir -p ${PIO_CONFIG_HOME}
mkdir -p ${PIO_DATA_HOME}

echo "Downloading and installing provenance..."
wget "https://github.com/provenance-io/provenance/releases/download/$PBC_VERSION/provenance-linux-amd64-$PBC_VERSION.zip" -P /tmp
sudo unzip "/tmp/provenance-linux-amd64-$PBC_VERSION.zip" -d ${PBC_GENESIS_PATH}
sudo ln -s ${PBC_GENESIS_PATH} ${DAEMON_HOME}/current
sudo chown -R ubuntu:ubuntu $DAEMON_HOME

echo "Installation completed!"
