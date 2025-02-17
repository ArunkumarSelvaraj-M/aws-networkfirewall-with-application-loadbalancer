output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_1a_id" {
  description = "The ID of the public subnet in Availability Zone 1a"
  value       = module.vpc.public_subnet_1a_id
}

output "public_subnet_1b_id" {
  description = "The ID of the public subnet in Availability Zone 1b"
  value       = module.vpc.public_subnet_1b_id
}

output "nginx_ip" {
  description = "The public IP address of the Nginx server instance"
  value       = module.instance.nginx_public_ip
}

output "apache_ip" {
  description = "The public IP address of the Apache server instance"
  value       = module.instance.apache_public_ip
}

output "allow_http_security_group_id" {
  description = "The security group ID that allows HTTP traffic"
  value       = module.instance.allow_http_security_group_id
}

output "allow_ssh_security_group_id" {
  description = "The security group ID that allows SSH access"
  value       = module.instance.allow_ssh_security_group_id
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = module.ALB.load_balancer_dns_name
}

output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = module.ALB.load_balancer_arn
}

output "load_balancer_id" {
  description = "The ID of the Application Load Balancer"
  value       = module.ALB.load_balancer_id
}
