# Homework - Terraform Infrastructure (Phase 2+)

This folder contains a complete Terraform codebase for the Task 1 architecture, with environment separation and a remote state backend, plus later phase improvements.

## Overview
The Terraform layout is split into three layers:
- `terraform/bootstrap`: Creates the S3 state bucket, DynamoDB lock table, and KMS key for state encryption.
- `terraform/root`: Root module that wires all infrastructure modules together.
- `terraform/environments/{dev,staging,prod}`: Environment-specific configurations that call the root module and use the remote backend.

## Prerequisites
- Terraform >= 1.6
- AWS credentials for the target account
- A unique S3 bucket name for state storage

## 1) Bootstrap the remote state backend
Run this once per AWS account/region. This step uses a local state file so the remote backend can be created.

```bash
cd terraform/bootstrap
terraform init
terraform apply
```

Outputs from `bootstrap` include the bucket name and DynamoDB table name to use in environment backends.

## 2) Configure the backend for each environment
Each environment folder includes a `backend.hcl` file. Update the bucket name, DynamoDB table name, and region, then run `terraform init` using that file.

Example for `dev`:

```bash
cd terraform/environments/dev
terraform init -backend-config=backend.hcl
```

Ensure the backend bucket names are globally unique.

## 3) Plan and apply an environment
Each environment uses `terraform.tfvars` for values such as CIDRs, instance sizes, and tags.

```bash
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

## Notes
- All resources are tagged via `default_tags` plus explicit `tags` arguments where required.
- IAM policies follow least-privilege and scope permissions to the specific resources they manage.
- Data sources are used for AMI lookup and account metadata.
- If you use SSE-KMS for artifacts, add CI/CD role ARNs to `kms_key_user_arns` so builds can read/write.

## Structure
```
terraform/
  bootstrap/
  root/
  modules/
    networking/
    alb/
    compute/
    ecr/
    s3/
    kms/
    observability/
    scheduler/
  environments/
    dev/
    staging/
    prod/
```
