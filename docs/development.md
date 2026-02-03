# 开发指南

为项目贡献代码。

## 🏗️ 项目结构

```
oh-my-opencode-agents/
├── docs/                          # 文档目录
│   ├── index.md                  # 主页
│   ├── getting-started/          # 入门指南
│   │   ├── installation.md
│   │   ├── quick-start.md
│   │   └── first-run.md
│   ├── features/                 # 功能文档
│   │   ├── overview.md
│   │   ├── dev-tools.md
│   │   ├── server-management.md
│   │   └── nginx-integration.md
│   ├── configuration/            # 配置文档
│   │   ├── environment.md
│   │   └── customization.md
│   ├── troubleshooting.md        # 故障排除
│   └── development.md           # 本文件
├── oh-my-opencode-agents.sh        # 主安装脚本
├── README.md                     # 英文README
├── README.zh-CN.md              # 中文README
├── mkdocs.yml                   # 文档站点配置
├── test-script.sh               # 测试脚本
└── TEST_REPORT.md               # 测试报告
```

## 🚀 快速开始开发

### 克隆仓库

```bash
git clone https://github.com/choovin/oh-my-opencode-agents.git
cd oh-my-opencode-agents
```

### 安装依赖

文档开发需要Python和MkDocs：

```bash
# 安装MkDocs
pip install mkdocs mkdocs-material

# 或使用Poetry
poetry add --group dev mkdocs mkdocs-material
```

### 启动文档开发服务器

```bash
# 预览文档站点
mkdocs serve

# 访问 http://127.0.0.1:8000
```

## 📝 添加新功能

### 1. 添加新的安装函数

在 `oh-my-opencode-agents.sh` 中添加：

```bash
install_new_tool() {
    log_header "New Tool Installation"
    
    if command_exists newtool; then
        log_warn "NewTool is already installed"
        if ! ask_yn "Reinstall NewTool?" "n"; then
            return 1
        fi
    fi
    
    if ask_yn "Install NewTool?" "y"; then
        log_info "Installing NewTool..."
        
        # 安装命令
        sudo apt-get install -y newtool
        
        # 验证
        if command_exists newtool; then
            log_success "NewTool installed: $(newtool --version)"
            return 0
        else
            log_error "NewTool installation failed"
            return 1
        fi
    else
        log_warn "Skipping NewTool installation"
        return 1
    fi
}
```

### 2. 更新主函数

在 `main()` 函数中添加调用：

```bash
main() {
    # ...
    install_poetry && installed_components+=("Poetry")
    install_new_tool && installed_components+=("New Tool")  # 添加这里
    install_gcc && installed_components+=("GCC & Build Tools")
    # ...
}
```

### 3. 更新状态检查

在 `check_installation_status()` 中添加：

```bash
check_installation_status() {
    # ...
    # 添加新工具的检查
    if command_exists newtool; then
        BEFORE_INSTALL[newtool]="$(newtool --version 2>/dev/null || echo 'installed')"
        echo -e "  ${GREEN}✓${NC} newtool: ${BEFORE_INSTALL[newtool]}" | tee -a "$LOG_FILE"
    else
        BEFORE_INSTALL[newtool]="not installed"
        echo -e "  ${RED}✗${NC} newtool: not installed" | tee -a "$LOG_FILE"
    fi
    # ...
}
```

### 4. 更新后安装检查

在 post-installation 循环中添加：

```bash
for tool in ... newtool; do
    case $tool in
        # ...
        newtool) command_exists newtool && current_status="$(newtool --version 2>/dev/null || echo 'installed')" ;;
        # ...
    esac
done
```

### 5. 更新文档

在 `docs/features/dev-tools.md` 中添加文档：

```markdown
## 🛠️ New Tool

### 特性
- 功能1
- 功能2

### 使用方法
```bash
newtool command
```

### 配置
编辑 `~/.newtool/config`：
```ini
setting = value
```
```

## 🧪 测试

### 本地测试

```bash
# 赋予执行权限
chmod +x oh-my-opencode-agents.sh

# 语法检查
bash -n oh-my-opencode-agents.sh

# 运行测试脚本
./test-script.sh
```

### 在Docker中测试

```bash
# 创建测试容器
docker run -it --rm ubuntu:22.04 bash

# 在容器中安装依赖
apt-get update && apt-get install -y curl wget git

# 复制并运行脚本
# ...
```

