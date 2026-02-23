data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

locals {
  root_arn = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"
}

data "aws_iam_policy_document" "key" {
  # Key policy grants full admin to root/admins and scoped usage to specific principals.
  statement {
    sid     = "AllowRootAdmin"
    effect  = "Allow"
    actions = ["kms:*"]

    principals {
      type        = "AWS"
      identifiers = concat([local.root_arn], var.admin_principal_arns)
    }

    resources = ["*"]
  }

  dynamic "statement" {
    for_each = length(var.user_principal_arns) > 0 ? [1] : []
    content {
      sid    = "AllowKeyUsage"
      effect = "Allow"
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ]

      principals {
        type        = "AWS"
        identifiers = var.user_principal_arns
      }

      resources = ["*"]
    }
  }
}

resource "aws_kms_key" "main" {
  description             = "KMS key for ${var.name_prefix}"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.key.json
  tags                    = merge(var.tags, { Name = "${var.name_prefix}-kms" })
}

resource "aws_kms_alias" "main" {
  name          = "alias/${var.name_prefix}"
  target_key_id = aws_kms_key.main.key_id
}
