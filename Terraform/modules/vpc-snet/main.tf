resource "aws_vpc" "NginxAWS_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "NginxAWS-VPC"
  }
}

resource "aws_internet_gateway" "NginxAWS_igw" {
  vpc_id = aws_vpc.NginxAWS_vpc.id
  tags = {
    Name = "NginxAWS-IGW"
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
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.NginxAWS_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


