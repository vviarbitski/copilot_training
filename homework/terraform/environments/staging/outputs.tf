output "alb_dns_name" {
  value = module.app.alb_dns_name
}

output "asg_name" {
  value = module.app.asg_name
}

output "ecr_repository_url" {
  value = module.app.ecr_repository_url
}

output "artifact_bucket_name" {
  value = module.app.artifact_bucket_name
}
