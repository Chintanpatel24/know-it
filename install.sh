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
RESET="\033[0m"

log_info()    { echo -e "  ${BLUE}[INFO]${RESET} $*" >&2; }
log_success() { echo -e "  ${GREEN}[OK]${RESET} $*" >&2; }
log_warn()    { echo -e "  ${YELLOW}[WARN]${RESET} $*" >&2; }
log_error()   { echo -e "  ${RED}[ERROR]${RESET} $*" >&2; }

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

# Prompt reader supporting pipes (curl ... | bash) via /dev/tty
prompt_read() {
    local prompt_msg="$1"
    local var_name="$2"
    local default_val="${3:-}"

    if [ -t 0 ]; then
        read -r -p "$prompt_msg" answer || true
    elif [ -e /dev/tty ]; then
        read -r -p "$prompt_msg" answer < /dev/tty || true
    else
        answer="$default_val"
    fi

    if [ -z "${answer:-}" ]; then
        answer="$default_val"
    fi
    eval "$var_name=\"$answer\""
}

DRY_RUN=0
NON_INTERACTIVE=0
TARGET_AGENT=""
CHANNEL="release"

# Parse flags
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)
            DRY_RUN=1
            shift
            ;;
        --agent)
            TARGET_AGENT="${2:-}"
            NON_INTERACTIVE=1
            shift 2
            ;;
        --channel)
            CHANNEL="${2:-release}"
            shift 2
            ;;
        --all)
            TARGET_AGENT="all"
            NON_INTERACTIVE=1
            shift
            ;;
        --yes|-y|--non-interactive)
            NON_INTERACTIVE=1
            shift
            ;;
        --help|-h)
            cat <<EOF
Usage: install.sh [OPTIONS]

Options:
  --agent <name>       Install only for specific agent (claude, antigravity, opencode, codex, cursor, windsurf, agentskills, all)
  --channel <name>     Source channel: 'release' (default, recommended) or 'main'
  --all                Install for all detected agents non-interactively
  -y, --yes            Skip interactive prompts and install with defaults
  --dry-run            Preview actions without modifying files
  --help, -h           Show this help message

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

SRC_DIR=""

# Determine source directory (local repo vs remote fetch)
detect_and_sync_source() {
    local selected_channel="$1"
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || echo "")"

    # If running locally from repo
    if [[ -n "$script_dir" && -d "${script_dir}/skills/know-it" && -d "${script_dir}/commands" ]]; then
        SRC_DIR="$script_dir"
        return 0
    fi

    # Running via pipe (curl | bash)
    echo -e "${BLUE}==> Preparing know-it repository in ${LOCAL_SHARE_DIR}...${RESET}" >&2
    mkdir -p "$(dirname "$LOCAL_SHARE_DIR")"
    if [[ -d "${LOCAL_SHARE_DIR}/.git" ]]; then
        git -C "$LOCAL_SHARE_DIR" fetch --tags --quiet origin 2>/dev/null || true
    else
        rm -rf "$LOCAL_SHARE_DIR"
        git clone --quiet "$REPO_URL" "$LOCAL_SHARE_DIR" 2>/dev/null || {
            if [[ -d "./skills/know-it" ]]; then
                SRC_DIR="$(pwd)"
                return 0
            fi
            log_error "Failed to clone repository from $REPO_URL"
            exit 1
        }
    fi

    if [[ ! -d "${LOCAL_SHARE_DIR}/skills/know-it" ]]; then
        git -C "$LOCAL_SHARE_DIR" checkout --quiet feature/know-it-suite 2>/dev/null || true
    fi

    if [[ "$selected_channel" == "release" ]]; then
        local latest_tag=""
        latest_tag=$(git -C "$LOCAL_SHARE_DIR" describe --tags "$(git -C "$LOCAL_SHARE_DIR" rev-list --tags --max-count=1 2>/dev/null)" 2>/dev/null || true)
        if [[ -n "$latest_tag" ]]; then
            log_info "Installing from latest release tag: ${latest_tag}"
            git -C "$LOCAL_SHARE_DIR" checkout --quiet "$latest_tag" 2>/dev/null || true
        else
            log_info "No published release tags found yet. Using latest commit from 'main' branch..."
            git -C "$LOCAL_SHARE_DIR" checkout --quiet main 2>/dev/null || true
            git -C "$LOCAL_SHARE_DIR" pull --quiet origin main 2>/dev/null || true
        fi
    else
        log_info "Installing from 'main' branch..."
        git -C "$LOCAL_SHARE_DIR" checkout --quiet main 2>/dev/null || true
        git -C "$LOCAL_SHARE_DIR" pull --quiet origin main 2>/dev/null || true
    fi

    if [[ ! -d "${LOCAL_SHARE_DIR}/skills/know-it" ]]; then
        git -C "$LOCAL_SHARE_DIR" checkout --quiet feature/know-it-suite 2>/dev/null || true
    fi

    SRC_DIR="$LOCAL_SHARE_DIR"
}

