terraform {
  backend "s3" {
    bucket         = "test-eksdemo-state"
    key            = "Test-EKSDemo/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "eks-terraform-locks"

    use_lockfile = true

  }
}
