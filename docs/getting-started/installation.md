# 安装指南

选择最适合您的安装方式。

## 系统要求

- **操作系统**: Ubuntu 20.04, 22.04, 或 24.04
- **权限**: sudo 访问权限
- **网络**: 稳定的互联网连接
- **磁盘空间**: 至少 500MB 可用空间
- **内存**: 建议 2GB 以上

## 快速安装（推荐）

最简单的方式是运行我们的安装脚本：

```bash
# 下载脚本
curl -O https://raw.githubusercontent.com/choovin/oh-my-opencode-agents/main/oh-my-opencode-agents.sh

# 添加执行权限
chmod +x oh-my-opencode-agents.sh

# 运行全自动安装
sudo ./oh-my-opencode-agents.sh -y
```

安装过程大约需要 **15-30分钟**，取决于您的网络速度和系统性能。

## 交互式安装

如果您想选择性地安装组件，使用交互模式：

```bash
./oh-my-opencode-agents.sh
```

脚本会逐个询问每个组件：

```
========================================
Git Installation
========================================
[WARN] Git is already installed (git version 2.43.0)
Reinstall/upgrade git? [y/N]: n

========================================
OpenCode Manager Installation
========================================
Install OpenCode Manager (runtime mode, no Docker)? [Y/n]: y
```

## 从GitHub克隆安装

```bash
# 克隆仓库
git clone https://github.com/choovin/oh-my-opencode-agents.git
cd oh-my-opencode-agents

# 运行安装
chmod +x oh-my-opencode-agents.sh
sudo ./oh-my-opencode-agents.sh -y
```

## 安装过程详解

### Phase 1: 系统基础 (5-10分钟)

1. **系统更新** - 更新包列表和已安装包
2. **Git** - 版本控制系统
3. **Zsh + Oh-My-Zsh** - 现代化Shell环境
4. **开发基础工具** - curl, wget, build-essential

### Phase 2: 开发环境 (5-10分钟)

5. **Zoxide** - 智能目录跳转工具
6. **Lazygit** - Git终端UI
7. **Lazydocker** - Docker终端UI
8. **Docker CE** - 容器平台
9. **Neovim** - 现代编辑器 (v0.10+)

### Phase 3: 语言工具 (5-10分钟)

10. **LuaRocks** - Lua包管理器
11. **Node.js LTS** - JavaScript运行时 (v20.x)
12. **UV** - 极速Python包管理器
13. **Poetry** - Python依赖管理工具
14. **GCC** - 编译工具链

### Phase 4: 实用工具 (2-3分钟)

15. **Btop** - 系统监控
16. **Tmux** - 终端复用器
17. **Fzf** - 模糊查找器
18. **Ripgrep & Fd** - 现代搜索工具

### Phase 5: 服务器套件 (10-15分钟)

19. **OpenCode Manager** - 开发环境管理器
20. **宝塔面板** - Web服务器管理
21. **Nginx** - 反向代理服务器
22. **网站配置** - www.sailfish.com.cn

### Phase 6: 配置优化 (2-3分钟)

23. **Neovim配置** - 克隆自定义配置
24. **Zsh配置** - 设置别名和插件

## 验证安装

安装完成后，运行以下命令验证：

```bash
# 检查核心工具
docker --version
nvim --version
lazygit --version

# 检查Python工具
uv --version
poetry --version

# 检查OpenCode Manager
systemctl status opencode-manager

# 检查Nginx
/www/server/nginx/sbin/nginx -v

# 检查宝塔面板
sudo bt default
```

## 访问服务

安装完成后，您可以通过以下地址访问：

| 服务 | 访问地址 | 说明 |
|------|----------|------|
| OpenCode Manager | http://www.sailfish.com.cn | 通过Nginx反向代理 |
| 宝塔面板 | http://<服务器IP>:8888 | 查看安装后输出的安全入口 |
| Nginx状态页 | http://<服务器IP> | 默认Nginx欢迎页 |

## 下一步

- [快速开始指南](quick-start.md) - 5分钟上手教程
- [首次运行配置](first-run.md) - 初始化配置说明
- [故障排除](troubleshooting.md) - 常见问题解决
