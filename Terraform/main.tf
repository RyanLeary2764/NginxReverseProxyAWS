terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    ansible = {
      source  = "ansible/ansible"
      version = "~> 1.0"
    }
  }

  backend "s3" {
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}


# ───────────────────────────────
# VPC + Subnet Module
# ───────────────────────────────
module "vpc_snet" {
  source = "./modules/vpc-snet"
  project = var.project
  contact = var.contact
}

# ───────────────────────────────
# Route Tables Module
# ───────────────────────────────
module "route_tables" {
  source = "./modules/route-tables"
  vpc_id     = module.vpc_snet.vpc_id
  subnet_id = module.vpc_snet.public_subnet_id
  project = var.project
  contact = var.contact

}

# ───────────────────────────────
# EC2 Module
# ───────────────────────────────
module "ec2" {
  source = "./modules/ec2"

  subnet_id = module.vpc_snet.public_subnet_id
  vpc_id    = module.vpc_snet.vpc_id
  sg_id     = module.vpc_snet.sg_id

  instance_type = var.instance_type
  public_key    = file("keys/id_rsa.pub")

  project = var.project
  contact = var.contact
}


