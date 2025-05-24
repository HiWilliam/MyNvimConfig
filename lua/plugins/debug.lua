return {
	{ "rcarriga/nvim-dap-ui", enabled = false },
	{
		"miroshQa/debugmaster.nvim",
		dependencies = { "mfussenegger/nvim-dap", "jbyuki/one-small-step-for-vimkind" },
		config = function()
			local dm = require("debugmaster")
			vim.keymap.set({ "n", "v" }, "sd", dm.mode.toggle, { nowait = true })
			vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
		end,
	},
	{
		"leoluz/nvim-dap-go",
		config = function()
			require("dap-go").setup({
				-- delve configurations
				delve = {
					path = "dlv",
					initialize_timeout_sec = 20,
					port = "${port}",
					-- additional args to pass to dlv
					args = {},
					build_flags = {},
					detached = vim.fn.has("win32") == 0,
					cwd = nil,
				},
				-- options related to running closest test
				tests = {
					-- enables verbosity when running the test.
					verbose = false,
				},
			})
		end,
	},
}
