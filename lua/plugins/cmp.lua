local cmp = require("cmp")
local luasnip = require("luasnip")

local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	preselect = cmp.PreselectMode.None,
	performance = {
		max_view_entries = 20,
	},
	window = {
		documentation = cmp.config.window.bordered(),
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
		{ name = "path" },
	}),
	view = {
		entries = { name = "custom" },
		docs = { auto_open = true },
	},
	formatting = {
		-- fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			local kind = require("lspkind").cmp_format({
				mode = "symbol",
				-- menu = {
				-- 	buffer = "[Buffer]",
				-- 	nvim_lsp = "[LSP]",
				-- 	luasnip = "[LuaSnip]",
				-- 	nvim_lua = "[Lua]",
				-- 	latex_symbols = "[Latex]",
				-- },
			})(entry, vim_item)

			-- local strings = vim.split(kind.kind, "%s", { trimempty = true })
			-- kind.kind = string.format(" %s ", (strings[1] or ""))
			-- kind.menu = string.format("%s %s", (strings[2] or ""), kind.menu)
			return kind
		end,
	},
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources(
		{ { name = "git" } }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
		{ { name = "buffer" } }
	),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = { { name = "buffer" } },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	formatting = {
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
