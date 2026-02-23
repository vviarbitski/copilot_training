output "cpu_high_alarm_arn" {
  value       = aws_cloudwatch_metric_alarm.cpu_high.arn
  description = "ARN of the high CPU alarm."
}

output "cpu_low_alarm_arn" {
  value       = aws_cloudwatch_metric_alarm.cpu_low.arn
  description = "ARN of the low CPU alarm."
}