# Scan available agents on the host system
scan_agents() {
    AVAILABLE_AGENTS=()
    AVAILABLE_LABELS=()

    if command -v claude &>/dev/null || [[ -d "$HOME/.claude" ]]; then
        AVAILABLE_AGENTS+=("claude")
        AVAILABLE_LABELS+=("Claude Code (~/.claude)")
    fi

    if command -v agy &>/dev/null || command -v antigravity &>/dev/null || [[ -d "$HOME/.gemini" ]]; then
        AVAILABLE_AGENTS+=("antigravity")
        AVAILABLE_LABELS+=("Antigravity / Google AGY (~/.gemini)")
    fi

    if command -v opencode &>/dev/null || [[ -d "$HOME/.config/opencode" ]]; then
        AVAILABLE_AGENTS+=("opencode")
        AVAILABLE_LABELS+=("OpenCode (~/.config/opencode)")
    fi

    if command -v codex &>/dev/null || [[ -d "$HOME/.codex" ]]; then
        AVAILABLE_AGENTS+=("codex")
        AVAILABLE_LABELS+=("Codex CLI / Operator (~/.codex)")
    fi

    if [[ -d "$HOME/.cursor" ]]; then
        AVAILABLE_AGENTS+=("cursor")
        AVAILABLE_LABELS+=("Cursor Rules (~/.cursor)")
    fi

    if [[ -d "$HOME/.windsurf" ]]; then
        AVAILABLE_AGENTS+=("windsurf")
        AVAILABLE_LABELS+=("Windsurf Rules (~/.windsurf)")
    fi

    AVAILABLE_AGENTS+=("agentskills")
    AVAILABLE_LABELS+=("Universal AgentSkills Standard (~/.agentskills)")
}

scan_agents

# Interactive Agent Selection
SELECTED_AGENTS=()

