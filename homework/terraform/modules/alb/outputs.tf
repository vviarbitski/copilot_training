output "alb_dns_name" {
  value       = aws_lb.main.dns_name
  description = "ALB DNS name."
}

output "alb_security_group_id" {
  value       = aws_security_group.alb.id
  description = "Security group ID for the ALB."
}

output "target_group_arn" {
  value       = aws_lb_target_group.main.arn
  description = "Target group ARN for the service."
}

output "alb_arn" {
  value       = aws_lb.main.arn
  description = "ALB ARN."
}
