# 故障排除

常见问题及解决方案。

## 🚨 安装问题

### 脚本权限被拒绝

**症状**：
```
bash: ./oh-my-opencode-agents.sh: Permission denied
```

**解决**：
```bash
chmod +x oh-my-opencode-agents.sh
./oh-my-opencode-agents.sh
```

### 网络连接失败

**症状**：
```
[ERROR] No internet connection detected
```

**检查**：
```bash
# 测试网络
ping -c 3 google.com

# 检查DNS
cat /etc/resolv.conf

# 检查代理
env | grep -i proxy
```

**解决**：
```bash
# 配置DNS
sudo tee /etc/resolv.conf << EOF
nameserver 8.8.8.8
nameserver 1.1.1.1
EOF

# 如果使用代理
export http_proxy=http://proxy.example.com:8080
export https_proxy=http://proxy.example.com:8080
```

### Sudo权限不足

**症状**：
```
[ERROR] Failed to obtain sudo privileges
```

**检查**：
```bash
# 检查sudo配置
sudo -l

# 检查用户组
groups
```

**解决**：
```bash
# 以root用户运行
sudo bash oh-my-opencode-agents.sh -y
```

## 🐋 Docker问题

### Docker命令需要sudo

**症状**：
```
permission denied while trying to connect to the Docker daemon socket
```

**解决**：
```bash
# 方法1：刷新用户组
newgrp docker

# 方法2：重新登录
logout
# 重新SSH登录

# 方法3：检查docker组
groups | grep docker
# 如果未显示，手动添加：
sudo usermod -aG docker $USER
```

### Docker安装失败

**症状**：
```
[ERROR] Docker installation failed
```

**手动安装**：
```bash
# 清理旧版本
sudo apt-get remove docker docker-engine docker.io containerd runc

# 官方安装脚本
curl -fsSL https://get.docker.com | sudo bash

# 添加到docker组
sudo usermod -aG docker $USER
```

## 🐚 Zsh问题

### Zsh未激活

**症状**：
默认Shell仍是bash

**检查**：
```bash
echo $SHELL
# 显示: /bin/bash (而非 /usr/bin/zsh)
```

**解决**：
```bash
# 更改默认shell
chsh -s $(which zsh)

# 如果提示需要密码，运行：
sudo chsh -s $(which zsh) $USER

# 重新登录
echo "请重新登录以激活Zsh"
```

### Oh-My-Zsh插件未加载

**症状**：
- 主题不显示
- 插件功能不可用

**检查**：
```bash
# 检查安装
ls -la ~/.oh-my-zsh/

# 检查配置
cat ~/.zshrc | grep -A 5 "plugins=("
```

**解决**：
```bash
# 重新安装oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# 重新加载配置
source ~/.zshrc
```

## 📝 Neovim问题

### Neovim配置克隆失败

**症状**：
```
[ERROR] Failed to clone Neovim config
```

**手动克隆**：
```bash
# 备份现有配置
mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d)

# 手动克隆
```bash
# 备份现有配置
mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d)

# 手动克隆
git clone https://github.com/choovin/nvimconfig.git ~/.config/nvim

# 或者使用SSH（如果已配置）
git clone git@github.com:choovin/nvimconfig.git ~/.config/nvim
```

### Neovim版本过低

**症状**：
某些功能不可用或报错

**检查**：
```bash
nvim --version
# 需要 v0.10+ 才能使用 vim.uv API
```

**升级**：
```bash
# 重新运行安装脚本中的neovim安装部分
# 或手动下载最新AppImage
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim
```

## 🌐 OpenCode Manager问题

### 服务无法启动

**症状**：
```
[ERROR] OpenCode Manager service failed to start
```

**诊断**：
```bash
# 查看服务状态
sudo systemctl status opencode-manager

# 查看详细日志
sudo journalctl -u opencode-manager -n 100 --no-pager

# 检查端口占用
sudo netstat -tlnp | grep 5003
```

**常见原因**：

1. **pnpm路径错误**
   ```bash
   # 检查pnpm位置
   which pnpm
   # 应该显示: /usr/local/bin/pnpm
   
   # 修复：编辑服务文件
   sudo nano /etc/systemd/system/opencode-manager.service
   # 确保 ExecStart=/usr/local/bin/pnpm start
   ```

2. **Node.js未安装**
   ```bash
   # 检查Node.js
   node --version
   
   # 重新安装
   curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo bash -
   sudo apt-get install -y nodejs
   sudo npm install -g pnpm
   ```

3. **端口被占用**
   ```bash
   # 查看占用5003端口的进程
   sudo lsof -i :5003
   
   # 终止进程
   sudo kill -9 <PID>
   
   # 重启服务
   sudo systemctl restart opencode-manager
   ```

### 无法访问Web界面

**症状**：
浏览器无法打开 http://www.sailfish.com.cn

**检查步骤**：

1. **检查服务运行状态**
   ```bash
   sudo systemctl is-active opencode-manager
   ```

2. **检查防火墙**
   ```bash
   sudo ufw status
   # 确保80/443/5003端口开放
   ```

3. **检查Nginx配置**
   ```bash
   sudo /www/server/nginx/sbin/nginx -t
   sudo /etc/init.d/nginx status
   ```

4. **直接访问端口测试**
   ```bash
   curl http://localhost:5003
   ```

## 🎛️ 宝塔面板问题

### 安装失败

**症状**：
宝塔安装脚本执行失败

**手动安装**：
```bash
# 下载官方脚本
wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh
sudo bash install.sh
```

### 忘记宝塔密码

**解决**：
```bash
# 重置面板密码
sudo bt 5
# 按提示输入新密码

