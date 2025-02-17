variable "region" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "cidr" {
  type = string
}

variable "zone" {
  type = list(string)
}

variable "firewall_subnet" {
  type = list(string)
}

variable "public_subnet" {
  type = list(string)
}

variable "private_subnet" {
  type = list(string)
}

variable "type" {
  type = string
}

variable "port" {
  type = list(number)
}

variable "firewall_name" {
  type        = string
  description = "description"
}

variable "filter_values" {
  type = list(string)
}


/* INSTANCE VARIABLES */

variable "key" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ssh_cidr" {
  type = string
}

/* Application Loadbalancer Variables */

variable "alb_name" {
  type = string
}

variable "lb_type" {
  type = string
}

variable "alb_port" {
  type = number
}