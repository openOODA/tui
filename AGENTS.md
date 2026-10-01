# tui: Agent Engineering Standards (v1)

This repository houses the terminal UI, interactive coding harness, and slash command subsystem for openOODA.
All work in this repository strictly defers to the organization standards in [`openOODA/AGENTS.md`](file:///home/ubermetroid/Projects/openOODA/openOODA/AGENTS.md).

---

## 1. UI Architecture & Runtime Latency SLA
- **Motor-Reflex Keystroke SLA ($\le 2\text{ms}$ p99)**: Keystroke echo and prompt redraw must never block on background LLM inference or slow I/O.
- **Non-Blocking Async**: Background network and LLM calls run in isolated threads; updates dispatch to the event bus without freezing user input.
- **Linear Arena Bulk Resets**: Churn from prompt parsing is bulk-reset on prompt return ($O(1)$ memory overhead).

---

## 2. Invariants & Quality Standards
- **The Page Rule**: Every `.oo` page must be between 16 and 256 lines.
- **Directory Density**: At most 8 `.oo` pages per directory.
- **4-Element Academy Header**: Mandatory on every `.oo` page (`// #`, `// Logline:`, `// Setup:`, `// Beats:`).
- **Double-Run Determinism**: All `qa/probe_*.oo` tests must pass in sequential fresh processes.

---

## 3. Local Verification Commands
```bash
make build
cli qa
```
