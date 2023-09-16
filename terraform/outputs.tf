output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_c.id]
}

output "elb_dns_name" {
  description = "The DNS name of the ELB"
  value       = aws_lb.elb.dns_name
}


output "public_ip_wordpress_server_a" {
  description = "The public IP of the wordpress_server_a"
  value       = aws_instance.wordpress_server_a.public_ip
}

output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.rds.endpoint
}
