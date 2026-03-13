#!/usr/bin/env bash

################################################################################
# macOS (Intel/x86_64) Server Initial Setup Script
#
# Description: Interactive installation script for essential development tools
# Author: Generated for choovin
# Date: 2025-02-03
#
# Features:
# - Interactive Y/N prompts for each component
# - Robust error handling with colored output
# - Comprehensive logging
# - Zsh with prefix-based history search
# - Latest stable versions from Homebrew
################################################################################

set -euo pipefail

################################################################################
# Global Variables
################################################################################

AUTO_YES=false
ARCH_TYPE="x86_64"
LOG_FILE="$HOME/macos-setup-$(date +%Y%m%d-%H%M%S).log"
BACKUP_DIR="$HOME/.config-backups/$(date +%Y%m%d-%H%M%S)"

################################################################################
# Color Definitions & Logging Functions
################################################################################

if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    CYAN='\033[0;36m'
    NC='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    CYAN=''
    NC=''
fi

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

log_header() {
    echo -e "\n${CYAN}========================================${NC}" | tee -a "$LOG_FILE"
    echo -e "${CYAN}$1${NC}" | tee -a "$LOG_FILE"
    echo -e "${CYAN}========================================${NC}\n" | tee -a "$LOG_FILE"
}

################################################################################
# Helper Functions
################################################################################

