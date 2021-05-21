#!/bin/bash

set -e

TRAP_FUNC ()
{
  nitro-cli terminate-enclave --enclave-id $(nitro-cli describe-enclaves | jq -r .[0].EnclaveID) || echo "no existing enclave"
  sudo kill -TERM $(pidof vsock-proxy)
  exit 1
}

nitro-cli run-enclave --cpu-count 2 --memory 8192 --debug-mode --eif-path tmkms.eif || TRAP_FUNC

vsock-proxy 8000 kms.us-east-1.amazonaws.com 443 &
echo "[kms vsock-proxy] Running in background ..."
vsock-proxy --config validator_vsock_proxy.yaml 5000 VALIDATOR_ADDR 26669 &
echo "[validator vsock-proxy] Running in background ..."

trap TRAP_FUNC TERM INT SIGKILL

sleep 1

# nitro-cli console --enclave-id $(nitro-cli describe-enclaves | jq -r .[0].EnclaveID) || echo "no existing enclave"
tmkms-nitro-helper start -c tmkms.toml --cid $(nitro-cli describe-enclaves | jq -r .[0].EnclaveCID)
