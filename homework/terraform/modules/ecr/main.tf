resource "aws_ecr_repository" "main" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"
  tags                 = var.tags
}

resource "aws_ecr_lifecycle_policy" "main" {
  count      = var.enable_lifecycle ? 1 : 0
  repository = aws_ecr_repository.main.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${var.lifecycle_keep_last} images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = var.lifecycle_keep_last
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
