#!/usr/bin/env bash
# know-it - Universal Agent Skill & Slash Command Installer
# Supports Claude Code, Antigravity, OpenCode, Codex, Cursor, Windsurf, and AgentSkills

set -euo pipefail

VERSION="1.0.0"
REPO_URL="https://github.com/Chintanpatel24/know-it"
LOCAL_SHARE_DIR="${HOME}/.local/share/know-it"
LOCAL_BIN_DIR="${HOME}/.local/bin"

# Styling
BOLD="\033[1m"
GREEN="\033[32m"
BLUE="\033[34m"
YELLOW="\033[33m"
CYAN="\033[36m"
RED="\033[31m"
MAGENTA="\033[35m"
RESET="\033[0m"

log_info()    { echo -e "  ${BLUE}ℹ${RESET} $*"; }
log_success() { echo -e "  ${GREEN}✓${RESET} $*"; }
log_warn()    { echo -e "  ${YELLOW}⚠${RESET} $*"; }
log_error()   { echo -e "  ${RED}✗${RESET} $*" >&2; }

print_banner() {
    echo -e "${CYAN}${BOLD}"
    cat <<'EOF'
  _                            _ _   
 | |                          (_) |  
 | | _____  _____      __      _| |_ 
 | |/ / _ \/ _ \ \ /\ / /_____| | __|
 |   <  __/ (_) \ V  V /______| | |_ 
 |_|\_\___|\___/ \_/\_/       |_|\__|
EOF
    echo -e "${RESET}${BOLD}Universal Agent Skill & Slash Command Suite (v${VERSION})${RESET}"
    echo -e "Interactive GitHub Repository Comprehension & Architecture Engine\n"
}

# Determine source directory (local repo vs curl install)
detect_source_dir() {
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || echo "")"

    if [[ -n "$script_dir" && -d "${script_dir}/skills/know-it" && -d "${script_dir}/commands" ]]; then
        echo "$script_dir"
    else
        # Running via pipe (curl | bash)
        echo -e "${BLUE}▶ Fetching know-it repository into ${LOCAL_SHARE_DIR}...${RESET}"
        mkdir -p "$(dirname "$LOCAL_SHARE_DIR")"
        if [[ -d "${LOCAL_SHARE_DIR}/.git" ]]; then
            git -C "$LOCAL_SHARE_DIR" pull --quiet origin main 2>/dev/null || true
        else
            rm -rf "$LOCAL_SHARE_DIR"
            git clone --depth 1 --quiet "$REPO_URL" "$LOCAL_SHARE_DIR" 2>/dev/null || {
                if [[ -d "./skills/know-it" ]]; then
                    echo "$(pwd)"
                    return
                fi
                log_error "Failed to clone repository from $REPO_URL"
                exit 1
            }
        fi
        echo "$LOCAL_SHARE_DIR"
    fi
}

DRY_RUN=0
TARGET_AGENT=""

# Parse flags
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)
            DRY_RUN=1
            shift
            ;;
        --agent)
            TARGET_AGENT="${2:-}"
            shift 2
            ;;
        --help|-h)
            cat <<EOF
Usage: install.sh [OPTIONS]

Options:
  --agent <name>    Install only for specific agent (claude, antigravity, opencode, codex, cursor, windsurf)
  --dry-run         Preview actions without modifying files
  --help, -h        Show this help message

One-Liner Execution:
  curl -fsSL https://raw.githubusercontent.com/Chintanpatel24/know-it/main/install.sh | bash
EOF
            exit 0
            ;;
        *)
            shift
            ;;
    esac
done

print_banner

SRC_DIR=$(detect_source_dir)
log_info "Source repository: ${SRC_DIR}"
echo ""

# 1. Install CLI helper executable
install_cli_helper() {
    echo -e "${BOLD}1. Installing CLI Helper (know-it)...${RESET}"
    mkdir -p "$LOCAL_BIN_DIR"
    local bin_target="${LOCAL_BIN_DIR}/know-it"
    local alias_target="${LOCAL_BIN_DIR}/know-how"

    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "[Dry-Run] Would copy ${SRC_DIR}/bin/know-it to ${bin_target}"
    else
        cp "${SRC_DIR}/bin/know-it" "$bin_target"
        chmod +x "$bin_target"
        ln -sf "$bin_target" "$alias_target"
        log_success "CLI executable installed: ${bin_target} (and ${alias_target})"
    fi

    if [[ ":$PATH:" != *":$LOCAL_BIN_DIR:"* ]]; then
        log_warn "${LOCAL_BIN_DIR} is not in your current PATH."
        echo -e "     Add it to your shell config (~/.bashrc or ~/.zshrc):"
        echo -e "     ${CYAN}export PATH=\"\$HOME/.local/bin:\$PATH\"${RESET}"
    fi
    echo ""
}

