# wsl-claude-notifier

> 为 WSL2 + tmux 环境下的 [Claude Code](https://docs.anthropic.com/en/docs/claude-code) 提供 Windows 原生 toast 通知。

[English](README.md)

## 痛点

WSL2 没有原生的 Windows 通知机制。Claude Code 完成任务或需要输入时，你只能反复切回终端查看。如果同时在多个 tmux 窗口运行 Claude，更难追踪哪个会话需要关注。

本工具解决以上所有问题：

- **Windows 原生通知** — Claude Code 停止或需要输入时弹出 Win11 toast 通知
- **Tmux 感知** — 通知标题显示 `[session:window]`，一眼识别是哪个会话
- **一键跳转** — 点击通知上的 "Jump" 按钮，自动激活 Windows Terminal 并切换到对应 tmux 窗口 _（pane 级跳转开发中 — 受 tmux mouse 模式影响暂未实现）_
- **Claude 图标** — 通知带有 Claude logo，视觉辨识度高
- **零配置** — 一个脚本完成所有安装：BurntToast、脚本部署、协议注册、Claude Code hooks

## 测试环境

- Windows 11 + Windows Terminal
- WSL2 (Ubuntu)
- tmux

## 安装

```bash
git clone <repo-url>
cd wsl-claude-notifier
bash install.sh
```

安装脚本会自动完成：
1. 安装 [BurntToast](https://github.com/Windos/BurntToast) PowerShell 模块
2. 部署通知脚本到 `~/.local/bin/`
3. 部署协议处理器 + 图标到 `C:\Users\<用户名>\.wsl-claude-notifier\`
4. 注册 `tmux-jump://` 自定义协议
5. 在 `~/.claude/settings.json` 中配置 hooks

## 前置依赖

- WSL2，已安装 `jq`（`sudo apt install jq`）
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI
- tmux（推荐，没有 tmux 也能用但无 Jump 按钮）
- Windows Terminal

## 卸载

```bash
bash uninstall.sh
```

移除所有部署的文件、注册表项和 Claude Code hooks。

## 故障排查

**通知不弹出？**
- 验证 BurntToast：`powershell.exe -NoProfile -Command "Import-Module BurntToast; New-BurntToastNotification -Text 'Test'"`
- 检查 Windows 通知设置（设置 > 系统 > 通知）
- 确认 `jq` 已安装：`which jq`

**Jump 按钮没有跳转？**
- 查看当前 tmux 位置：`tmux display-message -p '#{session_name}:#{window_index}.#{pane_index}'`
- 直接测试跳转：`bash ~/.local/bin/tmux-jump.sh <session>:<window>.<pane>`
- 测试协议处理器：`powershell.exe -Command "Start-Process 'tmux-jump://<session>:<window>.<pane>'"`
- 检查处理器是否存在：`ls /mnt/c/Users/*/.wsl-claude-notifier/tmux-jump.ps1`
- 查看协议日志：`cat /mnt/c/Users/*/.wsl-claude-notifier/tmux-jump.log`

**通知没有 Jump 按钮？**
- Jump 按钮仅在 tmux 环境内出现（`echo $TMUX` 应有输出）

## License

[MIT](LICENSE)

图标来自 [lobe-icons](https://github.com/lobehub/lobe-icons)（MIT License）。
