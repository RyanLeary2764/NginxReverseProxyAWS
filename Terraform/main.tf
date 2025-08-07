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

resource "aws_route_table" "NginxAWS_public_rt" {
  vpc_id = aws_vpc.NginxAWS_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.NginxAWS_igw.id
  }
  tags = {
    Name = "NginxAWS-Public-RT"
  }
}


resource "aws_route_table_association" "NginxAWS_public_rta" {
  subnet_id      = aws_subnet.NginxAWS_public_subnet.id
  route_table_id = aws_route_table.NginxAWS_public_rt.id
}

resource "aws_security_group" "NginxAWS_sg" {
  name        = "NginxAWS-sg"
  description = "Security group for Nginx application"
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

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "NginxAWS-SG"
  }
}

resource "aws_instance" "NginxAWS_server" {
  ami      ="ami-07d9b9ddc6cd8dd30"
  instance_type      = var.instance_type
  subnet_id      = aws_subnet.NginxAWS_public_subnet.id
  key_name      = "my-ec2-key"    

  vpc_security_group_ids = [aws_security_group.NginxAWS_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install docker.io -y
              sudo systemctl enable --now docker
              sudo usermod -aG docker ubuntu
              EOF

  tags = {
    Name = "NginxAWSApp"
  }
}



resource "aws_eip" "NginxAWS_eip" {
  instance = aws_instance.NginxAWS_server.id
  domain      = "vpc"
}
