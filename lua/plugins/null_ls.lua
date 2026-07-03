return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local null_ls = require("null-ls")
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		-- 使用内置的 formatter
		local opts = {
			sources = {
				--null_ls.builtins.formatting.gofmt,
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.goimports,
				null_ls.builtins.formatting.prettier.with({
					filetypes = { "json", "jsonc" },
				}),
			},
			on_attach = function(client, bufnr)
			if client:supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({
						group = augroup,
						buffer = bufnr,
					})
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ bufnr = bufnr })
						end,
					})
				end
			end,
		}
		null_ls.setup(opts)
	end,
}
