locals {
  load_balancer_name  = var.load_balancer_name
  load_balancer_type  = var.load_balancer_type
  instance_ids        = var.instance_ids
  vpc_id              = var.vpc_id
  subnet_ids          = var.subnet_ids
  security_groups_ids = var.security_groups_ids
  port                = var.port
}