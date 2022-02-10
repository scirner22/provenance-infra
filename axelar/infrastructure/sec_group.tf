resource "aws_security_group" "allow_personal_ssh" {
  name        = "allow_personal_ssh"
  description = "Allow SSH access from a specific source ip"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      "73.226.155.239/32",
      "67.182.236.69/32",
      "35.227.23.78/32"
    ]
  }

  tags = {
    Name = "allow_personal_ssh"
  }
}

resource "aws_security_group" "allow_internal_ssh" {
  name        = "allow_internal_ssh"
  description = "Allow SSH access from a bastion host"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    self      = true
  }

  tags = {
    Name = "allow_internal_ssh"
  }
}

resource "aws_security_group" "allow_tmkms" {
  name        = "allow_tmkms"
  description = "Allow tmkms port"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port = 26669
    to_port   = 26669
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port = 26669
    to_port   = 26669
    protocol  = "tcp"
    self      = true
  }

  tags = {
    Name = "allow_tmkms"
  }
}

resource "aws_security_group" "allow_internal_cosmos" {
  name        = "allow_internal_cosmos"
  description = "Allow all cosmos ports on self"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port = 26656
    to_port   = 26657
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port = 26656
    to_port   = 26657
    protocol  = "tcp"
    self      = true
  }

  tags = {
    Name = "allow_internal_cosmos"
  }
}

resource "aws_security_group" "allow_external_cosmos" {
  name        = "allow_external_cosmos"
  description = "Allow all cosmos ports to everyone"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 26656
    to_port     = 26657
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1317
    to_port     = 1317
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 26656
    to_port     = 26657
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_external_cosmos"
  }
}

resource "aws_security_group" "allow_strict_external_cosmos" {
  name        = "allow_strict_external_cosmos"
  description = "Allow internal nodes access to external cosmos nodes"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 26656
    to_port     = 26657
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 8545
    to_port     = 8546
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 30301
    to_port     = 30303
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 30301
    to_port     = 30303
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 9650
    to_port          = 9651
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 18545
    to_port          = 18545
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 9933
    to_port          = 9933
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }



  tags = {
    Name = "allow_strict_external_cosmos"
  }
}

resource "aws_security_group" "allow_outbound_internet_access" {
  name        = "allow_outbound_internet_access"
  description = "Allow all outbound to the internet"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 53
    to_port          = 53
    protocol         = "udp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 123
    to_port          = 123
    protocol         = "udp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 123
    to_port          = 123
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_outbound_internet_access"
  }
}

resource "aws_security_group" "allow_internal_ethereum" {
  name        = "allow_internal_ethereum"
  description = "Allow all ethereum ports on self"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port = 8545
    to_port   = 8546
    protocol  = "tcp"
    security_groups  = [aws_security_group.allow_strict_external_cosmos.id]
  }

  ingress {
    from_port = 30301
    to_port   = 30303
    protocol  = "tcp"
    security_groups  = [aws_security_group.allow_strict_external_cosmos.id]
  }

  ingress {
    from_port = 30301
    to_port   = 30303
    protocol  = "udp"
    security_groups  = [aws_security_group.allow_strict_external_cosmos.id]
  }

  tags = {
    Name = "allow_internal_ethereum"
  }
}

resource "aws_security_group" "allow_strict_external_ethereum" {
  name        = "allow_external_ethereum"
  description = "Allow all Ethereum ports to everyone"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 8545
    to_port     = 8546
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 30301
    to_port     = 30303
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 30301
    to_port     = 30303
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_strict_external_ethereum"
  }
}

resource "aws_security_group" "allow_internal_avalanche" {
  name        = "allow_internal_avalanche"
  description = "Allow all avalanche ports on self"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port = 9650
    to_port   = 9651
    protocol  = "tcp"
    security_groups  = [aws_security_group.allow_strict_external_cosmos.id]
  }

  tags = {
    Name = "allow_internal_avalanche"
  }
}

resource "aws_security_group" "allow_strict_external_avalanche" {
  name        = "allow_external_avalanche"
  description = "Allow all Avalanche ports to everyone"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 9650
    to_port     = 9651
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_strict_external_avalanche"
  }
}

resource "aws_security_group" "allow_internal_moonbeam" {
  name        = "allow_internal_moonbeam"
  description = "Allow all moonbeam ports on self"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port = 9615
    to_port   = 9616
    protocol  = "tcp"
    security_groups  = [aws_security_group.allow_strict_external_cosmos.id]
  }

  ingress {
    from_port = 9944
    to_port   = 9945
    protocol  = "tcp"
    security_groups  = [aws_security_group.allow_strict_external_cosmos.id]
  }

  ingress {
    from_port = 9933
    to_port   = 9934
    protocol  = "tcp"
    security_groups  = [aws_security_group.allow_strict_external_cosmos.id]
  }

  ingress {
    from_port = 30333
    to_port   = 30334
    protocol  = "tcp"
    security_groups  = [aws_security_group.allow_strict_external_cosmos.id]
  }


  tags = {
    Name = "allow_internal_moonbeam"
  }
}

resource "aws_security_group" "allow_strict_external_moonbeam" {
  name        = "allow_external_moonbeam"
  description = "Allow all Moonbeam ports to everyone"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 9615
    to_port     = 9616
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 9944
    to_port     = 9945
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 9933
    to_port     = 9934
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 30333
    to_port     = 30334
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_strict_external_moonbeam"
  }
}

resource "aws_security_group" "allow_internal_fantom" {
  name        = "allow_internal_fantom"
  description = "Allow all fantom ports on self"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port = 5050
    to_port   = 5050
    protocol  = "tcp"
    security_groups  = [aws_security_group.allow_strict_external_cosmos.id]
  }

  ingress {
    from_port = 5050
    to_port   = 5050
    protocol  = "udp"
    security_groups  = [aws_security_group.allow_strict_external_cosmos.id]
  }

  ingress {
    from_port = 18545
    to_port   = 18546
    protocol  = "tcp"
    security_groups  = [aws_security_group.allow_strict_external_cosmos.id]
  }

  tags = {
    Name = "allow_internal_fantom"
  }
}

resource "aws_security_group" "allow_strict_external_fantom" {
  name        = "allow_external_fantom"
  description = "Allow all Fantom ports to everyone"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 5050
    to_port     = 5050
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 5050
    to_port     = 5050
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 18545
    to_port     = 18546
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 30300
    to_port     = 30340
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_strict_external_fantom"
  }
}