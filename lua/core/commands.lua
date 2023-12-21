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
