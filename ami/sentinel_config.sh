#!/bin/bash
set -e

PIO_CONFIG_HOME=/home/ubuntu/config

echo "Downloading configuration..."
wget "https://raw.githubusercontent.com/provenance-io/testnet/main/$CHAIN_ID/config.toml" -P $PIO_CONFIG_HOME
wget "https://raw.githubusercontent.com/provenance-io/testnet/main/$CHAIN_ID/genesis.json" -P $PIO_CONFIG_HOME

echo "Config setup completed!"
