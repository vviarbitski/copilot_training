# Phase 4 Cost Report

## Assumptions
- Region: eu-west-1
- 730 hours per month
- Example based on the `prod` environment defaults:
  - 3 x `t3.medium` instances (ASG desired capacity = 3)
  - 1 NAT gateway (optimized default)
  - 1 ALB
  - 30 GiB total gp3 EBS (10 GiB per instance)
- Costs are approximate and depend on usage (LCU, logs, data transfer, and storage).

## Estimated Monthly Cost (Example)
- EC2 (3 x t3.medium): $0.0464 \times 3 \times 730 = 101.7$
- EBS gp3 (30 GiB): $0.08 \times 30 = 2.4$
- NAT Gateway (1): $0.045 \times 730 = 32.9$
- ALB base: $0.027 \times 730 = 19.7$
- CloudWatch logs/alarms (light usage): ~$2.0
- S3 artifacts + DynamoDB lock table: ~$1.0

Estimated total: ~$159.7 per month

## Savings From Phase 4 Improvements
1) NAT gateway count default reduced from 2 to 1
- Savings per environment: $0.045 \times 730 = 32.9$/month

2) S3 Gateway Endpoint enabled by default
- Avoids NAT data processing for S3 traffic.
- Example savings if 100 GB/month of S3 traffic would have crossed NAT:
  - $0.045 \times 100 = 4.5$/month

## Total Estimated Savings (Example)
- $32.9 + 4.5 = 37.4$/month per environment (usage dependent)

## Cost Reduction Opportunities (Optional)
- Use `enable_nat_gateway = false` for dev with no outbound dependency; run updates via SSM Session Manager.
- Schedule dev/staging scale-to-zero for non-working hours (already supported).
- Use smaller instance types in dev/staging and keep `asg_desired_capacity = 1`.

## Notes
- Prices vary by region and may change; validate against the AWS Pricing Calculator before budgeting.
- If you enable interface endpoints (ECR, CloudWatch), include their hourly charges in totals.
