return {
	"ray-x/go.nvim",
	lazy = true,
	ft = { "go", "gomod" },
	keys = {
		{ "gbt", "<cmd>GoBreakToggle<CR>", { silent = true, noremap = true }, "n" },
		{ "gbs", "<cmd>GoBreakSave<CR>", { silent = true, noremap = true }, "n" },
		{ "gbl", "<cmd>GoBreakLoad<CR>", { silent = true, noremap = true }, "n" },
		{ "gdh", "<cmd>GoD<CR>", { silent = true, noremap = true }, "n" },
	},
	dependencies = { -- optional packages
		"ray-x/guihua.lua",
		"theHamsta/nvim-dap-virtual-text",
	},
	config = function()
		require("go").setup({
			goimports = "gopls",
			fillstruct = "gopls",
			tag_options = "json=",
			dap_debug = false,
		})

		require("nvim-dap-virtual-text").setup()
	end,
	build = ':lua require("go.install").update_all_sync()',
}
