# Provides internet access to the subnets
# Creates an AWS Internet Gateway (IGW) and attaches it to your VPC.
resource "aws_internet_gateway" "igw" {
  # Attaches the Internet Gateway to the VPC named main
  vpc_id = aws_vpc.main.id # Dynamically fetches the ID of the VPC resource named main.

  tags = {
    Name = "${local.env}-igw"
  }
}
