variable "project_name" {
  type        = string
  description = "Project identifier used for naming."

  validation {
    condition     = length(var.project_name) > 0
    error_message = "project_name must not be empty."
  }
}

variable "environment" {
  type        = string
  description = "Deployment environment."

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "aws_region" {
  type        = string
  description = "AWS region for this environment."

  validation {
    condition     = length(var.aws_region) > 0
    error_message = "aws_region must not be empty."
  }
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid CIDR block."
  }
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnet CIDRs (one per AZ)."

  validation {
    condition     = length(var.public_subnet_cidrs) >= 2
    error_message = "public_subnet_cidrs must include at least two subnets."
  }
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDRs (one per AZ)."

  validation {
    condition     = length(var.private_subnet_cidrs) == length(var.public_subnet_cidrs)
    error_message = "private_subnet_cidrs must match the length of public_subnet_cidrs."
  }
}

variable "availability_zones" {
  type        = list(string)
  description = "Optional explicit AZ list. Leave empty to auto-select."
  default     = []

  validation {
    condition     = length(var.availability_zones) == 0 || length(var.availability_zones) == length(var.public_subnet_cidrs)
    error_message = "availability_zones must be empty or match the subnet list length."
  }
}

variable "subnet_az_count" {
  type        = number
  description = "Number of AZs to use when availability_zones is empty."
  default     = 2

  validation {
    condition     = var.subnet_az_count >= 2
    error_message = "subnet_az_count must be at least 2."
  }
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Whether to create NAT gateways for private subnets."
  default     = true
}

variable "nat_gateway_count" {
  type        = number
  description = "Number of NAT gateways to create (1 or per-AZ)."
  default     = 1

  validation {
    condition     = var.nat_gateway_count >= 1 && var.nat_gateway_count <= length(var.public_subnet_cidrs)
    error_message = "nat_gateway_count must be between 1 and the number of public subnets."
  }
}

variable "enable_s3_gateway_endpoint" {
  type        = bool
  description = "Create an S3 gateway endpoint for private subnets."
  default     = true
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for the Auto Scaling Group."
  default     = "t3.micro"
}

variable "ami_id" {
  type        = string
  description = "Optional AMI ID override. Leave empty to auto-select latest Amazon Linux 2."
  default     = ""
}

variable "user_data" {
  type        = string
  description = "User data script for EC2 instances."
  default     = ""
}

variable "asg_min_size" {
  type        = number
  description = "ASG minimum capacity."
  default     = 1
}

variable "asg_max_size" {
  type        = number
  description = "ASG maximum capacity."
  default     = 3
}

variable "asg_desired_capacity" {
  type        = number
  description = "ASG desired capacity."
  default     = 1
}

variable "alb_listener_port" {
  type        = number
  description = "ALB listener port."
  default     = 80
}

variable "alb_target_port" {
  type        = number
  description = "Target port for the application."
  default     = 8080
}

variable "alb_health_check_path" {
  type        = string
  description = "HTTP health check path for the target group."
  default     = "/health"
}

variable "enable_https" {
  type        = bool
  description = "Enable HTTPS on the ALB listener."
  default     = false
}

variable "acm_certificate_arn" {
  type        = string
  description = "ACM certificate ARN for HTTPS. Required if enable_https is true."
  default     = ""

  validation {
    condition     = var.enable_https == false || length(var.acm_certificate_arn) > 0
    error_message = "acm_certificate_arn is required when enable_https is true."
  }
}

variable "allowed_ingress_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach the ALB."

  validation {
    condition     = alltrue([for cidr in var.allowed_ingress_cidrs : can(cidrnetmask(cidr))])
    error_message = "allowed_ingress_cidrs must contain valid CIDR blocks."
  }
}

variable "enable_ssm" {
  type        = bool
  description = "Attach SSM managed policy to instances."
  default     = true
}

variable "root_volume_size" {
  type        = number
  description = "Root EBS volume size in GiB."
  default     = 10

  validation {
    condition     = var.root_volume_size >= 8
    error_message = "root_volume_size must be at least 8 GiB."
  }
}

variable "root_volume_type" {
  type        = string
  description = "Root EBS volume type."
  default     = "gp3"

  validation {
    condition     = contains(["gp3", "gp2", "io1", "io2", "st1", "sc1", "standard"], var.root_volume_type)
    error_message = "root_volume_type must be a valid EBS volume type."
  }
}

variable "root_volume_iops" {
  type        = number
  description = "Provisioned IOPS for gp3/io1/io2 volumes. Set 0 to use defaults."
  default     = 0

  validation {
    condition     = var.root_volume_iops >= 0
    error_message = "root_volume_iops must be 0 or greater."
  }
}

variable "root_volume_throughput" {
  type        = number
  description = "Provisioned throughput for gp3 volumes. Set 0 to use defaults."
  default     = 0

  validation {
    condition     = var.root_volume_throughput >= 0
    error_message = "root_volume_throughput must be 0 or greater."
  }
}

variable "ebs_kms_key_id" {
  type        = string
  description = "Optional KMS key ID/ARN for root volume encryption."
  default     = ""
}

variable "require_imdsv2" {
  type        = bool
  description = "Require IMDSv2 for instance metadata."
  default     = true
}

variable "metadata_hop_limit" {
  type        = number
  description = "IMDS hop limit for instance metadata."
  default     = 2

  validation {
    condition     = var.metadata_hop_limit >= 1 && var.metadata_hop_limit <= 64
    error_message = "metadata_hop_limit must be between 1 and 64."
  }
}

variable "ecr_repository_name" {
  type        = string
  description = "ECR repository name for the service image."
}

variable "enable_ecr_lifecycle_policy" {
  type        = bool
  description = "Enable ECR lifecycle policy."
  default     = true
}

variable "ecr_lifecycle_keep_last" {
  type        = number
  description = "Number of images to retain when lifecycle policy is enabled."
  default     = 10
}

variable "artifact_bucket_name" {
  type        = string
  description = "S3 bucket name for build artifacts."
}

variable "artifact_noncurrent_days" {
  type        = number
  description = "Days to retain noncurrent artifact versions."
  default     = 30
}

variable "log_retention_days" {
  type        = number
  description = "CloudWatch log retention in days."
  default     = 7
}

variable "alarm_cpu_high_threshold" {
  type        = number
  description = "CPU alarm high threshold for scaling alerting."
  default     = 70
}

variable "alarm_cpu_low_threshold" {
  type        = number
  description = "CPU alarm low threshold for idle alerting."
  default     = 20
}

variable "enable_night_shutdown" {
  type        = bool
  description = "Enable nightly scale-to-zero schedule."
  default     = true
}

variable "shutdown_cron" {
  type        = string
  description = "Cron expression for nightly shutdown."
  default     = "cron(0 20 ? * MON-FRI *)"
}

variable "startup_cron" {
  type        = string
  description = "Cron expression for startup."
  default     = "cron(0 6 ? * MON-FRI *)"
}

variable "shutdown_target_capacity" {
  type        = number
  description = "Desired capacity during shutdown window."
  default     = 0
}

variable "kms_key_admin_arns" {
  type        = list(string)
  description = "Additional principal ARNs with full KMS admin permissions."
  default     = []
}

variable "kms_key_user_arns" {
  type        = list(string)
  description = "Principal ARNs allowed to use the KMS key for encryption/decryption."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources."
}
