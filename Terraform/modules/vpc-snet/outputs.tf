output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = [aws_subnet.public.id, aws_subnet.private.id]
}

output "igw_id" {
  value = aws_internet_gateway.main.id
}
