# Creates an Elastic IP (EIP) for the NAT Gateway.
# NAT Gateways require an EIP to provide outbound internet access for resources in private subnets.

resource "aws_eip" "nat" {
  domain = "vpc" # Allocates the EIP for use in a VPC

  tags = {
    Name = "${local.env}-nat"
  }
}

# Creates a NAT Gateway in a public subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id             # Associates the EIP with the NAT Gateway
  subnet_id     = aws_subnet.public_zone1.id # Places the NAT Gateway in a public subnet

  tags = {
    Name = "${local.env}-nat"
  }
  # Ensures the Internet Gateway (IGW) exists first
  depends_on = [aws_internet_gateway.igw]

}
