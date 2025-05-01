return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path", -- 文件路径
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-buffer",
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets",
		"L3MON4D3/LuaSnip", -- snippets引擎，不装这个自动补全会出问题
		"onsails/lspkind.nvim",
	},
	config = function()
		local has_words_before = function()
			unpack = unpack or table.unpack
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local winOpt = {
			border = "rounded",
			side_padding = 0,
			winhighlight = "Normal:Pmenu,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
		}
		cmp.setup({
			-- 取消LSP的预选
			preselect = cmp.PreselectMode.None,
			performance = {
				max_view_entries = 20,
			},
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			window = {
				completion = cmp.config.window.bordered(winOpt),
				documentation = cmp.config.window.bordered(winOpt),
			},
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					elseif has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "nvim_lua" },
				{ name = "buffer" },
				{ name = "luasnip" },
				{ name = "codecompanion" },
				{ name = "path" },
			}),
			view = {
				entries = { name = "custom" },
				docs = { auto_open = true },
			},
			formatting = {
				expandable_indicator = true,
				fields = { "abbr", "kind", "menu" },
				format = function(entry, vim_item)
					local kind = require("lspkind").cmp_format({
						mode = "text_symbol",
						maxWidth = 50,
						ellipsis_char = "...",
						show_labelDetails = true,
						menu = {
							buffer = "[Buffer]",
							nvim_lsp = "[LSP]",
							luasnip = "[LuaSnip]",
							nvim_lua = "[Lua]",
							latex_symbols = "[Latex]",
							path = "[PATH]",
						},
					})(entry, vim_item)
					return kind
				end,
			},
		})

		-- Set configuration for specific filetype.
		cmp.setup.filetype("gitcommit", {
			sources = cmp.config.sources({ { name = "git" } }, { { name = "buffer" } }),
		})

		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = { { name = "buffer" } },
		})

		cmp.setup.cmdline(":", {
			formatting = {
				expandable_indicator = true,
				fields = { "abbr", "kind", "menu" },
				format = function(entry, vim_item)
					return require("lspkind").cmp_format({
						with_text = false,
						mode = "symbol",
						menu = {
							cmdline = "[CMD]",
							path = "[PATH]",
						},
					})(entry, vim_item)
				end,
			},
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
		})
	end,
}
