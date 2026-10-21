return {
	"folke/trouble.nvim",
	cmd = { "Trouble" },
	keys = {
		{ "<leader>xx", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix 面板" },
		{ "<leader>xd", "<cmd>Trouble diagnostics toggle<cr>", desc = "诊断面板" },
	},
	opts = {
		-- 结果面板常驻右侧，宽度占 35%
		win = { position = "right", size = 0.35 },
		modes = {
			-- quickfix 历史回溯：每次 <leader>r + <M-q> 都会留下一份列表
			qflist = {
				keys = {
					["<C-p>"] = {
						action = function(view)
							require("tools.qf").switch_view(view, "older")
						end,
						desc = "上一份搜索结果",
					},
					["<C-n>"] = {
						action = function(view)
							require("tools.qf").switch_view(view, "newer")
						end,
						desc = "下一份搜索结果",
					},
				},
			},
		},
	},
}
