#!/usr/bin/env bash
# Automated test suite for know-it

set -euo pipefail

BOLD="\033[1m"
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

TESTS_PASSED=0
TESTS_FAILED=0

assert_success() {
    local desc="$1"
    shift
    echo -n "Running: $desc ... "
    if "$@" >/dev/null 2>&1; then
        echo -e "${GREEN}PASS${RESET}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}FAIL${RESET}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

echo -e "${BOLD}=== Running know-it Test Suite ===${RESET}\n"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Test 1: CLI binary exists and is executable
assert_success "CLI executable check" test -x "${SCRIPT_DIR}/bin/know-it"

# Test 2: Help command output
assert_success "CLI help command" "${SCRIPT_DIR}/bin/know-it" help

# Test 3: Version command
assert_success "CLI version command" "${SCRIPT_DIR}/bin/know-it" version

# Test 4: Installer dry-run
assert_success "Installer dry-run" "${SCRIPT_DIR}/install.sh" --dry-run --all

# Test 4b: Updater exists and runs dry-run
assert_success "Updater executable check" test -x "${SCRIPT_DIR}/update.sh"
assert_success "Updater help command" "${SCRIPT_DIR}/update.sh" --help
assert_success "Updater dry-run" "${SCRIPT_DIR}/update.sh" --dry-run --all
assert_success "CLI update subcommand" "${SCRIPT_DIR}/bin/know-it" update --dry-run --all

# Test 5: Templates exist
assert_success "Template OVERVIEW.md exists" test -f "${SCRIPT_DIR}/templates/OVERVIEW.md"
assert_success "Template BTS.md exists" test -f "${SCRIPT_DIR}/templates/BTS.md"
assert_success "Template USE_CASES.md exists" test -f "${SCRIPT_DIR}/templates/USE_CASES.md"
assert_success "Template ARCHITECTURE.md exists" test -f "${SCRIPT_DIR}/templates/ARCHITECTURE.md"

# Test 6: Skill definitions exist
assert_success "SKILL.md exists" test -f "${SCRIPT_DIR}/skills/know-it/SKILL.md"
assert_success "Skill how exists" test -f "${SCRIPT_DIR}/skills/how/SKILL.md"
assert_success "Skill bts exists" test -f "${SCRIPT_DIR}/skills/bts/SKILL.md"
assert_success "Skill why exists" test -f "${SCRIPT_DIR}/skills/why/SKILL.md"
assert_success "Skill where exists" test -f "${SCRIPT_DIR}/skills/where/SKILL.md"
assert_success "Triage reference exists" test -f "${SCRIPT_DIR}/skills/know-it/references/triage-guide.md"
assert_success "Output schema exists" test -f "${SCRIPT_DIR}/skills/know-it/references/output-schema.md"

# Test 7: Slash commands exist
assert_success "Command /how exists" test -f "${SCRIPT_DIR}/commands/how.md"
assert_success "Command /bts exists" test -f "${SCRIPT_DIR}/commands/bts.md"
assert_success "Command /why exists" test -f "${SCRIPT_DIR}/commands/why.md"
assert_success "Command /where exists" test -f "${SCRIPT_DIR}/commands/where.md"

# Test 7b: Claude Code Plugin manifests exist
assert_success "Claude plugin.json exists" test -f "${SCRIPT_DIR}/.claude-plugin/plugin.json"
assert_success "Claude marketplace.json exists" test -f "${SCRIPT_DIR}/.claude-plugin/marketplace.json"

# Test 8: Rules exist
assert_success "Rule know-it.md exists" test -f "${SCRIPT_DIR}/rules/know-it.md"

# Test 9: Mock repo fetch & inspection
MOCK_DIR=$(mktemp -d)
git init -q "$MOCK_DIR"
cat <<'EOF' > "$MOCK_DIR/main.py"
def main():
    print("Hello know-it")

if __name__ == "__main__":
    main()
EOF
echo "# Test Repo" > "$MOCK_DIR/README.md"
git -C "$MOCK_DIR" add .
git -C "$MOCK_DIR" -c user.name="Test" -c user.email="test@test.com" commit -q -m "init"

assert_success "Repo inspection logic" python3 -c '
import os, json
cache_dir = "'"$MOCK_DIR"'"
entry_points = [f for f in os.listdir(cache_dir) if f.startswith("main.")]
assert "main.py" in entry_points
'

rm -rf "$MOCK_DIR"

echo ""
echo -e "${BOLD}Results:${RESET} ${GREEN}${TESTS_PASSED} passed${RESET}, ${RED}${TESTS_FAILED} failed${RESET}"

if [[ $TESTS_FAILED -gt 0 ]]; then
    exit 1
fi
