return {
	"ray-x/go.nvim",
	lazy = true,
	ft = { "go", "gomod" },
	dependencies = { -- optional packages
		"ray-x/guihua.lua",
		"theHamsta/nvim-dap-virtual-text",
	},
	config = function()
		require("go").setup({
			goimports = "gopls",
			fillstruct = "gopls",
			tag_options = "json=",
			-- 禁用 go.nvim 的 dap 功能，使用 nvim-dap-go
			dap_debug = false,
			dap_debug_keymap = false,
		})

		require("nvim-dap-virtual-text").setup()
	end,
	build = ':lua require("go.install").update_all_sync()',
}
