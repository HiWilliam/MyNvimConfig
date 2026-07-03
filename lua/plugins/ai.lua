return {
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		config = true,
		opts = {
			terminal_cmd = "claude --dangerously-skip-permissions",
			diff_opts = {
				layout = "horizontal", -- diff 布局：vertical 或 horizontal
				open_in_new_tab = true, -- 不在新标签页打开 diff
				keep_terminal_focus = false, -- false = 打开 diff 后光标留在代码 buffer
				hide_terminal_in_new_tab = true,
				on_new_file_reject = "keep_empty",
			},
			terminal = {
				-- 使用浮动窗口模式 (类似独立 buf)
				snacks_win_opts = {
					position = "float", -- 浮动模式，而非侧边分屏
					width = 0.8, -- 窗口宽度 80%
					height = 0.8, -- 窗口高度 80%
					border = "rounded", -- 圆角边框
					backdrop = 80, -- 背景透明度
					keys = {
						-- 退出输入模式
						quit_insert = {
							"<C-c>",
							function()
								vim.api.nvim_feedkeys(
									vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true),
									"n",
									true
								)
							end,
							mode = "t",
							desc = "Quit insert mode",
						},
						-- 翻阅历史记录 - 向上
						scroll_up = {
							"<C-p>",
							function()
								vim.api.nvim_feedkeys(
									vim.api.nvim_replace_termcodes("<C-\\><C-N>k", true, true, true),
									"n",
									true
								)
							end,
							mode = "t",
							desc = "Scroll up in history",
						},
						-- 翻阅历史记录 - 向下
						scroll_down = {
							"<C-n>",
							function()
								vim.api.nvim_feedkeys(
									vim.api.nvim_replace_termcodes("<C-\\><C-N>j", true, true, true),
									"n",
									true
								)
							end,
							mode = "t",
							desc = "Scroll down in history",
						},
						nav_h = {
							"<C-h>",
							function()
								vim.cmd("stopinsert")
								vim.cmd("TmuxNavigateLeft")
							end,
							mode = "t",
							desc = "Navigate left",
						},
						nav_j = {
							"<C-j>",
							function()
								vim.cmd("stopinsert")
								vim.cmd("TmuxNavigateDown")
							end,
							mode = "t",
							desc = "Navigate down",
						},
						nav_k = {
							"<C-k>",
							function()
								vim.cmd("stopinsert")
								vim.cmd("TmuxNavigateUp")
							end,
							mode = "t",
							desc = "Navigate up",
						},
						nav_l = {
							"<C-l>",
							function()
								vim.cmd("stopinsert")
								vim.cmd("TmuxNavigateRight")
							end,
							mode = "t",
							desc = "Navigate right",
						},
					},
				},
			},
		},
		keys = {
			{ "<leader>a", nil, desc = "AI/Claude Code" },
			{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
			{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
			{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
			{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
			{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
			{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
			{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
			{
				"<leader>as",
				"<cmd>ClaudeCodeTreeAdd<cr>",
				desc = "Add file",
				ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
			},
			-- Diff management
			{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
			{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
		},
	},
	-- OpenAI Codex CLI integration
	{
		"kkrampis/codex.nvim",
		lazy = true,
		cmd = { "Codex", "CodexToggle" },
		keys = {
			{
				"<leader>cc",
				function()
					require("codex").toggle()
				end,
				desc = "Toggle Codex popup",
				mode = "n",
			},
		},
		opts = {
			keymaps = {
				toggle = nil, -- 禁用内部默认键位，使用上方 keys 配置
				quit = "<C-q>", -- 终端模式下关闭 Codex 窗口
			},
			border = "rounded", -- 圆角边框 (与 Claude Code 一致)
			width = 0.8, -- 窗口宽度 80%
			height = 0.8, -- 窗口高度 80%
			model = nil, -- 使用默认模型
			autoinstall = true, -- 自动安装 Codex CLI
			panel = false, -- 使用浮动窗口而非侧边栏
			use_buffer = false, -- 使用终端 buffer
		},
		config = function(_, opts)
			require("codex").setup(opts)

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "codex",
				callback = function(event)
					local buf = event.buf

					-- Normal 模式: q 关闭弹窗
					vim.keymap.set("n", "q", function()
						require("codex").toggle()
					end, { buffer = buf, silent = true, desc = "Close Codex popup" })

					-- Terminal 模式: <Esc> 直接发送给 Codex CLI (而非退出终端模式)
					vim.keymap.set("t", "<Esc>", "<Esc>", { buffer = buf, silent = true, desc = "Send Esc to Codex" })
					-- Terminal 模式: <C-c> 退出到 Normal 模式 (而非发送 SIGINT 给 Codex 进程)
					vim.keymap.set("t", "<C-c>", "<C-\\><C-N>", { buffer = buf, noremap = true, silent = true, desc = "Exit to Normal mode" })
					-- Terminal 模式: 空格直接发送给底层进程，避免 leader 键等待超时
					vim.keymap.set("t", "<Space>", "<Space>", { buffer = buf, silent = true, desc = "Send Space to Codex" })
				end,
			})
		end,
	},
}
