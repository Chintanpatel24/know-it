---
name: know-it
description: >-
  Intelligent GitHub repository comprehension and architecture engine. Use when
  the user provides a GitHub repo link, runs /how, /bts, /why, or /where, or asks
  to understand a repository's usage, architecture, code logic, or systems mechanics.
---

# `know-it` - Intelligent Repository Comprehension Engine

`know-it` transforms any GitHub repository into an interactive, multi-dimensional learning experience. It breaks down complex codebases into intuitive mental models, behind-the-scenes systems logic, architecture maps, and practical use cases.

---

## 1. Supported Commands & Triggers

| Trigger | Intent | Mode | Generated File |
| :--- | :--- | :--- | :--- |
| `/how <repo>` | Comprehensive repo study | **Interactive Triage** (asks depth/focus questions) | `.know-it/<repo>/OVERVIEW.md` |
| `/bts <repo>` | Behind The Scenes (systems, code logic) | **Fast Direct** (skips questions) | `.know-it/<repo>/BTS.md` |
| `/why <repo>` | Value proposition & personal aims | **Fast Direct** (skips questions) | `.know-it/<repo>/USE_CASES.md` |
| `/where <repo>` | Architecture map & entry points | **Fast Direct** (skips questions) | `.know-it/<repo>/ARCHITECTURE.md` |

*(Also activate when the user asks naturally: "How does this repo work: <link>", "Explain the internals of <repo>", "Teach me how <repo> works behind the scenes".)*

---

## 2. Ingestion & Caching Workflow

Before analyzing, fetch and inspect the repository:
1. Run the helper CLI:
   ```bash
   know-it fetch <github-url-or-slug>
   ```
   This performs a fast shallow clone (`--depth 1`) into `~/.cache/know-it/<owner>/<repo>` and outputs a JSON summary containing:
   - Top languages & file extensions
   - Entry points (`main.c`, `main.py`, `Cargo.toml`, `Makefile`, etc.)
   - Documentation files (`README.md`, `ARCHITECTURE.md`)
2. If `know-it` is not in PATH, perform equivalent shallow clone manually:
   ```bash
   git clone --depth 1 https://github.com/<owner>/<repo>.git ~/.cache/know-it/<owner>/<repo>
   ```
3. To inspect file trees or specific files:
   ```bash
   know-it tree <repo> 2
   know-it inspect <repo> <path/to/file>
   ```

---

## 3. Workflow by Command

### A. When `/how <repo>` is triggered (Interactive Triage)
1. Ingest repo into cache using `know-it fetch <repo>`.
2. Present the user with a 4-question multiple-choice triage (using `ask_question` tool if available, or interactive formatted options in chat):
   - **Question 1: Depth of Understanding**
     - `1. High-Level Overview & Mental Model`: Conceptual analogies, big picture, practical CLI usage.
     - `2. Architecture & Design Patterns`: Component topology, modular boundaries, data contracts.
     - `3. Deep Systems & Low-Level Code (BTS)`: Kernel/network calls, memory layout, algorithms, line-by-line autopsy.
   - **Question 2: Learning Focus**
     - `1. Practical Usage & Recipes`: How to use it as a tool, commands, real-world deployment.
     - `2. Code Engineering`: How the software was built, main loops, thread pools, data structures.
     - `3. Protocol / Security Mechanics`: Protocol exploits, packet tampering, hardware/OS tricks.
     - `4. Personal Aims`: How can I reuse/fork or build something similar for my goals?
   - **Question 3: Output Format**
     - `1. Workspace Dossier + Chat Summary`: Save files to `.know-it/<repo>/` and display visual summary.
     - `2. Chat Walkthrough`: Keep it entirely interactive in the chat conversation.
   - **Question 4: Visual Diagram Style**
     - `1. Clean Mermaid Diagram [Recommended]`: 5-8 nodes max, functional subgraphs, numbered action steps, and reading legend.
     - `2. Structured ASCII Box-Art`: Universal terminal-friendly boxed diagram inside fenced code block.
     - `3. Text-only (No Diagrams)`: Pure narrative without diagrams.
