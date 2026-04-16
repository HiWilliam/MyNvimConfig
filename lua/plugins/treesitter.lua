return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"OXY2DEV/markview.nvim",
		},
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter")
			configs.setup({
				modules = {},
				ignore_install = { "vimdoc" },
				auto_install = true,
				ensure_installed = { "go", "gomod", "json", "lua", "vim", "vimdoc" },
				sync_install = false,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				locals = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "gnn",
						node_incremental = "grn",
						scope_incremental = "grc",
						node_decremental = "grm",
					},
				},
				indent = { enable = true },
				textobjects = {
					enable = true,
					lsp_interp = {
						enable = true,
						peek_definition_code = {
							["DF"] = "@function.outer",
						},
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
