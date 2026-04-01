return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	config = true,
	opts = {
		terminal_cmd = "/root/.local/bin/claude",
		terminal = {
			snacks_win_opts = {
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
}
