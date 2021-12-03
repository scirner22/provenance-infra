resource "aws_s3_bucket" "tmkms" {
  bucket = "tmkms"
  acl    = "private"

  tags = {
    Name = "tmkms"
  }
}
