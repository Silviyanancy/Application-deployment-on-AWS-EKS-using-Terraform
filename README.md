# Deployment of a Static Website on AWS EKS with ALB Ingress

## Part 1: Infrastructure: VPC, EKS Cluster, IAM Roles (Terraform).

To deploy an EKS cluster in AWS, the following networking components are required,

- Creation of VPC with four different subnets (two public and two private) in two different availabilty zones because EKS requires multiple subnets at least in two different availability zones.
- Private subnets to deploy kubernetes nodes and public subnets to provision network and load balancer.
- Internet gateway attached to VPC to provide internet access to the virtual machines with public IP in the public subnets.
- NAT Gateway in one of the public subnets which translates the private IP address to public that allows internet access within the private subnets.
- Route table - Public Route (Target - Internet Gateway), Private Route (Target - NAT Gateway) and attach these to the subnets.

## EKS_Terraform

- locals.tf - locals block defines values for environment, region, availability zones, and EKS cluster details.
- provider.tf - Configures the AWS provider, which allows Terraform to interact with AWS services.
- vpc.tf - Declares a Terraform resource of type aws_vpc.
- igw.tf - Creates an AWS Internet Gateway (IGW) and attaches it to your VPC.
- subnets.tf - 2 Private Subnets: For internal resources (e.g., EKS worker nodes), 2 Public Subnets: For internet-facing resources (e.g., load balancers, NAT Gateways). These subnets are spread across 2 Availability Zones (AZs) (local.zone1 and local.zone2) for high availability.
- nat.tf - Allows private subnet resources to securely access the internet, an Elastic IP (EIP) is a static, public IPv4 address that you can allocate to your AWS account.
- route.tf - Two route tables (public and private) and associates subnets with them to control traffic flow.
- eks.tf - Configuration for the EKS cluster, IAM role, and associated policies.
- nodes.tf - Configures IAM roles, policies, and an EKS node group for worker nodes in your Kubernetes cluster.

## Part 2: Application: App Deployment, Service, Ingress (Kubernetes Manifests), ALB using Helm.
