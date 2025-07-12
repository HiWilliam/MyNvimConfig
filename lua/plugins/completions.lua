return {
	"saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"nvim-tree/nvim-web-devicons",
		"onsails/lspkind.nvim",
		"xzbdmw/colorful-menu.nvim",
		"Kurama622/llm.nvim",
		"saghen/blink.compat",
	},

	version = "1.*",
	build = "cargo build --release -Znext-lockfile-bump",
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = "none",
			["<A-j>"] = {
				function(cmp)
					return cmp.select_next({ auto_insert = false })
				end,
				"fallback",
			},
			["<A-k>"] = {
				function(cmp)
					return cmp.select_prev({ auto_insert = false })
				end,
				"fallback",
			},
			["<C-n>"] = {
				function(cmp)
					return cmp.select_next({ auto_insert = false })
				end,
				"fallback",
			},
			["<C-p>"] = {
				function(cmp)
					return cmp.select_prev({ auto_insert = false })
				end,
				"fallback",
			},

			["<C-u>"] = { "scroll_documentation_up", "fallback" },
			["<C-d>"] = { "scroll_documentation_down", "fallback" },

			["<Tab>"] = {
				function(cmp)
					return cmp.select_next({ auto_insert = true })
				end,
				"fallback",
			},
			["<S-Tab>"] = {
				function(cmp)
					return cmp.select_prev({ auto_insert = true })
				end,
				"fallback",
			},
			["<CR>"] = {
				function(cmp)
					return cmp.accept()
				end,
				"fallback",
			},
			-- Close current completion and insert a newline
			["<S-CR>"] = {
				function(cmp)
					cmp.hide()
					return false
				end,
				"fallback",
			},

			-- Show/Remove completion
			["<A-/>"] = {
				function(cmp)
					if cmp.is_menu_visible() then
						return cmp.hide()
					else
						return cmp.show()
					end
				end,
				"fallback",
			},

			["<A-n>"] = {
				function(cmp)
					cmp.show({ providers = { "buffer" } })
				end,
			},
			["<A-p>"] = {
				function(cmp)
					cmp.show({ providers = { "buffer" } })
				end,
			},
			["<C-y>"] = {
				function(cmp)
					cmp.show({ providers = { "llm" } })
				end,
			},
		},

		appearance = {
			nerd_font_variant = "mono",
		},

		completion = {
			accept = { auto_brackets = { enabled = true } },
			list = { selection = { preselect = true, auto_insert = true } },
			menu = {
				border = "rounded",
				max_height = 20,
				draw = {
					-- We don't need label_description now because label and label_description are already
					-- combined together in label by colorful-menu.nvim.
					columns = { { "kind_icon" }, { "label", gap = 1 } },
					components = {
						label = {
							text = function(ctx)
								return require("colorful-menu").blink_components_text(ctx)
							end,
							highlight = function(ctx)
								return require("colorful-menu").blink_components_highlight(ctx)
							end,
						},
					},
				},
			},
			ghost_text = { enabled = true },
			trigger = {
				prefetch_on_insert = false,
				show_on_blocked_trigger_characters = {},
			},
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			providers = {
				llm = {
					name = "llm",
					module = "llm.common.completion.frontends.blink",
					timeout_ms = 10000,
					score_offset = 100,
					async = true,
				},
			},
		},

		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
