# Architecture Design Instructions

General guidelines for working with AI to design cloud architecture. Read these before starting any architecture design task.

**Before every session, read this file first, then:**
- Check [PROMPTS.md](PROMPTS.md) for task-specific prompts and context
- Review the learning curve and iteration history in PROMPTS.md

**Learning Curve:** These instructions set the foundation. PROMPTS.md shows how to apply them across tasks and evolve the approach.

## Best Practices for AI-Driven Architecture Design

### 1) Discovery and scope
- Clarify business goals, primary users, and success metrics.
- Capture functional requirements and non-functional requirements (availability, latency, compliance, security, cost).
- Identify constraints: cloud provider, regions, data residency, existing platforms, and team skills.
- List assumptions explicitly and ask for validation when needed.

### 2) Architecture diagram expectations
- Produce a diagram that shows all components and their interactions.
- Include ingress/egress, networking boundaries, data stores, compute, messaging, observability, and security controls.
- Use clear labels and one consistent notation.
- Call out trust boundaries and data flows.
- Provide a short legend if symbols are non-obvious.

### 3) Tool and service selection document
- List each selected tool or service and explain why it was chosen.
- Compare at least one alternative and note tradeoffs (cost, performance, operability, vendor lock-in).
- Highlight operational considerations (monitoring, alerting, scaling, backups, DR).
- Note licensing or compliance impacts where relevant.

### 4) Terraform parameter inventory
- Produce a complete list of parameters required to implement the design with Terraform.
- Group by subsystem (networking, compute, storage, database, messaging, security, observability, CI/CD).
- Include required types and examples: instance types, counts, autoscaling settings, storage sizes, backup windows, retention, encryption settings, subnets, CIDR ranges, and IAM roles.
- Mark which parameters are required vs optional and provide sane defaults where possible.

### 5) Security and compliance
- Apply least privilege, network segmentation, and encryption in transit/at rest.
- Include secrets management and key rotation strategy.
- Address audit logging and compliance (PCI, GDPR, SOC2) if applicable.

### 6) Reliability and resilience
- Include HA strategy, multi-AZ or multi-region guidance, and DR objectives (RPO/RTO).
- Describe failure modes and mitigation strategies.

### 7) Cost and scalability
- Provide cost drivers and a rough scaling model.
- Suggest cost optimizations and scaling triggers.

### 8) Deliverables checklist
- Architecture diagram covering all components.
- Tool selection and justification document.
- Terraform parameter list with required/optional flags and defaults.

### 9) Output format
- Keep outputs concise and structured with headings.
- Use ASCII-only diagrams (or Mermaid when supported) unless asked otherwise.
- Avoid proprietary or copyrighted content; use original text.

## AWS-Specific Guidance

### Services and architecture
- Prefer AWS-managed services where they reduce operational burden (e.g., RDS, ECS/EKS, Lambda, SQS/SNS, CloudWatch, KMS).
- Use well-architected pillars: security, reliability, performance efficiency, cost optimization, and operational excellence.
- Include VPC design with public/private subnets, NAT gateways, route tables, security groups, and NACLs.
- Specify IAM roles/policies, KMS keys, and AWS Secrets Manager or SSM Parameter Store for secrets.

### Observability
- Include CloudWatch logs/metrics/alarms, X-Ray when relevant, and centralized log retention.

### Storage and DR
- Document S3 lifecycle policies, encryption, and access policies.
- Specify multi-AZ as default and multi-region when required by RPO/RTO.

### Terraform
- Include provider config, account/region parameters, tagging standards, and state backend (S3 + DynamoDB lock).

## Terraform Best Practices (apply to all .tf work)

- Use modules to avoid duplication; keep root modules thin and focus on composition.
- Define variables with types, descriptions, and validation; set sane defaults where safe.
- Add outputs only when needed by callers; verify referenced attributes exist.
- Use data sources for dynamic values (AMI lookup, account/region metadata).
- Enforce least-privilege IAM policies and explicit resource tags.
- Add brief comments for non-obvious design decisions or tradeoffs.
- Run `terraform fmt -recursive` after any .tf changes and `terraform validate` when feasible.

## Learning Progression

This file is designed as a **reference and foundation** for all architecture design work. Use this progression approach:

1. **Start here** → Read sections 1-2 (Discovery and Architecture diagrams) to frame the problem correctly.
2. **Plan** → Review sections 3-4 (Tool selection and Terraform parameters) to map implementation.
3. **Validate** → Check sections 5-7 (Security, reliability, cost) to ensure production readiness.
4. **For AWS work** → Always apply AWS-specific guidance from the final section.
5. **See examples** → Check [PROMPTS.md](PROMPTS.md) for real task examples and how these principles were applied.

When starting a new session, skim this file (5 min) + review task prompts in PROMPTS.md to regain context without re-explanation.
