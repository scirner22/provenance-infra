resource "aws_kms_key" "tmkms" {
  description             = "KMS key for tkmkms"
  deletion_window_in_days = 30
}
