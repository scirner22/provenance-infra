resource "aws_security_group" "allow_personal_ssh" {
  name = "allow_personal_ssh"
  description = "Allow SSH access from a specific source ip"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["71.226.234.119/32"]
  }

  tags = {
    Name = "allow_personal_ssh"
  }
}

resource "aws_security_group" "allow_tmkms" {
  name = "allow_tmkms"
  description = "Allow tmkms port"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 26669
    to_port = 26669
    protocol = "tcp"
    self = true
  }

  tags = {
    Name = "allow_tmkms"
  }
}

resource "aws_security_group" "allow_internal_cosmos" {
  name = "allow_internal_cosmos"
  description = "Allow all cosmos ports on self"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 26656
    to_port = 26656
    protocol = "tcp"
    self = true
  }

  tags = {
    Name = "allow_internal_cosmos"
  }
}

resource "aws_security_group" "allow_external_cosmos" {
  name = "allow_external_cosmos"
  description = "Allow all cosmos ports to everyone"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 26656
    to_port = 26656
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_external_cosmos"
  }
}
