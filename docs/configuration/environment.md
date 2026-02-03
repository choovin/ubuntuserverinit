# 环境配置

环境变量和高级配置选项。

## 🔧 全局配置

### 脚本行为控制

#### Auto-Yes 模式

使用 `-y` 或 `--yes` 参数自动确认所有提示：

```bash
sudo ./oh-my-opencode-agents.sh -y
```

适用于：
- CI/CD自动化部署
- 无人值守安装
- 批量服务器配置

#### 帮助信息

```bash
./oh-my-opencode-agents.sh --help
```

输出：
```
Ubuntu Server Initial Setup Script

Usage: ./oh-my-opencode-agents.sh [OPTIONS]

OPTIONS:
    -y, --yes       Auto-answer yes to all prompts
    -h, --help      Display this help message

EXAMPLES:
    ./oh-my-opencode-agents.sh              # Interactive mode
    ./oh-my-opencode-agents.sh -y           # Non-interactive mode
    sudo bash ./oh-my-opencode-agents.sh -y # Run with sudo
```

## 📁 配置文件位置

### 安装日志
```
~/ubuntu-setup-YYYYMMDD-HHMMSS.log
```

查看日志：
```bash
cat ~/ubuntu-setup-*.log
tail -f ~/ubuntu-setup-*.log
```

### 备份目录
```
~/.config-backups/YYYYMMDD-HHMMSS/
```

内容：
- zshrc备份
- nvim配置备份
- 其他配置文件备份

### 各工具配置

| 工具 | 配置位置 |
|------|----------|
| Zsh | `~/.zshrc` |
| Neovim | `~/.config/nvim/` |
| Poetry | `~/.config/pypoetry/config.toml` |
| Docker | `/etc/docker/daemon.json` |
| Nginx | `/www/server/panel/vhost/nginx/` |
| 宝塔 | `/www/server/panel/data/` |

## 🐚 Zsh 配置

### 主题设置

编辑 `~/.zshrc`：

```bash
# 修改主题
ZSH_THEME="robbyrussell"  # 默认

# 其他推荐主题
ZSH_THEME="agnoster"      # 需要安装Powerline字体
ZSH_THEME="powerlevel10k/powerlevel10k"  # 高度可定制
ZSH_THEME="spaceship"     # 适用于开发
```

### 插件管理

默认启用的插件：
```bash
plugins=(
    git
    docker
    zoxide
    fzf
    zsh-history-substring-search
)
```

添加更多插件：
```bash
# 编辑 ~/.zshrc
plugins=(
    git
    docker
    zoxide
    fzf
    zsh-history-substring-search
    kubectl      # Kubernetes
    terraform    # Terraform
    aws          # AWS CLI
    npm          # npm自动补全
    python       # Python函数
    pip          # pip自动补全
)
```

### 自定义别名

```bash
# 编辑 ~/.zshrc，在文件末尾添加

# 个人别名
alias gs='git status'
alias gp='git pull'
alias gl='git log --oneline --graph'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias k='kubectl'
```

## 🐍 Python 环境配置

### Poetry 配置

查看当前配置：
```bash
poetry config --list
```

常用配置：
```bash
# 虚拟环境存储在项目目录
poetry config virtualenvs.in-project true

# 创建虚拟环境时自动激活
poetry config virtualenvs.prefer-active-python true

# 设置PyPI镜像（国内加速）
poetry config repositories.pypi https://pypi.tuna.tsinghua.edu.cn/simple/
```

配置文件位置：
```
~/.config/pypoetry/config.toml
```

### UV 配置

UV配置通过环境变量：
```bash
# 设置Python版本
export UV_PYTHON=python3.11

# 设置缓存目录
export UV_CACHE_DIR=/var/cache/uv

# 添加到 ~/.zshrc
```

## 🐋 Docker 配置

### Docker Daemon 配置

编辑 `/etc/docker/daemon.json`：

```json
{
  "registry-mirrors": [
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com"
  ],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2"
}
```

重启Docker：
```bash
sudo systemctl restart docker
```

### 用户组配置

当前用户已添加到docker组：
```bash
# 验证
groups | grep docker

# 刷新权限
newgrp docker

# 测试
docker ps
```

## 🌐 OpenCode Manager 配置

### 服务配置

Systemd服务文件：
```
/etc/systemd/system/opencode-manager.service
```

查看配置：
```bash
cat /etc/systemd/system/opencode-manager.service
```

### 环境变量

OpenCode Manager 读取 `.env` 文件：
```
/opt/opencode-manager/.env
```

常用配置：
```bash
# 编辑环境配置
cd /opt/opencode-manager
sudo nano .env

# 修改端口（默认5003）
PORT=5003

# 认证密钥
AUTH_SECRET=your-secure-secret-key

# 允许的外部访问
AUTH_TRUSTED_ORIGINS=http://www.sailfish.com.cn
```

重启服务：
```bash
sudo systemctl restart opencode-manager
```

## 🎛️ 宝塔面板配置

### 默认配置

宝塔配置目录：
```
/www/server/panel/
```

