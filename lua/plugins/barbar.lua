return {
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
			"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
		},
		lazy = false,
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {
			clickable = true, -- Enables/disables clickable tabs
			tabpages = true, -- Enable/disables current/total tabpages indicator (top right corner)
			insert_at_end = true,
			icons = {
				button = "x",
				buffer_index = true,
				filetype = { enabled = true },
				visible = { modified = { buffer_number = false } },
				gitsigns = {
					added = { enabled = true, icon = "+" },
					changed = { enabled = true, icon = "~" },
					deleted = { enabled = true, icon = "-" },
				},
			},
		},
		keys = {
			{ "<A-1>", "<cmd>BufferGoto 1<CR>", { silent = true, noremap = true }, { "n", "i" } },
			{ "<A-2>", "<cmd>BufferGoto 2<CR>", { silent = true, noremap = true }, { "n", "i" } },
			{ "<A-3>", "<cmd>BufferGoto 3<CR>", { silent = true, noremap = true }, { "n", "i" } },
			{ "<A-4>", "<cmd>BufferGoto 4<CR>", { silent = true, noremap = true }, { "n", "i" } },
			{ "<A-5>", "<cmd>BufferGoto 5<CR>", { silent = true, noremap = true }, { "n", "i" } },
			{ "<A-c>", "<cmd>w | BufferClose<CR>", { silent = true, noremap = true }, { "n", "i" } },
		},
		version = "^1.0.0", -- optional: only update when a new 1.x version is released
	},
}
