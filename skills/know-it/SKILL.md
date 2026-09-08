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
1. Ingest the repo into cache using `know-it fetch <repo>`.
2. Present the user with a multiple-choice triage (using `ask_question` tool if available, or interactive formatted options in chat):
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
3. Once the user responds, analyze the cached repository files based on their exact selections.
4. If output format includes files, write `.know-it/<repo-name>/OVERVIEW.md` (and any selected companion docs) using the templates in `templates/`.
5. Present a rich executive summary in the chat with a Mermaid diagram, mental model analogy, and clickable links to the generated documents.

---

### B. When `/bts <repo>` is triggered (Behind The Scenes)
*Skip all questions.* Directly conduct a low-level systems analysis:
1. Fetch repo into cache (`know-it fetch <repo>`).
2. Read entry points, core dispatch loops, socket/memory allocations, and build configs.
3. Explain:
   - **Why this language?** (e.g. why C instead of Python: raw socket manipulation, zero runtime overhead, direct memory pointers).
   - **System Mechanics**: Which kernel interfaces (`AF_PACKET`, `libpcap`, `ioctl`, `epoll`, `mmap`) make the magic happen.
   - **Algorithm & State Machine**: Sequence diagram of packet or data processing.
   - **Code Autopsy**: Highlight the critical 20-50 lines of code where the core trick lives, with step-by-step commentary.
4. Save to `.know-it/<repo-name>/BTS.md`.
5. Deliver an engaging, deep technical breakdown in chat.

---

### C. When `/why <repo>` is triggered (Why & Personal Aims)
*Skip all questions.* Focus on value proposition and real-world leverage:
1. Fetch repo into cache (`know-it fetch <repo>`).
2. Formulate:
   - What gap this project fills and why it was created.
   - 2-3 concrete real-world usage scenarios (e.g., enterprise auditing, CTF tournaments, local network testing).
   - Practical personal utility: Concrete ideas for how the user can fork, modify, or integrate this code for their own projects.
   - Comparison matrix against popular alternatives.
3. Save to `.know-it/<repo-name>/USE_CASES.md`.
4. Deliver summary in chat.

---

### D. When `/where <repo>` is triggered (Architecture Map)
*Skip all questions.* Focus on code geography and navigation:
1. Fetch repo into cache (`know-it fetch <repo>`).
2. Generate directory tree map (using `know-it tree <repo> 2`).
3. Identify all critical entry points (`main()`, dispatchers, config parsers).
4. Provide a module decomposition table and Mermaid data lifecycle diagram (`graph TD`).
5. Highlight "Where to Hack": the exact files to modify to add features, tweak logic, or change behavior.
6. Save to `.know-it/<repo-name>/ARCHITECTURE.md`.
7. Deliver summary in chat.

---

## 4. Key References
- Triage questionnaire details: see [`references/triage-guide.md`](./references/triage-guide.md)
- Output formatting & Mermaid guidelines: see [`references/output-schema.md`](./references/output-schema.md)
