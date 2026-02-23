output "bucket_name" {
  value       = aws_s3_bucket.main.bucket
  description = "Bucket name."
}

output "bucket_arn" {
  value       = aws_s3_bucket.main.arn
  description = "Bucket ARN."
}
