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

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true
			capabilities.textDocument.semanticTokens.full = true
			local cmpCapabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
			capabilities.textDocument.completion.completionItem = {
				commitCharactersSupport = true,
				tagSupport = { valueSet = { "deprecated" } },
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
				capabilities = cmpCapabilities,
				workspace = {
					library = {
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
				capabilities = cmpCapabilities,
			})

			lspconfig.pyright.setup({
				on_attach = on_attach,
				capabilities = cmpCapabilities,
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
				capabilities = cmpCapabilities,
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				settings = {
					gopls = {
						semanticTokens = true,
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

			lspconfig.buf_ls.setup({
				cmd = { "buf", "beta", "lsp" },
				filetypes = { "proto" },
				settings = {
					include_path = {
						"./proto",
						"./third-party/google/api",
					},
				},
			})
		end,
	},
	{ "towolf/vim-helm", ft = "helm" },
}
