# Claude Code Use Model

一个很小的 Claude Code 启动器，用来把 `claude` 接到小米 MiMo 的 Anthropic-compatible API。

安装后你可以直接输入：

```zsh
claude-mimo
```

也可以输入：

```zsh
claude-mimo config
```

进入配置菜单，切换 API key、模型、Base URL 和不同 profile。

## 安装

```zsh
git clone git@github.com:DragonTAT/claude-code-use-model.git
cd claude-code-use-model
./install.sh
source ~/.zshrc
```

第一次使用前先配置：

```zsh
claude-mimo config
```

配置完成后启动：

```zsh
claude-mimo
```

## `claude-mimo config` 能做什么

运行：

```zsh
claude-mimo config
```

菜单里可以做这些事：

- `Switch/create profile`：切换或创建配置，比如 `default`、`work`、`personal`
- `Set/change API key`：给当前 profile 设置或更换 API key
- `Select model`：选择主模型，默认是 `mimo-v2.5-pro`
- `Select fast model`：选择轻量/快速模型，默认和主模型一致
- `Select Base URL`：选择 MiMo 的 API 地址
- `Delete API key for this profile`：删除当前 profile 的 API key
- `Show status`：查看当前配置

API key 默认存在 macOS Keychain，不会写进 Git 仓库。没有 Keychain 的环境会退回到本机配置目录里的私有 key 文件。

如果你之前已经用过旧版 `claude-mimo`，并且 key 存在 macOS Keychain 的 `mimo-api-key` 里，新版 `default` profile 会自动兼容读取它。之后你也可以在 `claude-mimo config` 里重新保存到新的 profile 配置。

## 多个 API key / 多个模型

这个工具用 `profile` 管理不同账号或不同模型配置。比如你可以建两个 profile：

- `work`：公司 API key，`mimo-v2.5-pro`
- `personal`：个人 API key，自定义模型或 Base URL

交互式切换：

```zsh
claude-mimo config
```

命令行切换：

```zsh
claude-mimo use work
claude-mimo status
claude-mimo
```

## 命令行配置

也可以不用菜单，直接配置：

```zsh
claude-mimo config --profile work --model mimo-v2.5-pro
claude-mimo config --profile work --api-key 'YOUR_MIMO_API_KEY'
claude-mimo config --profile work --base-url 'https://token-plan-sgp.xiaomimimo.com/anthropic'
```

如果想让工具按 API key 自动判断 Base URL：

```zsh
claude-mimo config --profile work --auto-base-url
```

不想把 key 留在 shell history 里，可以用：

```zsh
printf '%s' 'YOUR_MIMO_API_KEY' | claude-mimo config --profile work --api-key-stdin
```

## 常用命令

```zsh
claude-mimo              # 用当前 profile 启动 Claude Code
claude-mimo config       # 打开配置菜单
claude-mimo status       # 查看当前 profile、模型、Base URL、key 状态
claude-mimo profiles     # 查看所有 profile
claude-mimo use work     # 切换到 work profile
claude-mimo help         # 查看帮助
```

## Base URL 选择

配置菜单里内置了三个常见地址：

- Pay-as-you-go：`https://api.xiaomimimo.com/anthropic`
- Token plan Singapore：`https://token-plan-sgp.xiaomimimo.com/anthropic`
- Token plan China：`https://token-plan-cn.xiaomimimo.com/anthropic`

如果你在 MiMo 控制台看到的地址不一样，选择 `Custom Base URL`，然后粘贴控制台给你的地址。

## 迁移到新设备

新设备上只需要：

```zsh
git clone git@github.com:DragonTAT/claude-code-use-model.git
cd claude-code-use-model
./install.sh
source ~/.zshrc
claude-mimo config
```

然后在 `claude-mimo config` 里重新输入新设备要用的 API key。

不建议同步整个 `~/.claude`，因为里面可能有历史会话、项目记录和敏感信息。这个仓库只同步脚本和文档；API key 每台设备自己配置。

## 配置文件位置

默认配置目录：

```zsh
~/.config/claude-code-use-model
```

里面会有：

- `active_profile`：当前启用的 profile
- `profiles/*.env`：每个 profile 的模型和 Base URL
- `keys/*.key`：只有在 Keychain 不可用时才会使用的本机 key 文件

## 环境变量覆盖

临时覆盖当前配置：

```zsh
MIMO_MODEL=mimo-v2.5-pro claude-mimo
MIMO_BASE_URL=https://token-plan-cn.xiaomimimo.com/anthropic claude-mimo
MIMO_API_KEY=xxx claude-mimo
```

如果 `claude` 命令不在 PATH 里，可以指定：

```zsh
CLAUDE_BIN=/path/to/claude claude-mimo
```

## 排查

如果提示找不到 `claude`：

```zsh
which claude
```

确认 Claude Code 已安装，并且 `claude` 命令能直接运行。

如果请求报鉴权错误，优先检查：

```zsh
claude-mimo status
```

重点看 API key 是否存在、Base URL 是否和你的 MiMo 控制台一致。
