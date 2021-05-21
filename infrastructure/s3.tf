resource "aws_s3_bucket" "treestaker" {
  bucket = "treestaker"
  acl    = "private"

  tags = {
    Name = "treestaker"
  }
}
