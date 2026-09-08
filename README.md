# know-it

> **Universal Agent Skill & Slash Command Suite for Deep GitHub Repository Comprehension**
>
> Learn any codebase at any depth -- from intuitive mental models to low-level systems logic, raw socket mechanics, and architecture blueprints.

[![Agent Skills](https://img.shields.io/badge/standard-AgentSkills-purple.svg)](#supported-agents)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Supported-orange.svg)](#supported-agents)
[![Antigravity](https://img.shields.io/badge/Antigravity-Supported-blue.svg)](#supported-agents)
[![OpenCode](https://img.shields.io/badge/OpenCode-Supported-emerald.svg)](#supported-agents)
[![Codex](https://img.shields.io/badge/Codex%20CLI-Supported-black.svg)](#supported-agents)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

---

## The One-Liner Install

Install `know-it` across all detected AI agents on your machine with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/Chintanpatel24/know-it/main/install.sh | bash
```

Or from a local clone:

```bash
git clone https://github.com/Chintanpatel24/know-it.git
cd know-it
./install.sh
```

The installer scans for available agents, presents an interactive numbered selection (e.g. `1. Claude Code`, `2. Antigravity`, ..., `N. All [Recommended]`), and lets you choose between `1. Latest Release [Recommended]` or `2. Main branch (main)`.

---

## The One-Liner Update

Update existing `know-it` installations across your agents at any time with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/Chintanpatel24/know-it/main/update.sh | bash
```

Or directly via the CLI:

```bash
know-it update
```

The updater scans for existing `know-it` installations, displays an interactive numbered list of environments to update, and allows choosing between `1. Latest Release [Recommended]` and `2. Main branch (main)`.

---

## What is `know-it`?

When you encounter an unfamiliar GitHub repository, reading through thousands of lines of code or deciphering vague READMEs takes hours. 

`know-it` gives your AI agent an intelligent, multi-dimensional learning framework:
1. **Interactive Triage (`/how <repo>`)**: Prompts you with an interactive questionnaire to determine your exact target depth (high-level mental model vs deep systems logic) and practical goals.
2. **Dedicated Shortcut Commands (`/bts`, `/why`, `/where`)**: Skip questions when you know exactly what you want.
3. **Dedicated Documentation Dossiers**: Generates crystal-clear Markdown guides inside `.know-it/<repo-name>/` with valid Mermaid diagrams, mental model analogies, and annotated code snippets.
4. **Local Shallow Caching Engine**: Clones repos with `--depth 1` into `~/.cache/know-it/`, bypassing GitHub API rate limits and allowing fast code inspection.

---

## Command Suite

### 1. `/how <github-repo-link>` -- The Interactive Master Triage
Launches an interactive multiple-choice questionnaire to tailor the learning session to your exact needs:
- **Question 1: Depth of Understanding**
  - High-Level Overview & Mental Model (Analogies, big picture, practical CLI usage)
  - Architecture & Systems Design (Component topology, module boundaries, data pipelines)
  - Deep Code & Systems Logic (Under-the-hood syscalls, memory layout, line-by-line autopsy)
- **Question 2: Learning Focus**
  - Practical Usage & Tooling (CLI recipes, configuration, real-world deployment)
  - Code Engineering (Main loops, thread pools, data structures, state machines)
  - Security / Protocol Mechanics (Protocol manipulation, packet crafting, attack surface)
  - Personal Aims (How to fork, adapt, or build a custom version for your projects)
- **Question 3: Output Deliverable**
  - Workspace Dossier (`.know-it/<repo>/OVERVIEW.md` + chat summary)
  - Interactive Chat Walkthrough (Chat-only conversation)

---

### 2. `/bts <github-repo-link>` -- Behind The Scenes: Systems & Code Logic
*Fast direct mode -- skips questions.* Performs a deep technical dive into:
- **Why this language & libraries?** (e.g., Why C was chosen over Python: raw socket manipulation, zero GC overhead, direct memory pointers).
- **Under-the-hood OS mechanics**: Raw sockets (`AF_PACKET`, `SOCK_RAW`), `ioctl`, kernel packet filtering, `libpcap` hooks.
- **The Core Engine Loop**: Sequence diagram of the event/packet lifecycle.
- **Code Autopsy**: Line-by-line breakdown of the critical 20-50 lines where the core logic executes.
- **Output**: Generates `.know-it/<repo-name>/BTS.md`.

---

### 3. `/why <github-repo-link>` -- Real-World Use Cases & Personal Aims
*Fast direct mode -- skips questions.* Unpacks the practical utility:
- **Value Proposition**: The exact problem it solves and why alternatives fall short.
- **Real-World Scenarios**: Concrete use cases (who uses it, the challenge, the payoff).
- **Personal Aims**: How you can fork, modify, or steal patterns from this repo for your own software.
- **Competitive Matrix**: Side-by-side comparison table against the top 2 alternatives.
- **Output**: Generates `.know-it/<repo-name>/USE_CASES.md`.

---

### 4. `/where <github-repo-link>` -- Code Geography & Architecture Map
*Fast direct mode -- skips questions.* Maps the codebase:
- **ASCII Directory Map**: Annotated tree of key modules and responsibilities.
- **Critical Entry Points**: Table of files where execution begins (`main()`, dispatchers, CLI parsing).
- **Data Lifecycle**: Mermaid flowchart (`graph TD`) tracing data from ingress to egress.
- **"Where To Hack"**: The exact files to touch if you want to add a feature or tweak protocol logic.
- **Output**: Generates `.know-it/<repo-name>/ARCHITECTURE.md`.

---

## Concrete Example: Analyzing Ettercap

Suppose you run:
```text
/how https://github.com/ettercap/ettercap
```

1. **The Interactive Triage**:
   The agent asks:
   - *Depth*: Deep Code & Systems Logic (BTS)
   - *Focus*: Security & Protocol Mechanics
   - *Output*: Workspace Dossier + Chat Summary

2. **The Result**:
   - Creates `.know-it/ettercap/OVERVIEW.md` and `.know-it/ettercap/BTS.md`.
   - **Mental Model Analogy**:
     > *"Think of Ettercap as a rogue postal courier standing at your neighborhood mailbox. It tells your computer 'I am your router' and tells your router 'I am your computer' by spamming fake ARP reply packets. When traffic flows, both parties willingly send all their unencrypted letters directly into Ettercap's hands."*
   - **Behind The Scenes Walkthrough**:
     - Explains why C was chosen: Direct pointer arithmetic on raw Ethernet/IP packet buffers (`struct ether_header`, `struct ip_header`) and `AF_PACKET` socket access without language runtime delays.
     - Sequence diagram showing ARP request poisoning and MITM packet forwarding.
     - Code autopsy of `ec_arp_poisoning()` and `pcap_dispatch()` packet loop.

---

## Supported Agents

| Platform | Type | Installation Location |
| :--- | :--- | :--- |
| **Claude Code** | Slash Commands & Skill | `~/.claude/commands/*.md` & `~/.claude/skills/know-it/` |
| **Google Antigravity** | Skill Package | `~/.gemini/config/skills/know-it/SKILL.md` |
| **OpenCode** | Slash Commands & Skill | `~/.config/opencode/commands/*.md` & `~/.config/opencode/skills/know-it/` |
| **Codex CLI / Operator** | Skill Package | `~/.codex/skills/know-it/` |
| **AgentSkills (Standard)** | Universal Agent Skill | `~/.agentskills/know-it/` |
| **Cursor & Windsurf** | Global Prompt Rules | `~/.cursor/rules/know-it.md` & `~/.windsurf/rules/know-it.md` |

---

## CLI Helper (`know-it`)

The bundled CLI tool manages repository cloning, caching, and inspection:

```bash
# Fetch and inspect repository metadata (outputs JSON summary)
know-it fetch ettercap/ettercap

# View clean ASCII directory tree up to depth 2
know-it tree ettercap/ettercap 2

# Inspect a specific file with line numbers
know-it inspect ettercap/ettercap src/ec_main.c

# List all cached repositories and disk space
know-it list

# Clean cache
know-it clean ettercap/ettercap
know-it clean --all

# Check installation status across all agents
know-it info
```

*(Note: `know-how` is also aliased to `know-it` for backwards compatibility.)*

---

## Generated Documentation Structure

When used within any project, `know-it` creates a dedicated, clean folder:

```
.know-it/
└── ettercap/
    ├── OVERVIEW.md       # High-level mental model, capabilities, quickstart
    ├── BTS.md            # Low-level systems logic, raw sockets, code autopsy
    ├── USE_CASES.md      # Practical use cases, personal aims, alternatives
    └── ARCHITECTURE.md   # Codebase directory map, entry points, Mermaid flow
```

---

## Uninstallation

To cleanly remove `know-it` from all agents:

```bash
./uninstall.sh
```

---

## License

MIT License. See [LICENSE](./LICENSE) for details.
