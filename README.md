
### NeoVim配置步骤
1. 插件管理工具
2. 文件树插件
3. 全局搜索插件，支持文件、关键词、历史记录等搜索功能
4. LSP插件 代码补全/联想
5. 语法高亮/全局主题
6. 其他插件，例如lualine、comment等

### 初始话步骤

1. 初始化基础环境
```shell

apt install ripgrep lua5.1 luarocks

apt install rustup

rustup default nightly
```

### 待优化的配置
1. 目前代码高亮颜色还不是很满意，暂时用了tokyonight主题。
2. 背景透明-设置Iterm的背景图，tokyonight主题设置transparent,详见others.lua。也可以设置hightlight，不过实现比较麻烦
3. 要想使用nvim-web-devicons，需要use，只require不会被加载
4. telescope git_commit的preview改成改动的文件列表，而不是默认改动差距
5. 某些文件在nvim-tree中会有下划线?
6. nvim in tmux 的ctrl + h/j/k/l 不可用
7. ray-x/go.nvim的集成开发环境，GoRun/GoStop使用不顺，GoRun可以自定用户名实现项目级别的自定义，但是启动后进程的统一停止待优化

### Solved
1. 代码联想时，刚打开文件的一段时间内或某个条件达成前，tab和方向键选择不可用。 -懒加载导致
2. 显示游标所在的document不可用 - lsp配置
3. "[["和"]]"不能返回到方法块的开始和结尾，而是文件的首行和尾行- 已解决 nvim-treesitter的move配置
4. 命令模式输入是命令行支持补全-已解决 cmp+cmp_cmdline插件

