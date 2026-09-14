# ooda-tui v0.1.1 Makefile
#
# Build and verify the harness. v0.1.1 adds the line-mode chrome
# (header, pane, input, status bar, popover) plus a second theme.
#
# Usage:
#   make build       - compile main.oo to dist/ooda-tui
#   make test        - run the binary's --help and --version
#   make parity      - verify sha256 matches dist/ooda-tui
#   make line-cap    - enforce 256-line cap on every .oo and .oot
#   make file-law    - reject forbidden file extensions
#   make academy     - verify every .oo has the 4-element Academy header
#   make check       - run oodac check on every .oo outside qa/
#   make qa          - run all qa/*.oo probes
#   make verify      - run all of the above checks
#   make install     - copy dist/ooda-tui to ~/.openooda/bin/
#   make clean       - remove build artifacts
#   make all         - build + verify + test

OODA_COMPILER ?= $(HOME)/.openooda/bin/oodac
BIN := dist/ooda-tui

.PHONY: all build test parity line-cap file-law academy check qa verify install clean

all: build verify test

build: $(BIN)

$(BIN): main.oo anchor.oo app.oo config.oo loop.oo mcp_client.oo lsp_client.oo llm.oo llm_anthropic.oo llm_openai.oo llm_ollama.oo llm_google.oo llm_custom.oo teamwork.oo slash.oo slash_extra.oo session.oo compact.oo plan.oo btw.oo keys.oo theme.oo themes/1982.oo themes/minimax.oo chrome.oo header.oo statusbar.oo pane.oo input.oo popover.oo markdown.oo tool_card.oo diff.oo
	@mkdir -p dist
	OO_LIST_AMBIENT_QUOTA=1073741824 OODACODEX=$(HOME)/.openooda/openOODA/northstar.oot OODA_COMPILER=$(OODA_COMPILER) ooda build main.oo -o $(BIN)
	@echo "built $(BIN)"

test: $(BIN)
	@echo "=== --help ==="
	@./$(BIN) --help > /dev/null && echo "PASS" || echo "FAIL"
	@echo "=== --version ==="
	@./$(BIN) --version > /dev/null && echo "PASS" || echo "FAIL"
	@echo "=== --unknown-flag (expect exit 2) ==="
	@./$(BIN) --unknown-flag 2>/dev/null; test $$? -eq 2 && echo "PASS" || echo "FAIL"

parity: install
	@dist_sum=$$(sha256sum dist/ooda-tui | cut -d' ' -f1); \
	inst_sum=$$(sha256sum $(HOME)/.openooda/bin/ooda-tui | cut -d' ' -f1); \
	if [ "$$dist_sum" = "$$inst_sum" ]; then \
		echo "PASS: binary parity $$dist_sum"; \
	else \
		echo "FAIL: dist $$dist_sum != install $$inst_sum"; exit 1; \
	fi

line-cap:
	@violations=0; \
	for f in $$(find . -name "*.oo" -o -name "*.oot"); do \
		n=$$(wc -l < "$$f"); \
		if [ $$n -gt 256 ]; then \
			echo "VIOLATION: $$f = $$n lines"; \
			violations=$$((violations+1)); \
		fi; \
	done; \
	if [ $$violations -gt 0 ]; then echo "FAIL: $$violations files exceed 256-line cap"; exit 1; fi; \
	echo "PASS: 256-line cap holds"

file-law:
	@forbidden="py js ts rb pl json yaml toml sh md"; \
	violations=0; \
	for ext in $$forbidden; do \
		found=$$(find . -name "*.$$ext" -not -path "./.git/*" 2>/dev/null | head -3); \
		if [ -n "$$found" ] && [ "$$ext" != "md" -o "$$found" != "./README.md" ]; then \
			echo "VIOLATION: .$$ext forbidden:"; echo "$$found"; \
			violations=$$((violations+1)); \
		fi; \
	done; \
	if [ $$violations -gt 0 ]; then echo "FAIL: file-law violations"; exit 1; fi; \
	echo "PASS: file law holds"

academy:
	@failures=0; \
	for f in $$(find . -name "*.oo"); do \
		header=$$(head -7 "$$f"); \
		if ! echo "$$header" | grep -q "^// # "; then \
			echo "FAIL: $$f missing '// # <Title>' in first 7 lines"; \
			failures=$$((failures+1)); \
			continue; \
		fi; \
		if ! echo "$$header" | grep -q "^// Logline:"; then \
			echo "FAIL: $$f missing '// Logline:' in first 7 lines"; \
			failures=$$((failures+1)); \
			continue; \
		fi; \
		if ! echo "$$header" | grep -q "^// Setup:"; then \
			echo "FAIL: $$f missing '// Setup:' in first 7 lines"; \
			failures=$$((failures+1)); \
			continue; \
		fi; \
		if ! echo "$$header" | grep -q "^// Beats:"; then \
			echo "FAIL: $$f missing '// Beats:' in first 7 lines"; \
			failures=$$((failures+1)); \
			continue; \
		fi; \
	done; \
	if [ $$failures -gt 0 ]; then echo "FAIL: $$failures academy header violations"; exit 1; fi; \
	echo "PASS: academy headers hold (all 4 elements present in first 7 lines)"

check:
	@OO_LIST_AMBIENT_QUOTA=1073741824 OODACODEX=$(HOME)/.openooda/openOODA/northstar.oot OODA_COMPILER=$(OODA_COMPILER) \
	failed=0; \
	for f in $$(find . -name "*.oo" -not -path "./qa/*" -not -path "./.ooda-cache/*"); do \
		if ! OODACODEX=$(HOME)/.openooda/openOODA/northstar.oot OODA_COMPILER=$(OODA_COMPILER) $$OODA_COMPILER check "$$f" > /dev/null 2>&1; then \
			echo "FAIL: oodac check $$f"; \
			failed=$$((failed+1)); \
		fi; \
	done; \
	if [ $$failed -gt 0 ]; then echo "FAIL: $$failed oodac check failures"; exit 1; fi; \
	echo "PASS: oodac check holds"

qa:
	@OO_LIST_AMBIENT_QUOTA=1073741824 OODACODEX=$(HOME)/.openooda/openOODA/northstar.oot OODA_COMPILER=$(OODA_COMPILER) \
	for f in $$(find qa -name "*.oo"); do \
		echo "=== $$f ==="; \
		OODACODEX=$(HOME)/.openooda/openOODA/northstar.oot OODA_COMPILER=$(OODA_COMPILER) $$OODA_COMPILER check "$$f" || exit 1; \
	done; \
	echo "PASS: qa probes compile"

verify: line-cap file-law academy check

install: $(BIN)
	@mkdir -p $(HOME)/.openooda/bin
	@cp $(BIN) $(HOME)/.openooda/bin/ooda-tui
	@chmod +x $(HOME)/.openooda/bin/ooda-tui
	@echo "installed $(HOME)/.openooda/bin/ooda-tui"

clean:
	@rm -rf dist .ooda-cache
	@echo "cleaned"
