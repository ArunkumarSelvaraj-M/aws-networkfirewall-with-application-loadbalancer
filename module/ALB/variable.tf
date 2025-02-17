variable "load_balancer_name" {
  type        = string
  description = "The name of the Application Load Balancer (ALB) to be created."
}

variable "load_balancer_type" {
  type        = string
  description = "The type of load balancer. Valid values: 'application', 'network', or 'gateway'."
}

variable "instance_ids" {
  type        = list(string)
  description = "A list of EC2 instance IDs to be registered with the target group."
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the load balancer and target group will be deployed."
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs in which the ALB will be deployed."
}

variable "security_groups_ids" {
  type        = list(string)
  description = "A list of security group IDs associated with the ALB for controlling inbound and outbound traffic."
}

variable "port" {
  type        = number
  description = "The port number on which the target group will receive traffic (e.g., 80 for HTTP, 443 for HTTPS)."
}
