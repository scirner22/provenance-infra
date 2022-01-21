resource "aws_instance" "bastion" {
  ami           = "ami-011899242bb902164"
  instance_type = "t2.micro"

  key_name = terraform.workspace

  subnet_id = aws_subnet.main_c_public.id
  vpc_security_group_ids = [
    aws_security_group.allow_personal_ssh.id,
    aws_security_group.allow_internal_ssh.id,
    aws_security_group.allow_internal_cosmos.id,
    aws_security_group.allow_outbound_internet_access.id,
  ]

  tags = {
    Name        = "bastion"
    Environment = "mainnet"
  }
}

resource "aws_eip" "bastion" {
  vpc               = true
}

resource "aws_eip_association" "eip_assoc_bastion" {
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.bastion.id
}

resource "aws_eip" "validator" {
  vpc               = true
}

resource "aws_eip_association" "eip_assoc_validator" {
  instance_id   = aws_instance.validator.id
  allocation_id = aws_eip.validator.id
}

resource "aws_instance" "validator" {
  ami           = "ami-011899242bb902164"
  instance_type = "m5.2xlarge"

  ebs_optimized = true
  root_block_device {
    delete_on_termination = false

    volume_type = "gp3"
    volume_size = 500
  }

  key_name = aws_key_pair.ssh.id
  private_ip = terraform.workspace == "axelar-testnet" ? "10.0.11.185" : "10.0.11.203"

  subnet_id = aws_subnet.main_b_public.id
  vpc_security_group_ids = [
    aws_security_group.allow_internal_ssh.id,
    aws_security_group.allow_internal_cosmos.id,
    aws_security_group.allow_strict_external_cosmos.id,
    aws_security_group.allow_tmkms.id,
    aws_security_group.allow_outbound_internet_access.id,
  ]

  tags = {
    Name        = "validator"
    Environment = terraform.workspace
  }
}



resource "aws_instance" "tmkms" {
  ami                  = "ami-0d5eff06f840b45e9"
  instance_type        = "m5.xlarge"
  iam_instance_profile = aws_iam_instance_profile.tmkms.name

  ebs_optimized = true
  root_block_device {
    delete_on_termination = false

    volume_type = "gp3"
    volume_size = 40
  }

  key_name = aws_key_pair.ssh.id

  subnet_id = aws_subnet.main_a_private.id
  # TODO put back in internal_private and remove outbound access
  vpc_security_group_ids = [
    aws_security_group.allow_internal_ssh.id,
    aws_security_group.allow_outbound_internet_access.id,
    aws_security_group.allow_tmkms.id,
  ]

  enclave_options {
    enabled = true
  }

  tags = {
    Name        = "tmkms"
    Environment = "testnet"
  }
}

resource "aws_instance" "ethereum_node" {
  ami           = "ami-011899242bb902164"
  instance_type = "m5.xlarge"

  ebs_optimized = true
  root_block_device {
    delete_on_termination = false

    volume_type = "gp3"
    volume_size = 1000
  }

  key_name = aws_key_pair.ssh.id
  private_ip = terraform.workspace == "axelar-testnet" ? "10.0.11.31" : "10.0.11.8"

  subnet_id = aws_subnet.main_b_public.id
  vpc_security_group_ids = [
    aws_security_group.allow_internal_ssh.id,
    aws_security_group.allow_internal_ethereum.id,
    aws_security_group.allow_strict_external_ethereum.id,
    aws_security_group.allow_outbound_internet_access.id,
  ]

  tags = {
    Name        = "ethereum"
    Environment = terraform.workspace
  }
}


resource "aws_eip" "ethereum" {
  vpc               = true
}

resource "aws_eip_association" "eip_assoc_ethereum" {
  instance_id   = aws_instance.ethereum_node.id
  allocation_id = aws_eip.ethereum.id
}


resource "aws_instance" "avalanche" {
  ami           = "ami-011899242bb902164"
  instance_type = "m5.xlarge"

  ebs_optimized = true
  root_block_device {
    delete_on_termination = false

    volume_type = "gp3"
    volume_size = 500
  }

  key_name = aws_key_pair.ssh.id
  private_ip = "10.0.10.30"

  subnet_id = aws_subnet.main_a_public.id
  vpc_security_group_ids = [
    aws_security_group.allow_internal_ssh.id,
    aws_security_group.allow_outbound_internet_access.id,
    aws_security_group.allow_internal_avalanche.id,
    aws_security_group.allow_strict_external_avalanche.id
  ]

  tags = {
    Name        = "avalanche"
    Environment = terraform.workspace
  }
}

# resource "aws_network_interface" "interface_avalanche_public" {
#   subnet_id   = aws_subnet.main_a_public.id
#   private_ips = ["10.0.10.30"]
# }

resource "aws_eip" "avalanche" {
  vpc               = true
}

resource "aws_eip_association" "eip_assoc_avalanche" {
  instance_id   = aws_instance.avalanche.id
  allocation_id = aws_eip.avalanche.id
}


resource "aws_instance" "moonbeam" {
  ami           = "ami-011899242bb902164"
  instance_type = "m5.xlarge"

  ebs_optimized = true
  root_block_device {
    delete_on_termination = false

    volume_type = "gp3"
    volume_size = 500
  }

  key_name = aws_key_pair.ssh.id
  private_ip = "10.0.1.30"

  subnet_id = aws_subnet.main_b_private.id
  vpc_security_group_ids = [
    aws_security_group.allow_internal_ssh.id,
    aws_security_group.allow_outbound_internet_access.id,
    aws_security_group.allow_internal_moonbeam.id,
    aws_security_group.allow_strict_external_moonbeam.id
  ]

  tags = {
    Name        = "moonbeam"
    Environment = terraform.workspace
  }
}

resource "aws_instance" "fantom" {
  ami           = "ami-011899242bb902164"
  instance_type = "m5.xlarge"

  ebs_optimized = true
  root_block_device {
    delete_on_termination = false

    volume_type = "gp3"
    volume_size = 500
  }

  key_name = aws_key_pair.ssh.id
  private_ip = "10.0.0.30"

  subnet_id = aws_subnet.main_a_private.id
  vpc_security_group_ids = [
    aws_security_group.allow_internal_ssh.id,
    aws_security_group.allow_outbound_internet_access.id,
    aws_security_group.allow_internal_fantom.id,
    aws_security_group.allow_strict_external_fantom.id,
  ]

  tags = {
    Name        = "fantom"
    Environment = terraform.workspace
  }
}