variable "bucket_name" {
  type        = string
  description = "S3 bucket name."
}

variable "kms_key_arn" {
  type        = string
  description = "KMS key ARN for bucket encryption."
}

variable "noncurrent_days" {
  type        = number
  description = "Days to retain noncurrent object versions."
  default     = 30
}

variable "enforce_ssl" {
  type        = bool
  description = "Deny non-TLS access to the bucket."
  default     = true
}

variable "enforce_sse_kms" {
  type        = bool
  description = "Deny uploads that do not use SSE-KMS."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the bucket."
}
