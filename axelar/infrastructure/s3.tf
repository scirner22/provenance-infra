resource "aws_s3_bucket" "tmkms" {
  bucket = "tmkms-${terraform.workspace}"
  acl    = "private"

  tags = {
    Name = "tmkms"
  }
}
