variable "public_key" {
  description = "The SSH public key used for accessing the instance"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance (e.g., t2.micro, t3.medium)"
  type        = string
}

variable "public_subnet_id" {
  description = "The ID of the public subnet where the instance will be launched"
  type        = list(string)
}


variable "vpc_id" {
  description = "The ID of the VPC where the instance and networking components are deployed"
  type        = string
}

variable "allow_ssh_cidr" {
  description = "The CIDR block allowed to access the instance via SSH (e.g., 0.0.0.0/0 for open access)"
  type        = string
}
