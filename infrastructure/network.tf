resource "aws_vpc" "main" {
	cidr_block = "10.0.0.0/16"
	enable_dns_hostnames = true

	tags = {
		Name = "main"
	}
}

resource "aws_internet_gateway" "main" {
	vpc_id = aws_vpc.main.id

	tags = {
		Name = "main_gateway"
	}
}

resource "aws_subnet" "main_a_private" {
	vpc_id = aws_vpc.main.id
	availability_zone = "us-east-1a"
	cidr_block = "10.0.0.0/24"

	tags = {
		Name = "main_a_private"
	}
}

resource "aws_subnet" "main_b_private" {
	vpc_id = aws_vpc.main.id
	availability_zone = "us-east-1b"
	cidr_block = "10.0.1.0/24"

	tags = {
		Name = "main_b_private"
	}
}

resource "aws_subnet" "main_c_private" {
	vpc_id = aws_vpc.main.id
	availability_zone = "us-east-1c"
	cidr_block = "10.0.2.0/24"

	tags = {
		Name = "main_c_private"
	}
}

resource "aws_subnet" "main_a_public" {
	vpc_id = aws_vpc.main.id
	availability_zone = "us-east-1a"
	cidr_block = "10.0.10.0/24"
	map_public_ip_on_launch = true

	tags = {
		Name = "main_a_public"
	}
}

resource "aws_subnet" "main_b_public" {
	vpc_id = aws_vpc.main.id
	availability_zone = "us-east-1b"
	cidr_block = "10.0.11.0/24"
	map_public_ip_on_launch = true

	tags = {
		Name = "main_b_public"
	}
}

resource "aws_subnet" "main_c_public" {
	vpc_id = aws_vpc.main.id
	availability_zone = "us-east-1c"
	cidr_block = "10.0.12.0/24"
	map_public_ip_on_launch = true

	tags = {
		Name = "main_c_public"
	}
}

resource "aws_route_table" "main_route_table" {
	vpc_id = aws_vpc.main.id

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.main.id
	}

	route {
		ipv6_cidr_block = "::/0"
		gateway_id = aws_internet_gateway.main.id
	}

	tags = {
		Name = "main_route_table"
	}
}

resource "aws_route_table_association" "main_a_public_route_table" {
  subnet_id      = aws_subnet.main_a_public.id
  route_table_id = aws_route_table.main_route_table.id
}

resource "aws_route_table_association" "main_b_public_route_table" {
  subnet_id      = aws_subnet.main_b_public.id
  route_table_id = aws_route_table.main_route_table.id
}

resource "aws_route_table_association" "main_c_public_route_table" {
  subnet_id      = aws_subnet.main_c_public.id
  route_table_id = aws_route_table.main_route_table.id
}
