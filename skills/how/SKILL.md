---
name: how
description: Interactive repository comprehension & triage engine. Use when the user runs /how or provides a GitHub repository to analyze.
---

# `/how` - Interactive Repository Comprehension

Use this skill when the user runs `/how <repo>` or asks to understand a GitHub repository.

## Workflow

1. **Locate Tool & Ingest Repository**:
   - Locate the `know-it` helper:
     ```bash
     KNOW_IT="know-it"
     for p in "$HOME/.local/bin/know-it" \
              "$HOME/.gemini/config/skills/know-it/bin/know-it" \
              "$HOME/.claude/skills/know-it/bin/know-it" \
              "$HOME/.config/opencode/skills/know-it/bin/know-it"; do
         if [[ -x "$p" ]]; then KNOW_IT="$p"; break; fi
     done
     ```
   - Fetch the repository: `$KNOW_IT fetch "<repo>"` (or shallow clone to `~/.cache/know-it/<repo>`).

2. **Conduct Interactive Triage**:
   - Ask the user 4 multiple-choice questions (using `ask_question` if available, or formatted options in chat):
     - **Depth**: High-Level Mental Model vs Architecture & Systems vs Deep Code / Systems Logic (BTS)
     - **Focus**: Practical Usage & Setup vs Code Engineering vs Protocol / Security Mechanics vs Personal Aims
     - **Output**: Workspace Dossier (`.know-it/<repo>/OVERVIEW.md` + chat summary) vs Chat Walkthrough
     - **Diagram Style**: Clean Mermaid (5-8 nodes max with subgraphs) vs Structured ASCII Box-Art vs Text-Only

3. **Explore Repo with Token-Optimized Docs-First Protocol**:
   - Run `$KNOW_IT docs "<repo>"` or examine the `docs` metadata first to absorb curated architectural context.
   - Run `$KNOW_IT tree "<repo>" 2` to locate critical entry points.
   - Use `$KNOW_IT inspect "<repo>" <path> <start> <end>` for surgical code slices, never reading full files (>150 lines) into context.

4. **Produce Masterclass Dossier & Visual Summary**:
   - Follow the 5-stage Masterclass progression: 1) Aha! Mental Model analogy, 2) Architectural Trade-offs & rejected alternatives, 3) End-to-end single artifact trace, 4) The Secret Sauce with code autopsy, 5) How to Hack & Learn.
   - Generate `.know-it/<repo-name>/OVERVIEW.md` (if file output selected).
   - Display a rich executive summary in the chat UI with the chosen diagram style.
