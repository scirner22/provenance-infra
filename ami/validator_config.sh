#!/bin/bash
set -e

sed -i 's/priv_validator_laddr\ =\ "TMKMS_IP:26669"/priv_validator_laddr\ =\ ""/' /home/ubuntu/config/config.toml

echo "Validator config completed!"
