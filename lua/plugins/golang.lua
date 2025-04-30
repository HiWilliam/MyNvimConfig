return {
	"ray-x/go.nvim",
	lazy = true,
	ft = { "go", "gomod" },
	keys = {},
	dependencies = { -- optional packages
		"ray-x/guihua.lua",
		"theHamsta/nvim-dap-virtual-text",
	},
	config = function()
		require("go").setup({
			goimports = "gopls",
			fillstruct = "gopls",
			tag_options = "json=",
			run = {
				use_process_group = true,
				tags = function()
					return vim.fn.getcwd()
				end,
			},
		})

		require("nvim-dap-virtual-text").setup()
	end,
	build = ':lua require("go.install").update_all_sync()',
}
