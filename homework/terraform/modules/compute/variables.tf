variable "name_prefix" {
  type        = string
  description = "Prefix used for compute resources."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for instances."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for the ASG."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
}

variable "ami_id" {
  type        = string
  description = "Optional AMI ID override."
  default     = ""
}

variable "user_data" {
  type        = string
  description = "User data script for instances."
  default     = ""
}

variable "asg_min_size" {
  type        = number
  description = "ASG minimum size."
}

variable "asg_max_size" {
  type        = number
  description = "ASG maximum size."
}

variable "asg_desired_capacity" {
  type        = number
  description = "ASG desired capacity."
}

variable "target_port" {
  type        = number
  description = "Port exposed by the application."
}

variable "alb_target_group_arn" {
  type        = string
  description = "Target group ARN for the ASG."
}

variable "alb_security_group_id" {
  type        = string
  description = "Security group ID for the ALB."
}

variable "enable_ssm" {
  type        = bool
  description = "Attach SSM managed policy."
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
  description = "Provisioned IOPS for gp3/io1/io2 volumes. Set 0 to use AWS defaults."
  default     = 0
}

variable "root_volume_throughput" {
  type        = number
  description = "Provisioned throughput (MiB/s) for gp3 volumes. Set 0 to use AWS defaults."
  default     = 0
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

variable "tags" {
  type        = map(string)
  description = "Tags applied to compute resources."
}
