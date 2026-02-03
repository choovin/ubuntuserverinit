# Ubuntu服务器初始化脚本

[![Ubuntu](https://img.shields.io/badge/Ubuntu-20.04%2F22.04%2F24.04-orange.svg)](https://ubuntu.com)
[![Bash](https://img.shields.io/badge/Bash-4.0%2B-green.svg)](https://www.gnu.org/software/bash/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

[English](README.md) | [简体中文](README.zh-CN.md)

一个功能全面的交互式Ubuntu服务器初始化脚本，一键安装现代开发环境所需的核心工具。

---

## 🚀 快速开始

### 首次使用命令

```bash
# 克隆仓库
git clone https://github.com/choovin/oh-my-opencode-agents.git
cd oh-my-opencode-agents

# 赋予执行权限
chmod +x oh-my-opencode-agents.sh

# 交互模式安装（推荐首次使用）
./oh-my-opencode-agents.sh

# 全自动模式（适用于CI/CD或自动化）
./oh-my-opencode-agents.sh -y
```

---

## ✨ 功能特性

- 🎯 **交互式安装** - 每个组件都有 Y/N 提示
- ⚡ **自动模式** - `-y` 标志全自动安装
- 🔍 **前后状态** - 显示已安装 vs 新安装
- 🎨 **彩色输出** - 清晰的严重程度分级
- 🔒 **错误处理** - 严格检查与详细日志
- 💾 **自动备份** - 修改前保存现有配置
- 📊 **完整日志** - 带时间戳的完整日志
- 🐳 **Docker用户组** - 自动配置用户权限
- 🐚 **智能Shell** - Zsh + 前缀历史搜索
- ⚡ **非交互模式** - 使用 `-y` 标志全自动安装

---

## 📦 安装内容

### 核心工具

| 工具 | 版本 | 用途 |
|------|------|------|
| **Git** | 最新版 | 版本控制系统 |
| **Zsh + Oh-My-Zsh** | 最新版 | 增强Shell框架 |
| **Zoxide** | 最新版 | 智能cd命令 |
| **Lazygit** | 最新版 | Git终端UI |
| **Lazydocker** | 最新版 | Docker终端UI |
| **Docker CE** | 最新版 | 容器化平台 |
| **Neovim** | v0.10+ | 现代编辑器 |
| **LuaRocks** | 最新版 | Lua包管理器 |
| **Node.js LTS** | v20.x+ | JavaScript运行时（含npm, yarn, pnpm） |
| **UV** | 最新版 | 极速Python包管理器 |
| **Poetry** | 最新版 | Python依赖管理和打包工具 |
| **GCC & 构建工具** | 最新版 | 编译器和开发基础工具 |

### 附加工具

| 工具 | 用途 |
|------|------|
| **btop** | 现代系统监控器 |
| **tmux** | 终端复用器 |
| **fzf** | 模糊查找器 |
| **ripgrep (rg)** | 快速grep替代品 |
| **fd** | 快速find替代品 |

---

## 🎮 使用方式

### 交互模式（推荐首次使用）

```bash
./oh-my-opencode-agents.sh
```

脚本将执行：
1. 显示预安装状态（已安装的工具）
2. 检查先决条件（sudo权限、网络连接）
3. 每个组件Y/N提示
4. 安装选定组件并显示进度
5. 配置安装后设置
6. 显示详细前后摘要

### 非交互模式（全自动）

```bash
./oh-my-opencode-agents.sh -y
# 或
./oh-my-opencode-agents.sh --yes
```

适用于：
- 🤖 CI/CD自动化部署
- 🔄 批量服务器配置
- ⏱️ 无人值守安装

### 显示帮助

```bash
./oh-my-opencode-agents.sh --help
```

---

## 📋 命令示例

### 首次运行示例

```bash
# 1. 下载脚本
curl -O https://raw.githubusercontent.com/choovin/oh-my-opencode-agents/main/oh-my-opencode-agents.sh

# 2. 添加执行权限
chmod +x oh-my-opencode-agents.sh

# 3. 运行（交互模式）
./oh-my-opencode-agents.sh

# 4. 查看日志
cat ~/ubuntu-setup-*.log
```

### 自动化示例

```bash
# 全自动安装
./oh-my-opencode-agents.sh -y

# 以root用户运行（不推荐）
sudo bash oh-my-opencode-agents.sh -y
```

---

## 🎯 预期输出

### 交互模式输出示例

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

### 自动模式输出

```bash
./oh-my-opencode-agents.sh -y

# 所有提示显示[AUTO-YES]：
Continue with installation? [AUTO-YES]
Install/upgrade git? [AUTO-YES]
# ... 全部自动安装
```

---

## 🔧 安装后配置

### 必要步骤

1. **重新登录**（Docker组权限和Shell更改需要）
   ```bash
   # 或者立即刷新Docker组：
   newgrp docker
   ```

2. **测试安装：**
   ```bash
   docker --version
   docker run hello-world
   nvim --version
   lazygit --version
   lazydocker --version
   ```

3. **检查Shell：**
   ```bash
   echo $SHELL
   # 应该显示：/usr/bin/zsh
   ```

### Zsh 特性

配置的zsh包含：

- **前缀历史搜索**：输入 `do` 按 ↑ 显示以 `do` 开头的命令
- **Oh-my-zsh插件**：git, docker, zoxide, fzf, history-substring-search
- **智能目录导航**：使用 `z <partial-name>` 跳转到常用目录
- **模糊搜索**：按 `Ctrl+R` 进行模糊命令历史搜索

### 别名配置

`.zshrc` 中配置了以下别名：

```bash
vim='nvim'       # 使用Neovim替代Vim
vi='nvim'        # 使用Neovim替代Vi
lg='lazygit'     # 快速启动lazygit
ld='lazydocker'  # 快速启动lazydocker
```

---

## 📁 配置文件位置

| 类型 | 路径 |
|------|------|
| 日志文件 | `~/ubuntu-setup-YYYYMMDD-HHMMSS.log` |
| 备份目录 | `~/.config-backups/YYYYMMDD-HHMMSS/` |
| Zsh配置 | `~/.zshrc` |
| Neovim配置 | `~/.config/nvim/` |

### Neovim 配置

脚本将从以下地址克隆您的自定义配置：
- 主源：`git@github.com:typhoon1217/nvimconfig.git`（SSH）
- 备用：`https://github.com/typhoon1217/nvimconfig.git`（HTTPS）

**注意**：SSH需要GitHub SSH密钥设置。如果SSH失败，会自动尝试HTTPS。

---

## 🛡️ 安全注意事项

### Docker 用户组

⚠️ **重要**：`docker` 组成员拥有主机系统的root级权限。

- 只将受信任的用户添加到docker组
- 生产环境考虑使用Docker无根模式
- 阅读更多：https://docs.docker.com/engine/security/rootless/

### 备份机制

所有现有配置在修改前都会备份到 `~/.config-backups/`：

```bash
# 查看备份
ls -la ~/.config-backups/

# 恢复备份
cp -r ~/.config-backups/20250122-143022/nvim-143500 ~/.config/nvim
```

---

## 🐛 故障排除

### 常见问题

**问题**：脚本因"权限拒绝"失败
```bash
# 解决：添加执行权限
chmod +x oh-my-opencode-agents.sh
```

**问题**：Docker命令需要sudo
```bash
# 解决：重新登录或运行：
newgrp docker
```

**问题**：Neovim配置克隆失败
```bash
# 解决：设置GitHub SSH密钥
ssh-keygen -t ed25519 -C "your_email@example.com"
cat ~/.ssh/id_ed25519.pub
# 添加到GitHub：Settings → SSH keys
```

**问题**：Zsh未激活
```bash
# 解决：检查默认shell
echo $SHELL

# 如果不是zsh，手动更改：
chsh -s $(which zsh)
# 然后重新登录
```

**问题**：历史搜索无法使用方向键
```bash
# 解决：检查插件安装
ls ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search

# 如果缺失，手动克隆：
git clone https://github.com/zsh-users/zsh-history-substring-search \
  ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search
```

### 检查安装

```bash
# 查看详细日志
cat ~/ubuntu-setup-*.log

# 检查特定工具
which lazygit
lazygit --version

# 验证Docker组
groups
# 应该包含'docker'

# 测试免sudo使用Docker
docker ps
```

---

## ⚙️ 自定义

### 修改组件

编辑脚本以跳过或添加组件：

```bash
# 在main()函数中注释掉不需要的安装
# install_btop && installed_components+=("Btop")  # 禁用
```

### 更改Zsh主题

编辑 `~/.zshrc`：

```bash
# 从robbyrussell更改为其他主题
ZSH_THEME="agnoster"  # 或 "powerlevel10k", "spaceship" 等
```

### 添加更多插件

编辑 `~/.zshrc`：

```bash
plugins=(
    git
    docker
    zoxide
    fzf
    zsh-history-substring-search
    # 在此处添加更多插件
    kubectl
    terraform
    aws
)
```

---

## 📋 系统要求

- Ubuntu 20.04、22.04 或 24.04
- Sudo权限
- 互联网连接
- 约500MB磁盘空间

---

## ✨ 最佳实践

本项目遵循行业最佳实践：

✅ 严格错误处理（`set -euo pipefail`）
✅ 仅终端使用颜色码
✅ 完整文件日志
✅ 修改前备份
✅ 官方包源（PPA、仓库）
✅ 用户权限验证
✅ 互联网连接检查
✅ 幂等操作（可安全重运行）

---

## 📚 参考链接

- [Docker官方文档](https://docs.docker.com/engine/install/ubuntu/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Neovim](https://neovim.io/)
- [Lazygit](https://github.com/jesseduffield/lazygit)
- [Lazydocker](https://github.com/jesseduffield/lazydocker)
- [Zoxide](https://github.com/ajeetdsouza/zoxide)
- [UV](https://github.com/astral-sh/uv)
- [Poetry](https://python-poetry.org/)

---

## 📄 许可证

本项目采用 MIT 许可证发布。

---

**作者**：typhoon1217  
**日期**：2025-01-22  
**版本**：1.0.0  

---

## 💡 快速参考

```bash
# 首次使用
chmod +x oh-my-opencode-agents.sh && ./oh-my-opencode-agents.sh

# 全自动安装
./oh-my-opencode-agents.sh -y

# 查看日志
cat ~/ubuntu-setup-*.log

# 刷新Docker权限
newgrp docker

# 测试所有工具
docker run hello-world && lazygit --version && nvim --version

# Poetry 使用指南
poetry new my-project          # 创建新项目
poetry add <package>           # 添加依赖
poetry install                 # 从poetry.lock安装
poetry run <command>           # 在虚拟环境中运行命令
poetry shell                   # 激活虚拟环境
poetry config virtualenvs.in-project true  # 虚拟环境存储在项目目录
```

**祝您编码愉快！🚀**
