# one-off-chain-infra
Repo that maintains all the AWS infrastructure files for different blockchains such as:

1) Axelar Mainnet/Testnet

### Terraform Axelar
In order to run the terraform contained in this repo it is required that you have access to the axelar-testnet and axelar-mainnet projects. A member of the DevOps team can create an account for you and get you programmatic access.

When you recieve your AWS credentials you will need to create profiles specific to these accounts

`vi ~/.aws/credentials`
Add in your creds following the example below:

[axelar-testnet]
aws_access_key_id = 
aws_secret_access_key = 
[axelar-mainnet]
aws_access_key_id = 
aws_secret_access_key = 

After having this in place you can now leverage the terraform file to manage state

### Terraform Workspaces

In order to access the axelar state you will need to use specific workspaces. These have been named after the aws account/profiles to make it simple for configuration

In order to create the necessarry workspaces run the following:

`terraform init`

`terraform workspace new axelar-testnet`

`terraform workspace new axelar-mainnet`


