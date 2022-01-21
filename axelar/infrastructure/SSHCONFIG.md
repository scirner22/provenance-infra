## Use the following configuration file to access the axelar nodes. Keys are kept in keybase

```
##Axelar-Testnet

Host bastion-axelar-testnet
  Hostname ec2-54-204-180-181.compute-1.amazonaws.com
  User ubuntu
  Port 22
  StrictHostKeyChecking no
  PasswordAuthentication no
  ServerAliveInterval 30
  ServerAliveCountMax 3
  IdentityFile ~/.ssh/axelar-testnet.pem

Host validator-axelar-testnet
  Hostname ip-10-0-11-185.ec2.internal
  User ubuntu
  Port 22
  StrictHostKeyChecking no
  PasswordAuthentication no
  ServerAliveInterval 30
  ServerAliveCountMax 3
  IdentityFile ~/.ssh/axelar-testnet.pem
  ProxyCommand ssh bastion-axelar-testnet nc %h %p

Host tmkms-axelar-testnet
  Hostname 10.0.0.133
  User ec2-user
  Port 22
  StrictHostKeyChecking no
  PasswordAuthentication no
  ServerAliveInterval 30
  ServerAliveCountMax 3
  IdentityFile ~/.ssh/axelar-testnet.pem
  ProxyCommand ssh bastion-axelar-testnet nc %h %p

Host ethereum-axelar-testnet
  Hostname ip-10-0-11-31.ec2.internal
  User ubuntu
  Port 22
  StrictHostKeyChecking no
  PasswordAuthentication no
  ServerAliveInterval 30
  ServerAliveCountMax 3
  IdentityFile ~/.ssh/axelar-testnet.pem
  ProxyCommand ssh bastion-axelar-testnet nc %h %p

Host avalanche-axelar-testnet
  Hostname ip-10-0-10-30.ec2.internal
  User ubuntu
  Port 22
  StrictHostKeyChecking no
  PasswordAuthentication no
  ServerAliveInterval 30
  ServerAliveCountMax 3
  IdentityFile ~/.ssh/axelar-testnet.pem
  ProxyCommand ssh bastion-axelar-testnet nc %h %p

Host moonbeam-axelar-testnet
  Hostname 10.0.1.30
  User ubuntu
  Port 22
  StrictHostKeyChecking no
  PasswordAuthentication no
  ServerAliveInterval 30
  ServerAliveCountMax 3
  IdentityFile ~/.ssh/axelar-testnet.pem
  ProxyCommand ssh bastion-axelar-testnet nc %h %p

Host fantom-axelar-testnet
  Hostname 10.0.0.30
  User ubuntu
  Port 22
  StrictHostKeyChecking no
  PasswordAuthentication no
  ServerAliveInterval 30
  ServerAliveCountMax 3
  IdentityFile ~/.ssh/axelar-testnet.pem
  ProxyCommand ssh bastion-axelar-testnet nc %h %p

##Axelar-Mainnet

Host bastion-axelar-mainnet
  Hostname ec2-18-205-12-44.compute-1.amazonaws.com
  User ubuntu
  Port 22
  StrictHostKeyChecking no
  PasswordAuthentication no
  ServerAliveInterval 30
  ServerAliveCountMax 3
  IdentityFile ~/.ssh/axelar-mainnet.pem

Host validator-axelar-mainnet
  Hostname ip-10-0-11-203.ec2.internal
  User ubuntu
  Port 22
  StrictHostKeyChecking no
  PasswordAuthentication no
  ServerAliveInterval 30
  ServerAliveCountMax 3
  IdentityFile ~/.ssh/axelar-mainnet.pem
  ProxyCommand ssh -W %h:%p bastion-axelar-mainnet

Host tmkms-axelar-mainnet
  Hostname ip-10-0-0-173.ec2.internal
  User ec2-user
  Port 22
  StrictHostKeyChecking no
  PasswordAuthentication no
  ServerAliveInterval 30
  ServerAliveCountMax 3
  IdentityFile ~/.ssh/axelar-mainnet.pem
  ProxyCommand ssh -W %h:%p bastion-axelar-mainnet

Host ethereum-axelar-mainnet
  Hostname ip-10-0-11-8.ec2.internal
  User ubuntu
  Port 22
  StrictHostKeyChecking no
  PasswordAuthentication no
  ServerAliveInterval 30
  ServerAliveCountMax 3
  IdentityFile ~/.ssh/axelar-mainnet.pem
  ProxyCommand ssh -W %h:%p bastion-axelar-mainnet

Host avalanche-axelar-mainnet
  Hostname ip-10-0-10-30.ec2.internal
  User ubuntu
  Port 22
  StrictHostKeyChecking no
  PasswordAuthentication no
  ServerAliveInterval 30
  ServerAliveCountMax 3
  IdentityFile ~/.ssh/axelar-mainnet.pem
  ProxyCommand ssh -W %h:%p bastion-axelar-mainnet

Host moonbeam-axelar-mainnet
  Hostname 10.0.1.30
  User ubuntu
  Port 22
  StrictHostKeyChecking no
  PasswordAuthentication no
  ServerAliveInterval 30
  ServerAliveCountMax 3
  IdentityFile ~/.ssh/axelar-mainnet.pem
  ProxyCommand ssh -W %h:%p bastion-axelar-mainnet

Host fantom-axelar-mainnet
  Hostname 10.0.0.30
  User ubuntu
  Port 22
  StrictHostKeyChecking no
  PasswordAuthentication no
  ServerAliveInterval 30
  ServerAliveCountMax 3
  IdentityFile ~/.ssh/axelar-mainnet.pem
  ProxyCommand ssh -W %h:%p bastion-axelar-mainnet

  ```