resource "aws_iam_instance_profile" "sentinel" {
  name = "sentinel_instance_profile"
  role = aws_iam_role.sentinel.name
}

resource "aws_iam_role" "sentinel" {
  name = "sentinel_role"
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
