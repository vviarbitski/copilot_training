variable "name_prefix" {
  type        = string
  description = "Prefix used for observability resources."
}

variable "asg_name" {
  type        = string
  description = "Auto Scaling Group name for alarms."
}

variable "alarm_cpu_high_threshold" {
  type        = number
  description = "CPU high threshold."
}

variable "alarm_cpu_low_threshold" {
  type        = number
  description = "CPU low threshold."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to CloudWatch alarms."
}
