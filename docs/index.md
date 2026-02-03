# Oh My OpenCode Agents

[![Ubuntu](https://img.shields.io/badge/Ubuntu-20.04%2F22.04%2F24.04-orange.svg)](https://ubuntu.com)
[![Bash](https://img.shields.io/badge/Bash-4.0%2B-green.svg)](https://www.gnu.org/software/bash/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

> 🚀 **一键部署，即刻开发** — 专为OpenCode设计的Ubuntu服务器初始化方案

**Oh My OpenCode Agents** 是一个功能全面的交互式Ubuntu服务器初始化脚本，一键安装现代开发环境所需的核心工具，并完美集成OpenCode Manager、宝塔面板和Nginx反向代理。

## ✨ 核心特性

- 🎯 **交互式安装** - 每个组件都有 Y/N 提示
- ⚡ **全自动模式** - `-y` 标志一键部署
- 🔍 **前后对比** - 清晰展示安装状态变化
- 🎨 **彩色输出** - 直观的视觉反馈
- 🔒 **错误处理** - 健壮的错误恢复机制
- 💾 **自动备份** - 配置修改前自动备份
- 📊 **完整日志** - 详细记录每一步操作
- 🌐 **域名访问** - Nginx反向代理到OpenCode Manager

## 🚀 快速开始

```bash
# 克隆仓库
git clone https://github.com/choovin/oh-my-opencode-agents.git
cd oh-my-opencode-agents

# 一键全自动安装（推荐用于生产环境）
chmod +x oh-my-opencode-agents.sh
sudo ./oh-my-opencode-agents.sh -y
```

安装完成后：
- 🌐 OpenCode Manager: `http://www.sailfish.com.cn`
- 🎛️ 宝塔面板: 运行 `sudo bt default` 查看访问地址
- 📝 查看日志: `cat ~/ubuntu-setup-*.log`

## 📦 安装内容

### 核心开发工具
- **Git** - 版本控制系统
- **Zsh + Oh-My-Zsh** - 增强Shell环境
- **Neovim** - 现代文本编辑器 (v0.10+)
- **Docker CE** - 容器化平台
- **Node.js LTS** - JavaScript运行时 (v20.x)
- **Python工具链** - UV, Poetry, GCC
- **开发工具** - Lazygit, Lazydocker, Zoxide

### 服务器管理套件
- **OpenCode Manager** - 开发环境管理器
- **宝塔面板** - Web服务器管理面板
- **Nginx** - 高性能反向代理服务器
- **预配置网站** - www.sailfish.com.cn

## 🎮 使用方式

### 交互模式（推荐首次使用）

```bash
./oh-my-opencode-agents.sh
```

脚本将引导您完成每个组件的选择和安装。

### 全自动模式（生产环境）

```bash
./oh-my-opencode-agents.sh -y
```

所有提示自动确认，适合CI/CD和自动化部署。

## 📚 文档导航

- [📖 安装指南](getting-started/installation.md) - 详细安装步骤
- [⚡ 快速开始](getting-started/quick-start.md) - 5分钟上手
- [🎯 功能介绍](features/overview.md) - 了解所有功能
- [⚙️ 配置指南](configuration/environment.md) - 高级配置选项
- [🔧 故障排除](troubleshooting.md) - 常见问题解决

## 🤝 贡献

欢迎提交Issue和Pull Request！

## 📄 许可证

[MIT License](LICENSE)

---

**作者**: choovin  
**版本**: 1.0.0  
**日期**: 2025-01-22
