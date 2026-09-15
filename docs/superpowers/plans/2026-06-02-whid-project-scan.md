# whid 按项目加载 + TODO 扫描功能 实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 为 whid 插件增加按 git 项目自动加载独立 JSON 文件和 git grep 扫描代码 TODO 注释的功能。

**Architecture:** 新增 `scanner.lua` 模块负责 git grep 扫描和解析；修改 `todo.lua` 的 setup 自动检测项目并加载对应 JSON，load 函数增加扫描区分区域渲染；修改 `window.lua` 注册高亮组；修改 `init.lua` 新增键位。

**Tech Stack:** Lua, Neovim API, git grep, vim.json

---

## 文件结构

| 文件 | 职责 | 变更类型 |
|------|------|---------|
| `lua/whid/scanner.lua` | git grep 扫描 + 解析 + 去重 | 新建 |
| `lua/whid/todo.lua` | setup 自动检测项目、load 分区渲染、新增 si/sa/sg/sr 操作 | 修改 |
| `lua/whid/common/window.lua` | 注册 WhidSection/WhidScanItem/WhidScanMarker 高亮组 | 修改 |
| `lua/whid/init.lua` | 新增 si/sa/sg/sr 键位 | 修改 |
| `lua/plugins/test.lua` | 简化配置为 setup({}) | 修改 |

所有文件基路径：`/home/wuhao/.local/share/nvim/lazy/whid/`，test.lua 除外：`/home/wuhao/.config/nvim/`

---

### Task 1: 新建 scanner.lua — git grep 扫描模块

**Files:**
- Create: `/home/wuhao/.local/share/nvim/lazy/whid/lua/whid/scanner.lua`

- [ ] **Step 1: 创建 scanner.lua 完整实现**

```lua
local M = {}

-- 扫描项目中的 TODO 注释
-- @param project_root string: git 项目根路径
-- @param existing_tasks table: 已有任务列表，用于去重
-- @return table: {{ file, line, text }}
function M.scan(project_root, existing_tasks)
	local cmd = string.format("git -C %s grep -n --untracked -e TODO", vim.fn.shellescape(project_root))
	local output = vim.fn.system(cmd)

	if vim.v.shell_error ~= 0 or output == "" then
		return {}
	end

	-- 构建已有任务的 title 集合，用于去重
	local existing_titles = {}
	for _, task in ipairs(existing_tasks) do
		if task.title then
			existing_titles[task.title] = true
		end
	end

	local results = {}
	for line_str in output:gmatch("[^\r\n]+") do
		local file, linenum, content = line_str:match("^(.-):(%d+):(.+)$")
		if file and linenum and content then
			-- 提取 TODO 文本，去除各种前缀变体
			local text = content
			text = text:gsub("^[/%-#]%s*TODO[%s：:]*", "")
			text = text:gsub("^TODO[%s：:]*", "")
			text = text:gsub("^%s+", "")
			text = text:gsub("%s+$", "")

			if text ~= "" and not existing_titles[text] then
				table.insert(results, {
					file = file,
					line = tonumber(linenum),
					text = text,
				})
			end
		end
	end

	return results
end

return M
```

- [ ] **Step 2: 提交**

```bash
cd /home/wuhao/.local/share/nvim/lazy/whid
git add lua/whid/scanner.lua
git commit -m "feat: 新建 scanner 模块，git grep 扫描项目 TODO 注释"
```

---

### Task 2: 修改 todo.lua — setup 自动检测项目

**Files:**
- Modify: `/home/wuhao/.local/share/nvim/lazy/whid/lua/whid/todo.lua`

当前 `M.setup` 函数（约第 274-287 行）：

```lua
function M.setup(cfg)
	if type(cfg) ~= "table" then
		cfg = {}
	end
	M.save_file = cfg.save_file or "./.vscode/todo.md"
	json.load_all(M.save_file)

	is_preview = false
	history = {}

	win.open("markdown", "TODO List")
	M.load()
	win.init_cursor(2)
end
```

- [ ] **Step 1: 在文件顶部添加 scanner 引用和模块变量**

在 `local select = require("whid.common.popmenu")` 之后添加：

```lua
local scanner = require("whid.scanner")
```

在 `local history = {}` 之后添加：

```lua
M.project_root = ""
M.project_name = ""
M.scan_results = {}
```

- [ ] **Step 2: 添加项目检测函数**

在 `M.project_name = ""` 之后，`MAX_HISTORY` 之前添加：