if [[ $NON_INTERACTIVE -eq 0 ]]; then
    echo -e "${BOLD}Detected AI Agent Environments:${RESET}"
    for i in "${!AVAILABLE_LABELS[@]}"; do
        idx=$((i + 1))
        echo -e "  ${CYAN}${idx}.${RESET} ${AVAILABLE_LABELS[$i]}"
    done
    all_idx=$((${#AVAILABLE_LABELS[@]} + 1))
    echo -e "  ${CYAN}${all_idx}.${RESET} ${BOLD}All detected environments [Recommended]${RESET}\n"

    prompt_read "Select agent environment(s) to install [1-${all_idx}, default: ${all_idx}]: " agent_choice "$all_idx"

    if [[ "$agent_choice" == "$all_idx" || "$agent_choice" == "all" || -z "$agent_choice" ]]; then
        SELECTED_AGENTS=("${AVAILABLE_AGENTS[@]}")
    else
        IFS=',' read -ra ADDR <<< "$agent_choice"
        for num in "${ADDR[@]}"; do
            num=$(echo "$num" | tr -d ' ')
            if [[ "$num" -ge 1 && "$num" -le ${#AVAILABLE_AGENTS[@]} ]]; then
                SELECTED_AGENTS+=("${AVAILABLE_AGENTS[$((num - 1))]}")
            fi
        done
        if [[ ${#SELECTED_AGENTS[@]} -eq 0 ]]; then
            log_warn "Unrecognized selection, defaulting to all detected agents."
            SELECTED_AGENTS=("${AVAILABLE_AGENTS[@]}")
        fi
    fi

    echo ""
    echo -e "${BOLD}Select Source Channel:${RESET}"
    echo -e "  ${CYAN}1.${RESET} Latest Release [Recommended]"
    echo -e "  ${CYAN}2.${RESET} Main branch (main)\n"

    prompt_read "Select source channel [1-2, default: 1]: " channel_choice "1"
    if [[ "$channel_choice" == "2" || "$channel_choice" == "main" ]]; then
        CHANNEL="main"
    else
        CHANNEL="release"
    fi
    echo ""
else
    if [[ -z "$TARGET_AGENT" || "$TARGET_AGENT" == "all" ]]; then
        SELECTED_AGENTS=("${AVAILABLE_AGENTS[@]}")
    else
        SELECTED_AGENTS=("$TARGET_AGENT")
    fi
fi

detect_and_sync_source "$CHANNEL"
log_info "Source repository: ${SRC_DIR}"
echo ""

is_agent_selected() {
    local target="$1"
    for a in "${SELECTED_AGENTS[@]}"; do
        if [[ "$a" == "$target" || "$a" == "all" ]]; then
            return 0
        fi
    done
    return 1
}

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

# 2. Install Claude Code (Commands, Skills, and Plugin Store)
install_claude() {
    if ! is_agent_selected "claude"; then return; fi

    echo -e "${BOLD}2. Installing for Claude Code...${RESET}"
    local cmd_dir="$HOME/.claude/commands"
    local skill_dir="$HOME/.claude/skills/know-it"

    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "[Dry-Run] Would install slash commands into ${cmd_dir}"
        log_info "[Dry-Run] Would install self-contained skill into ${skill_dir}"
        log_info "[Dry-Run] Would register Claude Code plugin"
    else
        mkdir -p "$cmd_dir" "$skill_dir"
        cp "${SRC_DIR}/commands/"*.md "$cmd_dir/"
        cp -r "${SRC_DIR}/skills/know-it/"* "$skill_dir/"
        mkdir -p "${skill_dir}/bin"
        cp "${SRC_DIR}/bin/know-it" "${skill_dir}/bin/know-it"
        chmod +x "${skill_dir}/bin/know-it"
        rm -rf "$HOME/.claude/skills/know-how" 2>/dev/null || true

        # Claude Code Plugin registration
        if command -v claude &>/dev/null; then
            log_info "Registering know-it in Claude Code plugin marketplace..."
            claude plugin marketplace add "${SRC_DIR}" 2>/dev/null || claude plugin marketplace add "Chintanpatel24/know-it" 2>/dev/null || true
            claude plugin install "know-it@know-it" 2>/dev/null || claude plugin install "know-it" 2>/dev/null || true
        fi

        log_success "Claude Code slash commands installed: /how, /bts, /why, /where (in ${cmd_dir})"
        log_success "Claude Code plugin & skill package installed: ${skill_dir}"
    fi
    echo ""
}

# 3. Install Antigravity (Skills, Workflows, and Plugin)
install_antigravity() {
    if ! is_agent_selected "antigravity"; then return; fi

    echo -e "${BOLD}3. Installing for Antigravity (Google AGY)...${RESET}"
    local agy_config="$HOME/.gemini/config"

    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "[Dry-Run] Would install skills for /how, /bts, /why, /where, /know-it into ${agy_config}/skills"
        log_info "[Dry-Run] Would install workflows into ${agy_config}/workflows"
    else
        # Install skills for each slash command
        for s in how bts why where know-it; do
            local target_skill="${agy_config}/skills/${s}"
            mkdir -p "${target_skill}/bin"
            if [[ -d "${SRC_DIR}/skills/${s}" ]]; then
                cp -r "${SRC_DIR}/skills/${s}/"* "${target_skill}/"
            else
                cp -r "${SRC_DIR}/skills/know-it/"* "${target_skill}/"
            fi
            cp "${SRC_DIR}/bin/know-it" "${target_skill}/bin/know-it"
            chmod +x "${target_skill}/bin/know-it"
        done

        # Install workflows for direct TUI /how, /bts, /why, /where slash command execution
        mkdir -p "${agy_config}/workflows" "${agy_config}/global_workflows"
        for cmd in how bts why where; do
            if [[ -f "${SRC_DIR}/commands/${cmd}.md" ]]; then
                cp "${SRC_DIR}/commands/${cmd}.md" "${agy_config}/workflows/${cmd}.md"
                cp "${SRC_DIR}/commands/${cmd}.md" "${agy_config}/global_workflows/${cmd}.md"
            fi
        done
        if [[ -f "${SRC_DIR}/rules/know-it.md" ]]; then
            cp "${SRC_DIR}/rules/know-it.md" "${agy_config}/workflows/know-it.md"
            cp "${SRC_DIR}/rules/know-it.md" "${agy_config}/global_workflows/know-it.md"
        fi

        # Install plugin bundle
        local plugin_dir="${agy_config}/plugins/know-it"
        mkdir -p "${plugin_dir}/skills" "${plugin_dir}/rules"
        cat <<'EOF' > "${plugin_dir}/plugin.json"
{
  "name": "know-it",
  "description": "Universal GitHub repository comprehension and architecture engine"
}
EOF
        cp -r "${SRC_DIR}/skills/"* "${plugin_dir}/skills/" 2>/dev/null || true
        cp "${SRC_DIR}/rules/know-it.md" "${plugin_dir}/rules/AGENTS.md"

        rm -rf "$HOME/.gemini/config/skills/know-how" 2>/dev/null || true
        log_success "Antigravity slash commands registered: /how, /bts, /why, /where, /know-it"
        log_success "Antigravity skills & workflows installed: ${agy_config}"
    fi
    echo ""
}

# 4. Install OpenCode directly into ~/.config/opencode/
install_opencode() {
    if ! is_agent_selected "opencode"; then return; fi

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
        mkdir -p "${oc_skill_dir}/bin"
        cp "${SRC_DIR}/bin/know-it" "${oc_skill_dir}/bin/know-it"
        chmod +x "${oc_skill_dir}/bin/know-it"
        rm -rf "$HOME/.config/opencode/skills/know-how" 2>/dev/null || true
        log_success "OpenCode slash commands installed: ${oc_cmd_dir}"
        log_success "OpenCode skill installed: ${oc_skill_dir}"
    fi
    echo ""
}

# 5. Install Codex CLI directly into ~/.codex/skills/
install_codex() {
    if ! is_agent_selected "codex"; then return; fi

    echo -e "${BOLD}5. Installing for Codex CLI / Operator...${RESET}"
    local codex_skill_dir="$HOME/.codex/skills/know-it"

    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "[Dry-Run] Would install skill into ${codex_skill_dir}"
    else
        mkdir -p "$codex_skill_dir"
        cp -r "${SRC_DIR}/skills/know-it/"* "$codex_skill_dir/"
        mkdir -p "${codex_skill_dir}/bin"
        cp "${SRC_DIR}/bin/know-it" "${codex_skill_dir}/bin/know-it"
        chmod +x "${codex_skill_dir}/bin/know-it"
        rm -rf "$HOME/.codex/skills/know-how" 2>/dev/null || true
        log_success "Codex skill installed: ${codex_skill_dir}"
    fi
    echo ""
}

# 6. Install Universal AgentSkills Standard directly into ~/.agentskills/
install_universal_agentskills() {
    if ! is_agent_selected "agentskills"; then return; fi

    echo -e "${BOLD}6. Installing Universal AgentSkills standard...${RESET}"
    local universal_dir="$HOME/.agentskills/know-it"

    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "[Dry-Run] Would install skill into ${universal_dir}"
    else
        mkdir -p "$universal_dir"
        cp -r "${SRC_DIR}/skills/know-it/"* "$universal_dir/"
        mkdir -p "${universal_dir}/bin"
        cp "${SRC_DIR}/bin/know-it" "${universal_dir}/bin/know-it"
        chmod +x "${universal_dir}/bin/know-it"
        rm -rf "$HOME/.agentskills/know-how" 2>/dev/null || true
        log_success "Universal AgentSkills installed: ${universal_dir}"
    fi
    echo ""
}

# 7. Install Cursor & Windsurf Rules
install_ide_rules() {
    if is_agent_selected "cursor" && [[ -d "$HOME/.cursor" ]]; then
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

    if is_agent_selected "windsurf" && [[ -d "$HOME/.windsurf" ]]; then
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

install_cli_helper
install_claude
install_antigravity
install_opencode
install_codex
install_universal_agentskills
install_ide_rules

echo -e "${GREEN}${BOLD}Installation Complete!${RESET}\n"
echo -e "know-it is permanently installed into your agent configuration directories."
echo -e "You can now use know-it in your AI agents:"
echo -e "  * ${CYAN}/how <github-repo-link>${RESET}  -> Interactive triage & project overview"
echo -e "  * ${CYAN}/bts <github-repo-link>${RESET}  -> Behind-The-Scenes systems & code logic"
echo -e "  * ${CYAN}/why <github-repo-link>${RESET}  -> Real-world use cases & personal aims"
echo -e "  * ${CYAN}/where <github-repo-link>${RESET}-> Codebase map, entry points & data flow"
echo ""
echo -e "Example: ${BOLD}/how torvalds/linux${RESET}"
