output "NginxAWS_server_public_ip" {
  value = module.ec2.public_ip
}

output "NginxServerDNS" {
  value = module.ec2.public_dns
}
