resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name
  tags   = var.tags
}

# Artifact bucket enforces SSE-KMS and blocks public access by default.

resource "aws_s3_bucket_ownership_controls" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_arn
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    id     = "expire-noncurrent"
    status = "Enabled"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_days
    }
  }
}

data "aws_iam_policy_document" "bucket" {
  count = var.enforce_ssl || var.enforce_sse_kms ? 1 : 0

  dynamic "statement" {
    for_each = var.enforce_ssl ? [1] : []
    content {
      sid     = "DenyInsecureTransport"
      effect  = "Deny"
      actions = ["s3:*"]
      resources = [
        aws_s3_bucket.main.arn,
        "${aws_s3_bucket.main.arn}/*"
      ]

      principals {
        type        = "*"
        identifiers = ["*"]
      }

      condition {
        test     = "Bool"
        variable = "aws:SecureTransport"
        values   = ["false"]
      }
    }
  }

  dynamic "statement" {
    for_each = var.enforce_sse_kms ? [1] : []
    content {
      sid     = "DenyUnencryptedUploads"
      effect  = "Deny"
      actions = ["s3:PutObject"]
      resources = [
        "${aws_s3_bucket.main.arn}/*"
      ]

      principals {
        type        = "*"
        identifiers = ["*"]
      }

      condition {
        test     = "StringNotEquals"
        variable = "s3:x-amz-server-side-encryption"
        values   = ["aws:kms"]
      }
    }
  }
}

resource "aws_s3_bucket_policy" "main" {
  count  = var.enforce_ssl || var.enforce_sse_kms ? 1 : 0
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.bucket[0].json
}
