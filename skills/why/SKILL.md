---
name: why
description: Value proposition, real-world application scenarios, and personal aims. Use when the user runs /why <repo>.
---

# `/why` - Use Cases, Practical Value & Personal Aims

Use this skill when the user runs `/why <repo>` or asks why a repository exists and how they can adapt it for their own projects.

## Workflow

1. **Locate Tool & Ingest Repository**:
   - Run `know-it fetch "<repo>"` to cache repository.
   - Read README, architecture docs, and package configurations.

2. **Formulate High-Value Utility Breakdown**:
   - **Value Proposition**: The exact gap this project fills in the ecosystem.
   - **Real-World Scenarios**: 2-3 concrete applications (who uses it, the problem, the payoff).
   - **Personal Aims**: Actionable ideas for how the user can fork, modify, or steal patterns for their own software.
   - **Competitive Matrix**: Side-by-side comparison table against top 2 alternatives.

3. **Output**:
   - Write `.know-it/<repo-name>/USE_CASES.md`.
   - Deliver executive summary in chat highlighting key takeaways.
