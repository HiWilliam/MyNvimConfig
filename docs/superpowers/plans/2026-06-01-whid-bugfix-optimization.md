# whid 插件 Bug 修复与核心优化 实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 修复 whid todo 插件的所有已知 Bug，并优化撤销机制、goto 函数、标签多选和序号偏移问题。

**Architecture:** 直接修改 `/home/wuhao/.local/share/nvim/lazy/whid/` 下的插件源码和 `/home/wuhao/.config/nvim/lua/plugins/test.lua` 配置文件。修复后需要在 Neovim 中手动验证。

**Tech Stack:** Lua, Neovim API, vim.json

---

### Task 1: 修复 init.lua 双重 setup 调用

**Files:**
- Modify: `/home/wuhao/.local/share/nvim/lazy/whid/lua/whid/init.lua:38-53`

**问题:** 模块加载时 `M.setup()` 无参调用，导致使用默认路径；lazy.nvim config 中再次调用 `setup({save_file=...})`，setup 被执行两次。

- [ ] **Step 1: 移除模块末尾的自动 setup 调用**

将 `init.lua` 最后的 `M.setup()` 删除，让 setup 只通过 lazy.nvim config 显式调用一次。

修改前:
```lua
-- Automatically call setup when required
M.setup()

return M
```

修改后:
```lua
return M
```

- [ ] **Step 2: 调整 setup 函数，防止重复调用**

在 `setup` 函数开头添加保护，防止重复注册命令。

修改前:
```lua
function M.setup(cfg)
    vim.api.nvim_create_user_command("TodoList", function()
        todo.setup({
            save_file = cfg.save_file or "/root/todos/default.md",
        })
        km.set(todo_maps)
    end, {})
    vim.api.nvim_create_user_command("TodoSwap", function(opts)
        todo.swap(opts.args)
    end, { nargs = 1 })
end
```

修改后:
```lua
local setup_done = false

function M.setup(cfg)
    if setup_done then
        return
    end
    setup_done = true

    vim.api.nvim_create_user_command("TodoList", function()
        todo.setup({
            save_file = cfg.save_file or "/root/todos/default.md",
        })
        km.set(todo_maps)
    end, {})
    vim.api.nvim_create_user_command("TodoSwap", function(opts)
        todo.swap(opts.args)
    end, { nargs = 1 })
end
```

- [ ] **Step 3: 提交**

```bash
cd /home/wuhao/.local/share/nvim/lazy/whid
git add lua/whid/init.lua
git commit -m "fix: 移除模块自动 setup 调用，防止双重初始化"
```

---

### Task 2: 修复 test.lua 拼写错误

**Files:**
- Modify: `/home/wuhao/.config/nvim/lua/plugins/test.lua:8`

**问题:** `/wuaho/workspace/default.json` 中 `wuaho` 应为 `wuhao`。

- [ ] **Step 1: 修正拼写**

修改前:
```lua
                save_file = "/wuaho/workspace/default.json"
```

修改后:
```lua
                save_file = "/wuhao/workspace/default.json"
```

- [ ] **Step 2: 提交**

```bash
cd /home/wuhao/.config/nvim
git add lua/plugins/test.lua
git commit -m "fix: 修正 whid save_file 路径拼写错误 wuaho -> wuhao"
```

---

### Task 3: 修复 todo.lua goto 函数中的 log.levels 拼写和 expr 返回值

**Files:**
- Modify: `/home/wuhao/.local/share/nvim/lazy/whid/lua/whid/todo.lua:259-300`

**问题:**
1. 第 293 行 `vim.log.level.ERROR` 应为 `vim.log.levels.ERROR`（少了个 s）
2. `goto` 设置了 `expr = true`，但超时无输入时没有返回值，会导致异常
3. 整个 goto 函数使用轮询方式阻塞 Neovim，体验差

- [ ] **Step 1: 重写 goto 函数，改用 vim.ui.input**

替换整个 `goto` 函数，使用 `vim.ui.input` 输入目标行号，非阻塞且无 expr 问题。

