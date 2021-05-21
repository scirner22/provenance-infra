#!/bin/sh
set -e

echo "Building enclave..."
nitro-cli build-enclave --docker-uri cryptocom/nitro-enclave-tmkms:latest --output-file /home/ec2-user/tmkms.eif > /home/ec2-user/enclave.output
printf "PCR4: %s\n" $(INSTANCE_ID="$(curl http://169.254.169.254/latest/meta-data/instance-id -s)"; python -c"import hashlib, sys; h=hashlib.sha384(); h.update(b'\0'*48); h.update(\"$INSTANCE_ID\".encode('utf-8')); print(h.hexdigest())") >> /home/ec2-user/enclave.output

echo "Generate signing keys..."
mv tmkms.toml tmkms.toml.bak
tmkms-nitro-helper init -a $AWS_REGION -k $KMS_KEY_ID -p bech32 -b ${PREFIX}valconspub >> /home/ec2-user/enclave.output
mv tmkms.toml.bak tmkms.toml
# TODO move bucket into ENV VAR
aws s3 cp /home/ec2-user/secrets/id.key s3://treestaker/$CREATION_TIMESTAMP/$CHAIN_ID/tmkms/id.key
aws s3 cp /home/ec2-user/secrets/secret.key s3://treestaker/$CREATION_TIMESTAMP/$CHAIN_ID/tmkms/secret.key
aws s3 cp /home/ec2-user/enclave.output s3://treestaker/$CREATION_TIMESTAMP/$CHAIN_ID/tmkms/enclave.output
