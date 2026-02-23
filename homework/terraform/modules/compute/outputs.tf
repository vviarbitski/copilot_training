output "asg_name" {
  value       = aws_autoscaling_group.main.name
  description = "Auto Scaling Group name."
}

output "asg_arn" {
  value       = aws_autoscaling_group.main.arn
  description = "Auto Scaling Group ARN."
}

output "instance_role_arn" {
  value       = aws_iam_role.instance.arn
  description = "IAM role ARN for EC2 instances."
}

output "instance_security_group_id" {
  value       = aws_security_group.instance.id
  description = "Security group ID for instances."
}
