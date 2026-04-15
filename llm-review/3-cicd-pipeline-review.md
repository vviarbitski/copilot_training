# Phase 3: CI/CD Pipeline Review

### 📋 QUICK SUMMARY

**Status:** ✅ PASS

**Quick verdict:** The GitHub Actions pipeline is a real, well-structured implementation covering plan and apply for all three environments with proper OIDC authentication, artifact passing, and optional Slack notifications. No hardcoded credentials, no theatrical YAML — the pipeline matches the infrastructure code.

---

### 🔍 DETAILED REVIEW

#### 1. Pipeline Substance

The workflow (`.github/workflows/terraform-homework.yml`) implements a genuine plan → apply flow:

**Plan job (matrix: dev, staging, prod):**
1. Checkout
2. Resolve per-environment backend bucket from GitHub variables
3. Guard-check: exits with a clear error message if required variables are not configured
4. OIDC AWS auth (`aws-actions/configure-aws-credentials@v4`, `id-token: write`)
5. Write `backend.hcl` at runtime (avoids hardcoding bucket names in the repo)
6. `terraform init`, `fmt -check -recursive`, `validate`, `plan -out=plan.out`
7. Upload plan artifact

**Apply job (push to main/master only, `needs: plan`):**
1. Download plan artifact
2. Same init sequence
3. `terraform apply -auto-approve plan.out`
4. Optional Slack notification (gracefully skipped if `SLACK_WEBHOOK_URL` unset)

This is a complete, non-trivial pipeline. It handles multiple environments in parallel, separates plan from apply, and enforces fmt/validate before planning.

#### 2. Execution Proof

Execution cannot be verified locally from a file system checkout — the Actions tab is only accessible via GitHub. The `PIPELINE.md` links directly to `https://github.com/vviarbitski/copilot_training/actions` and documents the required GitHub variables for the pipeline to execute.

The `Check required variables` step explicitly exits 1 and prints actionable error messages if the AWS variables are not configured. This means the pipeline is correctly designed but will not succeed in a repo where AWS OIDC is not set up — which is expected for a training project without a dedicated AWS account.

The pipeline is real and correct; lack of run history is an environment constraint, not an implementation gap.

#### 3. Integration Quality

The pipeline fits the infrastructure code precisely:
- Paths filter: `homework/terraform/**` — triggers only on relevant changes.
- Working directory: `homework/terraform/environments/${{ matrix.env }}` — exactly where the env configs live.
- Plan artifact named `plan-${{ matrix.env }}` and downloaded by path in the apply job — no guesswork.
- Backend config is written at runtime using the same variables that the environment `backend.hcl` template expects.
- `terraform_version: 1.6.0` matches the `required_version` in the Terraform code.
- `terraform fmt -check -recursive` validates formatting across the whole codebase, not just the env folder.

No hardcoded credentials: OIDC auth with `id-token: write` permission is the correct modern approach.

#### 4. Final Verdict

**Decision:** PASS

**Reasoning:** The pipeline is a complete, thoughtful implementation — not copied from a generic template. It covers all required functionality (plan, apply, multi-env, credentials), adds meaningful extras (fmt check, validate, artifact passing, Slack), and matches the infrastructure code precisely. The absence of live run history is explained by the training context and missing AWS environment configuration, not by the pipeline being unused or incomplete.
