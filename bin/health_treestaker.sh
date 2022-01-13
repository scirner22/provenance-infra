#!/bin/bash
set -e

curl node1.treestaker.com:26657/abci_info | jq .result.response.last_block_height
curl node2.treestaker.com:26657/abci_info | jq .result.response.last_block_height
curl node3.treestaker.com:26657/abci_info | jq .result.response.last_block_height
