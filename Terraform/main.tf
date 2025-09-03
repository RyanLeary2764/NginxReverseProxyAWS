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
    bucket         = var.tf_state_bucket
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = var.tf_state_lock_table
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "ansible" {
  inventory_file = "${path.module}/inventory.ini"
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
  subnet_ids = module.vpc_snet.subnet_ids
  igw_id = module.vpc_snet.igw_id

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
  public_key    = var.public_key
  project       = var.project
  contact       = var.contact
}

# ───────────────────────────────
# Ansible Playbook Execution (optional)
# ───────────────────────────────
resource "ansible_playbook" "deploy" {
  playbook = "${path.module}/ansible/playbook.yml"

  extra_vars = {
    ansible_user        = "ec2-user"
    ansible_host        = module.ec2.public_ip
    ansible_ssh_private_key_file = "${path.module}/id_rsa"
  }
}
