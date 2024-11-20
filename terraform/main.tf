terraform {
  backend "s3" {
    bucket = "ashok-tf-state-bucket"  # Use a valid S3 bucket name
    key    = "path/to/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
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

# S3 Bucket for State
resource "aws_s3_bucket" "state_bucket" {
  bucket = "ashok-tf-state-bucket"  # Replace with a valid bucket name
  acl    = "private"

  tags = {
    Name = "terraform-state-bucket"
  }
}

# Manage ACL separately
resource "aws_s3_bucket_acl" "state_bucket_acl" {
  bucket = aws_s3_bucket.state_bucket.id
  acl    = "private"
}
