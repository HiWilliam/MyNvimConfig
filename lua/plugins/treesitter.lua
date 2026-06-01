return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"OXY2DEV/markview.nvim",
		},
		build = ":TSUpdate",
		config = function()
			-- 高亮
			vim.treesitter.language.register("go", "gomod")
			vim.treesitter.language.register("go", "gosum")

			-- 基本设置
			require("nvim-treesitter").setup({
				modules = {},
				ignore_install = { "vimdoc" },
				auto_install = true,
				ensure_installed = { "go", "gomod", "json", "lua", "vim", "vimdoc" },
				sync_install = false,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "gnn",
						node_incremental = "grn",
						scope_incremental = "grc",
						node_decremental = "grm",
					},
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
}
