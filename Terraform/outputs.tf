output "NginxAWS_server_public_ip" {
  value = aws_eip.NginxAWS_eip.public_ip
}

output "NginxServerDNS" {
  value = aws_instance.NginxAWS_server.public_dns
}