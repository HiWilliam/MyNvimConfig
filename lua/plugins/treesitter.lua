return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = true,
		dependencies = { "OXY2DEV/markview.nvim" },
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")
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