```lua
local function detect_project()
	local root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
	if vim.v.shell_error ~= 0 or root == "" then
		return "", "default"
	end
	local name = vim.fn.fnamemodify(root, ":t")
	return root, name
end
```

- [ ] **Step 3: 重写 M.setup 函数**

替换整个 `M.setup` 函数：

```lua
function M.setup(cfg)
	if type(cfg) ~= "table" then
		cfg = {}
	end

	-- 自动检测 git 项目
	M.project_root, M.project_name = detect_project()

	-- 确定 save_file 路径
	local whid_dir = vim.fn.expand("~/.local/share/whid")
	if cfg.save_file then
		M.save_file = cfg.save_file
	else
		vim.fn.mkdir(whid_dir, "p")
		M.save_file = whid_dir .. "/" .. M.project_name .. ".json"
	end

	json.load_all(M.save_file)

	is_preview = false
	history = {}
	M.scan_results = {}

	-- 自动扫描 TODO
	if M.project_root ~= "" then
		M.scan_results = scanner.scan(M.project_root, json.tasks)
	end

	win.open("markdown", "TODO List")
	M.load()
	win.init_cursor(2)
end
```

- [ ] **Step 4: 提交**

```bash
cd /home/wuhao/.local/share/nvim/lazy/whid
git add lua/whid/todo.lua
git commit -m "feat: setup 自动检测 git 项目，加载对应 JSON，自动扫描 TODO"
```

---

### Task 3: 修改 window.lua — 注册高亮组

**Files:**
- Modify: `/home/wuhao/.local/share/nvim/lazy/whid/lua/whid/common/window.lua`

当前 `M.open` 函数（约第 10-36 行）在创建窗口后设置了 buf 选项。需要在设置选项之后、return 之前注册高亮组。

- [ ] **Step 1: 在 M.open 函数末尾（return 之前）添加高亮组注册**

在 `api.nvim_buf_set_option(buf, "undolevels", -1)` 之后，`return` 之前添加：

```lua
	-- 注册高亮组
	vim.api.nvim_command("highlight default WhidSection ctermfg=8 guifg=#6c7086")
	vim.api.nvim_command("highlight default WhidScanItem ctermfg=12 guifg=#89b4fa")
	vim.api.nvim_command("highlight default WhidScanMarker ctermfg=11 guifg=#f9e2af")
```

- [ ] **Step 2: 提交**

```bash
cd /home/wuhao/.local/share/nvim/lazy/whid
git add lua/whid/common/window.lua
git commit -m "feat: 注册 WhidSection/WhidScanItem/WhidScanMarker 高亮组"
```

---

### Task 4: 修改 todo.lua — load 分区域渲染

**Files:**
- Modify: `/home/wuhao/.local/share/nvim/lazy/whid/lua/whid/todo.lua`

当前 `M.load` 函数（约第 80-107 行）只渲染手动任务。需要追加扫描区渲染。

当前 `M.load` 函数完整内容：

```lua
function M.load()
	local lines = {}
	local icon = {}
	for i, task in ipairs(json.tasks) do
		if task.is_deleted then
			table.insert(lines, string.format(line_format, symbols.trash.code, i, task.module, task.title))
			table.insert(icon, { task.labels or { symbols.blu_circle.name } })
		else
			if task.status == "checked" then
				table.insert(lines, string.format(line_format, symbols.check.code, i, task.module, task.title))
			elseif task.status == "canceled" then
				table.insert(lines, string.format(line_format, symbols.cancel.code, i, task.module, task.title))
			else
				table.insert(lines, string.format(line_format, symbols.uncheck.code, i, task.module, task.title))
			end
			table.insert(icon, { task.labels or { symbols.blu_circle.name } })
		end
	end
	win.set_lines(lines)
	win.set_all_right_icons(icon)
end
```

- [ ] **Step 1: 重写 M.load 函数，增加扫描区渲染**

替换整个 `M.load` 函数：

