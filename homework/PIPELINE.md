# Task 2 CI/CD Pipeline (Phase 3)

This document describes the GitHub Actions pipeline for Terraform plan/apply.

## Workflow
- File: `.github/workflows/terraform-homework.yml`
- Triggers:
  - Pull requests that touch `copilot_training/homework/terraform/**`
  - Pushes to `main` that touch `copilot_training/homework/terraform/**`
  - Manual `workflow_dispatch`

## Jobs
1) Plan (dev/staging/prod)
- Initializes Terraform with the S3/DynamoDB backend.
- Runs `terraform fmt -check -recursive`.
- Runs `terraform validate`.
- Runs tfsec scan over `copilot_training/homework/terraform`.
- Creates a plan and uploads it as an artifact.

2) Apply (dev/staging/prod)
- Runs on push to `main` only.
- Downloads the plan artifact and applies it.
- Optional Slack notification if `SLACK_WEBHOOK_URL` is set.

## Required GitHub Secrets
- `AWS_ROLE_ARN` (OIDC role to assume)
- `AWS_REGION` (region for Terraform and backend)
- `TF_LOCK_TABLE` (DynamoDB lock table name)
- `TF_STATE_BUCKET_DEV`
- `TF_STATE_BUCKET_STAGING`
- `TF_STATE_BUCKET_PROD`

Optional:
- `SLACK_WEBHOOK_URL` for notifications

## Notes
- Backend configuration is generated at runtime with secrets to avoid hardcoding.
- If you need environment approvals, configure GitHub Environments named `dev`, `staging`, and `prod`.
- A successful run URL can be copied from the GitHub Actions UI after the first execution.
