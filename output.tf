output "aws_web_server_public_ip_1" {
  value = aws_instance.two-tier-web-1.public_ip
}

output "aws_web_server_public_ip_2"{
  value = aws_instance.two-tier-web-2.public_ip
}