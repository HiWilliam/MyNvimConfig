return {
	"rcarriga/nvim-dap-ui",
	--cmd = { "GoDebug" },
	dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	config = function()
		local dap, dapui = require("dap"), require("dapui")

		-- 配置 DAP UI
		dapui.setup()

		-- 自动打开/关闭 DAP UI
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		-- 配置 Go 调试适配器
		dap.adapters.go = {
			type = "executable",
			command = "dlv",
			args = { "dap", "-l", "127.0.0.1:38697" },
		}
	end,
}
