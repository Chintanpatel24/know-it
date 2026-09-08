# `/where` - Codebase Navigation & Architecture Map

You are running `know-it` in **Code Geography & Navigation (Where)** mode.
Target repository: `$ARGUMENTS`

---

## Instructions

1. **Verify Target Repository**:
   - If `$ARGUMENTS` is empty, ask the user: "Which GitHub repository would you like to navigate? (e.g. `ettercap/ettercap`)".

2. **Map Code Structure**:
   - Run `know-it fetch "$ARGUMENTS"` to ensure the repo is cached.
   - Run `know-it tree "$ARGUMENTS" 2` to capture the top-level directory layout.
   - Locate main entry points, build files (`CMakeLists.txt`, `Makefile`, `Cargo.toml`, etc.), and core module folders.

3. **Construct Codebase Map**:
   - **ASCII Directory Map**: Clean, annotated directory layout showing where each subsystem lives.
   - **Critical Entry Points**: Table of files where execution starts (`main()`, CLI argument parsers, engine dispatchers).
   - **Modular Decomposition**: Break down modules (e.g. Core Engine, I/O & Network, Protocol Parsers, UI/CLI) with inbound/outbound contracts.
   - **Data Lifecycle Diagram**: Mermaid flowchart (`graph TD`) tracing how data/packets flow from ingress to egress through the codebase.
   - **"Where To Hack" Guide**: Exact file paths to edit if the user wants to add a feature, tweak protocol logic, or change configurations.

4. **Output Deliverables**:
   - Save the comprehensive map to `.know-it/<repo-name>/ARCHITECTURE.md` in the current workspace.
   - Output the ASCII tree, entry points table, and Mermaid diagram in chat.
