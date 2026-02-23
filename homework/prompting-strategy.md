# Prompting Strategy (Task 2)

Goal: Generate a complete, modular Terraform codebase for the Task 1 architecture while meeting the Phase 2 requirements.

## Core prompts used
1) Root module composition
"Generate a Terraform root module that wires together networking, ALB, compute (ASG), ECR, S3 artifact bucket, KMS key, CloudWatch alarms, and EventBridge-driven Lambda for nightly scale-to-zero. Use variables/outputs, apply tags, and include comments explaining design decisions."

2) Module generation
"Generate Terraform module <MODULE_NAME> with variables, outputs, validation, and least-privilege IAM. Use AWS data sources where appropriate and tag all supported resources."

3) Environment separation
"Generate environment folders (dev/staging/prod) with backend configuration and tfvars. Each environment should call the root module and override only what is environment-specific."

4) Remote state backend
"Generate a bootstrap stack that creates the S3 backend bucket, DynamoDB lock table, and KMS key for state encryption. Include outputs for backend configuration."

## Quality checks embedded in prompts
- Ask the model to include variable validation on all CIDR and enum-style fields.
- Require least-privilege IAM policies for Lambda and EC2 roles.
- Require tags on all taggable resources (or via provider default tags).
- Require comments that explain design decisions, not trivial steps.

## Iteration strategy
- Start with the root module wiring and variables to lock the interface.
- Generate each module against the root module interface, then validate outputs.
- Generate environment folders last to avoid drift.

## Manual adjustments allowed (per constraints)
- Fixing syntax errors AI cannot resolve.
- Adjusting AI-generated configurations that do not meet requirements.
- Writing this prompting strategy document.
