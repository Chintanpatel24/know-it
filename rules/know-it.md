# `know-it` Agent Rules & Guidelines

When the user asks about understanding a GitHub repository, provides a GitHub link with an intent to learn, or uses `/how`, `/bts`, `/why`, or `/where`:

1. **Commands & Shortcuts**:
   - `/how <repo>`: Ingest repo, ask 4 multiple-choice triage questions (Depth, Focus, Output format, Diagram style: Clean Mermaid vs Structured ASCII vs Text-only), then generate `.know-it/<repo>/OVERVIEW.md` and chat summary.
   - `/bts <repo> [--ascii]`: Fast deep dive into systems logic, kernel/network mechanics, end-to-end trace, and surgical code autopsy. Generate `.know-it/<repo>/BTS.md`.
   - `/why <repo> [--ascii]`: Real-world use cases, value proposition, personal utility, and competitor comparison. Generate `.know-it/<repo>/USE_CASES.md`.
   - `/where <repo> [--ascii]`: Code navigation map, entry points, module breakdown, and data flow. Generate `.know-it/<repo>/ARCHITECTURE.md`.

2. **Token-Optimized Docs-First Protocol**:
   - Use `know-it fetch <repo>` to clone/update repository to `~/.cache/know-it/<owner>/<repo>`.
   - Run `know-it docs <repo>` to discover and inspect curated architecture and documentation files first.
   - Use `know-it tree <repo> 2` to view directory layout.
   - Use `know-it inspect <repo> <path> <start> <end>` to surgically view line slices rather than loading massive files into context.

3. **Masterclass Output Quality**:
   - Start with a clear real-world analogy ("Aha! Mental Model") before introducing technical concepts.
   - Include visual diagrams: Clean Mermaid (5-8 nodes max with subgraphs, numbered actions, and legend) or Structured ASCII Box-Art if requested/flagged.
   - Include architectural trade-offs and rejected alternatives.
   - Trace 1 concrete unit of data (packet, request, byte) end-to-end through the stack.
   - When writing code autopsies, annotate line-by-line explaining what happens at the machine/OS level.
   - Save files into `.know-it/<repo-name>/` in the current workspace.
