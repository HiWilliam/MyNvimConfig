return {
	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		keys = {
			-- 基础调试操作
			{
				"<leader>dt",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
				nowait = true,
			},
			{
				"<leader>dT",
				function()
					require("dap").clear_breakpoints()
				end,
				desc = "Clear All Breakpoints",
				nowait = true,
			},
			{
				"<leader>dC",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Conditional Breakpoint",
				nowait = true,
			},
			{
				"<leader>dL",
				function()
					require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
				end,
				desc = "Log Point",
				nowait = true,
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Continue",
				nowait = true,
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
				nowait = true,
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
				nowait = true,
			},
			{
				"<leader>du",
				function()
					require("dap").step_out()
				end,
				desc = "Step Out",
				nowait = true,
			},
			{
				"<leader>db",
				function()
					require("dap").step_back()
				end,
				desc = "Step Back",
				nowait = true,
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.open()
				end,
				desc = "Open REPL",
				nowait = true,
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "Run Last",
				nowait = true,
			},
			{
				"<leader>dq",
				function()
					require("dap").terminate()
					require("dapui").close()
				end,
				desc = "Terminate",
				nowait = true,
			},
			{
				"<leader>dR",
				function()
					require("dap").restart()
				end,
				desc = "Restart Debug Session",
				nowait = true,
			},
			-- 悬浮窗口
			{
				"<leader>dH",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "Hover Variables",
				nowait = true,
			},
			{
				"<leader>dP",
				function()
					local widgets = require("dap.ui.widgets")
					widgets.centered_float(widgets.scopes)
				end,
				desc = "Show Scopes",
				nowait = true,
			},
			-- UI 控制
			{
				"<leader>dui",
				function()
					require("dapui").toggle()
				end,
				desc = "Toggle Debug UI",
				nowait = true,
			},
			{
				"<leader>de",
				function()
					require("dap").set_exception_breakpoints({ "all" })
				end,
				desc = "Set Exception Breakpoints",
				nowait = true,
			},
		},
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			local dap = require("dap")
			local ui = require("dapui")
			local virural_text = require("nvim-dap-virtual-text")

			-- 虚拟文本配置
			virural_text.setup({
				enabled = true,
				enable_commands = true,
				highlight_changed_variables = true,
				highlight_new_as_changed = true,
				show_stop_reason = true,
				commented = false,
				only_first_definition = true,
				all_references = true,
			})

			-- UI 配置
			ui.setup({
				icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
				mappings = {
					expand = { "<CR>", "<2-LeftMouse>" },
					open = "o",
					remove = "d",
					edit = "e",
					repl = "r",
					toggle = "t",
				},
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.25 },
							{ id = "breakpoints", size = 0.25 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						size = 40,
						position = "left",
					},
					{
						elements = {
							{ id = "repl", size = 0.5 },
							{ id = "console", size = 0.5 },
						},
						size = 10,
						position = "bottom",
					},
				},
				controls = {
					enabled = true,
					element = "repl",
					icons = {
						pause = "⏸",
						play = "▶",
						step_into = "⏎",
						step_over = "⏭",
						step_out = "⏮",
						step_back = "b",
						run_last = "▶▶",
						terminate = "⏹",
						disconnect = "⏏",
					},
				},
				floating = {
					max_height = nil,
					max_width = nil,
					border = "single",
					mappings = {
						close = { "q", "<Esc>" },
					},
				},
				windows = { indent = 1 },
				render = {
					max_type_length = nil,
					max_value_lines = 100,
				},
			})

			-- 断点符号配置
			vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "🟡", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "⭕", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapStopped", { text = "▶", texthl = "", linehl = "DapStoppedLine", numhl = "" })

			-- 自动打开/关闭 UI
			dap.listeners.before.attach.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				ui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				ui.close()
			end

			-- Debug 会话开启时禁用 <leader>d 复制行映射，避免与 debug 快捷键冲突
			local copy_line_mapping = nil
			dap.listeners.before.launch.dap_disable_copy_line = function()
				-- 保存当前映射
				local mappings = vim.api.nvim_get_keymap("n")
				for _, mapping in ipairs(mappings) do
					if mapping.lhs == "<leader>d" then
						copy_line_mapping = {
							lhs = mapping.lhs,
							rhs = mapping.rhs or mapping.callback,
							opts = {
								desc = mapping.desc,
								silent = mapping.silent ~= 0,
								noremap = mapping.noremap ~= 0,
							},
						}
						break
					end
				end
				-- 删除映射
				vim.keymap.del("n", "<leader>d")
			end
			dap.listeners.before.attach.dap_disable_copy_line = function()
				-- 保存当前映射
				local mappings = vim.api.nvim_get_keymap("n")
				for _, mapping in ipairs(mappings) do
					if mapping.lhs == "<leader>d" then
						copy_line_mapping = {
							lhs = mapping.lhs,
							rhs = mapping.rhs or mapping.callback,
							opts = {
								desc = mapping.desc,
								silent = mapping.silent ~= 0,
								noremap = mapping.noremap ~= 0,
							},
						}
						break
					end
				end
				-- 删除映射
				vim.keymap.del("n", "<leader>d")
			end
			dap.listeners.before.event_terminated.dap_restore_copy_line = function()
				-- 恢复映射
				if copy_line_mapping then
					vim.keymap.set("n", copy_line_mapping.lhs, copy_line_mapping.rhs, copy_line_mapping.opts)
					copy_line_mapping = nil
				end
			end
			dap.listeners.before.event_exited.dap_restore_copy_line = function()
				-- 恢复映射
				if copy_line_mapping then
					vim.keymap.set("n", copy_line_mapping.lhs, copy_line_mapping.rhs, copy_line_mapping.opts)
					copy_line_mapping = nil
				end
			end

			-- 自动保存断点
			-- vim.api.nvim_create_autocmd("BufWritePost", {
			-- 	pattern = "*.go",
			-- 	callback = function()
			-- 		require("dap.breakpoints").save()
			-- 	end,
			-- })
		end,
	},
	{
		"leoluz/nvim-dap-go",
		ft = { "go", "gomod" },
		dependencies = { "mfussenegger/nvim-dap" },
		keys = {
			{
				"<leader>dgt",
				function()
					require("dap-go").debug_test()
				end,
				desc = "Debug Nearest Test",
				nowait = true,
			},
			{
				"<leader>dgl",
				function()
					require("dap-go").debug_last_test()
				end,
				desc = "Debug Last Test",
				nowait = true,
			},
		},
		config = function()
			require("dap-go").setup({
				delve = {
					path = "dlv",
					initialize_timeout_sec = 20,
					port = "${port}",
					args = {
						"dap",
						"-l",
						"127.0.0.1:${port}",
						"--check-go-version=false",
						"--log-dest",
						"/tmp/dlv.log",
					},
					build_flags = {},
					detached = vim.fn.has("win32") == 0,
					cwd = nil,
				},
				tests = {
					verbose = false,
				},
			})
		end,
	},
}
