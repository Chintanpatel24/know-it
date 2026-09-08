# `know-it` Agent Rules & Guidelines

When the user asks about understanding a GitHub repository, provides a GitHub link with an intent to learn, or uses `/how`, `/bts`, `/why`, or `/where`:

1. **Commands & Shortcuts**:
   - `/how <repo>`: Ingest repo, ask 3 multiple-choice triage questions (Depth, Focus, Output format), then generate `.know-it/<repo>/OVERVIEW.md` and chat summary.
   - `/bts <repo>`: Fast deep dive into systems logic, kernel/network mechanics, and code autopsy. Generate `.know-it/<repo>/BTS.md`.
   - `/why <repo>`: Real-world use cases, value proposition, personal utility, and competitor comparison. Generate `.know-it/<repo>/USE_CASES.md`.
   - `/where <repo>`: Code navigation map, entry points, module breakdown, and data flow. Generate `.know-it/<repo>/ARCHITECTURE.md`.

2. **Ingestion & Caching**:
   - Use `know-it fetch <repo>` to clone/update the repository to `~/.cache/know-it/<owner>/<repo>`.
   - Use `know-it tree <repo> 2` to view directory layout.
   - Use `know-it inspect <repo> <path>` to view file contents with line numbers.

3. **Output Quality**:
   - Always include valid Mermaid diagrams in generated docs.
   - Use clear real-world analogies ("Mental Models") before diving into complex code.
   - When writing code autopsies, annotate line-by-line explaining what happens at the machine/OS level.
   - Save files into `.know-it/<repo-name>/` in the current workspace.