3. Follow the **Token-Optimized Docs-First Protocol**:
   - First check `know-it docs <repo>` or examine metadata `docs` to read architecture guides before diving into code.
   - Pinpoint entry points with `know-it tree <repo> 2`.
   - Never dump huge files (>150 lines); use `know-it inspect <repo> <path> <start> <end>` for surgical code autopsies.
4. Structure the analysis using the **Masterclass Teaching Framework**:
   - The "Aha!" Mental Model (intuitive real-world analogy).
   - Architectural Trade-offs ("Why Built This Way?" & rejected alternatives).
   - Concrete End-to-End Trace (1 packet / 1 request / 1 byte through the stack).
   - The Secret Sauce (surgical code autopsy of the core 20-50 lines).
   - How to Hack & Learn From It (actionable takeaways).
5. If file output was requested, write `.know-it/<repo-name>/OVERVIEW.md` following the template in `templates/OVERVIEW.md`.
6. Deliver a rich executive summary in chat with the chosen diagram style and clickable links.

---

### B. When `/bts <repo>` is triggered (Behind The Scenes)
*Skip questions.* Directly conduct a low-level systems analysis:
1. Fetch repo into cache (`know-it fetch <repo>`).
2. If the user passes `--ascii` or `--no-mermaid`, use Structured ASCII Box-Art; otherwise default to Clean Mermaid.
3. Follow Docs-First protocol: read architecture docs, find critical syscalls/entry points, then use `know-it inspect <repo> <path> <start> <end>` for surgical code autopsy.
4. Deliver Masterclass breakdown:
   - **Why this language & libraries?** (Trade-offs & rejected alternatives).
   - **System Mechanics**: Kernel interfaces (`AF_PACKET`, `libpcap`, `ioctl`, `epoll`, `mmap`).
   - **End-to-End Trace**: Concrete packet/data walkthrough.
   - **Code Autopsy**: Surgical 20-50 line code slice with machine-level line commentary.
   - **Masterclass Takeaways**: Patterns to steal for personal software.
5. Save to `.know-it/<repo-name>/BTS.md`.
6. Deliver technical summary in chat.

---

### C. When `/why <repo>` is triggered (Why & Personal Aims)
*Skip questions.* Focus on value proposition and real-world leverage:
1. Fetch repo into cache (`know-it fetch <repo>`).
2. If `--ascii` is passed, use ASCII diagrams; otherwise default to Clean Mermaid.
3. Formulate:
   - What gap this project fills and why it was created.
   - 2-3 concrete real-world usage scenarios.
   - Practical personal utility: Concrete ideas for how the user can fork, modify, or integrate this code for their own projects.
   - Comparison matrix against popular alternatives.
4. Save to `.know-it/<repo-name>/USE_CASES.md`.
5. Deliver summary in chat.

---

### D. When `/where <repo>` is triggered (Architecture Map)
*Skip questions.* Focus on code geography and navigation:
1. Fetch repo into cache (`know-it fetch <repo>`).
2. If `--ascii` is passed, use ASCII diagrams; otherwise default to Clean Mermaid.
3. Generate directory tree map (`know-it tree <repo> 2`).
4. Identify critical entry points (`main()`, dispatchers, config parsers).
5. Provide a module decomposition table and data lifecycle diagram.
6. Highlight "Where to Hack": the exact files to modify to add features, tweak logic, or change behavior.
7. Save to `.know-it/<repo-name>/ARCHITECTURE.md`.
8. Deliver summary in chat.

---

## 4. Key References
- Triage questionnaire details: see [`references/triage-guide.md`](./references/triage-guide.md)
- Output formatting & Mermaid/ASCII guidelines: see [`references/output-schema.md`](./references/output-schema.md)
