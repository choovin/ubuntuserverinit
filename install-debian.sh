#!/usr/bin/env bash

################################################################################
# Debian Server Initial Setup Script
#
# Description: Interactive installation script for essential development tools
# Author: Generated for choovin
# Date: 2025-02-03
#
# Features:
# - Interactive Y/N prompts for each component
# - Robust error handling with colored output
# - Automatic backups of existing configurations
# - Comprehensive logging
# - Docker user group setup
# - Zsh with prefix-based history search
# - Latest stable versions from official sources
################################################################################

set -euo pipefail

################################################################################
# Global Variables
################################################################################

AUTO_YES=false
RUNNING_AS_ROOT=false
LOG_FILE="$HOME/debian-setup-$(date +%Y%m%d-%H%M%S).log"
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

check_installation_status() {
    log_header "Pre-Installation Status Check"
    log_info "Checking what is currently installed..."
    echo ""

    local tools=("git" "zsh" "docker" "neovim" "node" "gcc" "tmux" "fzf" "rg" "fd" "btop" "lazygit" "lazydocker" "zoxide" "uv" "poetry" "luarocks" "bun")
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

    if [ "$EUID" -eq 0 ]; then
        log_warn "Running as root user detected!"
        log_warn "This is not recommended for security reasons."
        RUNNING_AS_ROOT=true
    else
        RUNNING_AS_ROOT=false
        if ! sudo -n true 2>/dev/null; then
            log_info "This script requires sudo privileges. You may be prompted for your password."
            sudo -v || {
                log_error "Failed to obtain sudo privileges"
                exit 1
            }
        fi
    fi

    for cmd in curl wget; do
        if ! command_exists "$cmd"; then
            log_warn "$cmd not found. Installing..."
            sudo apt-get update -y
            sudo apt-get install -y "$cmd"
        fi
    done

    if ! ping -c 1 baidu.com >/dev/null 2>&1; then
        log_error "No internet connection detected"
        exit 1
    fi

    log_success "Prerequisites check passed"
}

install_system_updates() {
    log_header "System Updates"

    if ask_yn "Update system packages?" "y"; then
        log_info "Updating package lists..."
        sudo apt-get update -y

        log_info "Upgrading installed packages..."
        sudo apt-get upgrade -y

        log_info "Installing build essentials..."
        sudo apt-get install -y build-essential software-properties-common \
            apt-transport-https ca-certificates gnupg lsb-release

        log_success "System updated successfully"
    else
        log_warn "Skipping system updates"
    fi
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
        sudo apt-get install -y git
        log_success "Git installed: $(git --version)"
    else
        log_warn "Skipping git installation"
    fi
}

install_docker() {
    log_header "Docker CE Installation"

    if command_exists docker; then
        log_warn "Docker is already installed ($(docker --version))"
        if ! ask_yn "Reinstall docker?" "n"; then
            return 1
        fi
    fi

    if ask_yn "Install Docker CE?" "y"; then
        log_info "Installing Docker CE..."

        sudo apt-get remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true

        log_info "Adding Docker GPG key..."
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        sudo chmod a+r /etc/apt/keyrings/docker.gpg

        log_info "Adding Docker repository..."
        local osCodename=$(lsb_release -cs)
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian ${osCodename} stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        sudo apt-get update -y
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

        local compose_version=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
        if [ -z "$compose_version" ]; then
            compose_version="2.23.3"
        fi

        log_info "Installing Docker Compose v${compose_version}..."
        sudo curl -L "https://github.com/docker/compose/releases/download/v${compose_version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose

        if [ "$RUNNING_AS_ROOT" = false ]; then
            log_info "Adding user to docker group..."
            sudo usermod -aG docker "$USER"
            log_success "Docker installed successfully: $(docker --version)"
            log_warn "You need to log out and log back in for docker group changes to take effect"
        else
            log_success "Docker installed successfully: $(docker --version)"
        fi
    else
        log_warn "Skipping docker installation"
    fi
}

