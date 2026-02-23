variable "name_prefix" {
  type        = string
  description = "Prefix used for scheduler resources."
}

variable "enable_night_shutdown" {
  type        = bool
  description = "Enable scheduled scale actions."
  default     = true
}

variable "shutdown_cron" {
  type        = string
  description = "Cron expression for shutdown."
}

variable "startup_cron" {
  type        = string
  description = "Cron expression for startup."
}

variable "shutdown_target_capacity" {
  type        = number
  description = "Desired capacity during shutdown."
  default     = 0
}

variable "startup_target_capacity" {
  type        = number
  description = "Desired capacity on startup."
  default     = 1
}

variable "asg_name" {
  type        = string
  description = "Auto Scaling Group name."
}

variable "asg_arn" {
  type        = string
  description = "Auto Scaling Group ARN."
}

variable "log_retention_days" {
  type        = number
  description = "Retention for Lambda logs."
  default     = 7
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to scheduler resources."
}
