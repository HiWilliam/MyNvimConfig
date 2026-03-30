-- open the file at last position
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = { "*" },
	callback = function()
		if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
			vim.cmd("normal! g'\"", false)
		end
	end,
})

--set quickfix and location_list when open the file
vim.api.nvim_create_autocmd("DiagnosticChanged", {
	pattern = { "*" },
	callback = function()
		local opt = {
			open = false,
		}
		vim.diagnostic.setqflist(opt)
		vim.diagnostic.setloclist(opt)
	end,
})

-- 启动kratos服务
vim.api.nvim_create_user_command("GoRunServer", function()
	local term = require("toggleterm")
	local path = vim.trim(vim.fn.system("git rev-parse --show-toplevel"))
	local basename = vim.fn.fnamemodify(path, ":t")
	local output = string.format("%s/build/%s", path, basename)
	local project = string.format("%s/cmd/%s", basename, basename)
	local command =
		string.format("TermExec cmd='go build -gcflags=\"all=-N -l\" -o  %s %s' direction='float'", output, project)
	term.exec_command(command, 3)
	local run_command = string.format("TermExec cmd='%s -conf %s/configs/config*.yaml' direction='float'", output, path)
	term.exec_command(run_command, 3)
end, {})

local dap = require("dap")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

-- 停止当前项目的运行进程
vim.api.nvim_create_user_command("GoStopServer", function()
	--	local term = require("toggleterm")
	--	term.exec_command("TermExec cmd='pgrep -f $(git rev-parse --show-toplevel | xargs basename) |xargs kill -9'", 3)
	local basename = vim.trim(vim.fn.system("git rev-parse --show-toplevel | xargs basename"))
	local handle = io.popen(string.format("pgrep -af %s | grep -v pgrep", basename))
	if handle == nil then
		vim.notify(string.format("暂无%s项目进程", basename), vim.log.levels.INFO)
		return
	end
	local processes = {}
	for line in handle:lines() do
		local pid, cmd = line:match("^(%d+)%s+(.*)$")
		if pid and cmd then
			table.insert(processes, {
				pid = pid,
				display = string.format("PID: %-6s CMD: %s", pid, cmd),
			})
		end
	end
	handle:close()

	pickers
		.new({}, {
			prompt_title = "Pick And Stop",
			finder = finders.new_table({
				results = processes,
				entry_maker = function(entry)
					return {
						value = entry.pid,
						display = entry.display,
						ordinal = entry.display,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(_, map)
				map("i", "<CR>", function(prompt_bufnr)
					local selection = require("telescope.actions.state").get_selected_entry()
					require("telescope.actions").close(prompt_bufnr)
					local ok, output = pcall(vim.fn.system, string.format("kill -9 %d", tonumber(selection.value)))
					if not ok then
						print(output)
					end
				end)
				return true
			end,
		})
		:find()
end, {})

--- 使用 Telescope 选择 Go 进程并 Attach 调试
local function telescope_pick_go_process()
	-- 获取当前项目名称作为过滤条件
	local project_name = vim.trim(vim.fn.system("git rev-parse --show-toplevel 2>/dev/null | xargs basename 2>/dev/null"))

	-- 构建进程列表命令
	local cmd
	if project_name ~= "" then
		-- 优先显示当前项目相关的进程
		cmd = string.format("pgrep -af '%s' | grep -v 'pgrep\\|grep'", project_name)
	else
		-- 显示所有 Go 相关进程
		cmd = "ps aux | grep -E '\\.go$|go run|go build|main$' | grep -v grep"
	end

	local handle = io.popen(cmd)
	if handle == nil then
		vim.notify("无法获取进程列表", vim.log.levels.WARN)
		return
	end

	local processes = {}
	for line in handle:lines() do
		local pid, cmd_str = line:match("^(%d+)%s+(.+)$")
		if pid and cmd_str then
			-- 截断过长的命令行
			local display_cmd = cmd_str
			if #display_cmd > 80 then
				display_cmd = display_cmd:sub(1, 77) .. "..."
			end
			table.insert(processes, {
				pid = pid,
				cmd = cmd_str,
				display = string.format("PID: %-6s │ %s", pid, display_cmd),
			})
		end
	end
	handle:close()

	if #processes == 0 then
		vim.notify("没有找到可调试的 Go 进程", vim.log.levels.INFO)
		return
	end

	pickers
		.new({}, {
			prompt_title = "Attach to Go Process",
			finder = finders.new_table({
				results = processes,
				entry_maker = function(entry)
					return {
						value = entry.pid,
						display = entry.display,
						ordinal = entry.display,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(_, map)
				map("i", "<CR>", function(prompt_bufnr)
					local selection = require("telescope.actions.state").get_selected_entry()
					require("telescope.actions").close(prompt_bufnr)
					dap.run({
						name = "Attach to Process",
						type = "go",
						request = "attach",
						mode = "local",
						processId = tonumber(selection.value),
						showLog = true,
						trace = "verbose",
						dlvFlags = { "--check-go-version=false" },
					})
				end)
				return true
			end,
		})
		:find()
end

-- 注册命令
vim.api.nvim_create_user_command("GoDebugAttach", telescope_pick_go_process, { desc = "Attach to Go Process" })

-- 绑定快捷键
vim.keymap.set("n", "<leader>dA", telescope_pick_go_process, { desc = "Attach to Go Process", nowait = true })

vim.api.nvim_create_autocmd("TermEnter", {
	callback = function()
		-- If the terminal window is lazygit, we do not make changes to avoid clashes
		if string.find(vim.api.nvim_buf_get_name(0), "lazygit") then
			pcall(vim.api.nvim_del_keymap, "t", "<esc>")
		else
			vim.api.nvim_set_keymap("t", "<esc>", "<C-\\><C-n>", { silent = true, noremap = true })
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "Outline",
	callback = function(args)
		vim.bo[args.buf].buftype = "nofile" -- 非文件缓冲区
		vim.bo[args.buf].modifiable = false -- 不可修改
		vim.bo[args.buf].swapfile = false -- 禁止交换文件
		vim.bo[args.buf].bufhidden = "wipe" -- 关闭时自动清除
	end,
})
