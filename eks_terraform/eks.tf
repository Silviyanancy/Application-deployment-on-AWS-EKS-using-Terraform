# Creation of an IAM role that the EKS control plane assumes.
resource "aws_iam_role" "eks" {
  name = "${local.env}-${local.eks_name}-eks-cluster"

  # Allows the EKS service (eks.amazonaws.com) to assume this role.
  assume_role_policy = <<EOF
    {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "eks.amazonaws.com" 
      }
    }
  ]
}
EOF
}

# Attaches the AWS-managed policy AmazonEKSClusterPolicy to the IAM role.
resource "aws_iam_role_policy_attachment" "eks" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks.name
}

# Creates an Amazon EKS cluster with the specified configuration.
resource "aws_eks_cluster" "eks" {
  name     = "${local.env}-${local.eks_name}"
  version  = local.eks_version
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true

    subnet_ids = [
      aws_subnet.private_zone1.id,
      aws_subnet.private_zone2.id
    ]
  }

  access_config {
    # supports both IAM and Kubernetes RBAC
    authentication_mode = "API_AND_CONFIG_MAP"
    #  Grants the cluster creator full admin permissions
    bootstrap_cluster_creator_admin_permissions = true
  }
  # Ensures IAM Policy is attached before cluster creation
  depends_on = [aws_iam_role.eks]

}
