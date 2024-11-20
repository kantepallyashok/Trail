# terraform {
#   backend "s3" {
#     bucket = "ashoktf2"  # The name of your S3 bucket
#     key    = "state/statefile.tfstate"  # Path to the state file in S3
#     region = "us-east-1"  # The region of your S3 buckets.
#   }
# }

provider "aws" {
  region = "us-east-1"
}

# VPC
data "aws_vpc" "default" {
  default = true
}

# Default Subnet
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "APP_Auto"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "APP_ECS_Cluster"
  }
}