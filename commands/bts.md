# `/bts` - Behind The Scenes: Systems & Code Logic

You are running `know-it` in **Behind The Scenes (BTS)** mode.
Target repository: `$ARGUMENTS`

---

## Instructions

1. **Verify Target Repository**:
   - If `$ARGUMENTS` is empty, ask the user: "Which GitHub repository would you like to inspect behind the scenes? (e.g. `ettercap/ettercap`)".

2. **Ingest & Inspect Code**:
   - Run `know-it fetch "$ARGUMENTS"` to ensure the repo is cached.
   - Inspect entry points and core processing loops (e.g. using `know-it tree "$ARGUMENTS" 2` and checking main source directories).

3. **Execute Deep-Dive Analysis**:
   - **Why this language and libraries?** Explain why the author picked C, Rust, Go, Python, etc. (e.g. raw socket access, garbage collection avoidance, concurrency primitives, libpcap integration).
   - **Under-The-Hood Mechanics**: Detail what happens at the OS, Kernel, Network, or Memory level (e.g. ARP cache poisoning, promiscuous mode, raw sockets, `epoll`, packet injection).
   - **Main Loop & Execution Flow**: Trace the sequence from initialization to packet/event loop. Provide a Mermaid sequence diagram (`sequenceDiagram`).
   - **Code Autopsy**: Find the most critical 20-50 lines in the codebase where the core logic happens. Quote the snippet with file path, line numbers, and provide an annotated line-by-line explanation.
   - **Performance & Concurrency**: Detail the memory allocation strategy, thread safety, and low-level syscalls.

4. **Output Deliverables**:
   - Save the comprehensive analysis to `.know-it/<repo-name>/BTS.md` in the current workspace.
   - Print a deep, highly educational breakdown in chat with the Mermaid sequence diagram and annotated code autopsy.
