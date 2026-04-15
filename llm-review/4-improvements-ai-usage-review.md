# Phase 4: Improvements & AI Usage Review

### 📋 QUICK SUMMARY

**Status:** ✅ PASS

**Quick verdict:** All required deliverables are present and the improvement claims are accurately reflected in the code. Security hardening (IMDSv2, EBS encryption, S3 bucket policy, ALB egress scoping) and cost optimisation (NAT count default, S3 gateway endpoint) are all verifiable in the current Terraform files.

---

### 🔍 DETAILED REVIEW

#### 1. Deliverables Check

| Deliverable | Present | Notes |
|---|---|---|
| Improved Terraform code | ✅ | Verified in modules |
| `IMPROVEMENT_REPORT.md` | ✅ | `homework/IMPROVEMENT_REPORT.md` |
| `COST_REPORT.md` | ✅ | `homework/COST_REPORT.md` |
| `PROMPTS.md` | ✅ | Root `PROMPTS.md` + `homework/prompting-strategy.md` |

All four deliverables are present. No automatic fail.

#### 2. Actual Improvements

Each claim verified against current code using the interpretation rules:

**IMDSv2 enforcement**
- Claim: "Enforced IMDSv2 via `metadata_options`."
- Code (`modules/compute/main.tf` L81-84):
  ```hcl
  metadata_options {
    http_tokens = var.require_imdsv2 ? "required" : "optional"
    ...
  }
  ```
  Variable `require_imdsv2` defaults to `true`. ✅

**Root volume encryption**
- Claim: "Explicit encrypted root volume with optional KMS key."
- Code (`modules/compute/main.tf` L86-97): `encrypted = true`, `kms_key_id` wired from variable. ✅

**S3 bucket policy: TLS + SSE-KMS enforcement**
- Claim: "Added bucket policy to deny non-TLS access and non-SSE-KMS uploads."
- Code (`modules/s3/main.tf` L59-114): `data.aws_iam_policy_document.bucket` with `DenyInsecureTransport` and `DenyUnencryptedUploads` statements, both enabled by default (`enforce_ssl = true`, `enforce_sse_kms = true` in `s3/variables.tf`). ✅

**ALB security group egress scoped to VPC CIDR**
- Claim: "Scoped egress to VPC CIDR only."
- Code (`modules/alb/main.tf` L13-17): `cidr_blocks = [var.vpc_cidr]` — no longer `0.0.0.0/0`. ✅

**NAT gateway count default reduced from 2 to 1**
- Claim: "Default NAT gateway count reduced from 2 to 1."
- Code (`root/variables.tf` L88): `default = 1`. Comment: "1 for cost savings, or match AZ count for HA". ✅

**S3 gateway endpoint added**
- Claim: "Added optional S3 gateway endpoint to reduce NAT egress."
- Code (`modules/networking/main.tf` L96-104): `aws_vpc_endpoint.s3` with `vpc_endpoint_type = "Gateway"`, defaulted to enabled (`enable_s3_gateway_endpoint = true` in root variables). ✅

Zero code-report mismatches found.

#### 3. AI Management Quality

`PROMPTS.md` covers all four tasks with specific prompts for each. The Task 2 prompt in `prompting-strategy.md` is more granular and shows a structured approach: root module first to lock the interface, then modules, then environments — a deliberate sequencing decision.

Task 4 main prompt is somewhat generic ("Analyze and improve Terraform code quality, apply security hardening, and optimize costs") but the actual improvements are specific and verified in code, suggesting the generic prompt was followed by targeted refinements. The `prompting-strategy.md` also documents quality checks embedded in prompts (validation, least-privilege, tagging, design comments) which carry through to all four tasks.

#### 4. Understanding Depth

The student demonstrates genuine understanding of *why* each change matters:
- IMDSv2: protects against SSRF-based credential theft via the metadata service.
- EBS encryption: ensures data-at-rest protection for root volumes, not just data volumes.
- S3 bucket policy: enforces encryption in transit *and* at rest at the policy layer, preventing misconfigured uploads.
- ALB egress scoping: reduces blast radius if the ALB SG is misconfigured or misused.
- NAT count: explicit trade-off documented (1 for cost, match AZ count for full HA).
- S3 endpoint: routes S3 traffic inside AWS backbone, avoiding NAT data processing charges.

The `IMPROVEMENT_REPORT.md` and `COST_REPORT.md` both include follow-up recommendations and caveats (e.g., interface endpoints have hourly costs, validate prices against AWS Pricing Calculator) — signs of genuine domain understanding, not copy-paste content.

#### 5. Final Verdict

**Decision:** PASS

**Reasoning:** All required deliverables are present and correct. Every improvement claim in the report is verifiable in the current code with zero mismatches. The cost report is grounded in the actual architecture with realistic numbers and connected to real code changes. PROMPTS.md shows a progression through all four tasks. The student clearly understands the security and cost implications of the changes they made.
