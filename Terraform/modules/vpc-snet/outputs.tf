output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}


output "sg_id" {
  value = aws_security_group.sg.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}
