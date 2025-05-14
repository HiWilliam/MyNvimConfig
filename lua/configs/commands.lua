-- open the file at last position
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = { "*" },
	callback = function()
		if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
			vim.cmd("normal! g'\"", false)
		end
	end,
})

--set quickfix and location_list when open the file
vim.api.nvim_create_autocmd("DiagnosticChanged", {
	pattern = { "*" },
	callback = function()
		local opt = {
			open = false,
		}
		vim.diagnostic.setqflist(opt)
		vim.diagnostic.setloclist(opt)
	end,
})

-- 启动kratos服务
vim.api.nvim_create_user_command("GoRunServer", function()
	local term = require("toggleterm")
	term.toggle(2)
	term.exec_command(
		'2TermExec cmd="go run cmd/*manager/main.go cmd/*manager/wire_gen.go -conf=./configs/config-test.yaml"',
		2
	)
end, {})

vim.api.nvim_create_user_command("GoStopServer", function()
	local term = require("toggleterm")
	term.toggle(2)
	term.exec_command('2TermExec cmd="<C-c>"<CR>', 2)
end, {})
