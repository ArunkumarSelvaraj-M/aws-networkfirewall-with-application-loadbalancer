locals {
  vpc_name              = var.vpc_name
  vpc_cidr              = var.vpc_cidr
  availability_zone     = var.az_zone
  firewall_subnet       = var.firewall_subnet
  public_subnet         = var.public_subnet
  private_subnet        = var.private_subnet
  frg_type              = var.firewall_rule_group_type
  frg_port              = var.firewall_rule_group_port
  firewall_name         = var.firewall_name
  endpoint_filter_value = var.endpoint_filter_value
}
