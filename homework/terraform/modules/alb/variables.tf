variable "name_prefix" {
  type        = string
  description = "Prefix used for ALB resources."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the ALB."
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR used to scope ALB egress."
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs for the ALB."
}

variable "allowed_ingress_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach the ALB."

  validation {
    condition     = alltrue([for cidr in var.allowed_ingress_cidrs : can(cidrnetmask(cidr))])
    error_message = "allowed_ingress_cidrs must contain valid CIDRs."
  }
}

variable "listener_port" {
  type        = number
  description = "Listener port for the ALB."
}

variable "target_port" {
  type        = number
  description = "Target port for the service."
}

variable "health_check_path" {
  type        = string
  description = "Health check path for the target group."
}

variable "enable_https" {
  type        = bool
  description = "Enable HTTPS listener."
  default     = false
}

variable "acm_certificate_arn" {
  type        = string
  description = "ACM certificate ARN for HTTPS."
  default     = ""

  validation {
    condition     = var.enable_https == false || length(var.acm_certificate_arn) > 0
    error_message = "acm_certificate_arn is required when enable_https is true."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to ALB resources."
}
