output "ec2_public_dns" {
  value = aws_instance.realestate_server.public_dns
}

output "ec2_private_dns" {
  value = aws_instance.realestate_server.private_dns
}

output "ec2_public_ip" {
  value = aws_instance.realestate_server.public_ip
}

output "ec2_private_ip" {
  value = aws_instance.realestate_server.private_ip
}