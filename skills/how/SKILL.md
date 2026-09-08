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
   - Ask the user multiple-choice questions (using `ask_question` if available, or formatted options in chat):
     - **Depth**: High-Level Mental Model vs Architecture & Systems vs Deep Code / Systems Logic (BTS)
     - **Focus**: Practical Usage & Setup vs Code Engineering vs Protocol / Security Mechanics vs Personal Aims
     - **Output**: Workspace Dossier (`.know-it/<repo>/OVERVIEW.md` + chat summary) vs Chat Walkthrough

3. **Produce Dossier & Visual Summary**:
   - Inspect key entry points and core source files in cache.
   - Generate `.know-it/<repo-name>/OVERVIEW.md` with a real-world analogy ("Mental Model"), Mermaid flow diagram, feature highlights, and step-by-step practical usage.
   - Display a rich executive summary in the chat UI.