修改前:
```lua
function M.goto()
    local timeout = 500  -- 超时时间（毫秒）
    local start_time = vim.loop.now()
    local num_str = ""

    while (vim.loop.now() - start_time) < timeout do
        local char = vim.fn.getchar(0)  -- 非阻塞获取

        if char ~= 0 then  -- 有按键输入
            if type(char) == 'number' then
                char = string.char(char)
            end

            if char:match('%d') then
                num_str = num_str .. char  -- 追加数字
                start_time = vim.loop.now()  -- 重置超时计时
            else
                -- 遇到非数字键，返回原始功能
                return 'g' .. num_str .. char
            end
        else
            vim.wait(10)  -- 小延迟防止CPU占用过高
        end
    end

    if #num_str <= 0 then
        return
    end

    local target = tonumber(num_str)
    if not target then
        vim.notify("请输入数字类型", vim.log.level.ERROR)
        return
    end

    if target <= 0 or target > #json.tasks then
        vim.notify(string.format("参数范围为(0, %d]", #json.tasks), vim.log.levels.ERROR)
        return
    end

    win.move_cursor(target+1, 0)
end
```

修改后:
```lua
function M.goto()
    vim.ui.input({ prompt = "跳转到第几行: " }, function(input)
        if not input or input == "" then
            return
        end

        local target = tonumber(input)
        if not target then
            vim.notify("请输入数字类型", vim.log.levels.ERROR)
            return
        end

        if target <= 0 or target > #json.tasks then
            vim.notify(string.format("参数范围为(0, %d]", #json.tasks), vim.log.levels.ERROR)
            return
        end

        win.move_cursor(target + 1, 0)
    end)
end
```

- [ ] **Step 2: 修改 init.lua 中 goto 的键位定义，移除 expr**

修改前:
```lua
		{ "n", "g", todo.goto , { desc = "Toggle preview task detail", expr = true } },
```

修改后:
```lua
		{ "n", "g", todo.goto, { desc = "跳转到指定任务" } },
```

- [ ] **Step 3: 提交**

```bash
cd /home/wuhao/.local/share/nvim/lazy/whid
git add lua/whid/todo.lua lua/whid/init.lua
git commit -m "fix: 重写 goto 函数，使用 vim.ui.input 替代轮询，修复 log.levels 拼写和 expr 返回值问题"
```

---

### Task 4: 修复 json.lua decode 错误处理和 file.read 返回类型

**Files:**
- Modify: `/home/wuhao/.local/share/nvim/lazy/whid/lua/whid/utils/json.lua:27-36`
- Modify: `/home/wuhao/.local/share/nvim/lazy/whid/lua/whid/utils/file.lua:5-16`

**问题:**
1. `json.lua` 的 `load_all` 中 `vim.json.decode` 没有 pcall 保护，JSON 损坏会直接崩溃
2. `file.lua` 的 `read` 失败时返回 `false`，成功时返回 `string`，类型不一致

- [ ] **Step 1: 修复 file.read 返回类型**

修改前:
```lua
function M.read(filename)
	local f, err = io.open(filename, "r")
	if not f then
		vim.notify("Open file failed:" .. err)
		return false
	end

	local content = f:read("*a")
	f:close()

	return content
end
```

修改后:
```lua
function M.read(filename)
	local f, err = io.open(filename, "r")
	if not f then
		vim.notify("Open file failed:" .. err)
		return nil
	end

	local content = f:read("*a")
	f:close()

	return content
end
```

- [ ] **Step 2: 修复 json.lua load_all 添加 pcall 保护**

修改前:
```lua
function M.load_all(path)
	local content = file.read(path)
	if not content then
		print(string.format("Open Json File: %s failed", path))
		return
	end

	M.tasks = vim.json.decode(content)
end
```

修改后:
```lua
function M.load_all(path)
	local content = file.read(path)
	if not content then
		vim.notify(string.format("读取文件失败: %s", path), vim.log.levels.WARN)
		M.tasks = {}
		return
	end

	local ok, decoded = pcall(vim.json.decode, content)
	if not ok then
		vim.notify(string.format("JSON 解析失败: %s", decoded), vim.log.levels.ERROR)
		M.tasks = {}
		return
	end

	M.tasks = decoded
end
```

- [ ] **Step 3: 提交**

```bash
cd /home/wuhao/.local/share/nvim/lazy/whid
git add lua/whid/utils/json.lua lua/whid/utils/file.lua
git commit -m "fix: json decode 添加 pcall 保护，file.read 返回 nil 替代 false"
```

---

### Task 5: 修复撤销机制——buffer 与数据模型同步

**Files:**
- Modify: `/home/wuhao/.local/share/nvim/lazy/whid/lua/whid/todo.lua:233-237`

**问题:** 当前 `undo` 只调用 `vim.cmd("undo")` 撤销 buffer 内容，但 `json.tasks` 数据没有回滚，导致 buffer 和数据模型不一致。保存后数据会覆盖正确的状态。

