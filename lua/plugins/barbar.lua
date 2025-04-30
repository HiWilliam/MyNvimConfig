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
			tabpages = false, -- Enable/disables current/total tabpages indicator (top right corner)
			insert_at_end = true,
			auto_hide = false,
			animation = true,
			icons = {
				button = "",
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
		version = "^1.0.0", -- optional: only update when a new 1.x version is released
		keys = {
			{ "<A-1>", "<cmd>BufferGoto 1<CR>", { silent = true, noremap = true }, { "n", "i", "v" } },
			{ "<A-2>", "<cmd>BufferGoto 2<CR>", { silent = true, noremap = true }, { "n", "i", "v" } },
			{ "<A-3>", "<cmd>BufferGoto 3<CR>", { silent = true, noremap = true }, { "n", "i", "v" } },
			{ "<A-4>", "<cmd>BufferGoto 4<CR>", { silent = true, noremap = true }, { "n", "i", "v" } },
			{ "<A-5>", "<cmd>BufferGoto 5<CR>", { silent = true, noremap = true }, { "n", "i", "v" } },
			{ "<A-l>", "<cmd>BufferLast<CR>", { silent = true, noremap = true }, { "n", "i", "v" } },
			{ "<A-n>", "<cmd>BufferNext<CR>", { silent = true, noremap = true }, { "n", "i", "v" } },
			{ "<A-p>", "<cmd>BufferPin<CR>", { silent = true, noremap = true }, { "n", "i", "v" } },
			{ "<A-c>", "<cmd>w | BufferClose<CR>", { silent = true, noremap = true }, { "n", "i", "v" } },
			{ "<A-a>", "<cmd>w | BufferCloseAllButCurrent<CR>", { silent = true, noremap = true }, { "n", "i", "v" } },
		},
	},
}
