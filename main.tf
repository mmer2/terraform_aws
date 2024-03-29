#--root/main.tf
module "networking" {
  source           = "./networking"
  vpc_cidr         = local.vpc_cidr
  access_ip        = var.access_ip
  security_groups  = local.security_groups
  public_sn_count  = 2
  private_sn_count = 3
  max_subnets      = 20
  public_cidrs     = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs    = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  db_subnet_group  = true

}

module "database" {
  source                 = "./database"
  db_storage             = 10
  db_engine_version      = "8.0.33"
  db_instance_class      = "db.t2.micro"
  db_name                = var.db_name
  dbuser                 = var.db_user
  dbpassword             = var.db_password
  db_identifier          = "mtc-db"
  db_skip_db_snapshot    = true
  db_subnet_group_name   = module.networking.db_subnet_name[0]
  vpc_security_group_ids = module.networking.vpc_sec_group_ids

}

module "loadbalancing" {
  source                 = "./loadbalancing"
  public_sg              = module.networking.public_sg
  public_subnets         = module.networking.public_subnets
  tg_port                = 80
  tg_protocol            = "HTTP"
  vpc_id                 = module.networking.vpc_id
  lb_healthy_threshold   = 2
  lb_unhealthy_threshold = 2
  lb_timeout             = 3
  lb_interval            = 30
  listener_port          = 80
  listener_protocol      = "HTTP"

}

module "compute" {
  source              = "./compute"
  instance_count      = 2
  instance_type       = "t3.micro"
  public_sg           = module.networking.public_sg
  public_subnets      = module.networking.public_subnets
  vol_size            = 10
  key_name            = "kube_rsa"
  public_key_path     = "~/.ssh/kube_rsa.pub"
  user_data_path      = "${path.root}/userdata.tpl"
  db_name             = var.db_name
  db_pass             = var.db_password
  db_user             = var.db_user
  db_endpoint         = module.database.database_endpoint
  lb_target_group_arn = module.loadbalancing.lb_target_group_arn
  target_group_port   = 8000
  private_key_path = "/home/mmer2/.ssh/kube_rsa"

}