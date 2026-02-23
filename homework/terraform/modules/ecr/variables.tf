variable "repository_name" {
  type        = string
  description = "ECR repository name."
}

variable "enable_lifecycle" {
  type        = bool
  description = "Enable lifecycle policy."
  default     = true
}

variable "lifecycle_keep_last" {
  type        = number
  description = "Number of images to retain."
  default     = 10
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the repository."
}
