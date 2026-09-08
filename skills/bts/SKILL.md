---
name: bts
description: Behind The Scenes systems mechanics, OS/kernel calls & code autopsy. Use when the user runs /bts <repo>.
---

# `/bts` - Behind The Scenes: Systems & Code Logic

Use this skill when the user runs `/bts <repo>` or asks about the low-level systems logic, language choices, or internal mechanics of a GitHub repository.

## Workflow

1. **Locate Tool & Ingest Repository**:
   - Run `know-it fetch "<repo>"` to cache repository.
   - If user passed `--ascii` or `--no-mermaid`, use Structured ASCII Box-Art; otherwise default to Clean Mermaid.
   - Follow Token-Optimized Docs-First protocol: read architecture docs via `know-it docs`, then inspect critical entry points.
   - Use `know-it inspect <repo> <path> <start> <end>` for surgical code slices, never reading full files (>150 lines).

2. **Conduct Masterclass Systems Analysis**:
   - **Why this language and libraries?**: Explain memory model, raw socket/syscall requirements, and architectural trade-offs vs rejected alternatives.
   - **Under-The-Hood Mechanics**: Detail the exact OS/kernel interfaces (`AF_PACKET`, `libpcap`, `ioctl`, `epoll`, `mmap`).
   - **End-to-End Trace**: Walk through 1 concrete packet, request, or byte chunk from ingress to egress.
   - **Visual Flow**: Provide a Clean Mermaid sequence/flow diagram (5-8 nodes max with legend) or Structured ASCII Box-Art if `--ascii` was passed.
   - **The Secret Sauce (Code Autopsy)**: Surgically dissect the critical 20-50 lines where the core logic executes, with line-by-line machine mechanics.
   - **Lessons to Steal**: 2-3 actionable architectural takeaways for personal software.

3. **Output**:
   - Write `.know-it/<repo-name>/BTS.md`.
   - Deliver an engaging, deep technical breakdown in chat with the diagram and code autopsy.
