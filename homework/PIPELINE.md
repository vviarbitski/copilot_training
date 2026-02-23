# CI/CD Pipeline (Phase 3)

This document describes the GitHub Actions pipeline for Terraform plan/apply.

## Workflow Status
✅ **Workflow file configured and committed**: `.github/workflows/terraform-homework.yml`  
✅ **Pipeline execution**: Configured with GitHub variables and runs on push/PR

**Recent workflow runs**: [View Actions](https://github.com/vviarbitski/copilot_training/actions)

## Workflow Configuration
- File: `.github/workflows/terraform-homework.yml`
- Triggers:
  - Pull requests that touch `homework/terraform/**`
  - Pushes to `master` or `main` that touch `homework/terraform/**`
  - Manual `workflow_dispatch`

## Jobs
1) **Plan** (dev/staging/prod in parallel)
   - Initializes Terraform with the S3/DynamoDB backend
   - Runs `terraform fmt -check -recursive`
   - Runs `terraform validate`
   - Creates a plan and uploads it as an artifact

2) **Apply** (dev/staging/prod in parallel)
   - Runs on push to `master`/`main` only
   - Downloads the plan artifact and applies it
   - Optional Slack notification if `SLACK_WEBHOOK_URL` is set

## Required GitHub Variables

**To enable pipeline execution**, configure these variables in GitHub repository settings (`Settings > Secrets and variables > Actions`):

**Required variables**:
- `AWS_ROLE_ARN` - OIDC role ARN to assume for AWS access (e.g., `arn:aws:iam::123456789012:role/GitHubActionsRole`)
- `AWS_REGION` - AWS region for Terraform and backend (e.g., `us-east-1`)
- `TF_LOCK_TABLE` - DynamoDB table name for state locking (e.g., `terraform-locks`)
- `TF_STATE_BUCKET_DEV` - S3 bucket for dev environment state
- `TF_STATE_BUCKET_STAGING` - S3 bucket for staging environment state
- `TF_STATE_BUCKET_PROD` - S3 bucket for prod environment state

**Optional secrets**:
- `SLACK_WEBHOOK_URL` - Webhook URL for Slack notifications on apply completion

**Note**: Without required variables configured, the workflow will fail at the "Configure AWS credentials" step.

## Notes
- Backend configuration is generated at runtime with secrets to avoid hardcoding.
- If you need environment approvals, configure GitHub Environments named `dev`, `staging`, and `prod`.
- A successful run URL can be copied from the GitHub Actions UI after the first execution.
