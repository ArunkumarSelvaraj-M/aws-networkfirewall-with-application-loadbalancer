module "vpc" {
  source                   = "./module/vpc"
  vpc_name                 = var.vpc_name
  vpc_cidr                 = var.cidr
  az_zone                  = var.zone
  firewall_subnet          = var.firewall_subnet
  public_subnet            = var.public_subnet
  private_subnet           = var.private_subnet
  firewall_rule_group_type = var.type
  firewall_rule_group_port = var.port
  firewall_name            = var.firewall_name
  endpoint_filter_value    = var.filter_values
}

module "instance" {
  source           = "./module/instance"
  public_key       = var.key
  instance_type    = var.instance_type
  public_subnet_id = [module.vpc.public_subnet_1a_id, module.vpc.public_subnet_1b_id]
  vpc_id           = module.vpc.vpc_id
  allow_ssh_cidr   = var.ssh_cidr
  depends_on       = [module.vpc]
}

module "ALB" {
  source              = "./module/ALB"
  load_balancer_name  = var.alb_name
  load_balancer_type  = var.lb_type
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = [module.vpc.public_subnet_1a_id, module.vpc.public_subnet_1b_id]
  security_groups_ids = [module.instance.allow_http_security_group_id, module.instance.allow_ssh_security_group_id]
  instance_ids        = [module.instance.nginx_instance_id, module.instance.apache_instance_id]
  port                = var.alb_port
  depends_on          = [module.instance]
}
