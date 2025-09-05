output "public_ip" {
  value = aws_eip.NginxAWS_eip.public_ip
}

output "public_dns" {
  value = aws_instance.NginxAWS_server.public_dns
}
