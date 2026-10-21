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
	},
}
