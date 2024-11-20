terraform {
  backend "s3" {
    bucket = "ashoktf2"  # Replace with your S3 bucket name
    key    = "path/to/terraform.tfstate"  # Specify the path for the state file in the bucket
    region = "us-east-1"                  # Replace with your desired AWS region
    encrypt = true                        # Enable encryption for the state file (optional but recommended)
  }
}


provider "aws" {
  region = "us-east-1"
}

# VPC
data "aws_vpc" "default" {
  default = true
}

# Default Subnets
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