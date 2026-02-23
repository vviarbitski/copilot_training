output "lambda_name" {
  value       = aws_lambda_function.main.function_name
  description = "Scheduler Lambda function name."
}

output "shutdown_rule_name" {
  value       = var.enable_night_shutdown ? aws_cloudwatch_event_rule.shutdown[0].name : null
  description = "EventBridge rule name for shutdown."
}

output "startup_rule_name" {
  value       = var.enable_night_shutdown ? aws_cloudwatch_event_rule.startup[0].name : null
  description = "EventBridge rule name for startup."
}
