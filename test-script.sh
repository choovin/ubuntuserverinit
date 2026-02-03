#!/bin/bash

# Ubuntu Server Setup Test Script
# This script tests the installation logic without actually installing

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Test counters
TESTS_PASSED=0
TESTS_FAILED=0

test_header() {
    echo -e "\n${CYAN}========================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}========================================${NC}\n"
}

test_pass() {
    echo -e "${GREEN}✓ PASS:${NC} $1"
    ((TESTS_PASSED++))
}

test_fail() {
    echo -e "${RED}✗ FAIL:${NC} $1"
    ((TESTS_FAILED++))
}

test_info() {
    echo -e "${BLUE}ℹ INFO:${NC} $1"
}

# Test 1: Check script syntax
test_header "Test 1: Script Syntax Validation"
if bash -n /workspace/repos/oh-my-opencode-agents/oh-my-opencode-agents.sh 2>&1; then
    test_pass "Script syntax is valid"
else
    test_fail "Script has syntax errors"
fi

# Test 2: Check if all functions are defined
test_header "Test 2: Function Definitions"
REQUIRED_FUNCTIONS=(
    "install_system_updates"
    "install_git"
    "install_zsh"
    "install_zoxide"
    "install_lazygit"
    "install_lazydocker"
    "install_docker"
    "install_neovim"
    "install_luarocks"
    "install_nodejs"
    "install_uv"
    "install_poetry"
    "install_gcc"
    "install_btop"
    "install_tmux"
    "install_fzf"
    "install_ripgrep_fd"
    "install_opencode_manager"
    "install_baota_panel"
    "install_nginx_via_baota"
    "add_baota_website"
    "setup_nginx_symlink"
    "configure_neovim"
    "configure_zsh"
)

for func in "${REQUIRED_FUNCTIONS[@]}"; do
    if grep -q "^${func}()" /workspace/repos/oh-my-opencode-agents/oh-my-opencode-agents.sh; then
        test_pass "Function '$func' is defined"
    else
        test_fail "Function '$func' is NOT defined"
    fi
done

# Test 3: Check main function calls
test_header "Test 3: Main Function Execution Order"
MAIN_CALLS=(
    "install_system_updates"
    "install_git"
    "install_zsh"
    "install_zoxide"
    "install_lazygit"
    "install_lazydocker"
    "install_docker"
    "install_neovim"
    "install_luarocks"
    "install_nodejs"
    "install_uv"
    "install_poetry"
    "install_gcc"
    "install_btop"
    "install_tmux"
    "install_fzf"
    "install_ripgrep_fd"
    "install_opencode_manager"
    "install_baota_panel"
    "install_nginx_via_baota"
    "add_baota_website"
    "setup_nginx_symlink"
)

for call in "${MAIN_CALLS[@]}"; do
    if grep -A 50 "^main()" /workspace/repos/oh-my-opencode-agents/oh-my-opencode-agents.sh | grep -q "${call}"; then
        test_pass "'$call' is called in main()"
    else
        test_fail "'$call' is NOT called in main()"
    fi
done

# Test 4: Check Chinese language support in logs
test_header "Test 4: Chinese Language Support Analysis"

# Check for Chinese text in the script
CHINESE_PATTERNS=(
    "宝塔"
    "面板"
    "安装"
    "配置"
    "成功"
)

CHINESE_COUNT=$(grep -c "宝塔\|面板\|安装\|配置\|成功" /workspace/repos/oh-my-opencode-agents/oh-my-opencode-agents.sh || echo "0")
if [ "$CHINESE_COUNT" -gt 0 ]; then
    test_pass "Found $CHINESE_COUNT instances of Chinese text in logs"
else
    test_info "No Chinese text found in script logs (English only)"
fi

# Test 5: Check if log messages are clear and descriptive
test_header "Test 5: Log Message Quality"

LOG_PATTERNS=(
    "log_info.*Installing"
    "log_success.*successfully"
    "log_warn.*Skipping"
    "log_error.*Failed"
)

for pattern in "${LOG_PATTERNS[@]}"; do
    count=$(grep -cE "$pattern" /workspace/repos/oh-my-opencode-agents/oh-my-opencode-agents.sh || echo "0")
    if [ "$count" -gt 0 ]; then
        test_pass "Pattern '$pattern' found ($count times)"
    else
        test_fail "Pattern '$pattern' not found"
    fi
