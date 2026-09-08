#!/usr/bin/env bash
# know-it uninstaller

set -euo pipefail

BOLD="\033[1m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
RESET="\033[0m"

log_info()    { echo -e "  ${YELLOW}•${RESET} $*"; }
log_success() { echo -e "  ${GREEN}✓${RESET} $*"; }

echo -e "${BOLD}Uninstalling know-it skill suite...${RESET}\n"

# Remove CLI executable & alias
for bin_f in know-it know-how; do
    if [[ -f "$HOME/.local/bin/$bin_f" || -L "$HOME/.local/bin/$bin_f" ]]; then
        rm -f "$HOME/.local/bin/$bin_f"
        log_success "Removed ~/.local/bin/$bin_f"
    fi
done

# Remove Claude Code bindings
for f in how.md bts.md why.md where.md; do
    rm -f "$HOME/.claude/commands/$f" 2>/dev/null || true
done
rm -rf "$HOME/.claude/skills/know-it" "$HOME/.claude/skills/know-how" 2>/dev/null || true
log_success "Removed Claude Code commands & skills"

# Remove Antigravity skill
rm -rf "$HOME/.gemini/config/skills/know-it" "$HOME/.gemini/config/skills/know-how" 2>/dev/null || true
log_success "Removed Antigravity skill"

# Remove OpenCode bindings
for f in how.md bts.md why.md where.md; do
    rm -f "$HOME/.config/opencode/commands/$f" 2>/dev/null || true
done
rm -rf "$HOME/.config/opencode/skills/know-it" "$HOME/.config/opencode/skills/know-how" 2>/dev/null || true
log_success "Removed OpenCode commands & skills"

# Remove Codex skill
rm -rf "$HOME/.codex/skills/know-it" "$HOME/.codex/skills/know-how" 2>/dev/null || true
log_success "Removed Codex skill"

# Remove AgentSkills generic
rm -rf "$HOME/.agentskills/know-it" "$HOME/.agentskills/know-how" 2>/dev/null || true
log_success "Removed AgentSkills generic"

# Remove Cursor & Windsurf rules
rm -f "$HOME/.cursor/rules/know-it.md" "$HOME/.cursor/rules/know-how.md" 2>/dev/null || true
rm -f "$HOME/.windsurf/rules/know-it.md" "$HOME/.windsurf/rules/know-how.md" 2>/dev/null || true
log_success "Removed IDE rules"

# Optional: cache
for cache_dir in "$HOME/.cache/know-it" "$HOME/.cache/know-how"; do
    if [[ -d "$cache_dir" ]]; then
        read -r -p "Do you also want to remove cached repositories ($cache_dir)? [y/N] " remove_cache
        if [[ "$remove_cache" =~ ^[Yy]$ ]]; then
            rm -rf "$cache_dir"
            log_success "Removed cache ($cache_dir)"
        fi
    fi
done

echo -e "\n${GREEN}${BOLD}✓ know-it successfully uninstalled.${RESET}"
