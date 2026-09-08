#!/usr/bin/env bash
# know-it - Universal Agent Skill & Slash Command Updater
# Scans existing know-it presence and updates selected agents from release or main

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
    echo -e "${RESET}${BOLD}Universal Agent Skill & Slash Command Updater (v${VERSION})${RESET}"
    echo -e "Interactive GitHub Repository Comprehension & Architecture Engine\n"
}

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
Usage: update.sh [OPTIONS]

Options:
  --agent <name>       Update only specific agent (claude, antigravity, opencode, codex, cursor, windsurf, agentskills, all)
  --channel <name>     Source channel: 'release' (default, recommended) or 'main'
  --all                Update all detected installations non-interactively
  -y, --yes            Skip interactive prompts and update with defaults
  --dry-run            Preview actions without modifying files
  --help, -h           Show this help message

One-Liner Execution:
  curl -fsSL https://raw.githubusercontent.com/Chintanpatel24/know-it/main/update.sh | bash
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

# Scan for existing know-it installations
INSTALLED_AGENTS=()
INSTALLED_LABELS=()

if [[ -f "$HOME/.claude/commands/how.md" || -d "$HOME/.claude/skills/know-it" ]]; then
    INSTALLED_AGENTS+=("claude")
    INSTALLED_LABELS+=("Claude Code (~/.claude)")
fi

if [[ -f "$HOME/.gemini/config/skills/know-it/SKILL.md" ]]; then
    INSTALLED_AGENTS+=("antigravity")
    INSTALLED_LABELS+=("Antigravity / Google AGY (~/.gemini)")
fi

if [[ -f "$HOME/.config/opencode/commands/how.md" || -d "$HOME/.config/opencode/skills/know-it" ]]; then
    INSTALLED_AGENTS+=("opencode")
    INSTALLED_LABELS+=("OpenCode (~/.config/opencode)")
fi

if [[ -d "$HOME/.codex/skills/know-it" ]]; then
    INSTALLED_AGENTS+=("codex")
    INSTALLED_LABELS+=("Codex CLI / Operator (~/.codex)")
fi

if [[ -d "$HOME/.agentskills/know-it" ]]; then
    INSTALLED_AGENTS+=("agentskills")
    INSTALLED_LABELS+=("Universal AgentSkills Standard (~/.agentskills)")
fi

if [[ -f "$HOME/.cursor/rules/know-it.md" ]]; then
    INSTALLED_AGENTS+=("cursor")
    INSTALLED_LABELS+=("Cursor Rules (~/.cursor)")
fi

if [[ -f "$HOME/.windsurf/rules/know-it.md" ]]; then
    INSTALLED_AGENTS+=("windsurf")
    INSTALLED_LABELS+=("Windsurf Rules (~/.windsurf)")
fi

