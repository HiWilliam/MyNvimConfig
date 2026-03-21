return {
	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		keys = {
			{
				"<leader>dt",
				function()
					require("dap").toggle_breakpoint()
				end,
				"n",
				{
					desc = "Toggle Breakpoint",
					nowait = true,
					remap = false,
				},
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Continue",
				{
					nowait = true,
					remap = false,
				},
				"n",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
				{
					nowait = true,
					remap = false,
				},
				"n",
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
				nowait = true,
				remap = false,
			},
			{
				"<leader>du",
				function()
					require("dap").step_out()
				end,
				desc = "Step Out",
				{
					nowait = true,
					remap = false,
				},
				"n",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.open()
				end,
				desc = "Open REPL",
				{
					nowait = true,
					remap = false,
				},
				"n",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "Run Last",
				{
					nowait = true,
					remap = false,
				},
				"n",
			},
			{
				"<leader>dq",
				function()
					require("dap").terminate()
					require("dapui").close()
					require("nvim-dap-virtual-text").toggle()
				end,
				desc = "Terminate",
				{
					nowait = true,
					remap = false,
				},
				"n",
			},
			{
				"<leader>db",
				function()
					require("dap").list_breakpoints()
				end,
				desc = "List Breakpoints",
				nowait = true,
				remap = false,
			},
			{
				"<leader>de",
				function()
					require("dap").set_exception_breakpoints({ "all" })
				end,
				desc = "Set Exception Breakpoints",
				nowait = true,
				remap = false,
			},
		},
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			local dap = require("dap")
			local ui = require("dapui")
			local virural_text = require("nvim-dap-virtual-text")
			virural_text.setup()

			dap.configurations = {
				{
					dlvFlags = { "--check-go-version=false" },
					mode = "debug",
					name = "Launch File",
					program = function()
						local path = vim.fn.input(vim.fn.getcwd() .. "/", "file")
						print(path)
						return path
					end,
					request = "launch",
					type = "go",
				},
			}

			ui.setup()
			vim.fn.sign_define("DapBreakpoint", { text = "🐞" })
			dap.listeners.before.attach.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				ui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				ui.close()
			end
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
					args = {
						"dap",
						"-l",
						"127.0.0.1:${port}",
						"--check-go-version=false",
						"--log-dest",
						"/tmp/dlv.log",
					},
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
