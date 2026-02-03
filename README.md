# Multi-Platform Server Setup Scripts

[![Multi-Platform](https://img.shields.io/badge/Ubuntu-Centos-Debian-macOS-Windows-blue.svg)]()
[![Bash](https://img.shields.io/badge/Bash-4.0%2B-green.svg)](https://www.gnu.org/software/bash/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

[English](README.md) | [简体中文](README.zh-CN.md)

Comprehensive cross-platform interactive server setup scripts for Ubuntu, CentOS, Debian, macOS, and Windows, installing essential modern development tools with a single command.

---

## Supported Platforms

This project provides installation scripts for the following platforms:

| Platform | Script File | Package Manager | Description |
|----------|-------------|-----------------|-------------|
| **Ubuntu** | `oh-my-opencode-agents.sh` | apt | Original script, supports Ubuntu 20.04/22.04/24.04 |
| **CentOS/RHEL** | `install-centos.sh` | dnf/yum | Supports CentOS 7/8, RHEL, Rocky Linux, AlmaLinux |
| **OpenCloud/Alibaba** | `install-centos.sh` | dnf | Alibaba Cloud, Tencent Cloud and other domestic cloud servers |
| **Debian** | `install-debian.sh` | apt | Supports Debian 10/11/12 |
| **macOS (Intel)** | `install-macos-x86.sh` | Homebrew | For Intel-based Macs |
| **macOS (Apple Silicon)** | `install-macos-arm.sh` | Homebrew | For M1/M2/M3 chip Macs |
| **Windows** | `install-windows.ps1` | winget | PowerShell script, supports Windows 10/11 |

---

## ✨ Features

- 🎯 **Interactive Installation** - Y/N prompts for each component
- ⚡ **Auto Mode** - `-y` flag for fully automated installation
- 🔍 **Before/After Status** - Shows installed vs newly installed
- 🎨 **Colorized Output** - Clear, readable feedback with severity levels
- 🔒 **Robust Error Handling** - Strict error checking with detailed logging
- 💾 **Automatic Backups** - Saves existing configurations before modification
- 📊 **Comprehensive Logging** - Full logs saved with timestamps
- 🐳 **Docker User Setup** - Automatic user group configuration
- 🐚 **Smart Shell Config** - Zsh with prefix-based history search
- ⚡ **Non-Interactive Mode** - Use `-y` flag for fully automated installation
- 🌐 **Nginx Reverse Proxy** - Domain-based access to OpenCode Manager via Baota panel
- WebSocket Support - Full WebSocket proxy configuration for real-time applications

---

## Installation Commands

### Ubuntu

```bash
# Interactive mode
curl -fsSL https://raw.githubusercontent.com/choovin/oh-my-opencode-agents/main/oh-my-opencode-agents.sh -o install-ubuntu.sh && chmod +x install-ubuntu.sh && ./install-ubuntu.sh

# Auto mode
curl -fsSL https://raw.githubusercontent.com/choovin/oh-my-opencode-agents/main/oh-my-opencode-agents.sh -o install-ubuntu.sh && chmod +x install-ubuntu.sh && ./install-ubuntu.sh -y
```

### CentOS / RHEL / OpenCloud / Alibaba Cloud

```bash
# Interactive mode
curl -fsSL https://raw.githubusercontent.com/choovin/oh-my-opencode-agents/main/install-centos.sh -o install-centos.sh && chmod +x install-centos.sh && ./install-centos.sh

# Auto mode
curl -fsSL https://raw.githubusercontent.com/choovin/oh-my-opencode-agents/main/install-centos.sh -o install-centos.sh && chmod +x install-centos.sh && ./install-centos.sh -y
```

### Debian

```bash
# Interactive mode
curl -fsSL https://raw.githubusercontent.com/choovin/oh-my-opencode-agents/main/install-debian.sh -o install-debian.sh && chmod +x install-debian.sh && ./install-debian.sh

# Auto mode
curl -fsSL https://raw.githubusercontent.com/choovin/oh-my-opencode-agents/main/install-debian.sh -o install-debian.sh && chmod +x install-debian.sh && ./install-debian.sh -y
```

### macOS (Intel / x86_64)

```bash
# Interactive mode
curl -fsSL https://raw.githubusercontent.com/choovin/oh-my-opencode-agents/main/install-macos-x86.sh -o install-macos-x86.sh && chmod +x install-macos-x86.sh && ./install-macos-x86.sh
```

### macOS (Apple Silicon / M1/M2/M3)

```bash
# Interactive mode
curl -fsSL https://raw.githubusercontent.com/choovin/oh-my-opencode-agents/main/install-macos-arm.sh -o install-macos-arm.sh && chmod +x install-macos-arm.sh && ./install-macos-arm.sh
```

### Windows (PowerShell)

```powershell
# Run as Administrator
# Interactive mode
irm https://raw.githubusercontent.com/choovin/oh-my-opencode-agents/main/install-windows.ps1 | iex

# Or save and run the script
irm https://raw.githubusercontent.com/choovin/oh-my-opencode-agents/main/install-windows.ps1 -OutFile install-windows.ps1
.\install-windows.ps1
```

### All Platforms (Clone Repository)

```bash
# Clone the repository
git clone https://github.com/choovin/oh-my-opencode-agents.git
cd oh-my-opencode-agents

# Make scripts executable
chmod +x install-*.sh

# Run the script for your platform
./install-ubuntu.sh    # Ubuntu
./install-centos.sh    # CentOS/RHEL/Alibaba
./install-debian.sh    # Debian
./install-macos-x86.sh # macOS Intel
./install-macos-arm.sh # macOS Apple Silicon
```

---

## What Gets Installed
## 📦 What Gets Installed

### Core Tools

| Tool | Version | Purpose |
|------|---------|---------|
| **Git** | Latest | Version control system |
| **Zsh + Oh-My-Zsh** | Latest | Enhanced shell with framework |
| **Zoxide** | Latest | Smart cd command (remembers directories) |
| **Lazygit** | Latest | Terminal UI for git |
| **Lazydocker** | Latest | Terminal UI for Docker |
| **Docker CE** | Latest | Containerization platform |
| **Neovim** | v0.10+ | Modern text editor |
| **LuaRocks** | Latest | Lua package manager |
| **Node.js LTS** | v20.x+ | JavaScript runtime (npm, yarn, pnpm) |
| **UV** | Latest | Fast Python package manager |
| **Poetry** | Latest | Python dependency management & packaging |
| **GCC & Build Tools** | Latest | Compiler and development essentials |

### Server & Proxy Tools

| Tool | Version | Purpose |
|------|---------|---------|
| **OpenCode Manager** | Latest | Self-hosted development environment manager |
| **Baota Panel** | Latest | Web-based server management panel |
| **Nginx (via Baota)** | 1.24.0+ | High-performance reverse proxy with WebSocket support |

### Additional Tools

| Tool | Purpose |
|------|---------|
| **btop** | Modern system resource monitor |
| **tmux** | Terminal multiplexer |
| **fzf** | Fuzzy finder for files and history |
| **ripgrep (rg)** | Fast grep alternative |
| **fd** | Fast find alternative |

---

## 🎮 Usage

### Interactive Mode (Recommended for First Use)

```bash
./oh-my-opencode-agents.sh
```

The script will:
1. Show pre-installation status (what's already installed)
2. Check prerequisites (sudo access, internet connection)
3. Present Y/N prompts for each component
4. Install selected components with progress feedback
5. Configure post-installation settings
6. Display detailed before/after summary

### Non-Interactive Mode (Auto-Yes)

```bash
./oh-my-opencode-agents.sh -y
# or
./oh-my-opencode-agents.sh --yes
```

Perfect for:
- 🤖 CI/CD automated deployments
- 🔄 Batch server configuration
- ⏱️ Unattended installations

### Display Help

```bash
./oh-my-opencode-agents.sh --help
```

---

## 📋 Command Examples

### Quick Install (One Line)

```bash
# Download, make executable, and run interactively
curl -fsSL https://raw.githubusercontent.com/choovin/oh-my-opencode-agents/main/oh-my-opencode-agents.sh -o oh-my-opencode-agents.sh && chmod +x oh-my-opencode-agents.sh && ./oh-my-opencode-agents.sh

# Download and auto-install everything
curl -fsSL https://raw.githubusercontent.com/choovin/oh-my-opencode-agents/main/oh-my-opencode-agents.sh -o oh-my-opencode-agents.sh && chmod +x oh-my-opencode-agents.sh && ./oh-my-opencode-agents.sh -y
```

### Step-by-Step Install

```bash
# 1. Download script
curl -O https://raw.githubusercontent.com/choovin/oh-my-opencode-agents/main/oh-my-opencode-agents.sh

# 2. Make executable
chmod +x oh-my-opencode-agents.sh

# 3. Run (interactive mode)
./oh-my-opencode-agents.sh

# 4. Check logs
cat ~/ubuntu-setup-*.log
```

### Automation Example

```bash
# Full automatic installation
./oh-my-opencode-agents.sh -y

# Run as root (not recommended)
sudo bash oh-my-opencode-agents.sh -y
```

---

## 🎯 Expected Output

### Interactive Mode Output Example

```
========================================
Pre-Installation Status Check
========================================

[INFO] Checking what is currently installed...

  ✓ git: git version 2.43.0
  ✗ zsh: not installed
  ✗ lazygit: not installed
  ✓ docker: Docker version 24.0.7
  ...

Continue with installation? [Y/n]: y

========================================
Git Installation
========================================
[WARN] Git is already installed (git version 2.43.0)
Reinstall/upgrade git? [y/N]: n

...

========================================
Installation Summary
========================================

Newly Installed:
  ✓ zsh: zsh 5.9
  ✓ lazygit: version=0.40.2
  ✓ neovim: NVIM v0.9.5

Upgraded:
  ↑ docker: Docker version 24.0.7 → Docker version 25.0.0

Already Installed (unchanged):
  • git: git version 2.43.0
  • tmux: tmux 3.3a

Actions performed during this run:
  ✓ System Updates
  ✓ Zsh + Oh-My-Zsh
  ✓ Lazygit
  ✓ Docker CE
  ✓ Neovim
  ✓ Zsh Config
```

### Auto-Yes Mode Output

```bash
./oh-my-opencode-agents.sh -y

# All prompts show [AUTO-YES]:
Continue with installation? [AUTO-YES]
Install/upgrade git? [AUTO-YES]
# ... everything installs automatically
```

---

## 🔧 Post-Installation

### Important Steps

1. **Log out and back in** (required for Docker group and shell changes)
   ```bash
   # Or refresh Docker group immediately:
   newgrp docker
   ```

2. **Test installations:**
   ```bash
   docker --version
   docker run hello-world
   nvim --version
   lazygit --version
   lazydocker --version
   ```

3. **Check your shell:**
   ```bash
   echo $SHELL
   # Should show: /usr/bin/zsh
   ```

### Zsh Features

The configured zsh includes:

- **Prefix-based history search**: Type `do` and press ↑ to see only commands starting with `do`
- **Oh-my-zsh plugins**: git, docker, zoxide, fzf, history-substring-search
- **Smart directory navigation**: Use `z <partial-name>` to jump to frequently used directories
- **Fuzzy search**: Press `Ctrl+R` for fuzzy command history search

### Aliases

The following aliases are configured in `.zshrc`:

```bash
vim='nvim'       # Use Neovim instead of Vim
vi='nvim'        # Use Neovim instead of Vi
lg='lazygit'     # Quick access to lazygit
ld='lazydocker'  # Quick access to lazydocker
```

---

## 📦 Poetry - Python Dependency Management

Poetry is a modern Python dependency management and packaging tool that replaces `requirements.txt` and `setup.py`.

### Why Poetry?

| Feature | Traditional (pip) | Poetry |
|---------|-------------------|--------|
| **Dependency Resolution** | Manual, conflicts common | Automatic, resolves conflicts |
| **Lock File** | requirements.txt (loose) | poetry.lock (exact versions) |
| **Virtual Environments** | Manual (venv) | Automatic, in-project by default |
| **Packaging** | setup.py + MANIFEST.in | Single pyproject.toml |
| **Publishing** | twine + multiple commands | `poetry publish` |

### Quick Start

```bash
# Create a new project
poetry new my-project
cd my-project

# Or initialize Poetry in existing project
poetry init
```

### Common Commands

```bash
# Add dependencies
poetry add requests
poetry add pytest --group dev

# Add specific version
poetry add torch@2.1.0

# Install from lock file (production)
poetry install --no-dev

# Update dependencies
poetry update

# Run commands in virtual environment
poetry run python main.py
poetry run pytest

# Activate shell in venv
poetry shell

# Build and publish
poetry build
poetry publish
```

### Example: AI Project

```bash
# Create AI project
poetry new ai-project
cd ai-project

# Add ML dependencies
poetry add torch transformers datasets
poetry add jupyter --group dev

# Install everything
poetry install

# Run Jupyter from within venv
poetry run jupyter lab
```

### Configuration

Poetry is configured to create virtual environments inside project directories:

```bash
# Check config
poetry config --list

# Virtual envs in project (already set by script)
poetry config virtualenvs.in-project true

# Default Python version
poetry env use python3.11
```

### Project Structure

```
my-project/
├── pyproject.toml          # Project config & dependencies
├── poetry.lock             # Locked dependency versions
├── README.md
├── my_project/
│   └── __init__.py
├── tests/
└── .venv/                  # Virtual environment (in-project)
```

### VS Code Integration

```bash
# Get venv path for VS Code
poetry env info --path

# Set Python interpreter in VS Code to:
# <project-path>/.venv/bin/python
```

---

## 🌐 Nginx Reverse Proxy

The script can automatically configure Nginx as a reverse proxy for OpenCode Manager:

### Features

- **Domain Access**: Access OpenCode Manager via `http://www.sailfish.com.cn`
- **WebSocket Support**: Full WebSocket proxy with upgrade headers
- **HTTP/1.1**: Proper keep-alive and streaming support
- **Security Headers**: X-Frame-Options, X-Content-Type-Options, X-XSS-Protection
- **Static File Caching**: 30-day cache for assets (jpg, css, js, etc.)
- **Timeout Configuration**: 60s connect/send/read timeouts
- **Buffer Control**: Disabled buffering for real-time streaming

### Proxy Configuration

```
http://www.sailfish.com.cn  →  http://127.0.0.1:5003
```

### Nginx Config Location

```
/www/server/panel/vhost/nginx/www.sailfish.com.cn.conf
```

### Management Commands

```bash
# Start/Stop/Reload Nginx
sudo /etc/init.d/nginx start
sudo /etc/init.d/nginx stop
sudo /etc/init.d/nginx reload

# Test configuration
/www/server/nginx/sbin/nginx -t

# View logs
tail -f /www/wwwlogs/www.sailfish.com.cn.log
tail -f /www/wwwlogs/www.sailfish.com.cn.error.log
```

---

## 📁 Configuration Files

| Type | Location |
|------|----------|
| Log file | `~/ubuntu-setup-YYYYMMDD-HHMMSS.log` |
| Backups | `~/.config-backups/YYYYMMDD-HHMMSS/` |
| Zsh config | `~/.zshrc` |
| Neovim config | `~/.config/nvim/` |

### Neovim Configuration

The script clones your custom Neovim configuration from:
- Primary: `git@github.com:choovin/nvimconfig.git` (SSH)
- Fallback: `https://github.com/choovin/nvimconfig.git` (HTTPS)

**Note**: SSH requires GitHub SSH key setup. If SSH fails, HTTPS is attempted automatically.

---

## 🛡️ Security Considerations

### Docker Group

⚠️ **Important**: Members of the `docker` group have root-level privileges on the host system.

- Only add trusted users to the docker group
- Consider using Docker rootless mode for production environments
- Read more: https://docs.docker.com/engine/security/rootless/

### Backups

All existing configurations are backed up to `~/.config-backups/` before modification:

```bash
# View backups
ls -la ~/.config-backups/

# Restore a backup
cp -r ~/.config-backups/20250122-143022/nvim-143500 ~/.config/nvim
```

---

## 🐛 Troubleshooting

### Common Issues

**Issue**: Script fails with "permission denied"
```bash
# Solution: Make script executable
chmod +x oh-my-opencode-agents.sh
```

**Issue**: Docker commands require sudo
```bash
# Solution: Log out and back in, or run:
newgrp docker
```

**Issue**: Neovim config clone fails
```bash
# Solution: Setup SSH key for GitHub
ssh-keygen -t ed25519 -C "your_email@example.com"
cat ~/.ssh/id_ed25519.pub
# Add the public key to GitHub: Settings → SSH keys
```

**Issue**: Zsh not activated
```bash
# Solution: Check default shell
echo $SHELL

# If not zsh, change manually:
chsh -s $(which zsh)
# Then log out and back in
```

**Issue**: History search not working with arrows
```bash
# Solution: Check plugin installation
ls ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search

# If missing, clone manually:
git clone https://github.com/zsh-users/zsh-history-substring-search \
  ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search
```

### Check Installation

```bash
# View detailed log
cat ~/ubuntu-setup-*.log

# Check specific tool
which lazygit
lazygit --version

# Verify Docker group
groups
# Should include 'docker'

# Test Docker without sudo
docker ps
```

---

## ⚙️ Customization

### Modify Components

Edit the script to skip or add components:

```bash
# Comment out unwanted installations in main() function
# install_btop && installed_components+=("Btop")  # Disabled
```

### Change Zsh Theme

Edit `~/.zshrc`:

```bash
# Change from robbyrussell to another theme
ZSH_THEME="agnoster"  # or "powerlevel10k", "spaceship", etc.
```

### Add More Plugins

Edit `~/.zshrc`:

```bash
plugins=(
    git
    docker
    zoxide
    fzf
    zsh-history-substring-search
    # Add more plugins here
    kubectl
    terraform
    aws
)
```

---

## Requirements

### Ubuntu
- Ubuntu 20.04, 22.04, or 24.04
- Sudo privileges
- Internet connection
- ~500MB disk space for all tools

### CentOS / RHEL / Alibaba Cloud
- CentOS 7/8, RHEL 7/8, Rocky Linux 8/9, AlmaLinux 8/9
- Sudo privileges
- Internet connection
- ~500MB disk space for all tools

### Debian
- Debian 10 (Buster), 11 (Bullseye), 12 (Bookworm)
- Sudo privileges
- Internet connection
- ~500MB disk space for all tools

### macOS
- macOS 10.15 (Catalina) or higher
- Homebrew (script will install automatically)
- Internet connection
- ~500MB disk space for all tools

### Windows
- Windows 10 2004+ or Windows 11
- PowerShell 5.1+ or PowerShell Core 7+
- winget (Windows Package Manager)
- Administrator privileges (required for some installations)
- Internet connection

---

## ✨ Best Practices Applied

This script follows industry best practices:

✅ Strict error handling (`set -euo pipefail`)
✅ Color codes only for terminal output
✅ Comprehensive logging to file
✅ Backup before modification
✅ Official package sources (PPAs, repos)
✅ User permission validation
✅ Internet connectivity check
✅ Idempotent operations (safe to re-run)

---

## 📚 References

- [Docker Official Docs](https://docs.docker.com/engine/install/ubuntu/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Neovim](https://neovim.io/)
- [Lazygit](https://github.com/jesseduffield/lazygit)
- [Lazydocker](https://github.com/jesseduffield/lazydocker)
- [Zoxide](https://github.com/ajeetdsouza/zoxide)
- [UV](https://github.com/astral-sh/uv)

---

## 📄 License

This project is licensed under the MIT License.

---

**Author**: typhoon1217
**Date**: 2025-02-03
**Version**: 2.0.0 (Multi-Platform Support)

---

## 💡 Quick Reference

```bash
# First time use
chmod +x oh-my-opencode-agents.sh && ./oh-my-opencode-agents.sh

# Full automatic
./oh-my-opencode-agents.sh -y

# View logs
cat ~/ubuntu-setup-*.log

# Refresh Docker permissions
newgrp docker

# Test all tools
docker run hello-world && lazygit --version && nvim --version

# Poetry usage
poetry new my-project          # Create new project
poetry add <package>           # Add dependency
poetry install                 # Install from poetry.lock
poetry run <command>           # Run command in virtualenv
poetry shell                   # Activate virtualenv
poetry config virtualenvs.in-project true  # Store venvs in project dirs
```

**Happy Coding! 🚀**
