output "vpc_id" {
  value       = module.networking.vpc_id
  description = "VPC ID for the environment."
}

output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "ALB DNS name."
}

output "asg_name" {
  value       = module.compute.asg_name
  description = "Auto Scaling Group name."
}

output "ecr_repository_url" {
  value       = module.ecr.repository_url
  description = "ECR repository URL."
}

output "artifact_bucket_name" {
  value       = module.s3_artifacts.bucket_name
  description = "S3 bucket for artifacts."
}

output "scheduler_lambda_name" {
  value       = module.scheduler.lambda_name
  description = "Lambda function used for scheduled scale actions."
}