done

# Test 6: Check critical dependencies
test_header "Test 6: Dependency Chain Validation"

# Check if install_opencode_manager checks for npm
if grep -A 10 "install_opencode_manager()" /workspace/repos/oh-my-opencode-agents/oh-my-opencode-agents.sh | grep -q "command_exists npm"; then
    test_pass "install_opencode_manager checks for npm dependency"
else
    test_fail "install_opencode_manager missing npm dependency check"
fi

# Check if install_poetry checks for python3
if grep -A 10 "install_poetry()" /workspace/repos/oh-my-opencode-agents/oh-my-opencode-agents.sh | grep -q "command_exists python3"; then
    test_pass "install_poetry checks for python3"
else
    test_fail "install_poetry missing python3 check"
fi

# Test 7: Check systemd service configuration
test_header "Test 7: Systemd Service Configuration"

if grep -A 30 "opencode-manager.service" /workspace/repos/oh-my-opencode-agents/oh-my-opencode-agents.sh | grep -q "ExecStart.*pnpm"; then
    test_pass "Systemd service includes pnpm ExecStart"
else
    test_fail "Systemd service missing pnpm ExecStart"
fi

if grep -A 30 "opencode-manager.service" /workspace/repos/oh-my-opencode-agents/oh-my-opencode-agents.sh | grep -q "/usr/local/bin"; then
    test_pass "Systemd service includes correct PATH with /usr/local/bin"
else
    test_fail "Systemd service PATH may be incorrect"
fi

# Test 8: Check error handling
test_header "Test 8: Error Handling Coverage"

ERROR_HANDLING_PATTERNS=(
    "set -euo pipefail"
    "trap.*ERR"
    "log_error"
)

for pattern in "${ERROR_HANDLING_PATTERNS[@]}"; do
    if grep -q "$pattern" /workspace/repos/oh-my-opencode-agents/oh-my-opencode-agents.sh; then
        test_pass "Error handling: '$pattern' present"
    else
        test_fail "Error handling: '$pattern' missing"
    fi
done

# Test 9: Check for potential execution order issues
test_header "Test 9: Execution Order Analysis"

# Get line numbers of key installations
NODEJS_LINE=$(grep -n "install_nodejs &&" /workspace/repos/oh-my-opencode-agents/oh-my-opencode-agents.sh | head -1 | cut -d: -f1)
OPENCODE_LINE=$(grep -n "install_opencode_manager &&" /workspace/repos/oh-my-opencode-agents/oh-my-opencode-agents.sh | head -1 | cut -d: -f1)
POETRY_LINE=$(grep -n "install_poetry &&" /workspace/repos/oh-my-opencode-agents/oh-my-opencode-agents.sh | head -1 | cut -d: -f1)

if [ -n "$NODEJS_LINE" ] && [ -n "$OPENCODE_LINE" ]; then
    if [ "$NODEJS_LINE" -lt "$OPENCODE_LINE" ]; then
        test_pass "Node.js ($NODEJS_LINE) is installed before OpenCode Manager ($OPENCODE_LINE)"
    else
        test_fail "CRITICAL: OpenCode Manager ($OPENCODE_LINE) is installed BEFORE Node.js ($NODEJS_LINE)"
    fi
fi

# Test 10: README completeness
test_header "Test 10: Documentation Completeness"

if grep -q "Poetry" /workspace/repos/oh-my-opencode-agents/README.md; then
    test_pass "README.md documents Poetry"
else
    test_fail "README.md missing Poetry documentation"
fi

if grep -q "Poetry" /workspace/repos/oh-my-opencode-agents/README.zh-CN.md; then
    test_pass "README.zh-CN.md documents Poetry"
else
    test_fail "README.zh-CN.md missing Poetry documentation"
fi

# Summary
test_header "Test Summary"
echo -e "${GREEN}Tests Passed: $TESTS_PASSED${NC}"
echo -e "${RED}Tests Failed: $TESTS_FAILED${NC}"
echo -e "${BLUE}Total Tests: $((TESTS_PASSED + TESTS_FAILED))${NC}"

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "\n${GREEN}✓ All tests passed! Script is ready for production use.${NC}"
    exit 0
else
    echo -e "\n${YELLOW}⚠ Some tests failed. Please review the issues above.${NC}"
    exit 1
fi