# 2. Install Claude Code bindings
install_claude() {
    local detected=0
    if command -v claude &>/dev/null || [[ -d "$HOME/.claude" ]]; then
        detected=1
    fi

    if [[ -n "$TARGET_AGENT" && "$TARGET_AGENT" != "claude" ]]; then
        return
    fi

    if [[ $detected -eq 1 || "$TARGET_AGENT" == "claude" ]]; then
        echo -e "${BOLD}2. Installing for Claude Code...${RESET}"
        local cmd_dir="$HOME/.claude/commands"
        local skill_dir="$HOME/.claude/skills/know-it"

        if [[ $DRY_RUN -eq 1 ]]; then
            log_info "[Dry-Run] Would install slash commands into ${cmd_dir}"
            log_info "[Dry-Run] Would install skill into ${skill_dir}"
        else
            mkdir -p "$cmd_dir" "$skill_dir"
            cp "${SRC_DIR}/commands/"*.md "$cmd_dir/"
            cp -r "${SRC_DIR}/skills/know-it/"* "$skill_dir/"
            # Clean legacy know-how directory if exists
            rm -rf "$HOME/.claude/skills/know-how" 2>/dev/null || true
            log_success "Slash commands installed: /how, /bts, /why, /where (in ${cmd_dir})"
            log_success "Skill package installed: ${skill_dir}"
        fi
        echo ""
    fi
}

# 3. Install Antigravity bindings
install_antigravity() {
    local detected=0
    if command -v agy &>/dev/null || command -v antigravity &>/dev/null || [[ -d "$HOME/.gemini" ]]; then
        detected=1
    fi

    if [[ -n "$TARGET_AGENT" && "$TARGET_AGENT" != "antigravity" ]]; then
        return
    fi

    if [[ $detected -eq 1 || "$TARGET_AGENT" == "antigravity" ]]; then
        echo -e "${BOLD}3. Installing for Antigravity (Google AGY)...${RESET}"
        local agy_skill_dir="$HOME/.gemini/config/skills/know-it"

        if [[ $DRY_RUN -eq 1 ]]; then
            log_info "[Dry-Run] Would install skill into ${agy_skill_dir}"
        else
            mkdir -p "$agy_skill_dir"
            cp -r "${SRC_DIR}/skills/know-it/"* "$agy_skill_dir/"
            # Clean legacy know-how directory if exists
            rm -rf "$HOME/.gemini/config/skills/know-how" 2>/dev/null || true
            log_success "Antigravity skill installed: ${agy_skill_dir}/SKILL.md"
        fi
        echo ""
    fi
}

# 4. Install OpenCode bindings
install_opencode() {
    local detected=0
    if command -v opencode &>/dev/null || [[ -d "$HOME/.config/opencode" ]]; then
        detected=1
    fi

    if [[ -n "$TARGET_AGENT" && "$TARGET_AGENT" != "opencode" ]]; then
        return
    fi

    if [[ $detected -eq 1 || "$TARGET_AGENT" == "opencode" ]]; then
        echo -e "${BOLD}4. Installing for OpenCode...${RESET}"
        local oc_cmd_dir="$HOME/.config/opencode/commands"
        local oc_skill_dir="$HOME/.config/opencode/skills/know-it"

        if [[ $DRY_RUN -eq 1 ]]; then
            log_info "[Dry-Run] Would install commands into ${oc_cmd_dir}"
            log_info "[Dry-Run] Would install skill into ${oc_skill_dir}"
        else
            mkdir -p "$oc_cmd_dir" "$oc_skill_dir"
            cp "${SRC_DIR}/commands/"*.md "$oc_cmd_dir/"
            cp -r "${SRC_DIR}/skills/know-it/"* "$oc_skill_dir/"
            # Clean legacy know-how directory if exists
            rm -rf "$HOME/.config/opencode/skills/know-how" 2>/dev/null || true
            log_success "OpenCode slash commands installed: ${oc_cmd_dir}"
            log_success "OpenCode skill installed: ${oc_skill_dir}"
        fi
        echo ""
    fi
}

