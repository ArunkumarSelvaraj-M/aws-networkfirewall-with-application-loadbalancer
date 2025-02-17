locals {
  public_key = var.public_key
  instance_type = var.instance_type
  public_subnet_id = var.public_subnet_id
  vpc_id = var.vpc_id
  ssh_cidr = var.allow_ssh_cidr
}