```lua
function M.load()
	local lines = {}
	local icon = {}
	for i, task in ipairs(json.tasks) do
		if task.is_deleted then
			table.insert(lines, string.format(line_format, symbols.trash.code, i, task.module, task.title))
			table.insert(icon, { task.labels or { symbols.blu_circle.name } })
		else
			if task.status == "checked" then
				table.insert(lines, string.format(line_format, symbols.check.code, i, task.module, task.title))
			elseif task.status == "canceled" then
				table.insert(lines, string.format(line_format, symbols.cancel.code, i, task.module, task.title))
			else
				table.insert(lines, string.format(line_format, symbols.uncheck.code, i, task.module, task.title))
			end
			table.insert(icon, { task.labels or { symbols.blu_circle.name } })
		end
	end

	-- 渲染扫描区
	if #M.scan_results > 0 then
		local scan_count = #M.scan_results
		table.insert(lines, string.format("══ 扫描发现 (%d) ══", scan_count))
		table.insert(icon, {})

		for i, item in ipairs(M.scan_results) do
			local seq = #json.tasks + i
			table.insert(lines, string.format("  ◌ %d %s:%d %s", seq, item.file, item.line, item.text))
			table.insert(icon, { "📌" })
		end
	end

	win.set_lines(lines)
	win.set_all_right_icons(icon)

	-- 设置高亮
	local buf = vim.api.nvim_get_current_buf()
	local ns = vim.api.nvim_create_namespace("whid_highlight")
	vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

	if #M.scan_results > 0 then
		local section_line = #json.tasks
		vim.api.nvim_buf_add_highlight(buf, ns, "WhidSection", section_line, 0, -1)

		for i = 1, #M.scan_results do
			vim.api.nvim_buf_add_highlight(buf, ns, "WhidScanItem", section_line + i, 0, -1)
		end
	end
end
```

- [ ] **Step 2: 添加 is_scan_area 辅助函数**

在 `M.load` 函数之后添加：

```lua
function M.is_scan_area()
	local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
	local manual_end = #json.tasks + 1 -- +1 是标题行偏移（窗口第1行是标题）
	local scan_start = manual_end + 1 -- 分隔行
	return cursor_line > scan_start
end
```

注意：窗口中第 1 行是标题行 "TODO List"，手动任务从第 2 行开始，所以手动任务区行号 = 任务索引 + 1。manual_end = #json.tasks + 1 表示手动任务区最后一行。scan_start = manual_end + 1 是分隔行，扫描项从 scan_start + 1 开始。

- [ ] **Step 3: 提交**

```bash
cd /home/wuhao/.local/share/nvim/lazy/whid
git add lua/whid/todo.lua
git commit -m "feat: load 函数增加扫描区分区域渲染和高亮"
```

---

### Task 5: 修改 todo.lua — 新增 si/sa/sg/sr 操作

**Files:**
- Modify: `/home/wuhao/.local/share/nvim/lazy/whid/lua/whid/todo.lua`

- [ ] **Step 1: 添加 scan_import 函数（si — 导入当前扫描项）**

在文件末尾 `return M` 之前添加：

```lua
function M.scan_import()
	if not M.is_scan_area() then
		vim.notify("请在扫描区域使用此操作", vim.log.levels.WARN)
		return
	end

	local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
	local manual_end = #json.tasks + 1
	local scan_index = cursor_line - manual_end - 1 -- -1 是分隔行偏移

	if scan_index < 1 or scan_index > #M.scan_results then
		return
	end

	local item = M.scan_results[scan_index]
	push_history()

	local task = {
		module = vim.fn.fnamemodify(item.file, ":t:r"),
		title = item.text,
		content = string.format("%s:%d", item.file, item.line),
		status = "unchecked",
		labels = {},
		is_deleted = false,
	}
	table.insert(json.tasks, task)

	-- 重新扫描（去重会排除刚导入的）
	if M.project_root ~= "" then
		M.scan_results = scanner.scan(M.project_root, json.tasks)
	end

	M.load()
	vim.notify(string.format("已导入: %s", item.text), vim.log.levels.INFO)
end
```

- [ ] **Step 2: 添加 scan_import_all 函数（sa — 导入所有扫描项）**

```lua
function M.scan_import_all()
	if #M.scan_results == 0 then
		vim.notify("没有可导入的扫描项", vim.log.levels.WARN)
		return
	end

	push_history()

	for _, item in ipairs(M.scan_results) do
		local task = {
			module = vim.fn.fnamemodify(item.file, ":t:r"),
			title = item.text,
			content = string.format("%s:%d", item.file, item.line),
			status = "unchecked",
			labels = {},
			is_deleted = false,
		}
		table.insert(json.tasks, task)
	end

	vim.notify(string.format("已导入 %d 个扫描项", #M.scan_results), vim.log.levels.INFO)
	M.scan_results = {}
	M.load()
end
```

- [ ] **Step 3: 添加 scan_goto_source 函数（sg — 查看源码）**

