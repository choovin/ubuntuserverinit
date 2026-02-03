#!/usr/bin/env pwsh

################################################################################
# Windows Server/Desktop Initial Setup Script
#
# Description: Interactive installation script for essential development tools
# Author: Generated for typhoon1217
# Date: 2025-02-03
#
# Features:
# - Interactive Y/N prompts for each component
# - Robust error handling with colored output
# - Comprehensive logging
# - Uses winget (Windows Package Manager) for installations
################################################################################

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

################################################################################
# Global Variables
################################################################################

$AUTO_YES = $false
$LOG_FILE = "$HOME\windows-setup-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
$BACKUP_DIR = "$HOME\.config-backups\$(Get-Date -Format 'yyyyMMdd-HHmmss')"
$IS_ADMIN = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

################################################################################
# Color Definitions
################################################################################

$RED = if ($Host.UI.RawUI.BackgroundColor -eq 'Black') { "`e[0;31m" } else { "" }
$GREEN = if ($Host.UI.RawUI.BackgroundColor -eq 'Black') { "`e[0;32m" } else { "" }
$YELLOW = if ($Host.UI.RawUI.BackgroundColor -eq 'Black') { "`e[1;33m" } else { "" }
$BLUE = if ($Host.UI.RawUI.BackgroundColor -eq 'Black') { "`e[0;34m" } else { "" }
$CYAN = if ($Host.UI.RawUI.BackgroundColor -eq 'Black') { "`e[0;36m" } else { "" }
$NC = if ($Host.UI.RawUI.BackgroundColor -eq 'Black') { "`e[0m" } else { "" }

################################################################################
# Logging Functions
################################################################################

function Write-LogInfo {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "${BLUE}[INFO]${NC} $Message"
    Write-Host $logMessage
    Add-Content -Path $LOG_FILE -Value "[$timestamp] [INFO] $Message"
}

function Write-LogSuccess {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "${GREEN}[SUCCESS]${NC} $Message"
    Write-Host $logMessage
    Add-Content -Path $LOG_FILE -Value "[$timestamp] [SUCCESS] $Message"
}

function Write-LogWarn {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "${YELLOW}[WARN]${NC} $Message"
    Write-Host $logMessage
    Add-Content -Path $LOG_FILE -Value "[$timestamp] [WARN] $Message"
}

function Write-LogError {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "${RED}[ERROR]${NC} $Message"
    Write-Host $logMessage
    Add-Content -Path $LOG_FILE -Value "[$timestamp] [ERROR] $Message"
}

function Write-LogHeader {
    param([string]$Title)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $header = "${CYAN}========================================${NC}"
    Write-Host $header
    Write-Host "${CYAN}$Title${NC}"
    Write-Host $header
    Add-Content -Path $LOG_FILE -Value "[$timestamp] ========================================"
    Add-Content -Path $LOG_FILE -Value "[$timestamp] $Title"
    Add-Content -Path $LOG_FILE -Value "[$timestamp] ========================================"
}

################################################################################
# Helper Functions
################################################################################

