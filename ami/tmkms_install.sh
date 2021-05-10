#!/bin/bash
set -e

RUSTFLAGS=-Ctarget-feature=+aes,+ssse3
CARGO_PATH=/home/ubuntu/.cargo
CARGO_BIN=${CARGO_PATH}/bin

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y build-essential
sudo apt-get install -y pkg-config
sudo apt-get install -y jq
sudo apt-get install -y supervisor

# stop supervisor since we're just creating an ami
sudo service supervisor stop
sudo mv /tmp/tmkms.conf /etc/supervisor/conf.d/

echo "Downloading and installing rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

echo "Installing tmkms..."
RUSTFLAGS=$RUSTFLAGS $CARGO_BIN/cargo install tmkms --features=softsign
$CARGO_BIN/tmkms init .

sudo mv /tmp/tmkms.toml /home/ubuntu/tmkms.toml
sudo chown ubuntu:ubuntu /home/ubuntu/tmkms.toml
sed -i "s/CHAIN_ID/$CHAIN_ID/" /home/ubuntu/tmkms.toml
# TODO add prefix

echo "Installation completed!"
