data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda/scale_asg.py"
  output_path = "${path.module}/scale_asg.zip"
}

resource "null_resource" "lambda_archive" {
  triggers = {
    source_hash = filemd5("${path.module}/lambda/scale_asg.py")
  }

  provisioner "local-exec" {
    command = "cd ${path.module} && zip -j scale_asg.zip lambda/scale_asg.py || true"
  }
}

# EventBridge schedules invoke a small Lambda to set ASG desired capacity.

data "aws_iam_policy_document" "assume_lambda" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "${var.name_prefix}-scheduler-role"
  assume_role_policy = data.aws_iam_policy_document.assume_lambda.json
  tags               = var.tags
}

data "aws_iam_policy_document" "lambda" {
  statement {
    effect = "Allow"
    actions = [
      "autoscaling:UpdateAutoScalingGroup",
      "autoscaling:SetDesiredCapacity"
    ]
    resources = [var.asg_arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "autoscaling:DescribeAutoScalingGroups"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["${aws_cloudwatch_log_group.lambda.arn}:*"]
  }
}

resource "aws_iam_role_policy" "lambda" {
  name   = "${var.name_prefix}-scheduler-policy"
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.lambda.json
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.name_prefix}-scheduler"
  retention_in_days = var.log_retention_days
  tags              = var.tags
}

resource "aws_lambda_function" "main" {
  function_name = "${var.name_prefix}-scheduler"
  role          = aws_iam_role.lambda.arn
  handler       = "scale_asg.handler"
  runtime       = "python3.11"
  filename      = "${path.module}/scale_asg.zip"

  source_code_hash = base64sha256(file("${path.module}/lambda/scale_asg.py"))

  depends_on = [null_resource.lambda_archive]

  environment {
    variables = {
      ASG_NAME = var.asg_name
    }
  }

  tags = var.tags
}

resource "aws_cloudwatch_event_rule" "shutdown" {
  count               = var.enable_night_shutdown ? 1 : 0
  name                = "${var.name_prefix}-shutdown"
  schedule_expression = var.shutdown_cron
  tags                = var.tags
}

resource "aws_cloudwatch_event_rule" "startup" {
  count               = var.enable_night_shutdown ? 1 : 0
  name                = "${var.name_prefix}-startup"
  schedule_expression = var.startup_cron
  tags                = var.tags
}

resource "aws_cloudwatch_event_target" "shutdown" {
  count     = var.enable_night_shutdown ? 1 : 0
  rule      = aws_cloudwatch_event_rule.shutdown[0].name
  target_id = "shutdown"
  arn       = aws_lambda_function.main.arn

  input = jsonencode({
    target_capacity = var.shutdown_target_capacity
  })
}

resource "aws_cloudwatch_event_target" "startup" {
  count     = var.enable_night_shutdown ? 1 : 0
  rule      = aws_cloudwatch_event_rule.startup[0].name
  target_id = "startup"
  arn       = aws_lambda_function.main.arn

  input = jsonencode({
    target_capacity = var.startup_target_capacity
  })
}

resource "aws_lambda_permission" "shutdown" {
  count         = var.enable_night_shutdown ? 1 : 0
  statement_id  = "AllowExecutionFromShutdown"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.main.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.shutdown[0].arn
}

resource "aws_lambda_permission" "startup" {
  count         = var.enable_night_shutdown ? 1 : 0
  statement_id  = "AllowExecutionFromStartup"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.main.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.startup[0].arn
}
