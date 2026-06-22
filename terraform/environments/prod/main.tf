terraform {

  required_version = ">= 1.6.0"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {

  region = var.aws_region
}

module "networking" {

  source = "../../modules/networking"

  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"

  availability_zone = var.availability_zone
}

module "firewall" {

  source = "../../modules/firewall"

  vpc_id = module.networking.vpc_id

  allowed_ssh_cidr = var.allowed_ssh_cidr
}

module "vps" {

  source = "../../modules/vps"

  ami_id = var.ami_id

  instance_type = var.instance_type

  subnet_id = module.networking.subnet_id

  security_group_id = module.firewall.security_group_id

  key_name = var.key_name
}