# 5. Install Codex CLI bindings
install_codex() {
    local detected=0
    if command -v codex &>/dev/null || [[ -d "$HOME/.codex" ]]; then
        detected=1
    fi

    if [[ -n "$TARGET_AGENT" && "$TARGET_AGENT" != "codex" ]]; then
        return
    fi

    if [[ $detected -eq 1 || "$TARGET_AGENT" == "codex" ]]; then
        echo -e "${BOLD}5. Installing for Codex CLI / Operator...${RESET}"
        local codex_skill_dir="$HOME/.codex/skills/know-it"

        if [[ $DRY_RUN -eq 1 ]]; then
            log_info "[Dry-Run] Would install skill into ${codex_skill_dir}"
        else
            mkdir -p "$codex_skill_dir"
            cp -r "${SRC_DIR}/skills/know-it/"* "$codex_skill_dir/"
            rm -rf "$HOME/.codex/skills/know-how" 2>/dev/null || true
            log_success "Codex skill installed: ${codex_skill_dir}"
        fi
        echo ""
    fi
}

# 6. Install Universal AgentSkills Standard
install_universal_agentskills() {
    if [[ -n "$TARGET_AGENT" && "$TARGET_AGENT" != "agentskills" ]]; then
        return
    fi

    echo -e "${BOLD}6. Installing Universal AgentSkills standard...${RESET}"
    local universal_dir="$HOME/.agentskills/know-it"

    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "[Dry-Run] Would install skill into ${universal_dir}"
    else
        mkdir -p "$universal_dir"
        cp -r "${SRC_DIR}/skills/know-it/"* "$universal_dir/"
        rm -rf "$HOME/.agentskills/know-how" 2>/dev/null || true
        log_success "Universal AgentSkills installed: ${universal_dir}"
    fi
    echo ""
}

# 7. Install Cursor & Windsurf Rules (if directories exist)
install_ide_rules() {
    if [[ -d "$HOME/.cursor" ]]; then
        echo -e "${BOLD}7. Installing Cursor Global Rules...${RESET}"
        local cursor_rules="$HOME/.cursor/rules"
        if [[ $DRY_RUN -eq 1 ]]; then
            log_info "[Dry-Run] Would copy rules to ${cursor_rules}/know-it.md"
        else
            mkdir -p "$cursor_rules"
            cp "${SRC_DIR}/rules/know-it.md" "${cursor_rules}/know-it.md"
            rm -f "${cursor_rules}/know-how.md" 2>/dev/null || true
            log_success "Cursor rule installed: ${cursor_rules}/know-it.md"
        fi
        echo ""
    fi

    if [[ -d "$HOME/.windsurf" ]]; then
        echo -e "${BOLD}8. Installing Windsurf Global Rules...${RESET}"
        local windsurf_rules="$HOME/.windsurf/rules"
        if [[ $DRY_RUN -eq 1 ]]; then
            log_info "[Dry-Run] Would copy rules to ${windsurf_rules}/know-it.md"
        else
            mkdir -p "$windsurf_rules"
            cp "${SRC_DIR}/rules/know-it.md" "${windsurf_rules}/know-it.md"
            rm -f "${windsurf_rules}/know-how.md" 2>/dev/null || true
            log_success "Windsurf rule installed: ${windsurf_rules}/know-it.md"
        fi
        echo ""
    fi
}

# Run installation steps
install_cli_helper
install_claude
install_antigravity
install_opencode
install_codex
install_universal_agentskills
install_ide_rules

echo -e "${GREEN}${BOLD}🎉 Installation Complete!${RESET}\n"
echo -e "You can now use ${BOLD}know-it${RESET} in your AI agents:"
echo -e "  • ${CYAN}/how <github-repo-link>${RESET}  -> Interactive triage & project overview"
echo -e "  • ${CYAN}/bts <github-repo-link>${RESET}  -> Behind-The-Scenes systems & code logic"
echo -e "  • ${CYAN}/why <github-repo-link>${RESET}  -> Real-world use cases & personal aims"
echo -e "  • ${CYAN}/where <github-repo-link>${RESET}-> Codebase map, entry points & data flow"
echo ""
echo -e "Example: ${BOLD}/how ettercap/ettercap${RESET}"
