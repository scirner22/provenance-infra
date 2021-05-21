# Amazon Machine Images

#### Builds a testnet sentinel AMI

```bash
CHAIN_ID=pio-testnet-1 NETWORK=testnet GENESIS_VERSION=v0.2.0 packer build sentinel.json
```

#### Builds a mainnet sentinel AMI

```bash
CHAIN_ID=pio-mainnet-1 NETWORK=mainnet GENESIS_VERSION=v1.0.1 packer build sentinel.json
```

#### Builds a validator AMI

```bash
CHAIN_ID=pio-testnet-1 packer build validator.json
```

#### Builds a tmkms AMI

```bash
CHAIN_ID=pio-testnet-1 PREFIX=tp AWS_REGION=us-east-1 KMS_KEY_ID=<key id> packer build packer.json
```
