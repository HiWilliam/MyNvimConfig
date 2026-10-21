-- 用浮动终端打开 dst（dsh-tui 启动器），再次触发可收起
local M = {}

local term

function M.toggle()
	if not term then
		local Terminal = require("toggleterm.terminal").Terminal
		term = Terminal:new({
			cmd = "dst",
			direction = "float",
			close_on_exit = true,
			-- DSH 内核启动即完全访问（不审批 + 全盘写），等价于 Claude 的 bypassPermissions
			env = { DSH_PERMISSION_MODE = "danger-full-access" },
			float_opts = {
				border = "rounded",
				width = function()
					return math.max(1, math.floor(vim.o.columns * 0.9))
				end,
				height = function()
					return math.max(1, math.floor(vim.o.lines * 0.85))
				end,
			},
			on_open = function(t)
				vim.cmd("startinsert!")
				vim.keymap.set("n", "q", function()
					t:close()
				end, { buffer = t.bufnr, silent = true, desc = "Close dst" })
				-- configs/keymaps.lua 里有全局 tnoremap <Esc> -> <C-\><C-n>，
				-- 会让 dst 收不到 Esc（/settings 里退不回上一页）。这里用 buffer 级映射覆盖它。
				vim.keymap.set("t", "<Esc>", "<Esc>", {
					buffer = t.bufnr,
					silent = true,
					desc = "Send Esc to dst",
				})
				-- 与 claudecode 一致：<C-c> 退出终端模式回到 normal，而不是给 dst 发 SIGINT
				vim.keymap.set("t", "<C-c>", "<C-\\><C-N>", {
					buffer = t.bufnr,
					silent = true,
					desc = "Exit to Normal mode",
				})
			end,
		})
	end
	term:toggle()
end

return M