ask_yn() {
    local prompt="$1"
    local default="${2:-y}"
    local answer

    if [ "$AUTO_YES" = true ]; then
        echo -e "${CYAN}${prompt} [AUTO-YES]${NC}" | tee -a "$LOG_FILE"
        return 0
    fi

    if [[ "$default" == "y" ]]; then
        prompt="${prompt} [Y/n]: "
    else
        prompt="${prompt} [y/N]: "
    fi

    read -rp "$(echo -e "${CYAN}${prompt}${NC}")" answer
    answer="${answer:-$default}"

    [[ "$answer" =~ ^[Yy]$ ]]
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

backup_path() {
    local path="$1"
    if [ -e "$path" ]; then
        mkdir -p "$BACKUP_DIR"
        local backup_name
        backup_name="$(basename "$path")-$(date +%H%M%S)"
        cp -r "$path" "$BACKUP_DIR/$backup_name"
        log_info "Backed up $path to $BACKUP_DIR/$backup_name"
    fi
}

check_homebrew() {
    if ! command_exists brew; then
        log_info "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    if command_exists brew; then
        log_success "Homebrew is installed: $(brew --version | head -n1)"
    else
        log_error "Failed to install Homebrew"
        exit 1
    fi
}

check_installation_status() {
    log_header "Pre-Installation Status Check"
    log_info "Checking what is currently installed..."
    echo ""

    local tools=("git" "zsh" "docker" "neovim" "node" "gcc" "tmux" "fzf" "rg" "fd" "btop" "lazygit" "lazydocker" "zoxide" "uv" "poetry" "luarocks" "bun" "ghostty" "claude")
    for tool in "${tools[@]}"; do
        if command_exists "$tool"; then
            local version=$($tool --version 2>/dev/null | head -n1 || echo "installed")
            echo -e "  ${GREEN}✓${NC} $tool: $version" | tee -a "$LOG_FILE"
        else
            echo -e "  ${RED}✗${NC} $tool: not installed" | tee -a "$LOG_FILE"
        fi
    done

    echo ""
    log_info "Status check complete"
}

check_prerequisites() {
    log_header "Checking Prerequisites"

    if ! command_exists curl; then
        log_error "curl is required but not installed"
        exit 1
    fi

    check_homebrew

    if ! ping -c 1 baidu.com >/dev/null 2>&1; then
        log_error "No internet connection detected"
        exit 1
    fi

    log_success "Prerequisites check passed"
}

install_homebrew_formulae() {
    local formulae=("$@")
    for formula in "${formulae[@]}"; do
        if brew list "$formula" >/dev/null 2>&1; then
            log_info "$formula is already installed, upgrading..."
            brew upgrade "$formula"
        else
            log_info "Installing $formula..."
            brew install "$formula"
        fi
    done
}

install_git() {
    log_header "Git Installation"

    if command_exists git; then
        log_warn "Git is already installed ($(git --version))"
        if ! ask_yn "Reinstall/upgrade git?" "n"; then
            return 1
        fi
    fi

    if ask_yn "Install/upgrade git?" "y"; then
        brew install git || brew upgrade git
        log_success "Git installed: $(git --version)"
    else
        log_warn "Skipping git installation"
    fi
}

install_zsh() {
    log_header "Zsh & Oh-My-Zsh Installation"

    if ask_yn "Install zsh with oh-my-zsh?" "y"; then
        if ! command_exists zsh; then
            log_info "Installing zsh..."
            brew install zsh
        fi

        if [ ! -d "$HOME/.oh-my-zsh" ]; then
            log_info "Installing oh-my-zsh..."
            RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
        else
            log_warn "oh-my-zsh already installed"
        fi

        local plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search"
        if [ ! -d "$plugin_dir" ]; then
            log_info "Installing zsh-history-substring-search plugin..."
            git clone https://github.com/zsh-users/zsh-history-substring-search "$plugin_dir"
        fi

        log_success "Zsh installed successfully"
    else
        log_warn "Skipping zsh installation"
    fi
}

install_zoxide() {
    log_header "Zoxide Installation"

    if command_exists zoxide; then
        log_warn "Zoxide is already installed ($(zoxide --version))"
        return 1
    fi

    if ask_yn "Install zoxide (smart cd command)?" "y"; then
        log_info "Installing zoxide..."
        brew install zoxide
        log_success "Zoxide installed successfully"
    else
        log_warn "Skipping zoxide installation"
    fi
}

install_lazygit() {
    log_header "Lazygit Installation"

    if command_exists lazygit; then
        log_warn "Lazygit is already installed ($(lazygit --version))"
        return 1
    fi

    if ask_yn "Install lazygit (terminal UI for git)?" "y"; then
        log_info "Installing lazygit..."
        brew install lazygit
        log_success "Lazygit installed: $(lazygit --version)"
    else
        log_warn "Skipping lazygit installation"
    fi
}

install_lazydocker() {
    log_header "Lazydocker Installation"

    if command_exists lazydocker; then
        log_warn "Lazydocker is already installed"
        return 1
    fi

    if ask_yn "Install lazydocker (terminal UI for docker)?" "y"; then
        log_info "Installing lazydocker..."
        brew install lazydocker
        log_success "Lazydocker installed successfully"
    else
        log_warn "Skipping lazydocker installation"
    fi
}

install_docker() {
    log_header "Docker Installation"

    if command_exists docker; then
        log_warn "Docker is already installed ($(docker --version))"
        if ! ask_yn "Reinstall docker?" "n"; then
            return 1
        fi
    fi

    if ask_yn "Install Docker Desktop for Mac?" "y"; then
        log_info "Installing Docker Desktop..."
        brew install --cask docker
        log_info "Docker Desktop installed. Please start Docker Desktop from Applications."
        log_success "Docker installed: $(docker --version 2>/dev/null || echo 'Docker Desktop installed')"
    else
        log_warn "Skipping docker installation"
    fi
}

install_neovim() {
    log_header "Neovim Installation"

    if command_exists nvim; then
        log_warn "Neovim is already installed ($(nvim --version | head -n1))"
        if ! ask_yn "Reinstall neovim?" "n"; then
            return 1
        fi
    fi

    if ask_yn "Install Neovim?" "y"; then
        log_info "Installing Neovim..."
        brew install neovim
        log_success "Neovim installed: $(nvim --version | head -n1)"
    else
        log_warn "Skipping neovim installation"
    fi
}

install_uv() {
    log_header "UV Installation (Python Package Manager)"

    if command_exists uv; then
        log_warn "UV is already installed ($(uv --version))"
        return 1
    fi

    if ask_yn "Install UV (ultrafast Python package manager)?" "y"; then
        log_info "Installing UV..."
        brew install uv
        log_success "UV installed successfully"
    else
        log_warn "Skipping UV installation"
    fi
}

install_poetry() {
    log_header "Poetry Installation"

    if command_exists poetry; then
        log_warn "Poetry is already installed ($(poetry --version))"
        return 1
    fi

    if ask_yn "Install Poetry?" "y"; then
        log_info "Installing Poetry..."
        brew install poetry
        log_success "Poetry installed successfully"
    else
        log_warn "Skipping Poetry installation"
    fi
}

install_luarocks() {
    log_header "LuaRocks Installation"

    if command_exists luarocks; then
        log_warn "LuaRocks is already installed ($(luarocks --version))"
        return 1
    fi

    if ask_yn "Install LuaRocks (Lua package manager)?" "y"; then
        log_info "Installing LuaRocks..."
        brew install luarocks
        log_success "LuaRocks installed: $(luarocks --version)"
    else
        log_warn "Skipping LuaRocks installation"
    fi
}

install_nodejs() {
    log_header "Node.js Installation"

    if command_exists node; then
        log_warn "Node.js is already installed ($(node --version))"
        if ! ask_yn "Reinstall Node.js?" "n"; then
            return 1
        fi
    fi

    if ask_yn "Install Node.js LTS?" "        log_info "y"; then
Installing Node.js LTS..."
        brew install node@20
        brew link --overwrite node@20
        log_success "Node.js installed: $(node --version)"

        if ask_yn "Install yarn and pnpm?" "y"; then
            npm install -g yarn pnpm
            log_success "Global packages installed"
        fi
    else
        log_warn "Skipping Node.js installation"
    fi
}

install_gcc() {
    log_header "GCC & Build Tools Installation"

    if command_exists gcc; then
        log_warn "GCC is already installed ($(gcc --version | head -n1))"
        return 1
    fi

    if ask_yn "Install GCC and build tools?" "y"; then
        log_info "Installing GCC and build tools..."
        brew install gcc make cmake
        log_success "GCC installed successfully: $(gcc --version | head -n1)"
    else
        log_warn "Skipping GCC installation"
    fi
}

install_btop() {
    log_header "Btop Installation"

    if command_exists btop; then
        log_warn "Btop is already installed"
        return 1
    fi

    if ask_yn "Install btop (modern system monitor)?" "y"; then
        log_info "Installing btop..."
        brew install btop
        log_success "Btop installed successfully"
    else
        log_warn "Skipping btop installation"
    fi
}

install_tmux() {
    log_header "Tmux Installation"

    if command_exists tmux; then
        log_warn "Tmux is already installed ($(tmux -V))"
        return 1
    fi

    if ask_yn "Install tmux (terminal multiplexer)?" "y"; then
        brew install tmux
        log_success "Tmux installed: $(tmux -V)"
    else
        log_warn "Skipping tmux installation"
    fi
}

install_fzf() {
    log_header "Fzf Installation"

    if command_exists fzf; then
        log_warn "Fzf is already installed ($(fzf --version))"
        return 1
    fi

    if ask_yn "Install fzf (fuzzy finder)?" "y"; then
        brew install fzf
        log_success "Fzf installed: $(fzf --version)"
    else
        log_warn "Skipping fzf installation"
    fi
}

install_ripgrep_fd() {
    log_header "Ripgrep & Fd Installation"

    if ask_yn "Install ripgrep & fd?" "y"; then
        if ! command_exists rg; then
            log_info "Installing ripgrep..."
            brew install ripgrep
        fi
        if ! command_exists fd; then
            log_info "Installing fd..."
            brew install fd
        fi
        log_success "Ripgrep & fd installed successfully"
    else
        log_warn "Skipping ripgrep & fd installation"
    fi
}

install_bun() {
    log_header "Bun Installation"

    if command_exists bun; then
        log_warn "Bun is already installed ($(bun --version))"
        return 1
    fi

    if ask_yn "Install Bun (fast JavaScript runtime)?" "y"; then
        log_info "Installing Bun..."
        # Bun is not available in Homebrew core, use official installer
        curl -fsSL https://bun.sh/install | bash
        if command_exists bun; then
            log_success "Bun installed successfully"
        else
            # Source the shell config to make bun available
            export BUN_INSTALL="$HOME/.bun"
            export PATH="$BUN_INSTALL/bin:$PATH"
            if [ -f "$BUN_INSTALL/bin/bun" ]; then
                log_success "Bun installed successfully (restart terminal to use)"
            else
                log_error "Failed to install Bun"
            fi
        fi
    else
        log_warn "Skipping Bun installation"
    fi
}

install_ghostty() {
    log_header "Ghostty Terminal Installation"

    if command_exists ghostty; then
        log_warn "Ghostty is already installed"
        return 1
    fi

    if ask_yn "Install Ghostty terminal?" "y"; then
        log_info "Installing Ghostty..."
        brew install --cask ghostty

        # Create config directory
        mkdir -p "$HOME/.config/ghostty"

        # Backup existing config
        backup_path "$HOME/.config/ghostty/config"

        # Write Ghostty configuration
        cat > "$HOME/.config/ghostty/config" << 'GHOSTTY_CONFIG'
# ============================================
# Ghostty Terminal - Complete Configuration
# ============================================
# File: ~/.config/ghostty/config
# Reload: Cmd+Shift+, (macOS)
# View options: ghostty +show-config --default --docs

# --- Typography ---
font-family = "Maple Mono NF CN"
font-size = 14
font-thicken = true
adjust-cell-height = 2

# --- Theme and Colors ---
# Catppuccin with automatic light/dark switching
theme = Catppuccin Mocha

# --- Window and Appearance ---
background-opacity = 0.85
background-blur-radius = 30
macos-titlebar-style = transparent
window-padding-x = 10
window-padding-y = 8
window-save-state = always
window-theme = auto

# --- Cursor ---
cursor-style = bar
cursor-style-blink = true
cursor-opacity = 0.8

# --- Mouse ---
mouse-hide-while-typing = true
copy-on-select = clipboard

# --- Quick Terminal (Quake-style dropdown) ---
quick-terminal-position = top
quick-terminal-screen = mouse
quick-terminal-autohide = true
quick-terminal-animation-duration = 0.15

# --- Security ---
clipboard-paste-protection = true
clipboard-paste-bracketed-safe = true

# --- Shell Integration ---
shell-integration = detect

# --- Keybindings ---
# Tabs
keybind = cmd+t=new_tab
keybind = cmd+shift+left=previous_tab
keybind = cmd+shift+right=next_tab
keybind = cmd+w=close_surface

# Splits
keybind = cmd+d=new_split:right
keybind = cmd+shift+d=new_split:down
keybind = cmd+alt+left=goto_split:left
keybind = cmd+alt+right=goto_split:right
keybind = cmd+alt+up=goto_split:top
keybind = cmd+alt+down=goto_split:bottom

# Font size
keybind = cmd+plus=increase_font_size:1
keybind = cmd+minus=decrease_font_size:1
keybind = cmd+zero=reset_font_size

# Quick terminal global hotkey
keybind = global:ctrl+grave_accent=toggle_quick_terminal

# Splits management
keybind = cmd+shift+e=equalize_splits
keybind = cmd+shift+f=toggle_split_zoom

# Reload config
keybind = cmd+shift+comma=reload_config

# --- Performance ---
# Generous scrollback (25MB)
scrollback-limit = 25000000
GHOSTTY_CONFIG

        log_success "Ghostty installed and configured successfully"
        log_info "Config file: ~/.config/ghostty/config"
        log_info "Note: You may need to install 'Maple Mono NF CN' font for best experience"
    else
        log_warn "Skipping Ghostty installation"
    fi
}

install_claude() {
    log_header "Claude CLI Installation"

    if command_exists claude; then
        log_warn "Claude CLI is already installed ($(claude --version 2>/dev/null || echo 'installed'))"
        return 1
    fi

    if ask_yn "Install Claude CLI with domestic network configuration?" "y"; then
        log_info "Installing Claude CLI..."

        # Install claude CLI via npm
        npm install -g @anthropic-ai/claude-code

        if ! command_exists claude; then
            log_error "Failed to install Claude CLI"
            return 1
        fi

        # Create Claude config directory
        mkdir -p "$HOME/.claude"

        # Configure for domestic network (China proxy)
        # Create settings.json with proxy and API configuration
        cat > "$HOME/.claude/settings.json" << 'CLAUDE_SETTINGS'
{
  "apiProvider": "anthropic",
  "apiBaseUrl": "https://api.anthropic.com",
  "defaultModel": "claude-sonnet-4-6",
  "enableProxy": true,
  "proxyUrl": "http://127.0.0.1:7890"
}
CLAUDE_SETTINGS

        # Create .claude.json for project-level settings
        cat > "$HOME/.claude.json" << 'CLAUDE_PROJECT'
{
  "model": "claude-sonnet-4-6"
}
CLAUDE_PROJECT

        log_success "Claude CLI installed successfully"
        log_info "Configured with domestic network proxy support"
        log_info "Config file: ~/.claude/settings.json"
        log_warn "Note: Make sure your proxy is running on http://127.0.0.1:7890"
        log_warn "Or update the proxy URL in ~/.claude/settings.json"
    else
        log_warn "Skipping Claude CLI installation"
    fi
}

configure_bailian_subscription() {
    log_header "Alibaba Cloud Bailian (百炼) Subscription Configuration"

    if ask_yn "Configure Alibaba Cloud Bailian coding plan subscription?" "y"; then
        # Create .claude directory if not exists
        mkdir -p "$HOME/.claude"

        # Backup existing settings
        backup_path "$HOME/.claude/settings.json"

        # Configure Bailian API with glm-5 as default model
        cat > "$HOME/.claude/settings.json" << 'BAILIAN_CONFIG'
{
  "apiProvider": "openai-compatible",
  "apiBaseUrl": "https://dashscope.aliyuncs.com/compatible-mode/v1",
  "defaultModel": "glm-5",
  "models": {
    "glm-5": {
      "maxTokens": 8192,
      "contextWindow": 128000
    },
    "qwen-max": {
      "maxTokens": 8192,
      "contextWindow": 32000
    },
    "qwen-plus": {
      "maxTokens": 8192,
      "contextWindow": 128000
    }
  },
  "enableProxy": true,
  "proxyUrl": "http://127.0.0.1:7890"
}
BAILIAN_CONFIG

        log_success "Bailian subscription configured"
        log_info "Default model: glm-5"
        log_info "Config file: ~/.claude/settings.json"
        log_warn "IMPORTANT: You need to set your Bailian API key:"
        log_warn "  export DASHSCOPE_API_KEY='your-api-key-here'"
        log_warn "  Or add it to ~/.zshrc"
    else
        log_warn "Skipping Bailian subscription configuration"
    fi
}

configure_zsh() {
    log_header "Zsh Configuration"

    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_warn "oh-my-zsh not installed, skipping zsh configuration"
        return 1
    fi

    backup_path "$HOME/.zshrc"

    cat > "$HOME/.zshrc" << 'EOF'
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git docker zoxide fzf zsh-history-substring-search)
source $ZSH/oh-my-zsh.sh

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

alias vim='nvim'
alias vi='nvim'
alias lg='lazygit'
alias ld='lazydocker'
EOF

    log_success "Zsh configured successfully"

    if [ "$SHELL" != "$(which zsh)" ]; then
        if ask_yn "Set zsh as default shell?" "y"; then
            chsh -s "$(which zsh)"
            log_success "Default shell changed to zsh"
        fi
    fi
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -y|--yes)
                AUTO_YES=true
                shift
                ;;
            -h|--help)
                cat << EOF
