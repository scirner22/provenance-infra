#!/bin/bash

sudo sed -i "s/memory_mib: 512/memory_mib: 8192/" /etc/nitro_enclaves/allocator.yaml
sudo sed -i "s/VALIDATOR_ADDR/ip-10-0-1-241.ec2.internal/" /home/ec2-user/run.sh
sudo sed -i "s/VALIDATOR_ADDR/ip-10-0-1-241.ec2.internal/" /home/ec2-user/validator_vsock_proxy.yaml

sudo systemctl restart nitro-enclaves-allocator.service
