# Interactive Triage & Questionnaire Guide for know-it

When the user triggers `/how <repo>` or asks "how does <repo> work?", perform this multi-stage triage to tailor the analysis precisely to the user's needs.

---

## The 3-Question Triage Flow

### Question 1: Knowledge Depth
Ask: **"What level of depth are you looking for?"**
- **Option 1 (Mental Model & Overview)**: Fast conceptual understanding, what the project does, key analogies, and basic usage.
- **Option 2 (Architecture & Systems Design)**: Component interactions, module boundaries, data pipelines, and design patterns.
- **Option 3 (Deep Code & Systems Logic / BTS)**: Under-the-hood low-level mechanics, OS/kernel interactions, syscalls, why languages/libraries were picked, and line-by-line algorithm walkthroughs.

### Question 2: Learning Focus & Angle
Ask: **"What is your primary focus for this repository?"**
- **Option 1 (Practical Usage & Tooling)**: How to run it, commands, configurations, recipes, and setup.
- **Option 2 (Code Autopsy & Engineering)**: How the code was built, how functions execute, state machines, and concurrency.
- **Option 3 (Security, Protocols & Exploitation)**: Low-level mechanics, protocol abuse (e.g. ARP poisoning, packet crafting), or attack surface.
- **Option 4 (Personal Aims & Adaptation)**: How to fork, reuse, or build a custom version of this tool for personal projects.

### Question 3: Output Deliverable
Ask: **"Where would you like to receive the analysis?"**
- **Option 1 (Dossier + Chat Summary)**: Generate clean Markdown files in `.know-it/<repo-name>/` (e.g., `OVERVIEW.md`, `BTS.md`) and display an executive visual summary in chat.
- **Option 2 (Interactive Chat Walkthrough)**: Walk through the concepts directly in our chat conversation first without saving files yet.

---

## Skipping the Triage

When the user uses dedicated shortcut commands:
- `/bts <repo>`: Automatically select **Deep Code & Systems Logic** + **Code Autopsy / Security Mechanics** + generate `.know-it/<repo>/BTS.md`. Do not ask triage questions; start fetching and analyzing immediately.
- `/why <repo>`: Automatically select **Mental Model & Personal Aims** + generate `.know-it/<repo>/USE_CASES.md`.
- `/where <repo>`: Automatically select **Architecture & Systems Design** + generate `.know-it/<repo>/ARCHITECTURE.md`.
