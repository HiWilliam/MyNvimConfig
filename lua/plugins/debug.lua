return {
	{ "rcarriga/nvim-dap-ui", enabled = false },
	{
		"miroshQa/debugmaster.nvim",
		dependencies = { "mfussenegger/nvim-dap", "jbyuki/one-small-step-for-vimkind" },
		config = function()
			local dm = require("debugmaster")
			vim.keymap.set({ "n", "v" }, "sd", function()
				dm.mode.toggle()
				local is_active = require("debugmaster.debug.mode").is_active()
				local state = is_active and "开启" or "关闭"
				local notice = string.format("Debug模式%s", state)
				-- toggle side panel
				local state = require("debugmaster.state")
				state.sidepanel:toggle()
				require("notify")(notice, vim.log.levels.INFO)
			end, { nowait = true })
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
