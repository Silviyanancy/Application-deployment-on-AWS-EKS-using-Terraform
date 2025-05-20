resource "aws_vpc" "main" {
  # Creates a VPC in AWS with the CIDR range 10.0.0.0/16
  cidr_block = "10.0.0.0/16"

  # Enables DNS support and hostnames for internal communication.
  enable_dns_support   = true # Instances in the VPC can use AWS-provided DNS
  enable_dns_hostnames = true # Instances in the VPC receive AWS-generated DNS hostnames. Enables communication using hostnames instead of IP addresses.

  tags = {
    Name = "${local.env}-main" # VPC will be named staging-main in the AWS console.
  }

}
