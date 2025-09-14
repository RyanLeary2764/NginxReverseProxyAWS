resource "aws_vpc" "NginxAWS_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "NginxAWS-VPC"
  }
}


resource "aws_subnet" "NginxAWS_public_subnet" {
  vpc_id                  = aws_vpc.NginxAWS_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "NginxAWS-Public-Subnet"
  }
}

resource "aws_security_group" "NginxAWS_sg" {
  name        = "NginxAWS_sg"
  description = "Allow traffic as defined by user"
  vpc_id      = aws_vpc.NginxAWS_vpc.id

  dynamic "ingress" {
    for_each = { for k, v in var.security_group_rules : k => v if v.type == "ingress" }
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = { for k, v in var.security_group_rules : k => v if v.type == "egress" }
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}





