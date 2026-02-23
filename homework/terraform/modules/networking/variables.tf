variable "name_prefix" {
  type        = string
  description = "Prefix used for naming network resources."
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block."

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid CIDR block."
  }
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnet CIDRs in each AZ."

  validation {
    condition     = length(var.public_subnet_cidrs) >= 2
    error_message = "public_subnet_cidrs must include at least two subnets."
  }
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDRs in each AZ. Should match public subnet count."

  validation {
    condition     = length(var.private_subnet_cidrs) > 0
    error_message = "private_subnet_cidrs must contain at least one CIDR."
  }
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability Zones aligned with subnets."
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Create NAT gateways for private subnets."
  default     = true
}

variable "nat_gateway_count" {
  type        = number
  description = "Number of NAT gateways to create. Must not exceed public subnet count."
  default     = 1

  validation {
    condition     = var.nat_gateway_count >= 1
    error_message = "nat_gateway_count must be at least 1."
  }
}

variable "enable_s3_gateway_endpoint" {
  type        = bool
  description = "Create an S3 gateway endpoint for private subnets."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to network resources."
}
