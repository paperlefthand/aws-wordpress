output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_c.id]
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_c.id]
}

output "bastion_public_ip" {
  description = "The public IP of the bastion server"
  value       = aws_instance.bastion_host.public_ip
}

output "application_a_private_ip" {
  description = "The public IP of the app_server_a"
  value       = aws_instance.app_server_a.private_ip
}
output "application_c_private_ip" {
  description = "The public IP of the app_server_c"
  value       = aws_instance.app_server_c.private_ip
}
