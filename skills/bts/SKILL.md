---
name: bts
description: Behind The Scenes systems mechanics, OS/kernel calls & code autopsy. Use when the user runs /bts <repo>.
---

# `/bts` - Behind The Scenes: Systems & Code Logic

Use this skill when the user runs `/bts <repo>` or asks about the low-level systems logic, language choices, or internal mechanics of a GitHub repository.

## Workflow

1. **Locate Tool & Ingest Repository**:
   - Run `know-it fetch "<repo>"` to cache the repository.
   - Inspect entry points, core dispatch loops, and build files.

2. **Conduct Deep-Dive Systems Analysis**:
   - **Why this language and libraries?**: Explain memory model, raw socket/syscall requirements, and performance trade-offs.
   - **Under-The-Hood Mechanics**: Detail the exact OS/kernel interfaces (`AF_PACKET`, `libpcap`, `ioctl`, `epoll`, `mmap`).
   - **Execution Loop & Sequence**: Provide a Mermaid sequence diagram (`sequenceDiagram`) tracing execution flow.
   - **Code Autopsy**: Highlight the critical 20-50 lines where the core logic executes, with annotated line-by-line mechanics.

3. **Output**:
   - Write `.know-it/<repo-name>/BTS.md`.
   - Deliver an engaging, deep technical breakdown in chat with the Mermaid sequence diagram and code autopsy.
