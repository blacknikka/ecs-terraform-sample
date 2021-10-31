# aws_vpc
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = var.network_name
  }
}

# default security group allow nothing
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id
}

# aws_internet_gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.base_name
  }
}

# subnet
resource "aws_subnet" "public_a" {
  availability_zone       = "${data.aws_region.current.name}a"
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.base_name}-subnet-pub-a"
  }
}

resource "aws_subnet" "public_c" {
  availability_zone       = "${data.aws_region.current.name}c"
  cidr_block              = "10.0.2.0/24"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.base_name}-subnet-pub-c"
  }
}

resource "aws_subnet" "private_a" {
  availability_zone       = "${data.aws_region.current.name}a"
  cidr_block              = "10.0.11.0/24"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.base_name}-subnet-pri-a"
  }
}

resource "aws_subnet" "private_c" {
  availability_zone       = "${data.aws_region.current.name}c"
  cidr_block              = "10.0.12.0/24"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.base_name}-subnet-pri-c"
  }
}

# EIP
resource "aws_eip" "nat_a" {
  vpc = true

  tags = {
    Name = "natgw-a"
  }
}

# resource "aws_eip" "nat_c" {
#   vpc = true

#   tags = {
#     Name = "natgw-c"
#   }
# }

# NAT gateway
resource "aws_nat_gateway" "nat_a" {
  subnet_id     = aws_subnet.public_a.id
  allocation_id = aws_eip.nat_a.id

  tags = {
    Name = "nat-a"
  }
}

# resource "aws_nat_gateway" "nat_c" {
#   subnet_id     = aws_subnet.public_c.id
#   allocation_id = aws_eip.nat_c.id

#   tags = {
#     Name = "nat-c"
#   }
# }


# aws_route_table
resource "aws_route_table" "rt_public_a" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.base_name}-table-pub-a"
  }
}

resource "aws_route_table" "rt_public_c" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.base_name}-table-pub-c"
  }
}

resource "aws_route_table" "rt_private_a" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.base_name}-table-pri-a"
  }
}

resource "aws_route_table" "rt_private_c" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.base_name}-table-pri-c"
  }
}

# aws_route_table_association
resource "aws_route_table_association" "rta_public_a" {
  route_table_id = aws_route_table.rt_public_a.id
  subnet_id      = aws_subnet.public_a.id
}

resource "aws_route_table_association" "rta_public_c" {
  route_table_id = aws_route_table.rt_public_c.id
  subnet_id      = aws_subnet.public_c.id
}

resource "aws_route_table_association" "rta_private_a" {
  route_table_id = aws_route_table.rt_private_a.id
  subnet_id      = aws_subnet.private_a.id
}

resource "aws_route_table_association" "rta_private_c" {
  route_table_id = aws_route_table.rt_private_c.id
  subnet_id      = aws_subnet.private_c.id
}

# aws_route
resource "aws_route" "route_public_a" {
  route_table_id         = aws_route_table.rt_public_a.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

# resource "aws_route" "route_public_c" {
#   route_table_id         = aws_route_table.rt_public_c.id
#   gateway_id             = aws_internet_gateway.igw.id
#   destination_cidr_block = "0.0.0.0/0"
# }

resource "aws_route" "route_private_a" {
  route_table_id         = aws_route_table.rt_private_a.id
  nat_gateway_id         = aws_nat_gateway.nat_a.id
  destination_cidr_block = "0.0.0.0/0"
}

# resource "aws_route" "route_private_c" {
#   route_table_id         = aws_route_table.rt_private_c.id
#   nat_gateway_id         = aws_nat_gateway.nat_c.id
#   destination_cidr_block = "0.0.0.0/0"
# }