# 或者查看当前信息
sudo bt default
```

### 无法访问宝塔面板

**检查**：
```bash
# 检查宝塔运行状态
sudo bt status

# 检查端口监听
sudo netstat -tlnp | grep 8888

# 检查防火墙
sudo ufw allow 8888/tcp
```

### 面板显示异常

**解决**：
```bash
# 修复面板
sudo bt 16

# 或重新安装面板（保留数据）
sudo bt stop
sudo rm -rf /www/server/panel/BT-Task
sudo bt start
```

## 🌐 Nginx问题

### 配置文件错误

**症状**：
```
nginx: [emerg] directive "..." is not allowed here
```

**检查**：
```bash
# 测试配置语法
sudo /www/server/nginx/sbin/nginx -t

# 查看错误详情
sudo /www/server/nginx/sbin/nginx -t 2>&1
```

### 网站无法访问

**诊断**：
```bash
# 1. 检查Nginx运行状态
sudo /etc/init.d/nginx status

# 2. 检查错误日志
sudo tail -f /www/wwwlogs/www.sailfish.com.cn.error.log

# 3. 检查网站目录
ls -la /www/wwwroot/www.sailfish.com.cn/

# 4. 检查权限
sudo chown -R www:www /www/wwwroot/www.sailfish.com.cn/
```

### 反向代理502错误

**原因**：OpenCode Manager未运行

**解决**：
```bash
# 检查后端服务
sudo systemctl status opencode-manager

# 重启后端服务
sudo systemctl restart opencode-manager

# 检查端口连通性
curl http://127.0.0.1:5003
```

## 🐍 Python工具问题

### Poetry安装失败

**症状**：
```
ModuleNotFoundError: No module named '...'
```

**解决**：
```bash
# 确保Python3已安装
sudo apt-get install -y python3 python3-pip

# 重新安装Poetry
curl -sSL https://install.python-poetry.org | python3 -

# 添加到PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### UV命令找不到

**解决**：
```bash
# 检查安装
ls -la ~/.cargo/bin/uv

# 添加PATH
export PATH="$HOME/.cargo/bin:$PATH"

# 创建软链接
sudo ln -sf ~/.cargo/bin/uv /usr/local/bin/uv
```

## 📝 日志查看指南

### 安装日志
```bash
# 查看最新日志
ls -lt ~/ubuntu-setup-*.log | head -1

# 查看特定组件安装
# 查看OpenCode Manager安装
grep -A 20 "OpenCode Manager Installation" ~/ubuntu-setup-*.log
```

### 系统日志
```bash
# OpenCode Manager
sudo journalctl -u opencode-manager -f

# Nginx错误
sudo tail -f /www/wwwlogs/www.sailfish.com.cn.error.log

# 宝塔面板
sudo tail -f /www/server/panel/logs/error.log

# 系统日志
sudo tail -f /var/log/syslog
```

## 🔧 通用调试技巧

### 1. 逐步执行
```bash
# 在main函数中添加set -x调试
set -x  # 开启调试
install_opencode_manager
set +x  # 关闭调试
```

### 2. 检查变量
```bash
# 打印变量值
echo "VAR_VALUE=$VAR_VALUE"
echo "PATH=$PATH"
```

### 3. 测试单个函数
```bash
# 注释main()中的其他调用，只测试特定函数
main() {
    # ...
    # install_system_updates
    # install_git
    install_opencode_manager  # 只测试这个
}
```

## 📞 获取帮助

如果以上方法都无法解决问题：

1. **查看完整日志**：
   ```bash
   cat ~/ubuntu-setup-*.log
   ```

2. **提交Issue**：
   - 访问: https://github.com/choovin/oh-my-opencode-agents/issues
   - 提供：Ubuntu版本、错误信息、日志片段

3. **社区支持**：
   - 宝塔面板论坛: https://www.bt.cn/bbs
   - OpenCode文档: https://opencode.ai/docs
