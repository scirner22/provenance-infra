resource "aws_iam_instance_profile" "tmkms" {
  name = "tmkms_instance_profile"
  role = aws_iam_role.tmkms.name
}

resource "aws_iam_role" "tmkms" {
  name = "tmkms_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_policy" "tmkms_enclave_kms_decrypt_debug" {
  name        = "tmkms_enclave_kms_decrypt_debug"
  path        = "/"
  description = "Policy to decrypt the tmkms data key for KMS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Decrypt",
        ]
        Effect   = "Allow"
        Resource = aws_kms_key.tmkms.arn
        Condition = {
          StringEqualsIgnoreCase = {
            "kms:RecipientAttestation:ImageSha384" = "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "tmkms_enclave_kms_debug" {
  role       = aws_iam_role.tmkms.name
  policy_arn = aws_iam_policy.tmkms_enclave_kms_decrypt_debug.arn
}

resource "aws_iam_policy" "tmkms_enclave_kms_decrypt" {
  name        = "tmkms_enclave_kms_decrypt"
  path        = "/"
  description = "Policy to decrypt the tmkms data key for KMS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Decrypt",
        ]
        Effect   = "Allow"
        Resource = aws_kms_key.tmkms.arn
        Condition = {
          StringEqualsIgnoreCase = {
            "kms:RecipientAttestation:PCR4" : "45bffc6378b2480cb29b9feca8a5eaa20a75f30bd0aecd91a5ec541f470b9c4067abd298931b66acb1cc848f582aeec1",
            "kms:RecipientAttestation:PCR0" : "9c865ee27e269852f20fbe775a31bb2de65dddd45dbd24c80bd683f8a301aa5ae1bd884b8303833eb19c75b6877d8a60"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "tmkms_enclave_kms" {
  role       = aws_iam_role.tmkms.name
  policy_arn = aws_iam_policy.tmkms_enclave_kms_decrypt.arn
}

resource "aws_iam_policy" "tmkms_kms_encrypt" {
  name        = "tmkms_kms_encrypt"
  path        = "/"
  description = "Policy to encrypt tmkms data for KMS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Encrypt",
        ]
        Effect   = "Allow"
        Resource = aws_kms_key.tmkms.arn
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "tmkms_kms_encrypt" {
  role       = aws_iam_role.tmkms.name
  policy_arn = aws_iam_policy.tmkms_kms_encrypt.arn
}

resource "aws_iam_policy" "read_write_tmkms_bucket" {
  name        = "read_write_tmkms_bucket"
  path        = "/"
  description = "Policy to perform standard (read/write/list) operations on the tmkms bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:PutObject",
          "s3:GetObject",
        ]
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.tmkms.arn,
          "${aws_s3_bucket.tmkms.arn}/*",
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "tmkms_s3" {
  role       = aws_iam_role.tmkms.name
  policy_arn = aws_iam_policy.read_write_tmkms_bucket.arn
}
