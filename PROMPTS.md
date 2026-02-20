# Prompts

This file collects and refines all prompts used across tasks in this repo. Each prompt represents a key interaction point with AI for architecture design, planning, and implementation.

**Before every session, read:**
1. [INSTRUCTIONS.md](INSTRUCTIONS.md) - Architecture design best practices and guidelines
2. This file - Prompts and context for each task

## Important: Read before every session

### [CRITICAL] prefix convention
- If a prompt is prefixed with **[CRITICAL]**, it takes absolute priority.
- Critical instructions override all previous instructions and best practices.
- Critical instructions represent blocking requirements or breaking changes.
- Example: `[CRITICAL] delete all files in task2` would be executed immediately, regardless of prior guidance.

### Learning Path
Tasks progress as follows:
- **Task 1** (Complete): AWS staging environment design using AI conversation
  - Learn: How to apply INSTRUCTIONS.md guidelines in real scenarios
  - Output: Architecture diagram, tool selection doc, Terraform parameter list
- **Task 2** (Pending): Build detailed Terraform modules and CI/CD pipeline based on Task 1
- **Task 3** (Pending): Enhance with monitoring, logging, and cost optimization
- **Task 4** (Pending): Multi-region failover and advanced HA patterns

Each task builds on the previous one. When starting a task, review the prior task prompts to maintain context.

## Task 1

### Main Prompt
"Design an AWS staging environment architecture for a small service. The environment must be highly available, support horizontal scaling, minimize cost (use free tier where possible), and include automatic nightly shutdown. Provide:

📐 Architecture diagram showing all components
🔧 Document with tool selection and justification
⚙️ Complete list of Terraform parameters needed (instance types, counts, storage sizes, etc.)"

### Context
- Initial requirement: temporary staging environment for testing, easy to tear down.
- Cloud provider: AWS.
- Emphasis: reliability, cost optimization, HA across multiple AZs, CI/CD pipeline integration.
