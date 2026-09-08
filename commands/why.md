# `/why` - Use Cases, Practical Value & Personal Aims

You are running `know-it` in **Use Cases & Utility (Why)** mode.
Target repository: `$ARGUMENTS`

---

## Instructions

1. **Verify Target Repository**:
   - If `$ARGUMENTS` is empty, ask the user: "Which GitHub repository would you like to evaluate? (e.g. `ettercap/ettercap`)".

2. **Ingest & Inspect Context**:
   - Run `know-it fetch "$ARGUMENTS"` to ensure the repo is cached.
   - Read the `README.md`, documentation, and configuration files to understand intent and ecosystem positioning.

3. **Formulate High-Value Practical Assessment**:
   - **Value Proposition**: Exactly why this project was built and what niche it dominates.
   - **Real-World Application Scenarios**: Outline 2-3 distinct scenarios (e.g. network pen-testing, academic research, enterprise monitoring) detailing who uses it, the specific challenge, and the payoff.
   - **Personal Aims & Adaptation**: Give concrete advice on:
     - How the user can fork or adapt this code for their own projects.
     - How to integrate it into modern pipelines or personal tooling.
     - What design patterns from this repo are worth stealing for other projects.
   - **Competitive Matrix**: Compare the project side-by-side with 2 top alternatives across strengths, footprint, extensibility, and when to choose which.

4. **Output Deliverables**:
   - Save the full guide to `.know-it/<repo-name>/USE_CASES.md` in the current workspace.
   - Output an executive summary in chat highlighting key takeaways and personal leverage opportunities.
