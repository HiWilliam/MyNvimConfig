return {
	{
		"HiWilliam/whid",
		config = function()
			local basename = vim.trim(vim.fn.system("git rev-parse --show-toplevel | xargs basename"))
			local save_file = "/wuhao/workspace/todos.json"
			if basename == "whid" then
				save_file = "/wuaho/workspace/default.json"
			end
			require("whid").setup({ save_file = save_file })
		end,
	},
	{
		"m4xshen/hardtime.nvim",
		lazy = false,
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {},
		config = function()
			require("hardtime").setup()
		end,
	},
}
