#!/bin/bash
set -e

CARGO_PATH=/home/ec2-user/.cargo
CARGO_BIN=${CARGO_PATH}/bin

sudo yum -y update
sudo yum -y install gcc git
sudo amazon-linux-extras install aws-nitro-enclaves-cli
sudo yum install aws-nitro-enclaves-cli-devel -y
sudo yum install -y openssl-devel

echo "Configuring docker..."
sudo usermod -aG ne ec2-user
sudo usermod -aG docker ec2-user
newgrp docker
sudo systemctl enable docker
sudo systemctl enable nitro-enclaves-allocator.service

echo "Downloading and installing rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

echo "Downloading and installing tmkms tools..."
git clone https://github.com/crypto-com/tmkms-light.git && cd tmkms-light
$CARGO_BIN/cargo build --release -p tmkms-nitro-helper
sudo cp target/release/tmkms-nitro-helper /usr/local/bin/
cd /home/ec2-user

echo "Configuring env vars..."
echo "export AWS_REGION=$AWS_REGION" >> /home/ec2-user/.bashrc
echo "export PREFIX=$PREFIX" >> /home/ec2-user/.bashrc
echo "export CHAIN_ID=$CHAIN_ID" >> /home/ec2-user/.bashrc
echo "export CREATION_TIMESTAMP=$TIMESTAMP" >> /home/ec2-user/.bashrc
echo "export KMS_KEY_ID=$KMS_KEY_ID" >> /home/ec2-user/.bashrc

echo "Configuring tmkms..."
sudo mv /tmp/configure.sh /home/ec2-user/configure.sh
sudo chown ec2-user:ec2-user /home/ec2-user/configure.sh
chmod a+x configure.sh
sudo mv /tmp/tmkms.toml /home/ec2-user/tmkms.toml
sudo chown ec2-user:ec2-user /home/ec2-user/tmkms.toml
sed -i "s/CHAIN_ID/$CHAIN_ID/g" /home/ec2-user/tmkms.toml
sed -i "s/AWS_REGION/$AWS_REGION/g" /home/ec2-user/tmkms.toml

echo "Configuring nitro service..."
sudo mv /tmp/validator_vsock_proxy.yaml /home/ec2-user/validator_vsock_proxy.yaml
sudo chown ec2-user:ec2-user /home/ec2-user/validator_vsock_proxy.yaml
sudo mv /tmp/run.sh /home/ec2-user/run.sh
sudo chown ec2-user:ec2-user /home/ec2-user/run.sh
chmod a+x run.sh
sed -i "s/AWS_REGION/$AWS_REGION/g" /home/ec2-user/run.sh
sudo mv /tmp/tmkms.service /lib/systemd/system/tmkms.service
sudo systemctl daemon-reload
sudo systemctl enable tmkms.service

echo "Installation completed!"
