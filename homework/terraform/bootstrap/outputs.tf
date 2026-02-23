output "state_bucket_name" {
  value       = aws_s3_bucket.state.id
  description = "S3 bucket name for Terraform state."
}

output "lock_table_name" {
  value       = aws_dynamodb_table.lock.name
  description = "DynamoDB table name for state locking."
}

output "state_kms_key_arn" {
  value       = aws_kms_key.state.arn
  description = "KMS key ARN for state encryption."
}
