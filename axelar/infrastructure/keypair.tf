# this resource was imported and the pem can be found here:
# /Volumes/Keybase/team/figureops/axelar/axelar.pem
resource "aws_key_pair" "ssh" {
  key_name   = "axelar"
  public_key = ""
}
