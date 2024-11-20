# Provider Configuration
provider "aws" {
  region = "us-east-1"  # Specify the AWS region for all resources
}

# # Backend Configuration
# terraform {
#   backend "s3" {
#     bucket = "staefile"  # Replace with your S3 bucket name
#     key    = "path/to/terraform.tfstate"  # Specify the path for the state file in the bucket
#     region = "us-east-1"  # Replace with the region where the S3 bucket will be created
#     encrypt = true        # Enable encryption for the state file (recommended)
#   }
# }

# Create S3 Bucket for Terraform State File
resource "aws_s3_bucket" "state_bucket" {
  bucket = "state_bucket"  # Replace with your desired bucket name
  acl    = "private"

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "Dev"
  }
}

# VPC Data Source (Default VPC)
data "aws_vpc" "default" {
  default = true
}

# Default Subnets Data Source
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# ECS Cluster Resource
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
