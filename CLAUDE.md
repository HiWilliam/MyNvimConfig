# CLAUDE.md

本文件为 Claude Code (claude.ai/code) 在此代码仓库中工作提供指导。

## 概述

这是一个使用 Lua 编写的 Neovim 配置仓库，采用 lazy.nvim 作为插件管理器。

## 项目结构

```
~/.config/nvim/
├── init.lua          # 入口文件，加载 lazy.nvim 和配置
├── lua/
│   ├── configs/      # Neovim 核心配置
│   │   ├── keymaps.lua   # 键位绑定 (leader 键 = 空格)
│   │   ├── options.lua   # 编辑器选项 (缩进、行号等)
│   │   ├── commands.lua  # 自定义命令 (GoRunServer、GoStopServer 等)
│   │   └── events.lua    # 自动命令和事件处理
│   ├── plugins/      # 插件配置 (由 lazy.nvim 加载)
│   │   ├── ai.lua        # Claude Code 集成
│   │   ├── lspconfigs.lua# LSP 配置 (Go、Lua、Python、Helm)
│   │   ├── completions.lua# blink.cmp 配置
│   │   ├── telescope.lua # 模糊搜索
│   │   ├── null_ls.lua   # 代码格式化 (gofmt、stylua)
│   │   └── ...
│   └── var/          # 变量和环境配置
└── lazy-lock.json   # 插件版本锁定文件
```

## 核心命令

- `GoRunServer` - 编译并运行 Go 服务端 (带调试参数)
- `GoStopServer` - 通过 Telescope 选择并终止 Go 进程
- `GoDebugAttach` - 附加调试器到运行中的 Go 进程

## Leader 键位绑定 (空格键)

- `<leader>a` - Telescope 主菜单
- `<leader>f` - 搜索文件
- `<leader>r` - 全局搜索
- `<leader>b` - 缓冲区列表
- `<leader>nh` - 清除搜索高亮
- `<leader>td` - 任务清单
- `<leader>ac` - 切换 Claude Code
- `<leader>aa` / `<leader>ad` - 接受/拒绝 Claude 的 diff
- `gi` / `gr` - LSP 实现/引用跳转
- `se` - 显示诊断悬浮窗
- `<C-h/j/k/l>` - tmux 窗口导航

## 架构设计

- **插件管理**: lazy.nvim，配置文件位于 `lua/plugins/`
- **LSP**: nvim-lspconfig + mason.nvim 管理语言服务器
- **代码补全**: blink.cmp (支持 LSP、代码片段、缓冲区)
- **代码格式化**: none-ls.nvim (gofmt、goimports、stylua)
- **主题**: Catppuccin
- **文件树**: NvimTree
- **Git 集成**: gitsigns.nvim、diffview.nvim
- **终端**: toggleterm.nvim

## Go 开发支持

配置包含完整的 Go 开发工具链:
- gopls LSP (支持语义高亮、智能补全)
- go.nvim 提供 IDE 功能
- nvim-dap + nvim-dap-go 支持调试
- 自定义命令运行/停止 Go 服务
- 支持附加到运行中的进程进行实时调试

## 编辑器选项

- 缩进：4 空格，自动展开
- 行号：相对行号 + 当前行号
- 搜索：忽略大小写 (smartcase)
- 折叠：手动折叠模式
- 剪贴板：OSC 52 (支持 SSH 远程)
