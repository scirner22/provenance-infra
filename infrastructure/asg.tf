# resource "aws_launch_template" "public_sentinel" {
# 	name_prefix = "public-sentinel-"
# 	image_id = data.aws_ami.sentinel.id
# 	key_name = 
# 
# 	vpc_security_group_ids = // TODO add security groups
# 
# 	instance_type = "m5.xlarge"
# 
# 	iam_instance_profile {
# 		arn = aws_iam_instance_profile.sentinel.arn
# 	}
# 
# 	ebs_optimized = true
# 
# 	# block_device_mappings {
# 	# 	device_name = ""
# 
# 	# 	ebs {
# 	# 		volume_size =
# 	# 	}
# 	# }
# }

# TODO move to auto scaling groups
# Plan - 3 of 5 asg groups for both external sentinels and internal sentinels
# Daily (or every two days) timed based scaling to bring the 2 nodes online so their EBS volumes can
# stay pretty close to up-to-date. Scale down to 3 nodes 30 minutes later. This should naturally terminate
# the two oldest nodes.
# Problem - we need a custom user data script that will attach the associated EBS from the pool because
# typical ASGs aren't setup to attach to persistent volumes.

resource "aws_instance" "public_sentinel_1" {
  ami = "ami-04893c9535825d595"
  instance_type = "m5.xlarge"

  ebs_optimized = true
  root_block_device {
    delete_on_termination = true

    volume_type = "gp2"
    volume_size = 1000
  }

  key_name = aws_key_pair.ssh.id

  subnet_id = aws_subnet.main_a_public.id
  vpc_security_group_ids = [
    aws_security_group.allow_personal_ssh.id,
    aws_security_group.allow_external_cosmos.id,
    aws_security_group.allow_internal_cosmos.id,
    aws_security_group.allow_outbound_internet_access.id,
  ]

  tags = {
    Name = "public_sentinel_1"
    Environment = "mainnet"
  }
}

resource "aws_instance" "public_sentinel_2" {
  ami = "ami-04893c9535825d595"
  instance_type = "m5.xlarge"

  ebs_optimized = true
  root_block_device {
    delete_on_termination = true

    volume_type = "gp2"
    volume_size = 1000
  }

  key_name = aws_key_pair.ssh.id

  subnet_id = aws_subnet.main_b_public.id
  vpc_security_group_ids = [
    aws_security_group.allow_personal_ssh.id,
    aws_security_group.allow_external_cosmos.id,
    aws_security_group.allow_internal_cosmos.id,
    aws_security_group.allow_outbound_internet_access.id,
  ]

  tags = {
    Name = "public_sentinel_2"
    Environment = "mainnet"
  }
}

resource "aws_instance" "public_sentinel_3" {
  ami = "ami-04893c9535825d595"
  instance_type = "m5.xlarge"

  ebs_optimized = true
  root_block_device {
    delete_on_termination = true

    volume_type = "gp2"
    volume_size = 1000
  }

  key_name = aws_key_pair.ssh.id

  subnet_id = aws_subnet.main_c_public.id
  vpc_security_group_ids = [
    aws_security_group.allow_personal_ssh.id,
    aws_security_group.allow_external_cosmos.id,
    aws_security_group.allow_internal_cosmos.id,
    aws_security_group.allow_outbound_internet_access.id,
  ]

  tags = {
    Name = "public_sentinel_3"
    Environment = "mainnet"
  }
}

resource "aws_instance" "bastion" {
  ami = "ami-011899242bb902164"
  instance_type = "t2.micro"

  key_name = aws_key_pair.ssh.id

  subnet_id = aws_subnet.main_c_public.id
  vpc_security_group_ids = [
    aws_security_group.allow_personal_ssh.id,
    aws_security_group.allow_internal_ssh.id,
    aws_security_group.allow_outbound_internet_access.id,
  ]

  tags = {
    Name = "bastion"
    Environment = "mainnet"
  }
}

resource "aws_eip_association" "eip_assoc_bastion" {
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.bastion.id
}

resource "aws_eip_association" "eip_assoc_public_sentinel_1" {
  instance_id   = aws_instance.public_sentinel_1.id
  allocation_id = aws_eip.ip_a.id
}

resource "aws_eip_association" "eip_assoc_public_sentinel_2" {
  instance_id   = aws_instance.public_sentinel_2.id
  allocation_id = aws_eip.ip_b.id
}

resource "aws_eip_association" "eip_assoc_public_sentinel_3" {
  instance_id   = aws_instance.public_sentinel_3.id
  allocation_id = aws_eip.ip_c.id
}


resource "aws_instance" "private_sentinel_1" {
  ami = "ami-04893c9535825d595"
  instance_type = "m5.xlarge"

  ebs_optimized = true
  root_block_device {
    delete_on_termination = true

    volume_type = "gp2"
    volume_size = 1000
  }

  key_name = aws_key_pair.ssh.id

  subnet_id = aws_subnet.main_a_private.id
  vpc_security_group_ids = [
    aws_security_group.allow_internal_ssh.id,
    aws_security_group.allow_internal_cosmos.id,
    aws_security_group.allow_outbound_internet_access.id,
  ]

  user_data = file("user_data/private_sentinel.sh")

  tags = {
    Name = "private_sentinel_1"
    Environment = "mainnet"
  }
}
