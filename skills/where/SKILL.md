---
name: where
description: Codebase architecture map, directory layout & entry points. Use when the user runs /where <repo>.
---

# `/where` - Codebase Navigation & Architecture Map

Use this skill when the user runs `/where <repo>` or asks for the architecture layout and key files of a GitHub repository.

## Workflow

1. **Locate Tool & Ingest Repository**:
   - Run `know-it fetch "<repo>"` to cache repository.
   - If user passed `--ascii` or `--no-mermaid`, use Structured ASCII Box-Art; otherwise default to Clean Mermaid.
   - Follow Token-Optimized Docs-First protocol: read architecture docs via `know-it docs`, then run `know-it tree "<repo>" 2`.

2. **Construct Codebase Map**:
   - **ASCII Directory Map**: Clean, annotated directory layout showing where each subsystem lives.
   - **Critical Entry Points**: Table of files where execution starts (`main()`, dispatch loops, CLI parsers).
   - **Modular Decomposition**: Purpose and boundaries of core modules.
   - **Data Lifecycle**: Visual data flow: Clean Mermaid flowchart (5-8 nodes max with legend) or Structured ASCII Box-Art if `--ascii` was passed.
   - **"Where To Hack"**: The exact files to modify to add features or tweak behavior.

3. **Output**:
   - Write `.know-it/<repo-name>/ARCHITECTURE.md`.
   - Deliver summary in chat with the ASCII tree, entry points table, and flow diagram.