function Test-CommandExists {
    param([string]$Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

function Invoke-YesNoPrompt {
    param(
        [string]$Prompt,
        [string]$Default = "y"
    )

    if ($AUTO_YES) {
        Write-Host "${CYAN}${Prompt} [AUTO-YES]${NC}"
        return $true
    }

    if ($Default -eq "y") {
        $promptText = "${Prompt} [Y/n]: "
    } else {
        $promptText = "${Prompt} [y/N]: "
    }

    $answer = Read-Host $promptText
    if ([string]::IsNullOrEmpty($answer)) {
        $answer = $Default
    }

    return $answer -match '^[Yy]$'
}

function Start-Backup {
    param([string]$Path)

    if (Test-Path $Path) {
        if (-not (Test-Path $BACKUP_DIR)) {
            New-Item -ItemType Directory -Path $BACKUP_DIR -Force | Out-Null
        }
        $backupName = "$(Split-Path -Leaf $Path)-$(Get-Date -Format 'HHmmss')"
        Copy-Item -Path $Path -Destination "$BACKUP_DIR\$backupName" -Recurse
        Write-LogInfo "Backed up $Path to $BACKUP_DIR\$backupName"
    }
}

function Install-WingetPackage {
    param(
        [string]$PackageId,
        [string]$PackageName,
        [switch]$IsMSIX = $false
    )

    try {
        if (Test-CommandExists $PackageName.ToLower()) {
            Write-LogInfo "$PackageName is already installed"
            return $true
        }

        Write-LogInfo "Installing $PackageName..."

        if ($IsMSIX) {
            winget install --id $PackageId -e --source msstore | Out-Null
        } else {
            winget install --id $PackageId -e --source winget | Out-Null
        }

        if ($?) {
            Write-LogSuccess "$PackageName installed successfully"
            return $true
        } else {
            Write-LogWarn "Failed to install $PackageName via winget"
            return $false
        }
    } catch {
        Write-LogWarn "Error installing $PackageName: $_"
        return $false
    }
}

function Test-InternetConnection {
    try {
        $result = Test-Connection -ComputerName "baidu.com" -Count 1 -Quiet
        return $result
    } catch {
        return $false
    }
}

################################################################################
# Prerequisite Checks
################################################################################

function Test-Prerequisites {
    Write-LogHeader "Checking Prerequisites"

    if ($IS_ADMIN) {
        Write-LogWarn "Running as administrator detected!"
        Write-LogWarn "Some installations may require administrator privileges."
    }

    if (-not (Test-CommandExists "winget")) {
        Write-LogError "winget (Windows Package Manager) is not installed."
        Write-LogInfo "Please install Windows Package Manager first:"
        Write-Info "https://github.com/microsoft/winget-cli#installing-the-client"
        exit 1
    }

    Write-LogInfo "winget is available: $(winget --version)"

    if (-not (Test-InternetConnection)) {
        Write-LogError "No internet connection detected"
        exit 1
    }

    Write-LogSuccess "Prerequisites check passed"
}

function Show-InstallationStatus {
    Write-LogHeader "Pre-Installation Status Check"
    Write-LogInfo "Checking what is currently installed..."
    Write-Host ""

    $tools = @(
        @{Name = "git"; Command = "git"},
        @{Name = "zsh"; Command = "zsh"},
        @{Name = "docker"; Command = "docker"},
        @{Name = "neovim"; Command = "nvim"},
        @{Name = "node"; Command = "node"},
        @{Name = "gcc"; Command = "gcc"},
        @{Name = "tmux"; Command = "tmux"},
        @{Name = "fzf"; Command = "fzf"},
        @{Name = "ripgrep"; Command = "rg"},
        @{Name = "fd"; Command = "fd"},
        @{Name = "lazygit"; Command = "lazygit"},
        @{Name = "lazydocker"; Command = "lazydocker"},
        @{Name = "zoxide"; Command = "zoxide"},
        @{Name = "uv"; Command = "uv"},
        @{Name = "poetry"; Command = "poetry"},
        @{Name = "bun"; Command = "bun"}
    )

    foreach ($tool in $tools) {
        if (Test-CommandExists $tool.Command) {
            try {
                $version = & $tool.Command --version 2>$null | Select-Object -First 1
                if ([string]::IsNullOrEmpty($version)) { $version = "installed" }
                Write-Host "  ${GREEN}✓${NC} $($tool.Name): $version" -ForegroundColor Green
                Add-Content -Path $LOG_FILE -Value "$($tool.Name): $version"
            } catch {
                Write-Host "  ${GREEN}✓${NC} $($tool.Name): installed" -ForegroundColor Green
                Add-Content -Path $LOG_FILE -Value "$($tool.Name): installed"
            }
        } else {
            Write-Host "  ${RED}✗${NC} $($tool.Name): not installed" -ForegroundColor Red
            Add-Content -Path $LOG_FILE -Value "$($tool.Name): not installed"
        }
    }

    Write-Host ""
    Write-LogInfo "Status check complete"
}

################################################################################
# Installation Functions
################################################################################

function Install-Git {
    Write-LogHeader "Git Installation"

    if (Test-CommandExists "git") {
        $version = git --version
        Write-LogWarn "Git is already installed ($version)"
        if (-not (Invoke-YesNoPrompt -Prompt "Reinstall/upgrade git?" -Default "n")) {
            return
        }
    }

    if (Invoke-YesNoPrompt -Prompt "Install/upgrade git?" -Default "y") {
        Install-WingetPackage -PackageId "Git.Git" -PackageName "git"
    } else {
        Write-LogWarn "Skipping git installation"
    }
}

function Install-Zsh {
    Write-LogHeader "Zsh Installation"

    if (Invoke-YesNoPrompt -Prompt "Install zsh?" -Default "y") {
        Install-WingetPackage -PackageId "JuniorWorld.zsh" -PackageName "zsh" -IsMSIX | Out-Null

        if (Test-CommandExists "zsh") {
            Write-LogSuccess "Zsh installed successfully"
        } else {
            Write-LogWarn "Zsh may not be in PATH. Please restart PowerShell."
        }
    } else {
        Write-LogWarn "Skipping zsh installation"
    }
}

function Install-Docker {
    Write-LogHeader "Docker Installation"

    if (Test-CommandExists "docker") {
        $version = docker --version
        Write-LogWarn "Docker is already installed ($version)"
        if (-not (Invoke-YesNoPrompt -Prompt "Reinstall Docker?" -Default "n")) {
            return
        }
    }

    if (Invoke-YesNoPrompt -Prompt "Install Docker Desktop for Windows?" -Default "y") {
        Install-WingetPackage -PackageId "Docker.DockerDesktop" -PackageName "docker"

        if (Test-CommandExists "docker") {
            Write-LogSuccess "Docker installed: $(docker --version)"
            Write-LogInfo "Please start Docker Desktop from the Start Menu"
        }
    } else {
        Write-LogWarn "Skipping docker installation"
    }
}

function Install-Neovim {
    Write-LogHeader "Neovim Installation"

    if (Test-CommandExists "nvim") {
        $version = nvim --version | Select-Object -First 1
        Write-LogWarn "Neovim is already installed ($version)"
        if (-not (Invoke-YesNoPrompt -Prompt "Reinstall Neovim?" -Default "n")) {
            return
        }
    }

    if (Invoke-YesNoPrompt -Prompt "Install Neovim?" -Default "y") {
        Install-WingetPackage -PackageId "Neovim.Neovim" -PackageName "neovim"
    } else {
        Write-LogWarn "Skipping neovim installation"
    }
}

function Install-NodeJS {
    Write-LogHeader "Node.js Installation"

    if (Test-CommandExists "node") {
        $version = node --version
        Write-LogWarn "Node.js is already installed ($version)"
        if (-not (Invoke-YesNoPrompt -Prompt "Reinstall Node.js?" -Default "n")) {
            return
        }
    }

    if (Invoke-YesNoPrompt -Prompt "Install Node.js LTS?" -Default "y") {
        Install-WingetPackage -PackageId "OpenJS.NodeJSLTS" -PackageName "node"

        if (Test-CommandExists "node") {
            Write-LogSuccess "Node.js installed: $(node --version)"

            if (Invoke-YesNoPrompt -Prompt "Install yarn and pnpm?" -Default "y") {
                npm install -g yarn pnpm
                Write-LogSuccess "Global packages installed"
            }
        }
    } else {
        Write-LogWarn "Skipping Node.js installation"
    }
}

function Install-GCC {
    Write-LogHeader "GCC & Build Tools Installation"

    if (Test-CommandExists "gcc") {
        $version = gcc --version | Select-Object -First 1
        Write-LogWarn "GCC is already installed ($version)"
        return
    }

    if (Invoke-YesNoPrompt -Prompt "Install GCC and build tools (Visual Studio Build Tools)?" -Default "y") {
        Install-WingetPackage -PackageId "Microsoft.VisualStudio.2022.BuildTools" -PackageName "vsbuildtools"

        Write-LogSuccess "Visual Studio Build Tools installed"
        Write-LogInfo "You may need to restart PowerShell for PATH changes to take effect"
    } else {
        Write-LogWarn "Skipping GCC installation"
    }
}

function Install-Tmux {
    Write-LogHeader "Tmux Installation"

    if (Test-CommandExists "tmux") {
        Write-LogWarn "Tmux is already installed"
        return
    }

    if (Invoke-YesNoPrompt -Prompt "Install tmux?" -Default "y") {
        Install-WingetPackage -PackageId "ericvitruev0.tmux" -PackageName "tmux"
    } else {
        Write-LogWarn "Skipping tmux installation"
    }
}

function Install-Fzf {
    Write-LogHeader "Fzf Installation"

    if (Test-CommandExists "fzf") {
        Write-LogWarn "Fzf is already installed"
        return
    }

    if (Invoke-YesNoPrompt -Prompt "Install fzf (fuzzy finder)?" -Default "y") {
        Install-WingetPackage -PackageId "Fzf.Fzf" -PackageName "fzf"
    } else {
        Write-LogWarn "Skipping fzf installation"
    }
}

function Install-Ripgrep {
    Write-LogHeader "Ripgrep Installation"

    if (Test-CommandExists "rg") {
        Write-LogWarn "Ripgrep is already installed"
        return
    }

    if (Invoke-YesNoPrompt -Prompt "Install ripgrep?" -Default "y") {
        Install-WingetPackage -PackageId "BurntSushi.ripgrep.MSVC" -PackageName "ripgrep"
    } else {
        Write-LogWarn "Skipping ripgrep installation"
    }
}

function Install-Fd {
    Write-LogHeader "Fd Installation"

    if (Test-CommandExists "fd") {
        Write-LogWarn "Fd is already installed"
        return
    }

    if (Invoke-YesNoPrompt -Prompt "Install fd?" -Default "y") {
        Install-WingetPackage -PackageId "sharkdp.fd" -PackageName "fd"
    } else {
        Write-LogWarn "Skipping fd installation"
    }
}

function Install-Lazygit {
    Write-LogHeader "Lazygit Installation"

    if (Test-CommandExists "lazygit") {
        Write-LogWarn "Lazygit is already installed"
        return
    }

    if (Invoke-YesNoPrompt -Prompt "Install lazygit (terminal UI for git)?" -Default "y") {
        Install-WingetPackage -PackageId "Lazygit.Lazygit" -PackageName "lazygit"
    } else {
        Write-LogWarn "Skipping lazygit installation"
    }
}

function Install-Lazydocker {
    Write-LogHeader "Lazydocker Installation"

    if (Test-CommandExists "lazydocker") {
        Write-LogWarn "Lazydocker is already installed"
        return
    }

    if (Invoke-YesNoPrompt -Prompt "Install lazydocker (terminal UI for docker)?" -Default "y") {
        Install-WingetPackage -PackageId "Lazydocker.Lazydocker" -PackageName "lazydocker"
    } else {
        Write-LogWarn "Skipping lazydocker installation"
    }
}

function Install-Zoxide {
    Write-LogHeader "Zoxide Installation"

    if (Test-CommandExists "zoxide") {
        Write-LogWarn "Zoxide is already installed"
        return
    }

    if (Invoke-YesNoPrompt -Prompt "Install zoxide (smart cd command)?" -Default "y") {
        Install-WingetPackage -PackageId "ajeetdsouza.zoxide" -PackageName "zoxide"
    } else {
        Write-LogWarn "Skipping zoxide installation"
    }
}

function Install-UV {
    Write-LogHeader "UV Installation (Python Package Manager)"

    if (Test-CommandExists "uv") {
        Write-LogWarn "UV is already installed"
        return
    }

    if (Invoke-YesNoPrompt -Prompt "Install UV (ultrafast Python package manager)?" -Default "y") {
        Install-WingetPackage -PackageId "Astral.UV" -PackageName "uv"
    } else {
        Write-LogWarn "Skipping UV installation"
    }
}

function Install-Poetry {
    Write-LogHeader "Poetry Installation"

    if (Test-CommandExists "poetry") {
        Write-LogWarn "Poetry is already installed"
        return
    }

    if (Invoke-YesNoPrompt -Prompt "Install Poetry?" -Default "y") {
        Install-WingetPackage -PackageId "Schniz.fnm" -PackageName "fnm" | Out-Null
        fnm install --lts
        fnm use lts
        npm install -g poetry
        Write-LogSuccess "Poetry installed successfully"
    } else {
        Write-LogWarn "Skipping Poetry installation"
    }
}

function Install-Bun {
    Write-LogHeader "Bun Installation"

    if (Test-CommandExists "bun") {
        Write-LogWarn "Bun is already installed"
        return
    }

    if (Invoke-YesNoPrompt -Prompt "Install Bun (fast JavaScript runtime)?" -Default "y") {
        Install-WingetPackage -PackageId "Jarred.Sumner.Bun" -PackageName "bun"
    } else {
        Write-LogWarn "Skipping Bun installation"
    }
}

function Install-WindowsTerminal {
    Write-LogHeader "Windows Terminal Installation"

    if (Test-CommandExists "wt") {
        Write-LogWarn "Windows Terminal is already installed"
        return
    }

    if (Invoke-YesNoPrompt -Prompt "Install Windows Terminal?" -Default "y") {
        Install-WingetPackage -PackageId "Microsoft.WindowsTerminal" -PackageName "windowsterminal"
        Write-LogSuccess "Windows Terminal installed"
    } else {
        Write-LogWarn "Skipping Windows Terminal installation"
    }
}

function Install-PoshGit {
    Write-LogHeader "Posh-Git Installation"

    if (Test-ModuleInstalled -Name "posh-git") {
        Write-LogWarn "Posh-Git is already installed"
        return
    }

    if (Invoke-YesNoPrompt -Prompt "Install Posh-Git (PowerShell git prompt)?" -Default "y") {
        Install-Module -Name posh-git -Scope CurrentUser -AllowPrerelease -Force
        Add-PoshGitToProfile -ErrorAction SilentlyContinue
        Write-LogSuccess "Posh-Git installed"
    } else {
        Write-LogWarn "Skipping Posh-Git installation"
    }
}

function Test-ModuleInstalled {
    param([string]$Name)
    try {
        Get-Module -Name $Name -ListAvailable | Out-Null
        return $true
    } catch {
        return $false
    }
}

function Add-PoshGitToProfile {
    Add-Content -Path $PROFILE -Value "`n# Import Posh-Git" -ErrorAction SilentlyContinue
    Add-Content -Path $PROFILE -Value "Import-Module posh-git" -ErrorAction SilentlyContinue
}

################################################################################
# Main Function
################################################################################

function Start-Main {
    Write-LogHeader "Windows Server/Desktop Setup"

    Show-InstallationStatus

    if (-not (Invoke-YesNoPrompt -Prompt "Continue with installation?" -Default "y")) {
        Write-LogInfo "Installation cancelled"
        exit 0
    }

    Test-Prerequisites

    Install-WindowsTerminal
    Install-Git
    Install-Zsh
    Install-Docker
    Install-Neovim
    Install-NodeJS
    Install-GCC
    Install-Tmux
    Install-Fzf
    Install-Ripgrep
    Install-Fd
    Install-Lazygit
    Install-Lazydocker
    Install-Zoxide
    Install-UV
    Install-Poetry
    Install-Bun
    Install-PoshGit

    Write-LogHeader "Installation Complete"
    Write-LogSuccess "All requested tools have been installed"
    Write-LogInfo "Log file: $LOG_FILE"
    Write-LogInfo "Please restart PowerShell for PATH changes to take effect"
}

Start-Main
