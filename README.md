### NeoVim配置步骤
1. 插件管理工具
2. 文件书插件
3. 全局搜索插件，支持文件、关键词、历史记录等搜索功能
4. LSP插件
5. 代码补全/联想
6. 语法高亮/全局主题
7. 其他插件，例如lualine、comment等

### 待优化的配置
1. 目前代码高亮颜色还不是很满意，暂时用了tokyonight主题。
2. "[["和"]]"不能返回到方法块的开始和结尾，而是文件的首行和尾行- 已解决 nvim-treesitter的move配置
3. 命令模式输入是命令行支持补全-已解决 cmp+cmp_cmdline插件
4. 背景透明-设置Iterm的背景图，tokyonight主题设置transparent,详见others.lua。也可以设置hightlight，不过实现比较麻烦
5. 要想使用nvim-web-devicons，需要use，只require不会被加载
6. telescope git_commit的preview改成改动的文件列表，而不是默认改动差距
7. 某些文件在nvim-tree中会有下划线
8. 批量注释、批量取消注释
