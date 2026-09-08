# Documentation Output Standards for know-it

All generated documents must follow these quality and educational standards.

---

## 1. Directory Structure
When generating files, place them in a dedicated `.know-it/<repo-name>/` directory inside the current workspace root:
```
.know-it/
└── <repo-name>/
    ├── OVERVIEW.md        # Produced by /how (conceptual model, features, usage)
    ├── BTS.md             # Produced by /bts (behind-the-scenes, OS/systems logic, code autopsy)
    ├── USE_CASES.md       # Produced by /why (real-world applications, personal utility)
    └── ARCHITECTURE.md    # Produced by /where (directory tree, entry points, data flow)
```

---

## 2. Core Educational Guidelines

### Visuals First (Mermaid Diagrams)
- Always include at least one Mermaid diagram in each generated document.
- Diagrams must be clear, well-labeled, and syntactically valid (e.g. quote labels containing parentheses: `id["Label (Info)"]`).
- For `/bts`: Use sequence diagrams or state diagrams showing thread loops and packet/data processing.
- For `/where`: Use flowchart diagrams (`graph TD` or `graph LR`) showing data lifecycle.

### Analogies & Mental Models
- Start with a clear analogy explaining the core technique.
  - *Example for Ettercap*: "Think of Ettercap as a malicious mail carrier who tells the homeowner 'I am the post office' and tells the post office 'I am the homeowner', routing all letters through their own hands before delivering them."

### Annotated Code Snippets
- Don't just paste code. Explain:
  1. What the code is doing in machine terms (allocating buffer, opening raw socket `SOCK_RAW`, calling `ioctl`).
  2. Why the author wrote it that way (performance, portability, protocol requirements).
  3. Key edge cases handled.

### Concrete System Mechanics
- Identify the exact kernel APIs, system calls, and network primitives used:
  - Sockets: `AF_INET`, `AF_PACKET`, `SOCK_RAW`
  - Polling: `epoll_wait`, `select`, `kqueue`, `io_uring`
  - Memory: zero-copy ring buffers, `mmap`, custom pool allocators
  - Threading: POSIX threads, worker pools, event loops
