# whid 插件：按项目加载 + TODO 扫描功能设计

## 概述

为 whid todo 插件增加两个核心功能：
1. **按 git 项目自动加载独立 JSON 文件** — 打开 TodoList 时自动检测当前 git 项目，加载对应项目的任务列表
2. **代码 TODO 注释扫描** — 用 git grep 扫描项目代码中的 TODO 注释，分区域展示，可选择性导入为手动任务

## 功能 1：按项目自动加载

### 数据存储

- 路径：`~/.local/share/whid/<project_name>.json`
- `project_name` 由 `git rev-parse --show-toplevel | xargs basename` 获取
- 文件不存在时自动创建空 JSON 数组（`[]`），与现有格式一致
- 项目根路径存为模块变量 `M.project_root`，供 scanner 使用

### 配置接口

```lua
require("whid").setup({})  -- 自动检测项目，零配置
```

保留 `save_file` 参数覆盖能力（用于调试或非 git 项目）：

```lua
require("whid").setup({ save_file = "/path/to/custom.json" })
```

### 行为

1. 调用 `setup` 时检测 git 项目
2. 非 git 项目：回退到默认路径 `~/.local/share/whid/default.json`
3. 获取项目名后拼接 `~/.local/share/whid/<name>.json` 作为 save_file
4. 确保 `~/.local/share/whid/` 目录存在（首次时 mkdir）

## 功能 2：TODO 扫描器

### 新模块：`lua/whid/scanner.lua`

#### 扫描方式

使用 `git grep -n --untracked -e "TODO"` 在项目根路径下扫描。

参数说明：
- `-n`：显示行号
- `--untracked`：包含未跟踪文件（新文件中的 TODO 也能发现）
- `-e "TODO"`：只扫描 TODO 关键词

#### 输出解析

git grep 输出格式：`<file>:<line>:<content>`

解析规则：
1. 按换行分割
2. 按 `:` 分割第一段为文件路径、第二段为行号、剩余为内容
3. 提取 TODO 文本：去除 `// TODO:`、`//TODO:`、`# TODO:`、`-- TODO:`、`// TODO：`、`--TODO：` 等前缀变体
4. 去除首尾空白

#### 返回结构

```lua
{
    { file = "lua/whid/todo.lua", line = 42, text = "修复撤销逻辑" },
    { file = "lua/whid/init.lua", line = 15, text = "移除自动setup" },
}
```

#### 去重逻辑

扫描结果与 `json.tasks` 中的已有任务按 `text` 字段匹配去重：
- 遍历扫描结果，检查 text 是否已存在于 json.tasks 的 title 中
- 已存在的跳过，只展示新增的扫描项

#### 模块接口

```lua
local scanner = {}

-- 扫描项目 TODO，返回过滤后的列表
function scanner.scan(project_root, existing_tasks) -> { { file, line, text } }

return scanner
```

#### 扫描触发

- 打开 TodoList 时自动扫描一次
- 按 `sr` 手动重新扫描

## 渲染：分区域展示

### 渲染结构

```
  ══ 手动任务 (2) ════════════════
  ☐ 1 [whid] 修复 goto 函数       🔵
  ☐ 2 [whid] 添加按项目加载功能    🔴
  ══ 扫描发现 (3) ════════════════
  ◌ 3 todo.lua:42 修复撤销逻辑     📌
  ◌ 4 init.lua:15 移除自动setup    📌
  ◌ 5 symbols.lua:8 添加新符号     📌
```

### 实现方式

1. `load()` 渲染手动任务区（现有逻辑不变）
2. 追加分隔行：`══ 扫描发现 (N) ══`
3. 追加扫描结果行：`◌ <序号> <file>:<line> <text>`
4. 扫描结果行的序号是连续编号（接手动任务区最后一个序号）

### 高亮组

| 高亮组 | 用途 | 颜色 |
|--------|------|------|
| `WhidSection` | 分隔行 | 特殊色（如 Comment 的淡色） |
| `WhidScanItem` | 扫描结果行文本 | 次要色 |
| `WhidScanMarker` | 扫描项符号 📌 | 次要高亮色 |

在 `window.lua` 的 `open` 函数中注册高亮组。

### 光标区域判断

需要判断当前光标位于手动区还是扫描区：

- `manual_end_line`：手动任务区的最后一行行号（= #json.tasks + 1，1 是标题行偏移）
- `scan_start_line`：扫描区起始行号（= manual_end_line + 1，分隔行）
- 光标行号 <= manual_end_line → 手动区
- 光标行号 > scan_start_line → 扫描区

新增辅助函数 `M.is_scan_area()` 返回布尔值。

### 操作分区

| 操作 | 手动区 | 扫描区 |
|------|--------|--------|
| `i/o/O` 插入 | 可用 | 忽略，提示先导入 |
| `w` 保存 | 可用 | 可用（保存手动任务） |
| `r` 重载 | 可用 | 可用（重载 + 重新扫描） |
| `ds/dd` 删除 | 可用 | 忽略 |
| `ct/cm` 编辑 | 可用 | 忽略 |
| `ms/ml` 标记 | 可用 | 忽略 |
| `u` 撤销 | 可用 | 忽略 |
| `p` 预览 | 可用 | 可用（预览 TODO 上下文） |
| `g` 跳转 | 可用（跳转到序号） | 可用（跳转到源文件） |
| `si` 导入 | 不可用 | 可用（导入当前扫描项） |
| `sa` 全部导入 | 可用 | 可用 |
| `sg` 查看源码 | 不可用 | 可用（打开源文件跳转行号） |
| `sr` 重新扫描 | 可用 | 可用 |

### 导入操作 `si`

1. 获取当前光标行的扫描项数据
2. 创建 task：`{ module = 文件名, title = TODO文本, content = "文件:行号", status = "unchecked", labels = {}, is_deleted = false }`
3. push_history + 插入 json.tasks
4. 重新渲染（load + scan 展示）

### 全部导入 `sa`

遍历所有扫描项，逐个创建 task 插入 json.tasks，一次渲染。

### 查看源码 `sg`

用 `vim.api.nvim_command("edit +<line> <file>")` 在新 buffer 打开源文件并跳转到对应行。先关闭 TodoList 窗口。

## 新增 Keymap

| 按键 | 功能 |
|------|------|
| `si` | 导入当前扫描项为手动任务 |
| `sa` | 导入所有扫描项 |
| `sg` | 查看扫描项源码（打开文件跳转行号） |
| `sr` | 重新扫描项目 TODO |

## 修改的文件清单

| 文件 | 变更 |
|------|------|
| `lua/whid/scanner.lua` | 新建 — git grep 扫描 + 解析 + 去重 |
| `lua/whid/todo.lua` | 修改 — setup 自动检测项目、load 增加扫描区渲染、新增 si/sa/sg/sr 操作、is_scan_area 判断 |
| `lua/whid/common/window.lua` | 修改 — 注册高亮组 WhidSection/WhidScanItem/WhidScanMarker |
| `lua/whid/init.lua` | 修改 — 新增 keymap（si/sa/sg/sr） |
| `lua/plugins/test.lua` | 修改 — 简化配置为 `setup({})` |