### 虚拟机测试

使用Vagrant：

```ruby
# Vagrantfile
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.provision "shell", path: "oh-my-opencode-agents.sh"
end
```

```bash
vagrant up
vagrant ssh
```

## 📚 文档贡献

### 文档结构

所有文档使用 Markdown 格式，遵循 Material for MkDocs 主题规范。

### 添加新页面

1. 创建 `.md` 文件：
   ```bash
   touch docs/features/new-feature.md
   ```

2. 添加到导航：
   编辑 `mkdocs.yml`：
   ```yaml
   nav:
     - Features:
       - New Feature: features/new-feature.md
   ```

3. 编写内容：
   ```markdown
   # 新功能标题
   
   介绍文本...
   
   ## 使用方法
   
   ```bash
   代码示例
   ```
   ```

### 文档格式规范

- 使用 `#` 一级标题作为页面标题
- 使用 `##` 二级标题作为章节
- 使用代码块标注 `bash`, `nginx`, `json` 等语言
- 添加表格展示对比信息
- 使用 admonitions 标注提示信息：
  ```markdown
  !!! tip
      提示信息
  
  !!! warning
      警告信息
  ```

## 🔄 提交规范

### Git Commit 格式

使用 Conventional Commits 规范：

```
<type>(<scope>): <description>

<body>

<footer>
```

类型：
- `feat`: 新功能
- `fix`: 修复
- `docs`: 文档
- `test`: 测试
- `refactor`: 重构
- `chore`: 杂项

示例：
```bash
git commit -m "feat: 添加Redis安装支持

- 新增install_redis()函数
- 自动配置systemd服务
- 添加到主函数执行流程"
```

### 提交前检查

```bash
# 1. 语法检查
bash -n oh-my-opencode-agents.sh

# 2. 运行测试
./test-script.sh

# 3. 文档构建
mkdocs build

# 4. 提交
git add .
git commit -m "type: description"
```

## 🌐 国际化

### 添加新语言

1. 创建翻译文件：
   ```
   README.<lang>.md
   ```

2. 更新语言切换链接：
   ```markdown
   [English](README.md) | [简体中文](README.zh-CN.md) | [New Language](README.<lang>.md)
   ```

## 🐛 调试技巧

### 脚本调试

```bash
# 开启详细输出
bash -x oh-my-opencode-agents.sh

# 或在脚本中添加
set -x  # 开启调试
# ... 代码 ...
set +x  # 关闭调试
```

### 日志分析

```bash
# 查看特定函数执行
grep -A 20 "install_opencode_manager" ~/ubuntu-setup-*.log

# 查找错误
grep -i "error\|fail\|warning" ~/ubuntu-setup-*.log
```

## 📦 发布流程

### 版本号规范

使用语义化版本：
- `MAJOR.MINOR.PATCH`
- 示例：`1.2.3`

### 发布检查清单

- [ ] 所有测试通过
- [ ] 文档已更新
- [ ] README已更新
- [ ] 版本号已更新
- [ ] CHANGELOG已更新
- [ ] Git标签已创建

### 创建发布

```bash
# 1. 更新版本号
# 编辑脚本中的版本信息

# 2. 提交
git add .
git commit -m "chore: bump version to 1.2.3"

# 3. 打标签
git tag -a v1.2.3 -m "Release version 1.2.3"

# 4. 推送
git push origin main
git push origin v1.2.3
```

## 🤝 贡献指南

### 提交Issue

1. 使用清晰的标题
2. 描述问题症状
3. 提供复现步骤
4. 附上日志片段
5. 标明Ubuntu版本

### 提交PR

1. Fork 仓库
2. 创建功能分支：`git checkout -b feature/my-feature`
3. 提交更改：`git commit -m "feat: add feature"`
4. 推送分支：`git push origin feature/my-feature`
5. 创建 Pull Request

### Code Review

- 保持代码风格一致
- 添加适当的注释
- 确保错误处理完善
- 更新相关文档

## 📞 联系我们

- GitHub Issues: https://github.com/choovin/oh-my-opencode-agents/issues
- 项目主页: https://choovin.github.io/oh-my-opencode-agents/

---

感谢您对项目的贡献！🎉
