# Claude Code Use Model

[中文](#中文) | [English](#english)

## 中文

`claude-mimo` 是一个非官方 Claude Code 启动器，用来让 `claude` 命令通过小米 MiMo 的 Anthropic-compatible API 运行。

它不会安装 Claude Code 本身，也不会把 API key 同步到 Git 仓库。它只负责在启动 Claude Code 前设置必要的环境变量，并提供一个简单的配置菜单来管理 API key、模型、Base URL 和 profile。

### 功能

- 用 `claude-mimo` 启动接入 MiMo 的 Claude Code
- 用 `claude-mimo config` 交互式配置 API key、模型和 Base URL
- 支持多个 profile，例如 `default`、`work`、`personal`
- API key 默认保存到 macOS Keychain
- 没有 Keychain 的环境会退回到本机私有 key 文件
- 支持命令行配置，适合自动化安装

### 前置条件

- 已安装 Claude Code，并且 `claude` 命令可以直接运行
- 拥有可用的 MiMo API key
- macOS 或其他带 `zsh` 的类 Unix 环境
- 已安装 `git`

如果 `claude` 不在 `PATH` 中，可以通过 `CLAUDE_BIN=/path/to/claude` 指定 Claude Code 的路径。

### 安装

使用 SSH：

```zsh
git clone git@github.com:DragonTAT/claude-code-use-model.git
cd claude-code-use-model
./install.sh
source ~/.zshrc
```

如果没有配置 GitHub SSH key，可以使用 HTTPS：

```zsh
git clone https://github.com/DragonTAT/claude-code-use-model.git
cd claude-code-use-model
./install.sh
source ~/.zshrc
```

安装后确认版本：

```zsh
claude-mimo --version
```

### 首次配置

运行：

```zsh
claude-mimo config
```

配置菜单可以：

- `Switch/create profile`：切换或创建 profile
- `Set/change API key`：设置或更换当前 profile 的 API key
- `Select model`：选择主模型，默认是 `mimo-v2.5-pro`
- `Select fast model`：选择快速模型，默认和主模型一致
- `Select Base URL`：选择 MiMo API 地址
- `Delete API key for this profile`：删除当前 profile 的 API key
- `Show status`：查看当前配置

配置完成后启动：

```zsh
claude-mimo
```

### 常用命令

```zsh
claude-mimo              # 使用当前 profile 启动 Claude Code
claude-mimo config       # 打开配置菜单
claude-mimo status       # 查看当前 profile、模型、Base URL 和 key 状态
claude-mimo profiles     # 查看所有 profile
claude-mimo use work     # 切换到 work profile
claude-mimo help         # 查看帮助
```

### 命令行配置

不打开菜单也可以直接配置：

```zsh
claude-mimo config --profile work --model mimo-v2.5-pro
claude-mimo config --profile work --api-key 'YOUR_MIMO_API_KEY'
claude-mimo config --profile work --base-url 'https://token-plan-sgp.xiaomimimo.com/anthropic'
```

让工具按 API key 自动判断 Base URL：

```zsh
claude-mimo config --profile work --auto-base-url
```

避免 API key 留在 shell history 中：

```zsh
printf '%s' 'YOUR_MIMO_API_KEY' | claude-mimo config --profile work --api-key-stdin
```

### Profile

每个 profile 可以有独立的 API key、模型和 Base URL。常见用法：

- `default`：默认个人配置
- `work`：工作账号或公司 key
- `personal`：个人账号或实验模型

切换 profile：

```zsh
claude-mimo use work
claude-mimo status
```

### Base URL

配置菜单内置了三个常见地址：

- Pay-as-you-go：`https://api.xiaomimimo.com/anthropic`
- Token plan Singapore：`https://token-plan-sgp.xiaomimimo.com/anthropic`
- Token plan China：`https://token-plan-cn.xiaomimimo.com/anthropic`

如果 MiMo 控制台显示的地址不同，选择 `Custom Base URL`，并粘贴控制台给出的地址。

### 安全说明

- API key 不会写进这个 Git 仓库
- macOS 上默认保存到 Keychain
- Keychain 不可用时，会保存到 `~/.config/claude-code-use-model/keys/*.key`
- 不建议同步整个 `~/.claude` 目录，因为里面可能包含历史会话、项目路径和敏感信息

兼容性说明：如果系统里曾经使用过旧版 `claude-mimo`，并把 key 保存为 macOS Keychain 服务 `mimo-api-key`，新版 `default` profile 会尝试自动读取它。新用户可以忽略这一点。

### 配置文件位置

默认配置目录：

```zsh
~/.config/claude-code-use-model
```

主要文件：

- `active_profile`：当前启用的 profile
- `profiles/*.env`：每个 profile 的模型和 Base URL
- `keys/*.key`：只有在 Keychain 不可用时才使用的本机 key 文件

### 环境变量覆盖

可以临时覆盖当前 profile：

```zsh
MIMO_MODEL=mimo-v2.5-pro claude-mimo
MIMO_BASE_URL=https://token-plan-cn.xiaomimimo.com/anthropic claude-mimo
MIMO_API_KEY=YOUR_MIMO_API_KEY claude-mimo
```

如果 `claude` 命令不在 `PATH` 中：

```zsh
CLAUDE_BIN=/path/to/claude claude-mimo
```

### 更新

进入仓库目录后运行：

```zsh
git pull
./install.sh
claude-mimo --version
```

如果是从旧版本升级，建议检查配置：

```zsh
claude-mimo status
```

### 卸载

删除启动器：

```zsh
rm -f ~/.local/bin/claude-mimo
```

删除本机配置：

```zsh
rm -rf ~/.config/claude-code-use-model
```

macOS Keychain 中保存的 key 可以在 `claude-mimo config` 中用 `Delete API key for this profile` 删除。

### 排查

找不到 `claude`：

```zsh
which claude
```

确认 Claude Code 已安装，并且 `claude` 命令可以直接运行。

认证失败：

```zsh
claude-mimo status
```

重点检查 API key 是否存在、Base URL 是否和 MiMo 控制台一致。

Base URL 无法解析：

```zsh
claude-mimo config --profile default --auto-base-url
```

或者重新进入配置菜单，选择一个干净的 Base URL。

## English

`claude-mimo` is an unofficial Claude Code launcher that runs the `claude` command through Xiaomi MiMo's Anthropic-compatible API.

It does not install Claude Code itself, and it does not sync API keys to Git. It only prepares the environment variables needed by Claude Code and provides a small configuration menu for API keys, models, Base URLs, and profiles.

### Features

- Start MiMo-backed Claude Code with `claude-mimo`
- Configure API keys, models, and Base URLs with `claude-mimo config`
- Manage multiple profiles such as `default`, `work`, and `personal`
- Store API keys in macOS Keychain by default
- Fall back to a private local key file when Keychain is unavailable
- Support command-line configuration for automated setup

### Prerequisites

- Claude Code is installed, and the `claude` command works directly
- A valid MiMo API key
- macOS or another Unix-like environment with `zsh`
- `git` is installed

If `claude` is not in `PATH`, set `CLAUDE_BIN=/path/to/claude`.

### Installation

Using SSH:

```zsh
git clone git@github.com:DragonTAT/claude-code-use-model.git
cd claude-code-use-model
./install.sh
source ~/.zshrc
```

If you do not have a GitHub SSH key configured, use HTTPS:

```zsh
git clone https://github.com/DragonTAT/claude-code-use-model.git
cd claude-code-use-model
./install.sh
source ~/.zshrc
```

Confirm the installed version:

```zsh
claude-mimo --version
```

### First-time Configuration

Run:

```zsh
claude-mimo config
```

The configuration menu can:

- `Switch/create profile`: switch or create a profile
- `Set/change API key`: set or change the API key for the current profile
- `Select model`: choose the main model, defaulting to `mimo-v2.5-pro`
- `Select fast model`: choose the fast model, defaulting to the main model
- `Select Base URL`: choose the MiMo API endpoint
- `Delete API key for this profile`: delete the API key for the current profile
- `Show status`: show the current configuration

After configuration, start Claude Code:

```zsh
claude-mimo
```

### Common Commands

```zsh
claude-mimo              # Start Claude Code with the current profile
claude-mimo config       # Open the configuration menu
claude-mimo status       # Show current profile, model, Base URL, and key status
claude-mimo profiles     # List all profiles
claude-mimo use work     # Switch to the work profile
claude-mimo help         # Show help
```

### Command-line Configuration

Configure directly without opening the menu:

```zsh
claude-mimo config --profile work --model mimo-v2.5-pro
claude-mimo config --profile work --api-key 'YOUR_MIMO_API_KEY'
claude-mimo config --profile work --base-url 'https://token-plan-sgp.xiaomimimo.com/anthropic'
```

Let the tool choose the Base URL automatically based on the API key:

```zsh
claude-mimo config --profile work --auto-base-url
```

Avoid leaving the API key in shell history:

```zsh
printf '%s' 'YOUR_MIMO_API_KEY' | claude-mimo config --profile work --api-key-stdin
```

### Profiles

Each profile can have its own API key, model, and Base URL. Common examples:

- `default`: default personal configuration
- `work`: work account or company key
- `personal`: personal account or experimental model

Switch profiles:

```zsh
claude-mimo use work
claude-mimo status
```

### Base URL

The configuration menu includes three common endpoints:

- Pay-as-you-go: `https://api.xiaomimimo.com/anthropic`
- Token plan Singapore: `https://token-plan-sgp.xiaomimimo.com/anthropic`
- Token plan China: `https://token-plan-cn.xiaomimimo.com/anthropic`

If the MiMo console shows a different endpoint, choose `Custom Base URL` and paste the endpoint shown in the console.

### Security Notes

- API keys are not written to this Git repository
- On macOS, API keys are stored in Keychain by default
- When Keychain is unavailable, keys are stored in `~/.config/claude-code-use-model/keys/*.key`
- Do not sync the entire `~/.claude` directory; it may contain conversation history, project paths, and sensitive data

Compatibility note: if a system previously used an older `claude-mimo` script that stored the key as the macOS Keychain service `mimo-api-key`, the new `default` profile will try to read it automatically. New users can ignore this.

### Config File Location

Default config directory:

```zsh
~/.config/claude-code-use-model
```

Main files:

- `active_profile`: the active profile
- `profiles/*.env`: model and Base URL settings for each profile
- `keys/*.key`: local key files used only when Keychain is unavailable

### Environment Variable Overrides

Temporarily override the current profile:

```zsh
MIMO_MODEL=mimo-v2.5-pro claude-mimo
MIMO_BASE_URL=https://token-plan-cn.xiaomimimo.com/anthropic claude-mimo
MIMO_API_KEY=YOUR_MIMO_API_KEY claude-mimo
```

If `claude` is not in `PATH`:

```zsh
CLAUDE_BIN=/path/to/claude claude-mimo
```

### Updating

From the repository directory:

```zsh
git pull
./install.sh
claude-mimo --version
```

After upgrading from an older version, check the current configuration:

```zsh
claude-mimo status
```

### Uninstalling

Remove the launcher:

```zsh
rm -f ~/.local/bin/claude-mimo
```

Remove local configuration:

```zsh
rm -rf ~/.config/claude-code-use-model
```

Keys stored in macOS Keychain can be removed from `claude-mimo config` with `Delete API key for this profile`.

### Troubleshooting

`claude` cannot be found:

```zsh
which claude
```

Make sure Claude Code is installed and that the `claude` command can run directly.

Authentication fails:

```zsh
claude-mimo status
```

Check whether the API key exists and whether the Base URL matches the one shown in the MiMo console.

Base URL cannot be parsed:

```zsh
claude-mimo config --profile default --auto-base-url
```

Or reopen the configuration menu and choose a clean Base URL.