- [ ] **Step 1: 实现操作历史栈替代 vim undo**

在 `todo.lua` 顶部添加历史栈，在每次修改 json.tasks 的操作前记录快照，undo 时恢复。

在 `todo.lua` 文件顶部（`local is_preview = false` 之后）添加:

```lua
local history = {}
local MAX_HISTORY = 50

local function snapshot()
    local copy = {}
    for i, task in ipairs(json.tasks) do
        copy[i] = vim.deepcopy(task)
    end
    return copy
end

local function push_history()
    if #history >= MAX_HISTORY then
        table.remove(history, 1)
    end
    table.insert(history, snapshot())
end
```

- [ ] **Step 2: 在所有修改 json.tasks 的操作前调用 push_history**

需要在以下函数中添加 `push_history()` 调用（在修改 json.tasks 之前）:

1. `M.input` — `table.insert(json.tasks, task)` 之前
2. `M.input_after` — `table.insert(json.tasks, index + 1, task)` 之前
3. `M.input_before` — `table.insert(json.tasks, index, task)` 之前
4. `M.update` — `json.tasks[index][key] = input` 之前
5. `M.mark_status` — `json.tasks[index].status = choice.name` 之前
6. `M.mark_label` — `json.tasks[index].labels = { choice.name }` 之前
7. `M.toggle_delete` — `task.is_deleted = not task.is_deleted` 之前
8. `M.pyhsical_delete` — `table.remove(json.tasks, index)` 之前
9. `M.swap` — `json.tasks[target], json.tasks[current] = ...` 之前

每个函数中，在第一条修改 `json.tasks` 的语句之前添加:
```lua
push_history()
```

- [ ] **Step 3: 重写 undo 函数**

修改前:
```lua
function M.undo()
	win.update_line(function()
		vim.cmd("undo")
	end)
end
```

修改后:
```lua
function M.undo()
	if #history == 0 then
		vim.notify("没有可撤销的操作", vim.log.levels.WARN)
		return
	end

	json.tasks = table.remove(history)
	M.load()
end
```

- [ ] **Step 4: 移除 window.lua 中不必要的 undolevels 设置**

修改 `/home/wuhao/.local/share/nvim/lazy/whid/lua/whid/common/window.lua:23`:

修改前:
```lua
	api.nvim_buf_set_option(buf, "undolevels", 1000)
```

修改后:
```lua
	api.nvim_buf_set_option(buf, "undolevels", -1)
```

设置 `undolevels = -1` 禁用 vim 内置 undo，因为现在用自定义历史栈管理。

- [ ] **Step 5: 提交**

```bash
cd /home/wuhao/.local/share/nvim/lazy/whid
git add lua/whid/todo.lua lua/whid/common/window.lua
git commit -m "feat: 用操作历史栈替代 vim undo，保证 buffer 与数据模型同步"
```

---

### Task 6: 修复任务序号偏移问题

**Files:**
- Modify: `/home/wuhao/.local/share/nvim/lazy/whid/lua/whid/todo.lua:38-56`

**问题:** `M.input` 函数中用 `vim.api.nvim_buf_line_count(0)` 获取行数作为任务序号，但窗口有标题行（第 0 行），导致序号与实际 task 索引不一致。

- [ ] **Step 1: 修复 input 函数的序号计算**

修改前:
```lua
function M.input()
	win.update_line(function()
		local task = getInput()
		if task == nil then
			return
		end
		local count = vim.api.nvim_buf_line_count(0)

		vim.api.nvim_buf_set_lines(
			0,
			-1,
			-1,
			false,
			{ string.format(line_format, symbols.uncheck.code, count, task.module, task.title) }
		)

		table.insert(json.tasks, task)
	end)
end
```

修改后:
```lua
function M.input()
	win.update_line(function()
		local task = getInput()
		if task == nil then
			return
		end
		push_history()
		local count = #json.tasks + 1

		vim.api.nvim_buf_set_lines(
			0,
			-1,
			-1,
			false,
			{ string.format(line_format, symbols.uncheck.code, count, task.module, task.title) }
		)

		table.insert(json.tasks, task)
	end)
end
```

用 `#json.tasks + 1` 替代 `vim.api.nvim_buf_line_count(0)`，确保序号与实际数据索引一致。

- [ ] **Step 2: 提交**

```bash
cd /home/wuhao/.local/share/nvim/lazy/whid
git add lua/whid/todo.lua
git commit -m "fix: 用 json.tasks 长度计算序号，修复标题行导致的序号偏移"
```

