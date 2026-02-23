variable "aws_region" {
  type        = string
  description = "AWS region for the state backend resources."

  validation {
    condition     = length(var.aws_region) > 0
    error_message = "aws_region must not be empty."
  }
}

variable "state_bucket_name" {
  type        = string
  description = "Globally unique S3 bucket name for Terraform state."

  validation {
    condition     = length(var.state_bucket_name) >= 3
    error_message = "state_bucket_name must be at least 3 characters."
  }
}

variable "lock_table_name" {
  type        = string
  description = "DynamoDB table name for state locking."

  validation {
    condition     = length(var.lock_table_name) > 0
    error_message = "lock_table_name must not be empty."
  }
}

variable "kms_key_alias" {
  type        = string
  description = "Alias for the KMS key used to encrypt the state bucket."
  default     = "alias/tf-state"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources."
}
