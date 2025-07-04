return {
	{
		"hiwilliam-whid",
		dev = true,
		dir = "/root/workspace/lua/whid",
		config = function()
			local basename = vim.trim(vim.fn.system("git rev-parse --show-toplevel | xargs basename"))
			local save_file = "/root/todos/todos.json"
			if basename == "whid" then
				save_file = "/root/workspace/lua/whid/default.json"
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