# If no installation found
if [[ ${#INSTALLED_AGENTS[@]} -eq 0 ]]; then
    log_warn "No existing know-it installations found on this system."
    prompt_read "Would you like to run the full installer instead? [Y/n]: " run_installer "Y"
    if [[ "$run_installer" =~ ^[Yy]$ || -z "$run_installer" ]]; then
        script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || echo "")"
        if [[ -f "${script_dir}/install.sh" ]]; then
            exec "${script_dir}/install.sh" "$@"
        else
            curl -fsSL https://raw.githubusercontent.com/Chintanpatel24/know-it/main/install.sh | bash
            exit 0
        fi
    else
        echo "Update cancelled."
        exit 0
    fi
fi

# Interactive Agent Selection
SELECTED_AGENTS=()

if [[ $NON_INTERACTIVE -eq 0 ]]; then
    echo -e "${BOLD}Detected Installed know-it Environments:${RESET}"
    for i in "${!INSTALLED_LABELS[@]}"; do
        idx=$((i + 1))
        echo -e "  ${CYAN}${idx}.${RESET} ${INSTALLED_LABELS[$i]}"
    done
    all_idx=$((${#INSTALLED_LABELS[@]} + 1))
    echo -e "  ${CYAN}${all_idx}.${RESET} ${BOLD}All installed environments [Recommended]${RESET}\n"

    prompt_read "Select environment(s) to update [1-${all_idx}, default: ${all_idx}]: " agent_choice "$all_idx"

    if [[ "$agent_choice" == "$all_idx" || "$agent_choice" == "all" || -z "$agent_choice" ]]; then
        SELECTED_AGENTS=("${INSTALLED_AGENTS[@]}")
    else
        IFS=',' read -ra ADDR <<< "$agent_choice"
        for num in "${ADDR[@]}"; do
            num=$(echo "$num" | tr -d ' ')
            if [[ "$num" -ge 1 && "$num" -le ${#INSTALLED_AGENTS[@]} ]]; then
                SELECTED_AGENTS+=("${INSTALLED_AGENTS[$((num - 1))]}")
            fi
        done
        if [[ ${#SELECTED_AGENTS[@]} -eq 0 ]]; then
            log_warn "Unrecognized selection, defaulting to all installed environments."
            SELECTED_AGENTS=("${INSTALLED_AGENTS[@]}")
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
        SELECTED_AGENTS=("${INSTALLED_AGENTS[@]}")
    else
        SELECTED_AGENTS=("$TARGET_AGENT")
    fi
fi

# Fetch and sync source repository
detect_and_sync_source() {
    local selected_channel="$1"
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || echo "")"

    # If running locally from repo
    if [[ -n "$script_dir" && -d "${script_dir}/skills/know-it" && -d "${script_dir}/commands" ]]; then
        SRC_DIR="$script_dir"
        return 0
    fi

    echo -e "${BLUE}==> Fetching latest know-it updates into ${LOCAL_SHARE_DIR}...${RESET}" >&2
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
            log_info "Updating from latest release tag: ${latest_tag}"
            git -C "$LOCAL_SHARE_DIR" checkout --quiet "$latest_tag" 2>/dev/null || true
        else
            log_info "No published release tags found yet. Updating from latest 'main' branch..."
            git -C "$LOCAL_SHARE_DIR" checkout --quiet main 2>/dev/null || true
            git -C "$LOCAL_SHARE_DIR" pull --quiet origin main 2>/dev/null || true
        fi
    else
        log_info "Updating from latest 'main' branch..."
        git -C "$LOCAL_SHARE_DIR" checkout --quiet main 2>/dev/null || true
        git -C "$LOCAL_SHARE_DIR" pull --quiet origin main 2>/dev/null || true
    fi

    if [[ ! -d "${LOCAL_SHARE_DIR}/skills/know-it" ]]; then
        git -C "$LOCAL_SHARE_DIR" checkout --quiet feature/know-it-suite 2>/dev/null || true
    fi

    SRC_DIR="$LOCAL_SHARE_DIR"
}

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

# Update CLI helper
update_cli_helper() {
    echo -e "${BOLD}1. Updating CLI Helper (know-it)...${RESET}"
    mkdir -p "$LOCAL_BIN_DIR"
    local bin_target="${LOCAL_BIN_DIR}/know-it"
    local alias_target="${LOCAL_BIN_DIR}/know-how"

    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "[Dry-Run] Would copy ${SRC_DIR}/bin/know-it to ${bin_target}"
    else
        cp "${SRC_DIR}/bin/know-it" "$bin_target"
        chmod +x "$bin_target"
        ln -sf "$bin_target" "$alias_target"
        log_success "CLI executable updated: ${bin_target}"
    fi
    echo ""
}

# Update Claude Code
update_claude() {
    if ! is_agent_selected "claude"; then return; fi

    echo -e "${BOLD}2. Updating Claude Code...${RESET}"
    local cmd_dir="$HOME/.claude/commands"
    local skill_dir="$HOME/.claude/skills/know-it"

    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "[Dry-Run] Would update commands in ${cmd_dir}"
        log_info "[Dry-Run] Would update skill in ${skill_dir}"
    else
        mkdir -p "$cmd_dir" "$skill_dir"
        cp "${SRC_DIR}/commands/"*.md "$cmd_dir/"
        cp -r "${SRC_DIR}/skills/know-it/"* "$skill_dir/"
        mkdir -p "${skill_dir}/bin"
        cp "${SRC_DIR}/bin/know-it" "${skill_dir}/bin/know-it"
        chmod +x "${skill_dir}/bin/know-it"
        rm -rf "$HOME/.claude/skills/know-how" 2>/dev/null || true
        log_success "Claude Code slash commands and self-contained skill updated."
    fi
    echo ""
}

# Update Antigravity
update_antigravity() {
    if ! is_agent_selected "antigravity"; then return; fi

    echo -e "${BOLD}3. Updating Antigravity (Google AGY)...${RESET}"
    local agy_skill_dir="$HOME/.gemini/config/skills/know-it"

    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "[Dry-Run] Would update skill in ${agy_skill_dir}"
    else
        mkdir -p "$agy_skill_dir"
        cp -r "${SRC_DIR}/skills/know-it/"* "$agy_skill_dir/"
        mkdir -p "${agy_skill_dir}/bin"
        cp "${SRC_DIR}/bin/know-it" "${agy_skill_dir}/bin/know-it"
        chmod +x "${agy_skill_dir}/bin/know-it"
        rm -rf "$HOME/.gemini/config/skills/know-how" 2>/dev/null || true
        log_success "Antigravity self-contained skill updated: ${agy_skill_dir}/SKILL.md"
    fi
    echo ""
}

# Update OpenCode
update_opencode() {
    if ! is_agent_selected "opencode"; then return; fi

    echo -e "${BOLD}4. Updating OpenCode...${RESET}"
    local oc_cmd_dir="$HOME/.config/opencode/commands"
    local oc_skill_dir="$HOME/.config/opencode/skills/know-it"

    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "[Dry-Run] Would update commands in ${oc_cmd_dir}"
        log_info "[Dry-Run] Would update skill in ${oc_skill_dir}"
    else
        mkdir -p "$oc_cmd_dir" "$oc_skill_dir"
        cp "${SRC_DIR}/commands/"*.md "$oc_cmd_dir/"
        cp -r "${SRC_DIR}/skills/know-it/"* "$oc_skill_dir/"
        mkdir -p "${oc_skill_dir}/bin"
        cp "${SRC_DIR}/bin/know-it" "${oc_skill_dir}/bin/know-it"
        chmod +x "${oc_skill_dir}/bin/know-it"
        rm -rf "$HOME/.config/opencode/skills/know-how" 2>/dev/null || true
        log_success "OpenCode commands and self-contained skill updated."
    fi
    echo ""
}

# Update Codex
update_codex() {
    if ! is_agent_selected "codex"; then return; fi

    echo -e "${BOLD}5. Updating Codex CLI / Operator...${RESET}"
    local codex_skill_dir="$HOME/.codex/skills/know-it"

    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "[Dry-Run] Would update skill in ${codex_skill_dir}"
    else
        mkdir -p "$codex_skill_dir"
        cp -r "${SRC_DIR}/skills/know-it/"* "$codex_skill_dir/"
        mkdir -p "${codex_skill_dir}/bin"
        cp "${SRC_DIR}/bin/know-it" "${codex_skill_dir}/bin/know-it"
        chmod +x "${codex_skill_dir}/bin/know-it"
        rm -rf "$HOME/.codex/skills/know-how" 2>/dev/null || true
        log_success "Codex self-contained skill updated: ${codex_skill_dir}"
    fi
    echo ""
}

# Update Universal AgentSkills
update_agentskills() {
    if ! is_agent_selected "agentskills"; then return; fi

    echo -e "${BOLD}6. Updating Universal AgentSkills standard...${RESET}"
    local universal_dir="$HOME/.agentskills/know-it"

    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "[Dry-Run] Would update skill in ${universal_dir}"
    else
        mkdir -p "$universal_dir"
        cp -r "${SRC_DIR}/skills/know-it/"* "$universal_dir/"
        mkdir -p "${universal_dir}/bin"
        cp "${SRC_DIR}/bin/know-it" "${universal_dir}/bin/know-it"
        chmod +x "${universal_dir}/bin/know-it"
        rm -rf "$HOME/.agentskills/know-how" 2>/dev/null || true
        log_success "Universal AgentSkills updated: ${universal_dir}"
    fi
    echo ""
}

# Update IDE Rules
update_ide_rules() {
    if is_agent_selected "cursor" && [[ -d "$HOME/.cursor" ]]; then
        local cursor_rules="$HOME/.cursor/rules"
        if [[ $DRY_RUN -eq 1 ]]; then
            log_info "[Dry-Run] Would update ${cursor_rules}/know-it.md"
        else
            mkdir -p "$cursor_rules"
            cp "${SRC_DIR}/rules/know-it.md" "${cursor_rules}/know-it.md"
            log_success "Cursor rule updated: ${cursor_rules}/know-it.md"
        fi
    fi

    if is_agent_selected "windsurf" && [[ -d "$HOME/.windsurf" ]]; then
        local windsurf_rules="$HOME/.windsurf/rules"
        if [[ $DRY_RUN -eq 1 ]]; then
            log_info "[Dry-Run] Would update ${windsurf_rules}/know-it.md"
        else
            mkdir -p "$windsurf_rules"
            cp "${SRC_DIR}/rules/know-it.md" "${windsurf_rules}/know-it.md"
            log_success "Windsurf rule updated: ${windsurf_rules}/know-it.md"
        fi
    fi
}

update_cli_helper
update_claude
update_antigravity
update_opencode
update_codex
update_agentskills
update_ide_rules

echo -e "${GREEN}${BOLD}Update Complete!${RESET}\n"
echo -e "know-it has been updated successfully."
echo -e "Run ${BOLD}know-it info${RESET} to view active integration status."
