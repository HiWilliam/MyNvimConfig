return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = true,
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "gopls", "vimls" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"folke/neodev.nvim",
		},
		config = function()
			-- lsp common settings
			local on_attach = function(client)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end

			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			capabilities.textDocument.completion.completionItem = {
				documentationFormat = { "markdown", "plaintext" },
				snippetSupport = true,
				preselectSupport = true,
				insertReplaceSupport = true,
				labelDetailsSupport = true,
				deprecatedSupport = true,
				commitCharactersSupport = true,
				tagSupport = { valueSet = { 1 } },
				resolveSupport = {
					properties = {
						"documentation",
						"detail",
						"additionalTextEdits",
					},
				},
			}
			require("neodev").setup({})
			local lspconfig = require("lspconfig")

			lspconfig.lua_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				workspace = {
					library = {
						["/usr/local/lib/lua"] = true,
						[vim.fn.expand("$LUA_CPATH")] = true,
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
						[vim.fn.expand(vim.fn.stdpath("data") .. "/site/pack/packer/start/?")] = true,
					},
					maxPreload = 100000,
					preloadFileSize = 10000,
				},
			})

			lspconfig.vimls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			lspconfig.pyright.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			lspconfig.helm_ls.setup({
				settings = {
					["helm-ls"] = {
						yamlls = {
							path = "yaml-language-server",
						},
					},
				},
			})

			lspconfig.gopls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				settings = {
					gopls = {
						usePlaceholders = true,
						completeUnimported = true,
						experimentalPostfixCompletions = true,
						analyses = {
							bools = true,
							printf = true,
							unusedparams = true,
							shadow = true,
							analysisProgressReporting = false,
						},
					},
				},
			})
		end,
	},
	{ "towolf/vim-helm", ft = "helm" },
}
