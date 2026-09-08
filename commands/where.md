---
description: Codebase architecture map, directory tree & entry points
argument-hint: <github-repo-url-or-slug> [--ascii]
---

# `/where` - Codebase Navigation & Architecture Map

You are running `know-it` in **Code Geography & Navigation (Where)** mode.
Target repository: `$ARGUMENTS`

---

## Instructions

1. **Verify Target Repository & Flags**:
   - Check if user specified `--ascii` or `--no-mermaid`. If present, strip flag and use Structured ASCII Box-Art; otherwise default to Clean Mermaid.
   - If target repository is empty, ask: "Which GitHub repository would you like to navigate? (e.g. `ettercap/ettercap`)".

2. **Map Code Structure with Token-Optimized Docs-First Protocol**:
   - Locate the `know-it` CLI tool.
   - Run `$KNOW_IT fetch "$REPO"` to ensure the repo is cached.
   - Run `$KNOW_IT docs "$REPO"` to absorb architectural documentation before exploring code.
   - Run `$KNOW_IT tree "$REPO" 2` to capture the top-level directory layout.
   - Locate main entry points, build files (`CMakeLists.txt`, `Makefile`, `Cargo.toml`, etc.), and core module folders.

3. **Construct Codebase Map**:
   - **ASCII Directory Map**: Clean, annotated directory layout showing where each subsystem lives.
   - **Critical Entry Points**: Table of files where execution starts (`main()`, CLI argument parsers, engine dispatchers).
   - **Modular Decomposition**: Break down modules (e.g. Core Engine, I/O & Network, Protocol Parsers, UI/CLI) with inbound/outbound contracts.
   - **Data Lifecycle Diagram**: Clean Mermaid flowchart (5-8 nodes max with legend) or Structured ASCII Box-Art if `--ascii` was specified.
   - **"Where To Hack" Guide**: Exact file paths to edit if the user wants to add a feature, tweak protocol logic, or change configurations.

4. **Output Deliverables**:
   - Save the comprehensive map to `.know-it/<repo-name>/ARCHITECTURE.md` in the current workspace.
   - Output the ASCII tree, entry points table, and flow diagram in chat.
