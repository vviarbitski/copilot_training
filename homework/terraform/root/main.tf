data "aws_availability_zones" "available" {}

locals {
  azs         = length(var.availability_zones) > 0 ? var.availability_zones : slice(data.aws_availability_zones.available.names, 0, var.subnet_az_count)
  name_prefix = "${var.project_name}-${var.environment}"
  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
  })
}

# Network layer is separated for reuse and clearer blast radius when changed.
module "networking" {
  source                     = "../modules/networking"
  name_prefix                = local.name_prefix
  vpc_cidr                   = var.vpc_cidr
  public_subnet_cidrs        = var.public_subnet_cidrs
  private_subnet_cidrs       = var.private_subnet_cidrs
  availability_zones         = local.azs
  enable_nat_gateway         = var.enable_nat_gateway
  nat_gateway_count          = var.nat_gateway_count
  enable_s3_gateway_endpoint = var.enable_s3_gateway_endpoint
  tags                       = local.common_tags
}

# Dedicated KMS key keeps artifact encryption separate from the state key.
module "kms" {
  source               = "../modules/kms"
  name_prefix          = local.name_prefix
  admin_principal_arns = var.kms_key_admin_arns
  user_principal_arns  = var.kms_key_user_arns
  tags                 = local.common_tags
}

module "s3_artifacts" {
  source          = "../modules/s3"
  bucket_name     = var.artifact_bucket_name
  kms_key_arn     = module.kms.key_arn
  noncurrent_days = var.artifact_noncurrent_days
  tags            = local.common_tags
}

module "ecr" {
  source              = "../modules/ecr"
  repository_name     = var.ecr_repository_name
  enable_lifecycle    = var.enable_ecr_lifecycle_policy
  lifecycle_keep_last = var.ecr_lifecycle_keep_last
  tags                = local.common_tags
}

module "alb" {
  source                = "../modules/alb"
  name_prefix           = local.name_prefix
  vpc_id                = module.networking.vpc_id
  vpc_cidr              = var.vpc_cidr
  public_subnet_ids     = module.networking.public_subnet_ids
  allowed_ingress_cidrs = var.allowed_ingress_cidrs
  listener_port         = var.alb_listener_port
  target_port           = var.alb_target_port
  health_check_path     = var.alb_health_check_path
  enable_https          = var.enable_https
  acm_certificate_arn   = var.acm_certificate_arn
  tags                  = local.common_tags
}

module "compute" {
  source                 = "../modules/compute"
  name_prefix            = local.name_prefix
  vpc_id                 = module.networking.vpc_id
  private_subnet_ids     = module.networking.private_subnet_ids
  instance_type          = var.instance_type
  ami_id                 = var.ami_id
  user_data              = var.user_data
  asg_min_size           = var.asg_min_size
  asg_max_size           = var.asg_max_size
  asg_desired_capacity   = var.asg_desired_capacity
  target_port            = var.alb_target_port
  alb_target_group_arn   = module.alb.target_group_arn
  alb_security_group_id  = module.alb.alb_security_group_id
  enable_ssm             = var.enable_ssm
  root_volume_size       = var.root_volume_size
  root_volume_type       = var.root_volume_type
  root_volume_iops       = var.root_volume_iops
  root_volume_throughput = var.root_volume_throughput
  ebs_kms_key_id         = var.ebs_kms_key_id
  require_imdsv2         = var.require_imdsv2
  metadata_hop_limit     = var.metadata_hop_limit
  tags                   = local.common_tags
}

module "observability" {
  source                   = "../modules/observability"
  name_prefix              = local.name_prefix
  asg_name                 = module.compute.asg_name
  alarm_cpu_high_threshold = var.alarm_cpu_high_threshold
  alarm_cpu_low_threshold  = var.alarm_cpu_low_threshold
  tags                     = local.common_tags
}

# EventBridge + Lambda is used for scale-to-zero to minimize ongoing costs.
module "scheduler" {
  source                   = "../modules/scheduler"
  name_prefix              = local.name_prefix
  enable_night_shutdown    = var.enable_night_shutdown
  shutdown_cron            = var.shutdown_cron
  startup_cron             = var.startup_cron
  shutdown_target_capacity = var.shutdown_target_capacity
  startup_target_capacity  = var.asg_desired_capacity
  asg_name                 = module.compute.asg_name
  asg_arn                  = module.compute.asg_arn
  log_retention_days       = var.log_retention_days
  tags                     = local.common_tags
}