macOS (Intel/x86_64) Server Setup Script

Usage: $0 [OPTIONS]

OPTIONS:
    -y, --yes       Auto-answer yes to all prompts (non-interactive mode)
    -h, --help      Display this help message

EXAMPLES:
    $0              # Interactive mode with prompts
    $0 -y           # Non-interactive mode, auto-yes to everything

For more information, see README.md
EOF
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                echo "Use -h or --help for usage information"
                exit 1
                ;;
        esac
    done
}

main() {
    parse_args "$@"

    if [ "$AUTO_YES" = true ]; then
        log_info "Running in AUTO-YES mode - all prompts will be automatically accepted"
    fi

    log_header "macOS (Intel/x86_64) Setup"

    check_installation_status

    if ! ask_yn "Continue with installation?" "y"; then
        log_info "Installation cancelled"
        exit 0
    fi

    check_prerequisites
    install_git || true
    install_zsh || true
    install_zoxide || true
    install_lazygit || true
    install_lazydocker || true
    install_docker || true
    install_neovim || true
    install_uv || true
    install_poetry || true
    install_luarocks || true
    install_nodejs || true
    install_gcc || true
    install_btop || true
    install_tmux || true
    install_fzf || true
    install_ripgrep_fd || true
    install_bun || true
    install_ghostty || true
    install_claude || true
    configure_bailian_subscription || true
    configure_zsh || true

    log_header "Installation Complete"
    log_success "All requested tools have been installed"
    log_info "Log file: $LOG_FILE"
    log_info "Note: Some tools may require restarting terminal or logging out/in"
}

main "$@"
