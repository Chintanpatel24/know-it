---
name: where
description: Codebase architecture map, directory layout & entry points. Use when the user runs /where <repo>.
---

# `/where` - Codebase Navigation & Architecture Map

Use this skill when the user runs `/where <repo>` or asks for the architecture layout and key files of a GitHub repository.

## Workflow

1. **Locate Tool & Ingest Repository**:
   - Run `know-it fetch "<repo>"` to cache repository.
   - Run `know-it tree "<repo>" 2` to capture directory hierarchy.

2. **Construct Codebase Map**:
   - **ASCII Directory Map**: Clean, annotated directory layout showing where each subsystem lives.
   - **Critical Entry Points**: Table of files where execution starts (`main()`, dispatch loops, CLI parsers).
   - **Modular Decomposition**: Purpose and boundaries of core modules.
   - **Data Lifecycle**: Mermaid flowchart (`graph TD`) tracing data from ingress to egress.
   - **"Where To Hack"**: The exact files to modify to add features or tweak behavior.

3. **Output**:
   - Write `.know-it/<repo-name>/ARCHITECTURE.md`.
   - Deliver summary in chat with the ASCII tree, entry points table, and Mermaid diagram.
