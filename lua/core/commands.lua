-- open the file at last position
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = { "*" },
	callback = function()
		if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
			vim.cmd("normal! g'\"", false)
		end
	end,
})

-- show the  iterm bg image
vim.api.nvim_create_autocmd("BufWinEnter", {
	callback = function()
		local groups = {
			"Normal",
			"Comment",
			"Constant",
			"Special",
			"Identifier",
			"Statement",
			"PreProc",
			"Type",
			"Underlined",
			"Todo",
			"String",
			"Function",
			"Conditional",
			"Repeat",
			"Operator",
			"Structure",
			"LineNr",
			"NonText",
			"SignColumn",
			"CursorLineNr",
			"EndOfBuffer",
			"NormalNC",
		}
		for _, v in pairs(groups) do
			vim.cmd("hi " .. v .. " guibg=none ctermbg=none")
		end
	end,
})
