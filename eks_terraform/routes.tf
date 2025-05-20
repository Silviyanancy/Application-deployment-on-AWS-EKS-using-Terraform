# Routes traffic from private subnets through the NAT Gateway.
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id # Attach to the VPC

  # Route all outbound traffic (0.0.0.0/0) to the NAT Gateway
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id # NAT Gateway created earlier
  }

  tags = {
    Name = "${local.env}-private"
  }
}

# Routes traffic from public subnets directly to the Internet Gateway.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # Route all outbound traffic (0.0.0.0/0) to the Internet Gateway (IGW)
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id # IGW created earlier
  }

  tags = {
    Name = "${local.env}-public"
  }
}

# Traffic from private_zone1 and private_zone2 subnets is routed through the NAT Gateway.
resource "aws_route_table_association" "private_zone1" {
  subnet_id      = aws_subnet.private_zone1.id # Private subnet in AZ1
  route_table_id = aws_route_table.private.id  # Private route table
}

resource "aws_route_table_association" "private_zone2" {
  subnet_id      = aws_subnet.private_zone2.id # Private subnet in AZ2
  route_table_id = aws_route_table.private.id
}

# Traffic from public_zone1 and public_zone2 subnets is routed through the Internet Gateway
resource "aws_route_table_association" "public_zone1" {
  subnet_id      = aws_subnet.public_zone1.id # Public subnet in AZ1
  route_table_id = aws_route_table.public.id  # Public route table
}

resource "aws_route_table_association" "public_zone2" {
  subnet_id      = aws_subnet.public_zone2.id # Public subnet in AZ2
  route_table_id = aws_route_table.public.id
}
