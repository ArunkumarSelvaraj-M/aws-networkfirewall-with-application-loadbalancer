variable "vpc_name" {
  type        = string
  description = "The name of the VPC where resources will be deployed"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC (e.g., 10.0.0.0/16)"
}

variable "az_zone" {
  type        = list(string)
  description = "A list of availability zones to distribute resources across for high availability"

  validation {
    condition     = length(var.az_zone) >= 2
    error_message = "At least two availability zones must be specified."
  }
}

variable "firewall_subnet" {
  type        = list(string)
  description = "A list of subnets designated for firewall deployment"

  validation {
    condition     = length(var.firewall_subnet) >= 2
    error_message = "At least two firewall subnets must be specified."
  }
}

variable "public_subnet" {
  type        = list(string)
  description = "A list of public subnets where publicly accessible resources will be deployed"

  validation {
    condition     = length(var.public_subnet) >= 2
    error_message = "At least two public subnets must be specified."
  }
}

variable "private_subnet" {
  type        = list(string)
  description = "A list of private subnets for internal resource deployment"

  validation {
    condition     = length(var.private_subnet) >= 2
    error_message = "At least two private subnets must be specified."
  }
}

variable "firewall_rule_group_type" {
  type        = string
  description = "The type of firewall rule group (e.g., stateful, stateless)"
}

variable "firewall_rule_group_port" {
  type        = list(number)
  description = "A list of port numbers to be included in the firewall rule group"

  validation {
    condition     = length(var.firewall_rule_group_port) >= 2
    error_message = "At least two ports must be specified in the firewall rule group."
  }
}

variable "firewall_name" {
  type        = string
  description = "The name of the firewall resource"
}

variable "endpoint_filter_value" {
  type        = list(string)
  description = "A list of filter values used for endpoint configurations"

  validation {
    condition     = length(var.endpoint_filter_value) >= 2
    error_message = "At least two endpoint filter values must be specified."
  }
}