install_zsh() {
    log_header "Zsh & Oh-My-Zsh Installation"

    if ask_yn "Install zsh with oh-my-zsh?" "y"; then
        if ! command_exists zsh; then
            log_info "Installing zsh..."
            sudo apt-get install -y zsh
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
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
        export PATH="$HOME/.local/bin:$PATH"
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
        log_info "Installing lazygit from GitHub releases..."

        local LAZYGIT_VERSION
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')

        if [ -z "$LAZYGIT_VERSION" ]; then
            LAZYGIT_VERSION="0.43.1"
        fi

        log_info "Installing lazygit version $LAZYGIT_VERSION..."

        local temp_dir
        temp_dir=$(mktemp -d)
        cd "$temp_dir"

        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz
        sudo install lazygit /usr/local/bin

        cd - >/dev/null
        rm -rf "$temp_dir"

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
        local temp_dir
        temp_dir=$(mktemp -d)
        cd "$temp_dir"
        curl -sS https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
        cd - >/dev/null
        rm -rf "$temp_dir"
        log_success "Lazydocker installed successfully"
    else
        log_warn "Skipping lazydocker installation"
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

        local NVIM_VERSION
        NVIM_VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')

        if [ -z "$NVIM_VERSION" ]; then
            NVIM_VERSION="v0.10.0"
        fi

        log_info "Latest version: $NVIM_VERSION"

        sudo mkdir -p /opt/nvim
        local NVIM_URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim.appimage"

        if ! sudo curl -fL "$NVIM_URL" -o /opt/nvim/nvim.appimage; then
            log_info "Installing Neovim from Debian repositories..."
            sudo apt-get install -y neovim
            if command_exists nvim; then
                log_success "Neovim installed: $(nvim --version | head -n1)"
                return 0
            fi
        fi

        sudo chmod +x /opt/nvim/nvim.appimage
        sudo ln -sf /opt/nvim/nvim.appimage /usr/local/bin/nvim

        if command_exists nvim; then
            log_success "Neovim installed: $(nvim --version | head -n1)"
        else
            log_error "Neovim installation failed"
        fi
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
        curl -LsSf https://astral.sh/uv/install.sh | sh
        export PATH="$HOME/.cargo/bin:$PATH"
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
        if ! command_exists python3; then
            sudo apt-get install -y python3 python3-pip
        fi
        curl -sSL https://install.python-poetry.org | python3 -
        export PATH="$HOME/.local/bin:$PATH"
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
        sudo apt-get install -y luarocks lua5.4 liblua5.4-dev
        log_success "LuaRocks installed: $(luarocks --version)"
    else
        log_warn "Skipping LuaRocks installation"
    fi
}

install_nodejs() {
    log_header "Node.js Installation (Official LTS)"

    if command_exists node; then
        log_warn "Node.js is already installed ($(node --version))"
        if ! ask_yn "Reinstall Node.js?" "n"; then
            return 1
        fi
    fi

    if ask_yn "Install Node.js LTS?" "y"; then
        log_info "Installing Node.js LTS..."
        sudo apt-get remove -y nodejs npm 2>/dev/null || true
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt-get install -y nodejs

        if command_exists node; then
            log_success "Node.js installed: $(node --version)"
            if ask_yn "Install yarn and pnpm?" "y"; then
                sudo npm install -g yarn pnpm
                log_success "Global packages installed"
            fi
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
        log_info "Installing GCC and build essentials..."
        sudo apt-get install -y build-essential
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
        sudo apt-get install -y btop || {
            log_info "Installing btop from source..."
            local temp_dir=$(mktemp -d)
            cd "$temp_dir"
            curl -Lo btop.tbz "https://github.com/aristocratos/btop/releases/latest/download/btop-x86_64-linux-musl.tbz"
            tar xjf btop.tbz
            sudo install -m 755 btop /usr/local/bin/btop
            cd - >/dev/null
            rm -rf "$temp_dir"
        }
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
        sudo apt-get install -y tmux
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
        sudo apt-get install -y fzf
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
            sudo apt-get install -y ripgrep
        fi
        if ! command_exists fd; then
            log_info "Installing fd..."
            sudo apt-get install -y fd-find
            sudo ln -sf "$(which fdfind)" /usr/local/bin/fd 2>/dev/null || true
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
        curl -fsSL https://bun.sh/install | bash
        export PATH="$HOME/.bun/bin:$PATH"
        log_success "Bun installed successfully"
    else
        log_warn "Skipping Bun installation"
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
            if [ "$RUNNING_AS_ROOT" = true ]; then
                chsh -s "$(which zsh)" root
            else
                sudo chsh -s "$(which zsh)" "$USER"
            fi
            log_success "Default shell changed to zsh"
        fi
    fi
}

main() {
    log_header "Debian Server Setup"

    check_installation_status

    if ! ask_yn "Continue with installation?" "y"; then
        log_info "Installation cancelled"
        exit 0
    fi

    check_prerequisites
    install_system_updates
    install_git
    install_zsh
    install_zoxide
    install_lazygit
    install_lazydocker
    install_docker
    install_neovim
    install_uv
    install_poetry
    install_luarocks
    install_nodejs
    install_gcc
    install_btop
    install_tmux
    install_fzf
    install_ripgrep_fd
    install_bun
    configure_zsh

    log_header "Installation Complete"
    log_success "All requested tools have been installed"
    log_info "Log file: $LOG_FILE"
}

main "$@"
