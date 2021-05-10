# Amazon Machine Images

#### Builds a sentinel AMI

```bash
CHAIN_ID=pio-testnet-1 packer build sentinel.json
```

#### Builds a validator AMI

```bash
CHAIN_ID=pio-testnet-1 packer build validator.json
```

#### Builds a tmkms AMI

```bash
CHAIN_ID=pio-testnet-1 packer build tmkms.json
```
