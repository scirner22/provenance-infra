# this resource was imported and the pem can be found here:
# /Volumes/Keybase/team/figureops/axelar/
resource "aws_key_pair" "ssh" {
  key_name        = terraform.workspace
  public_key      = terraform.workspace == "axelar-testnet" ? "" : var.mainnet_public_key

}