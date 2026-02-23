output "key_arn" {
  value       = aws_kms_key.main.arn
  description = "KMS key ARN."
}

output "key_id" {
  value       = aws_kms_key.main.key_id
  description = "KMS key ID."
}
