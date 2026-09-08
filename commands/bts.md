---
description: Behind The Scenes systems mechanics, OS/kernel calls & code autopsy
argument-hint: <github-repo-url-or-slug> [--ascii]
---

# `/bts` - Behind The Scenes: Systems & Code Logic

You are running `know-it` in **Behind The Scenes (BTS)** mode.
Target repository: `$ARGUMENTS`

---

## Instructions

1. **Verify Target Repository & Flags**:
   - Check if the user specified `--ascii` or `--no-mermaid`. If present, strip the flag from the repository target and use Structured ASCII Box-Art for diagrams; otherwise default to Clean Mermaid.
   - If target repository is empty, ask: "Which GitHub repository would you like to inspect behind the scenes? (e.g. `ettercap/ettercap`)".

2. **Ingest & Explore with Token-Optimized Docs-First Protocol**:
   - Locate the `know-it` CLI tool.
   - Run `$KNOW_IT fetch "$REPO"` to ensure the repo is cached.
   - Run `$KNOW_IT docs "$REPO"` or check metadata `docs` to absorb curated architecture/design docs first before diving into raw code.
   - Run `$KNOW_IT tree "$REPO" 2` to identify entry points.
   - Use `$KNOW_IT inspect "$REPO" <path> <start> <end>` to surgically extract the critical 20-50 lines without loading large files into context.

3. **Execute Masterclass Systems Analysis**:
   - **Why this language and libraries?**: Explain why the author picked this stack. Detail architectural trade-offs and what alternatives were rejected.
   - **Under-The-Hood Mechanics**: Detail what happens at the OS, Kernel, Network, or Memory level (`AF_PACKET`, raw sockets, `epoll`, `ioctl`, `mmap`).
   - **End-to-End Trace**: Trace a single concrete artifact (e.g. 1 packet, 1 HTTP request, 1 byte) through each subsystem from entry to exit.
   - **Visual Flow**: Provide a Clean Mermaid diagram (5-8 nodes max, subgraphs, numbered actions, and legend) or Structured ASCII Box-Art if `--ascii` was specified.
   - **The Secret Sauce (Code Autopsy)**: Dissect the critical 20-50 lines where the core trick executes, quoting exact line numbers and machine-level mechanics.
   - **Lessons to Steal**: Concrete design patterns and engineering lessons the user can take away for their own software.

4. **Output Deliverables**:
   - Save the comprehensive analysis to `.know-it/<repo-name>/BTS.md` in the current workspace.
   - Print a deep, highly educational breakdown in chat with the diagram and annotated code autopsy.
