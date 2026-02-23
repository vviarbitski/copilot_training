# Task 4 Improvement Report

## Summary
This report covers code optimization, security hardening, and cost improvements applied after Task 2.

## 1) Code Optimization
- Reduced duplication by wiring new shared settings through the root module rather than per-environment overrides.
- Added optional S3 gateway endpoint support to reduce NAT egress for S3 traffic.

Key changes:
- Networking endpoint support: [copilot_training/homework/terraform/modules/networking/main.tf](copilot_training/homework/terraform/modules/networking/main.tf)
- Root wiring for endpoint and compute hardening: [copilot_training/homework/terraform/root/main.tf](copilot_training/homework/terraform/root/main.tf)

## 2) Security Hardening
Vulnerabilities and fixes:
- IMDSv1 allowed by default on EC2 Launch Templates.
  - Fix: Enforced IMDSv2 via `metadata_options`.
  - File: [copilot_training/homework/terraform/modules/compute/main.tf](copilot_training/homework/terraform/modules/compute/main.tf)
- Root volumes could be unencrypted or use default encryption without explicit control.
  - Fix: Explicit encrypted root volume configuration with optional KMS key.
  - File: [copilot_training/homework/terraform/modules/compute/main.tf](copilot_training/homework/terraform/modules/compute/main.tf)
- Artifact bucket lacked a policy to enforce TLS and SSE-KMS.
  - Fix: Added bucket policy to deny non-TLS access and non-SSE-KMS uploads.
  - File: [copilot_training/homework/terraform/modules/s3/main.tf](copilot_training/homework/terraform/modules/s3/main.tf)
- ALB security group egress allowed all destinations.
  - Fix: Scoped egress to VPC CIDR only.
  - File: [copilot_training/homework/terraform/modules/alb/main.tf](copilot_training/homework/terraform/modules/alb/main.tf)

## 3) Cost Optimization
- Default NAT gateway count reduced from 2 to 1 for cost savings in non-critical environments.
  - Files: [copilot_training/homework/terraform/root/variables.tf](copilot_training/homework/terraform/root/variables.tf), [copilot_training/homework/terraform/modules/networking/variables.tf](copilot_training/homework/terraform/modules/networking/variables.tf)
- Added an optional S3 gateway endpoint to reduce NAT data processing charges.
  - File: [copilot_training/homework/terraform/modules/networking/main.tf](copilot_training/homework/terraform/modules/networking/main.tf)

## Security Best Practices Applied
- Least privilege preserved for Lambda and EC2 roles.
- Enforced encryption-in-transit and encryption-at-rest for S3 artifacts.
- Hardened instance metadata access (IMDSv2).

## Follow-up Recommendations
- Consider enabling HTTPS on the ALB for production with ACM.
- Add CloudWatch log group encryption if compliance requires it.
- Use VPC interface endpoints for ECR only if NAT data costs become significant (interface endpoints have hourly costs).
