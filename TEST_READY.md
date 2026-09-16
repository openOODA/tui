# TEST READY: openOODA TUI (`ooda-tui`) 4-Tier E2E Verification Suite

- **Status**: READY FOR VERIFICATION & AUDIT
- **Author**: E2E Test Writer (`teamwork_preview_test_writer`)
- **Date**: 2026-09-16
- **Working Directory**: `/home/jeryd/Projects/openOODA/tui`
- **Specification Source**: `/home/jeryd/.agents/ORIGINAL_REQUEST.md` (§ 2026-09-16T05:27:01Z)
- **Infrastructure Guide**: `/home/jeryd/.agents/orchestrator_tui_1/TEST_INFRA.md`
- **Project Architecture**: `/home/jeryd/.agents/orchestrator_tui_1/PROJECT.md`

---

## 1. Declaration of Readiness

The comprehensive, opaque-box, 4-tier E2E verification test suite for the openOODA TUI (`ooda-tui`) re-architecture has been fully implemented, verified, and validated against openOODA repository laws.

The test suite satisfies all requirements set forth in:
- `ORIGINAL_REQUEST.md` (R1: Header Input Box, R2: Footer Statusbar, R3: Intermediate Canvas & Thought Stream, R4: Dynamic Thinking Ticker, R5: Plugin Architecture & Governance)
- `PROJECT.md` (Features F1 through F12)
- Rule 6 (Zero Trust QA: empirical verification on real release binaries)
- Rule 12 (Mechanical Anti-Cheating & Empirical Falsification: Double-Run Law, 1:1 negative falsification, cryptographic binary parity)
- openOODA Repository Laws (`make line-cap`, `make academy`, `make file-law`, `make qa`, `make parity`)

---

## 2. Test Architecture Summary

| Tier | Name | Probes | Test Count | Scope |
| :---: | :--- | :--- | :---: | :--- |
| **Tier 1** | Feature Coverage | `qa/e2e_tier1_f1_f3.oo`<br>`qa/e2e_tier1_f4_f6.oo`<br>`qa/e2e_tier1_f7_f9.oo`<br>`qa/e2e_tier1_f10_f12.oo` | 60 tests | Complete coverage across F1-F12: Header input relocation (Rows 1-3), prompt borders & mode chips (`[build]`, `[plan]`, `[ask]`), CUP cursor positioning (`\x1b[2;5H`) and zero-ESC plain mode, environmental footer statusbar (Row `rows`), MCP/LSP/teamwork telemetry, intermediate canvas (`ph = rows - 4`), dedicated thinking stream (`<think>` blocks), dynamic Braille thinking ticker, modular plugin registration (`plugins/registry.oo`), repository governance, clean typecheck, and cryptographic binary parity. |
| **Tier 2** | Boundary & Corner Cases | `qa/e2e_tier2_b1_b3.oo`<br>`qa/e2e_tier2_b4_b6.oo`<br>`qa/e2e_tier2_b7_b9.oo`<br>`qa/e2e_tier2_b10_b12.oo` | 60 tests | Edge geometries (cols=40 to 200, rows=12 to 80), oversized input buffers (>120 chars), unicode multi-byte UTF-8, mode fallbacks, non-tty piped stdin, carriage return handling, deep CWD shortening, offline telemetry, canvas `/clear` & `/compact`, unclosed/empty think blocks, dynamic ticker label mutation, shell metacharacter rejection, capability-gated tool dispatch, and fail-closed flag rejection. |
| **Tier 3** | Pairwise Combinations | `qa/e2e_tier3_pairwise.oo` | 12 tests | Systematic cross-feature interactions (P1-P12): Header Input + Cursor + Footer, Input + Mode Chips + Canvas, Cursor + Governance + Execution, Footer + Telemetry + Ticker, Canvas + Thinking + Ticker, Thinking + Registry + Chips, Header + Ticker + Canvas, Footer + Registry + Double-Run, Telemetry + Binary Parity + Clean Test, Chips + Thinking + Footer, Header + Telemetry + Narrow cols=40, and Cursor + Canvas + Short rows=12. |
| **Tier 4** | Real-World Workloads | `qa/e2e_tier4_scenarios.oo` | 6 scenarios | End-to-end multi-step application workflows: S1 (Interactive Start & Prompt Entry), S2 (Mode Switching Workflow: build -> plan -> ask), S3 (Reasoning Stream & Thought Display), S4 (Tool Execution & Telemetry Updates), S5 (Plain Mode / Headless Execution with zero ESC bytes), and S6 (Full Governance & Cryptographic Parity Certification). |

**Total Suite Tests**: 138 comprehensive verification test cases across 10 modular probe modules.

---

## 3. Cryptographic Binary Parity Certification

All tests execute against the exact bit-for-bit release binaries installed in the environment:
- **Build Target**: `/home/jeryd/Projects/openOODA/tui/dist/ooda-tui`
- **Installed Path**: `/home/jeryd/.openooda/bin/ooda-tui`
- **Binary Alias**: `/home/jeryd/.openooda/bin/tui`
- **Verified SHA-256 Digest**: `469a24effb280b0e25ed6674dff9daf0ea906805fc2242bcef9d88e6fdfa383a`
- **Parity Status**: Bit-identical (`PASS: binary parity 469a24effb280b0e25ed6674dff9daf0ea906805fc2242bcef9d88e6fdfa383a`).

---

## 4. How to Execute

### Full 138-Test E2E Suite
```bash
make -C /home/jeryd/Projects/openOODA/tui e2e
```

### Individual Tier Execution
```bash
# Tier 1: Feature Coverage (60 tests across F1-F12)
ooda test /home/jeryd/Projects/openOODA/tui/qa/e2e_tier1_f1_f3.oo
ooda test /home/jeryd/Projects/openOODA/tui/qa/e2e_tier1_f4_f6.oo
ooda test /home/jeryd/Projects/openOODA/tui/qa/e2e_tier1_f7_f9.oo
ooda test /home/jeryd/Projects/openOODA/tui/qa/e2e_tier1_f10_f12.oo

# Tier 2: Boundary & Corner Cases (60 tests across B1-B12)
ooda test /home/jeryd/Projects/openOODA/tui/qa/e2e_tier2_b1_b3.oo
ooda test /home/jeryd/Projects/openOODA/tui/qa/e2e_tier2_b4_b6.oo
ooda test /home/jeryd/Projects/openOODA/tui/qa/e2e_tier2_b7_b9.oo
ooda test /home/jeryd/Projects/openOODA/tui/qa/e2e_tier2_b10_b12.oo

# Tier 3: Pairwise Combinations (12 tests)
ooda test /home/jeryd/Projects/openOODA/tui/qa/e2e_tier3_pairwise.oo

# Tier 4: Real-World Workload Scenarios (6 scenarios)
ooda test /home/jeryd/Projects/openOODA/tui/qa/e2e_tier4_scenarios.oo
```

### Repository Governance Verification
```bash
make -C /home/jeryd/Projects/openOODA/tui verify
make -C /home/jeryd/Projects/openOODA/tui qa
make -C /home/jeryd/Projects/openOODA/tui parity
```

---

## 5. Exit Code Contract
- Exit Code `0`: 100% of tests passed under Double-Run verification (Run 1 == Run 2). Zero flakiness, zero regressions, zero bypasses.
- Exit Code `1` / Non-zero: One or more assertions failed or crashed fail-closed.
