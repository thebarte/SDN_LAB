module "vpc" {
  source = "./vpc"
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
  source = "./high_availability_infrastructure"
  subnets = module.vpc.subnet_ids
  ami_id = "ami-0ee1b569239bf6c3e" # Replace with your custom AMI ID
  vpc_id = module.vpc.vpc_id
  security_group_id = module.security_group.security_group_id
}
