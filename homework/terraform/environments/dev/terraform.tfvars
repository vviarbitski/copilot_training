project_name = "copilot-training"
environment  = "dev"
aws_region   = "eu-west-1"

vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
availability_zones   = []
subnet_az_count      = 2

enable_nat_gateway = true
nat_gateway_count  = 1

instance_type = "t3.micro"
ami_id        = ""
user_data     = "#!/bin/bash\nset -e\nyum update -y\nyum install -y python3\ncd /home/ec2-user\npython3 -m http.server 8080 &\n"

asg_min_size         = 0
asg_max_size         = 3
asg_desired_capacity = 0

alb_listener_port     = 80
alb_target_port       = 8080
alb_health_check_path = "/health"

enable_https        = false
acm_certificate_arn = ""

allowed_ingress_cidrs = ["0.0.0.0/0"]
enable_ssm            = true

ecr_repository_name         = "copilot-training-dev"
enable_ecr_lifecycle_policy = true
ecr_lifecycle_keep_last     = 10

artifact_bucket_name     = "replace-me-dev-artifacts"
artifact_noncurrent_days = 30

log_retention_days       = 7
alarm_cpu_high_threshold = 70
alarm_cpu_low_threshold  = 20

enable_night_shutdown    = true
shutdown_cron            = "cron(0 20 ? * MON-FRI *)"
startup_cron             = "cron(0 6 ? * MON-FRI *)"
shutdown_target_capacity = 0

kms_key_admin_arns = []
kms_key_user_arns  = []

tags = {
  owner       = "platform-team"
  cost_center = "training"
}
