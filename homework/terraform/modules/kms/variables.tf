variable "name_prefix" {
  type        = string
  description = "Prefix used for KMS resources."
}

variable "admin_principal_arns" {
  type        = list(string)
  description = "Principal ARNs with full KMS admin permissions."
  default     = []
}

variable "user_principal_arns" {
  type        = list(string)
  description = "Principal ARNs allowed to use the key."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to KMS resources."
}
