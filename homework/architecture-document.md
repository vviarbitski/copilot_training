# Architecture Document

## Overview
A temporary, low-cost staging environment for a small service in AWS. The design is highly available, supports horizontal scaling, includes nightly shutdown to reduce cost, and is easy to tear down.

## Assumptions
- Stateless service with a health endpoint at `/health`.
- Low traffic with short-lived test usage.
- Multi-AZ availability within one region.

## Tool Selection and Justification
- Compute: EC2 Auto Scaling Group
  - Why: Lowest cost for always-on staging, HA across AZs, supports scaling.
  - Alternative: ECS Fargate (simpler ops but higher steady-state cost).
- Load Balancer: Application Load Balancer
  - Why: Managed, HA, health checks, flexible routing.
- Container Registry: ECR
  - Why: AWS-native, IAM integration, low cost.
- CI/CD: GitHub Actions with AWS OIDC
  - Why: Fast setup, minimal ops, secure short-lived credentials.
- Secrets: SSM Parameter Store
  - Why: Low cost, simple IAM-controlled access. Use Secrets Manager if rotation is required.
- Observability: CloudWatch Logs/Alarms
  - Why: Managed monitoring and alerting.
- Nightly Stop: EventBridge + Lambda
  - Why: Scheduled scale-to-zero to reduce cost.
- Terraform State: S3 + DynamoDB
  - Why: Durable remote state with locking.

## Terraform Parameters
### Networking
- aws_region (required, default: eu-west-1)
- vpc_cidr (required, example: 10.0.0.0/16)
- public_subnet_cidrs (required, example: ["10.0.1.0/24","10.0.2.0/24"])
- private_subnet_cidrs (required, example: ["10.0.11.0/24","10.0.12.0/24"])
- availability_zones (required, example: ["eu-west-1a","eu-west-1b"])
- enable_nat_gateway (optional, default: true)
- nat_gateway_count (optional, default: 2)

### Compute
- instance_type (required, default: t3.micro)
- ami_id (required, example: latest Amazon Linux 2)
- asg_min_size (required, default: 1)
- asg_max_size (required, default: 3)
- asg_desired_capacity (required, default: 1)
- user_data (optional, default: bootstrap + container runtime)

### Load Balancing
- alb_enable (required, default: true)
- alb_listener_port (required, default: 80)
- alb_target_port (required, default: 8080)
- alb_health_check_path (required, default: /health)
- enable_https (optional, default: false)
- acm_certificate_arn (optional, required if enable_https=true)

### Containers and Artifacts
- ecr_repository_name (required)
- image_tag (required, default: latest)
- artifact_bucket_name (required)
- enable_ecr_lifecycle_policy (optional, default: true)
- ecr_lifecycle_keep_last (optional, default: 10)

### Security
- allowed_ingress_cidrs (required, example: ["0.0.0.0/0"] or office IPs)
- enable_ssm (optional, default: true)
- kms_key_arn (optional, for S3/SSM encryption)
- instance_security_group_rules (required)

### Observability
- log_retention_days (optional, default: 7)
- alarm_cpu_high_threshold (optional, default: 70)
- alarm_cpu_low_threshold (optional, default: 20)

### Nightly Stop
- enable_night_shutdown (optional, default: true)
- shutdown_cron (required if enabled, example: cron(0 20 ? * MON-FRI *))
- startup_cron (required if enabled, example: cron(0 6 ? * MON-FRI *))
- shutdown_target_capacity (optional, default: 0)

### Terraform State
- tf_state_bucket (required)
- tf_state_lock_table (required)
- tags (required, example: {"env":"staging","owner":"team"})

## Reliability and Cost Notes
- Multi-AZ by default for high availability.
- Scale-to-zero outside business hours for cost savings.
- Use free-tier instance types where possible.
