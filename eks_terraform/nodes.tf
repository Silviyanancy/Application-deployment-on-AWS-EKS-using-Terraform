# IAM Role for Worker Nodes to interact with AWS Services (EC2)
resource "aws_iam_role" "nodes" {
  name = "${local.env}-${local.eks_name}-eks-nodes"

  # Trust policy: Allow EC2 instances (worker nodes) to assume this role
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
EOF
}

# Grants permissions for worker nodes to join the EKS cluster (e.g., registering with the control plane).
# This policy now includes AssumeRoleForPodIdentity for the Pod Identity Agent
resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

# Permissions for the Amazon VPC CNI plugin to manage pod networking (e.g., assigning IPs to pods).
resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

# Allows worker nodes to pull container images from Amazon ECR.
resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

resource "aws_eks_node_group" "general" {
  cluster_name    = aws_eks_cluster.eks.name
  version         = local.eks_version
  node_group_name = "general"
  node_role_arn   = aws_iam_role.nodes.arn

  # Subnets where worker nodes will be deployed (private subnets)
  subnet_ids = [
    aws_subnet.private_zone1.id,
    aws_subnet.private_zone2.id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t2.large"]

  # Auto-scaling configuration
  scaling_config {
    desired_size = 1
    max_size     = 10
    min_size     = 0
  }

  # Rolling update configuration
  update_config {
    max_unavailable = 1
  }

  # Labels for the node group (used by Kubernetes for scheduling)
  labels = {
    role = "general"
  }

  # Ensure policies are attached before creating the node group
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]

  # Ignore changes to desired_size to allow external changes by tools like the Kubernetes Cluster Autoscaler to manage scaling without Terraform plan difference.
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}
