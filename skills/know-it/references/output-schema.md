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

### Visual Standards (Clean Mermaid vs Structured ASCII)
Depending on the user's diagram style choice (or shortcut default):

#### When Clean Mermaid is Selected:
- **Node Cap**: 5 to 8 nodes maximum per diagram. Avoid overwhelming 20+ node spaghetti diagrams.
- **Functional Subgraphs**: Group nodes by boundary (e.g. `User Space` vs `Kernel Space`, `Ingress` vs `Worker Pool`).
- **Numbered Action Edges**: Every connector must describe the transition clearly (`-->|"1. Ingress packet"|`).
- **Syntax Safety**: Always double-quote node labels containing special characters (`id["Label (Context)"]`).
- **Reading Legend**: Include a 2-sentence blockquote `> **How to Read This Flow**: ...` directly beneath the diagram.

#### When Structured ASCII Box-Art is Selected:
- Use clean ASCII/Unicode box-drawing characters inside a ````text` code block.
- Clearly delineate component boundaries and numbered arrows (`| 1. Action v`).
- Ensure diagrams render cleanly without horizontal scrolling in terminals and chat windows.

#### When Text-Only is Selected:
- Omit visual diagrams and provide a rich step-by-step numbered breakdown of the component flow.

---

## 3. The 'Masterclass' Teaching Framework
Every generated document and chat walkthrough must follow this 5-stage learning progression:

1. **The "Aha!" Mental Model**:
   - Begin with a vivid everyday analogy that demystifies the system before using jargon.
   - *Example*: "Think of Ettercap as a rogue mail carrier who tells the homeowner 'I am the post office' and tells the post office 'I am the homeowner'..."

2. **Architectural Trade-offs ("Why Built This Way?")**:
   - Explain why the author selected this specific language, runtime, or library.
   - Explicitly state the alternatives considered and rejected (e.g. Why C over Python: zero GC latency, raw pointer arithmetic, kernel socket bindings).

3. **Concrete End-to-End Trace**:
   - Trace a single concrete artifact (1 packet, 1 HTTP request, 1 byte) through each subsystem from entry to exit.

4. **The Secret Sauce & Code Autopsy**:
   - Locate the most clever 20-50 lines where the core algorithm lives.
   - Break it down line-by-line with machine-level explanation (memory, syscalls, state changes).

5. **How to Hack & Learn From It**:
   - Provide concrete instructions on where to hack to extend or tweak functionality.
   - Highlight design patterns the reader can steal for their own applications.

---

## 4. Token-Optimized Docs-First Inspection Protocol
To conserve LLM context tokens and avoid asking repeated file-read permissions:
1. **Docs First**: Run `know-it docs <repo>` or examine the JSON summary `docs` list. Read `README.md`, `docs/`, `DESIGN.md`, or architecture docs before diving into raw source code.
2. **Pinpoint Entry Points**: Use `know-it tree <repo> 2` and entry points from `know-it fetch` metadata.
3. **Surgical Line-Slice Inspection**: Never dump full files (>150 lines). Always use:
   `know-it inspect <repo> <path> <start_line> <end_line>`
   to read only the critical 20-50 lines needed for the code autopsy.
