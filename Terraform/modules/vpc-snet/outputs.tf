output "vpc_id" {
  value = aws_vpc.NginxAWS_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.NginxAWS_public_subnet.id
}


output "sg_id" {
  value = aws_security_group.NginxAWS_sg.id
}