```lua
function M.scan_goto_source()
	if not M.is_scan_area() then
		vim.notify("请在扫描区域使用此操作", vim.log.levels.WARN)
		return
	end

	local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
	local manual_end = #json.tasks + 1
	local scan_index = cursor_line - manual_end - 1

	if scan_index < 1 or scan_index > #M.scan_results then
		return
	end

	local item = M.scan_results[scan_index]
	local filepath = M.project_root .. "/" .. item.file

	-- 关闭 TodoList 窗口
	vim.api.nvim_win_close(0, true)

	-- 打开源文件并跳转到对应行
	vim.api.nvim_command(string.format("edit +%d %s", item.line, vim.fn.fnameescape(filepath)))
end
```

- [ ] **Step 4: 添加 scan_refresh 函数（sr — 重新扫描）**

```lua
function M.scan_refresh()
	if M.project_root == "" then
		vim.notify("当前不在 git 项目中", vim.log.levels.WARN)
		return
	end

	M.scan_results = scanner.scan(M.project_root, json.tasks)
	M.load()
	vim.notify(string.format("扫描完成，发现 %d 个 TODO", #M.scan_results), vim.log.levels.INFO)
end
```

- [ ] **Step 5: 提交**

```bash
cd /home/wuhao/.local/share/nvim/lazy/whid
git add lua/whid/todo.lua
git commit -m "feat: 新增 si/sa/sg/sr 扫描操作函数"
```

---

### Task 6: 修改 init.lua — 新增键位绑定

**Files:**
- Modify: `/home/wuhao/.local/share/nvim/lazy/whid/lua/whid/init.lua`

当前 `todo_maps` 表（约第 12-33 行）：

```lua
local todo_maps = {
	{ "n", "i", todo.input, { desc = "Insert a new TODO" } },
	{ "n", "o", todo.input_after, { desc = "Insert a new TODO after current line" } },
	{ "n", "O", todo.input_before, { desc = "Insert a new TODO before current line" } },
	{ "n", "w", todo.save, { desc = "Save the todo list" } },
	{ "n", "r", todo.reload, { desc = "Reload the todo list" } },
	{ "n", "ds", todo.toggle_delete, { desc = "Toggle soft delete" } },
	{ "n", "dd", todo.physical_delete, { desc = "Physical delete TODO" } },
	{ "n", "ct", todo.update_title, { desc = "Update TODO title" } },
	{ "n", "cm", todo.update_module, { desc = "Update TODO module" } },
	{ "n", "ms", todo.mark_status, { desc = "Mark TODO status" } },
	{ "n", "ml", todo.mark_label, { desc = "Mark TODO label" } },
	{ "n", "u", todo.undo, { desc = "Undo last action" } },
	{ "n", "p", todo.preview, { desc = "Toggle preview" } },
	{ "n", "g", todo.goto, { desc = "跳转到指定任务" } },
	{ "n", "q", todo.close, { desc = "Close window" } },
	{ "n", "<C-h>", function() end, { desc = "Disabled" } },
	{ "n", "<C-j>", function() end, { desc = "Disabled" } },
	{ "n", "<C-k>", function() end, { desc = "Disabled" } },
	{ "n", "<C-l>", function() end, { desc = "Disabled" } },
}
```

- [ ] **Step 1: 在 todo_maps 表末尾（`<C-l>` 之后）添加扫描相关键位**

在 `{ "n", "<C-l>", function() end, { desc = "Disabled" } },` 之后、`}` 之前添加：

```lua
	{ "n", "si", todo.scan_import, { desc = "导入当前扫描项" } },
	{ "n", "sa", todo.scan_import_all, { desc = "导入所有扫描项" } },
	{ "n", "sg", todo.scan_goto_source, { desc = "查看扫描项源码" } },
	{ "n", "sr", todo.scan_refresh, { desc = "重新扫描 TODO" } },
```

- [ ] **Step 2: 提交**

```bash
cd /home/wuhao/.local/share/nvim/lazy/whid
git add lua/whid/init.lua
git commit -m "feat: 新增 si/sa/sg/sr 扫描键位绑定"
```

---

### Task 7: 简化 test.lua 配置

**Files:**
- Modify: `/home/wuhao/.config/nvim/lua/plugins/test.lua`

当前内容：

```lua
return {
	"HiWilliam/whid",
	config = function()
		require("whid").setup({
			save_file = "/wuhao/workspace/default.json"
		})
	end,
}
```

- [ ] **Step 1: 简化配置为自动检测**

替换整个文件内容：

```lua
return {
	"HiWilliam/whid",
	config = function()
		require("whid").setup({})
	end,
}
```

- [ ] **Step 2: 提交**

```bash
cd /home/wuhao/.config/nvim
git add lua/plugins/test.lua
git commit -m "refactor: 简化 whid 配置为自动检测项目"
```
