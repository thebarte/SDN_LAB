terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.52.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
  required_version = ">= 1.1.0"

  cloud {
    organization = "Terraform_Project_TELE36058
"

    workspaces {
      name = "SDNdev"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "random_pet" "sg" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


module "vpc" {
  source   = "./vpc"
  vpc_cidr = "192.168.0.0/16"
  subnet_cidrs = [
    "192.168.1.0/24",
    "192.168.2.0/24",
    "192.168.3.0/24"
  ]
  availability_zones = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]
}
module "security_group" {
  source = "./security_group"
  vpc_id = module.vpc.vpc_id
}

module "high_availability_infrastructure" {
  source            = "./high_availability_infrastructure"
  subnets           = module.vpc.subnet_ids
  ami_id            = "ami-0ee1b569239bf6c3e" # Replace with your custom AMI ID
  vpc_id            = module.vpc.vpc_id
  security_group_id = module.security_group.security_group_id
}
