---
description: Interactive GitHub repository comprehension, mental model & triage
argument-hint: <github-repo-url-or-slug>
---

# `/how` - Interactive Repository Comprehension & Overview

You are running the `know-it` interactive learning engine.
Target repository: `$ARGUMENTS`

---

## Instructions

1. **Verify Target Repository**:
   - If `$ARGUMENTS` is empty, ask the user: "Which GitHub repository would you like to analyze? (e.g. `ettercap/ettercap` or full GitHub URL)".
   - If provided, normalize the slug (e.g. `owner/repo`).

2. **Locate & Ingest Repository**:
   - Locate the `know-it` CLI tool:
     ```bash
     KNOW_IT="know-it"
     if ! command -v know-it &>/dev/null; then
         for p in "$HOME/.local/bin/know-it" \
                  "$HOME/.gemini/config/skills/know-it/bin/know-it" \
                  "$HOME/.claude/skills/know-it/bin/know-it" \
                  "$HOME/.config/opencode/skills/know-it/bin/know-it" \
                  "$HOME/.codex/skills/know-it/bin/know-it"; do
             if [[ -x "$p" ]]; then
                 KNOW_IT="$p"
                 break
             fi
         done
     fi
     ```
   - Run `$KNOW_IT fetch "$ARGUMENTS"` (or run `git clone --depth 1 https://github.com/$ARGUMENTS.git ~/.cache/know-it/$ARGUMENTS` if `know-it` is not executable).
   - Read the summary output (languages, entry points, doc files).

3. **Interactive Triage (Ask the User)**:
   Present the user with a 4-question multiple-choice triage:
   - **Question 1: Depth of Understanding**
     - `A) High-Level Overview & Mental Model`: Clear analogies, purpose, how to use it.
     - `B) Architecture & Systems Design`: Component interactions, module boundaries, data flows.
     - `C) Deep Code & Systems Logic (BTS)`: Low-level syscalls, kernel/network mechanics, line-by-line autopsy.
   - **Question 2: Learning Focus**
     - `A) Practical Usage & Setup`: Commands, flags, recipes, real-world deployment.
     - `B) Code Engineering`: How the engine was built, main loops, concurrency, data structures.
     - `C) Protocol / Security Mechanics`: Low-level protocol tricks, packet handling, attack surface.
     - `D) Personal Aims`: How to adapt, fork, or build something similar for my own projects.
   - **Question 3: Output Format**
     - `A) Create .know-it/<repo>/ Markdown Dossier + Chat Summary`: Generate `.know-it/<repo>/OVERVIEW.md` and print summary.
     - `B) Interactive Chat Walkthrough`: Walk through the analysis in chat without generating files.
   - **Question 4: Visual Diagram Style**
     - `A) Clean Mermaid Diagram [Recommended]`: Modern flowchart with subgraphs, max 5-8 nodes, and reading legend.
     - `B) Structured ASCII Box-Art`: Universal terminal-friendly boxed diagram in a text block.
     - `C) Text-Only (No Diagrams)`: Deep narrative explanation without diagrams.

4. **Token-Optimized Docs-First Inspection Protocol**:
   - Run `$KNOW_IT docs "$ARGUMENTS"` or examine the `docs` metadata first to read architecture docs before diving into code.
   - Run `$KNOW_IT tree "$ARGUMENTS" 2` to identify entry points.
   - Use `$KNOW_IT inspect "$ARGUMENTS" <path> <start> <end>` to read surgical code slices, never loading massive files (>150 lines) into context.

5. **Analyze & Generate Masterclass Output**:
   - Follow the 5-stage Masterclass progression: 1) Aha! Mental Model, 2) Architectural Trade-offs & rejected alternatives, 3) End-to-end single artifact trace, 4) The Secret Sauce with code autopsy, 5) How to Hack & Learn.
   - If file output was requested, create `.know-it/<repo-name>/OVERVIEW.md` following the template standards.
   - Print a rich executive summary in the chat UI with the chosen diagram style and key takeaways.