---

### Task 7: 标签支持多选（追加模式）

**Files:**
- Modify: `/home/wuhao/.local/share/nvim/lazy/whid/lua/whid/todo.lua:189-197`
- Modify: `/home/wuhao/.local/share/nvim/lazy/whid/lua/whid/common/popmenu.lua:23-38`

**问题:** `mark_label` 每次只设置一个标签，覆盖之前的标签。

- [ ] **Step 1: 修改 popmenu.lua 的 LabelSelect 支持追加模式**

修改前:
```lua
function M.LabelSelect(callback)
	local list = {}
	for _, v in pairs(symbols.get_labels()) do
		table.insert(list, symbols[v])
	end
	vim.ui.select(list, {
		prompt = "Choose an option:",
		format_item = function(item)
			return string.format("%s %s", item.name, item.code)
		end,
	}, function(choice)
		if choice then
			callback(choice)
		end
	end)
end
```

修改后:
```lua
function M.LabelSelect(callback)
	local list = {}
	for _, v in pairs(symbols.get_labels()) do
		table.insert(list, symbols[v])
	end
	-- 添加"追加"和"覆盖"选项
	table.insert(list, 1, { name = "append", code = "+", desc = "追加标签" })
	table.insert(list, 1, { name = "replace", code = "→", desc = "替换标签" })
	vim.ui.select(list, {
		prompt = "选择标签操作:",
		format_item = function(item)
			return string.format("%s %s", item.desc or item.name, item.code)
		end,
	}, function(choice)
		if not choice then
			return
		end

		-- 如果选的是操作类型，再弹出标签选择
		if choice.name == "append" or choice.name == "replace" then
			local labels = {}
			for _, v in pairs(symbols.get_labels()) do
				table.insert(labels, symbols[v])
			end
			vim.ui.select(labels, {
				prompt = "选择标签:",
				format_item = function(item)
					return string.format("%s %s", item.desc or item.name, item.code)
				end,
			}, function(label_choice)
				if label_choice then
					callback(label_choice, choice.name == "append")
				end
			end)
		else
			-- 直接选择了一个标签，默认替换
			callback(choice, false)
		end
	end)
end
```

- [ ] **Step 2: 修改 todo.lua 的 mark_label 函数支持追加模式**

修改前:
```lua
function M.mark_label()
	local index = vim.api.nvim_win_get_cursor(0)[1] - 1
	local task = json.tasks[index]
	select.LabelSelect(function(choice)
		win.update_line(function()
			win.set_right_icons(index, { choice.code })
		end)
		json.tasks[index].labels = { choice.name }
	end)
end
```

修改后:
```lua
function M.mark_label()
	local index = vim.api.nvim_win_get_cursor(0)[1] - 1
	local task = json.tasks[index]
	push_history()
	select.LabelSelect(function(choice, is_append)
		local labels
		if is_append then
			labels = vim.deepcopy(task.labels or { symbols.blu_circle.name })
			table.insert(labels, choice.name)
		else
			labels = { choice.name }
		end
		json.tasks[index].labels = labels
		win.update_line(function()
			local label_codes = symbols.get_labels_code(labels)
			win.set_right_icons(index, label_codes)
		end)
	end)
end
```

- [ ] **Step 3: 提交**

```bash
cd /home/wuhao/.local/share/nvim/lazy/whid
git add lua/whid/todo.lua lua/whid/common/popmenu.lua
git commit -m "feat: 标签支持追加模式，可选替换或追加标签"
```

---

### Task 8: 修复 is_preview 状态管理

**Files:**
- Modify: `/home/wuhao/.local/share/nvim/lazy/whid/lua/whid/todo.lua:10,79-94,302-312`

**问题:** `is_preview` 是模块级变量，窗口关闭后再打开状态可能残留。

- [ ] **Step 1: 在 setup 函数中重置 is_preview**

修改 `M.setup` 函数:

修改前:
```lua
function M.setup(cfg)
	if type(cfg) ~= "table" then
		cfg = {}
	end
	M.save_file = cfg.save_file or "./.vscode/todo.md"
	json.load_all(M.save_file)

	win.open("markdown", "TODO List")
	M.load()
	win.init_cursor(2)
end
```

修改后:
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

- [ ] **Step 2: 提交**

```bash
cd /home/wuhao/.local/share/nvim/lazy/whid
git add lua/whid/todo.lua
git commit -m "fix: setup 时重置 is_preview 和 history 状态"
```