重要文件：
```
/www/server/panel/data/port.pl        # 面板端口
/www/server/panel/data/admin_path.pl  # 安全入口
/www/server/panel/data/default.db     # 数据库
```

### 修改面板端口

```bash
# 方法1：使用bt命令
sudo bt 8
# 输入新端口号

# 方法2：直接修改
sudo echo "8889" > /www/server/panel/data/port.pl
sudo bt restart
```

### 修改安全入口

```bash
# 生成新的随机入口
sudo bt 9
# 按提示操作
```

## 🌐 Nginx 配置

### 主配置文件

```
/www/server/nginx/conf/nginx.conf
```

关键配置项：
```nginx
user www;                          # 运行用户
worker_processes auto;             # 工作进程数
error_log /www/wwwlogs/nginx_error.log warn;

events {
    worker_connections 4096;       # 连接数
    use epoll;                     # 使用epoll
}

http {
    include mime.types;
    default_type application/octet-stream;
    
    # 日志格式
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';
    
    # Gzip
    gzip on;
    gzip_vary on;
    
    # 包含虚拟主机配置
    include /www/server/panel/vhost/nginx/*.conf;
}
```

### 虚拟主机配置

模板：
```nginx
server {
    listen 80;
    server_name example.com www.example.com;
    root /www/wwwroot/example.com;
    index index.html index.php;
    
    # 访问日志
    access_log /www/wwwlogs/example.com.log;
    error_log /www/wwwlogs/example.com.error.log;
    
    # 静态文件缓存
    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
    
    # PHP处理
    location ~ [^/]\.php(/|$) {
        fastcgi_pass unix:/tmp/php-cgi-74.sock;
        fastcgi_index index.php;
        include fastcgi.conf;
    }
    
    # 反向代理示例
    location /api/ {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    
    # 安全：禁止访问隐藏文件
    location ~ /\.(?!well-known) {
        deny all;
    }
}
```

## 🔒 安全配置

### SSH 安全

编辑 `/etc/ssh/sshd_config`：

```bash
# 修改默认端口（推荐）
Port 2222

# 禁用root登录
PermitRootLogin no

# 禁用密码认证（仅使用密钥）
PasswordAuthentication no
PubkeyAuthentication yes

# 限制用户
AllowUsers developer

# 重启SSH
sudo systemctl restart sshd
```

### 防火墙配置

UFW配置：
```bash
# 默认策略
sudo ufw default deny incoming
sudo ufw default allow outgoing

# 允许服务
sudo ufw allow 2222/tcp    # SSH（修改后的端口）
sudo ufw allow 80/tcp      # HTTP
sudo ufw allow 443/tcp     # HTTPS
sudo ufw allow 8888/tcp    # 宝塔（如果未修改）

# 启用
sudo ufw enable
sudo ufw status verbose
```

### Fail2ban

安装和配置：
```bash
sudo apt install fail2ban

# 创建本地配置
sudo tee /etc/fail2ban/jail.local << 'EOF'
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5
backend = systemd

[sshd]
enabled = true
port = 2222
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
EOF

# 启动
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# 查看状态
sudo fail2ban-client status
sudo fail2ban-client status sshd
```

## 📝 自定义安装脚本

### 跳过某些组件

编辑脚本，注释掉不需要的组件：
```bash
# 编辑脚本
nano oh-my-opencode-agents.sh

# 在main()函数中注释掉
main() {
    # ...
    install_system_updates && installed_components+=("System Updates")
    install_git && installed_components+=("Git")
    # install_zsh && installed_components+=("Zsh + Oh-My-Zsh")  # 跳过
    # ...
}
```

### 创建自定义脚本

```bash
#!/bin/bash
# custom-setup.sh

# 下载主脚本
curl -O https://raw.githubusercontent.com/choovin/oh-my-opencode-agents/main/oh-my-opencode-agents.sh
chmod +x oh-my-opencode-agents.sh

# 只安装特定组件（示例）
# 这里可以调用主脚本中的单个函数
source ./oh-my-opencode-agents.sh

# 手动调用需要的函数
check_prerequisites
install_system_updates
install_git
install_docker
install_nodejs
# ...等等
```

## 🔄 自动化部署

### 无人值守安装

```bash
#!/bin/bash
# deploy.sh - 用于CI/CD

set -e

SERVER_IP=$1
SSH_KEY=$2

# 复制脚本到服务器
scp -i $SSH_KEY oh-my-opencode-agents.sh root@$SERVER_IP:/tmp/

# 执行安装
ssh -i $SSH_KEY root@$SERVER_IP "chmod +x /tmp/oh-my-opencode-agents.sh && /tmp/oh-my-opencode-agents.sh -y"

# 验证安装
ssh -i $SSH_KEY root@$SERVER_IP "docker --version && systemctl status opencode-manager"

echo "Deployment completed!"
```

### Cloud-init 配置

用于云平台初始化：
```yaml
# cloud-config.yaml
#cloud-config

runcmd:
  - curl -O https://raw.githubusercontent.com/choovin/oh-my-opencode-agents/main/oh-my-opencode-agents.sh
  - chmod +x oh-my-opencode-agents.sh
  - ./oh-my-opencode-agents.sh -y
  - reboot
```
