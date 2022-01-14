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

resource "aws_eip_association" "eip_assoc_bastion" {
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.bastion.id
}

resource "aws_instance" "validator" {
  ami           = "ami-011899242bb902164"
  instance_type = "m5.2xlarge"

  ebs_optimized = true
  root_block_device {
    delete_on_termination = false

    volume_type = "gp3"
    volume_size = 100
  }

  key_name = aws_key_pair.ssh.id

  subnet_id = aws_subnet.main_b_public.id
  vpc_security_group_ids = [
    aws_security_group.allow_internal_ssh.id,
    aws_security_group.allow_internal_cosmos.id,
    aws_security_group.allow_strict_external_cosmos.id,
    aws_security_group.allow_tmkms.id,
    aws_security_group.allow_outbound_internet_access.id,
    aws_security_group.allow_strict_external_ethereum.id,
  ]

  tags = {
    Name        = "validator"
    Environment = "testnet"
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

  subnet_id = aws_subnet.main_b_public.id
  vpc_security_group_ids = [
    aws_security_group.allow_internal_ssh.id,
    aws_security_group.allow_internal_ethereum.id,
    aws_security_group.allow_strict_external_ethereum.id,
    aws_security_group.allow_outbound_internet_access.id,
  ]

  tags = {
    Name        = "ethereum"
    Environment = "testnet"
  }
}

resource "aws_instance" "chain_node_1" {
  ami           = "ami-011899242bb902164"
  instance_type = "m5.xlarge"

  ebs_optimized = true
  root_block_device {
    delete_on_termination = false

    volume_type = "gp3"
    volume_size = 20
  }

  ebs_block_device {
    delete_on_termination = true

    device_name = ""
    volume_type = "gp3"
    volume_size = 1000
  }

  key_name = aws_key_pair.ssh.id

  subnet_id = aws_subnet.main_b_public.id
  vpc_security_group_ids = [
    aws_security_group.allow_internal_ssh.id,
    aws_security_group.allow_outbound_internet_access.id,
  ]

  tags = {
    Name        = "chain-node-1"
    Environment = "mainnet"
  }
}
