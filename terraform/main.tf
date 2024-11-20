# Step 2: Configure the Terraform backend with S3
terraform {
  backend "s3" {
    bucket = "ashok-tf"  # Use the same bucket name
    key    = "terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"
}

# Step 3: VPC Data Source
data "aws_vpc" "default" {
  default = true
}

# Step 4: Default Subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Step 5: ECS Cluster
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
