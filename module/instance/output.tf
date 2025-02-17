output "deployer_key_name" {
  description = "The name of the deployer key pair"
  value       = aws_key_pair.deployer.key_name
}

output "ubuntu_ami_id" {
  description = "The AMI ID for the Ubuntu image"
  value       = data.aws_ami.ubuntu.id
}

output "nginx_instance_id" {
  description = "The instance ID of the NGINX server"
  value       = aws_instance.nginx.id
}

output "nginx_public_ip" {
  description = "The public IP of the NGINX server"
  value       = aws_instance.nginx.public_ip
}

output "apache_instance_id" {
  description = "The instance ID of the Apache server"
  value       = aws_instance.apache.id
}

output "apache_public_ip" {
  description = "The public IP of the Apache server"
  value       = aws_instance.apache.public_ip
}

output "allow_http_security_group_id" {
  description = "The security group ID for allowing HTTP traffic"
  value       = aws_security_group.allow_http.id
}

output "allow_ssh_security_group_id" {
  description = "The security group ID for allowing SSH traffic"
  value       = aws_security_group.allow_ssh.id
}

output "nginx_instance_private_ip" {
  description = "The private IP of the NGINX server"
  value       = aws_instance.nginx.private_ip
}

output "apache_instance_private_ip" {
  description = "The private IP of the Apache server"
  value       = aws_instance.apache.private_ip
}
