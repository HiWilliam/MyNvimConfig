return {
	{
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
				dap_debug = true, -- 启用调试配置
				dap_debug_keymap = true, -- 启用调试键映射
				dap_debug_gui = true, -- 启用调试 GUI 界面
			})

			require("nvim-dap-virtual-text").setup({})
		end,
		build = ':lua require("go.install").update_all_sync()',
	},
}
