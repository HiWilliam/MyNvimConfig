return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	dependencies = {
		"rafamadriz/friendly-snippets",
		"nvim-tree/nvim-web-devicons",
		"onsails/lspkind.nvim",
	},

	-- use a release tag to download pre-built binaries
	version = "1.*",
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	build = "cargo build --release",
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
		-- 'super-tab' for mappings similar to vscode (tab to accept)
		-- 'enter' for enter to accept
		-- 'none' for no mappings
		--
		-- All presets have the following mappings:
		-- C-space: Open menu or open docs if already open
		-- C-n/C-p or Up/Down: Select next/previous item
		-- C-e: Hide menu
		-- C-k: Toggle signature help (if signature.enabled = true)
		--
		-- See :h blink-cmp-config-keymap for defining your own keymap
		keymap = {
			-- If the command/function returns false or nil, the next command/function will be run.
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
					return cmp.select_next({ auto_insert = false })
				end,
				"fallback",
			},
			["<S-Tab>"] = {
				function(cmp)
					return cmp.select_prev({ auto_insert = false })
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
					columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
					components = {
						kind_icon = {
							ellipsis = false,
							text = function(ctx)
								local icon = ctx.kind_icon
								if icon then
									-- Do nothing
								elseif vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										icon = dev_icon
									end
								else
									icon = require("lspkind").symbolic(ctx.kind, { mode = "symbol" })
								end
								return string.format("%s %s", icon, ctx.icon_gap)
							end,
							highlight = function(ctx)
								local hl = ctx.kind_hl
								if hl then
									-- Do nothing
								elseif vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										hl = dev_hl
									end
								end
								return hl
							end,
						},
					},
				},
			},
			ghost_text = { enabled = true },
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},

		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
