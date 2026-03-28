local env = Env.theme
local flavour = env.colorvariant or "mocha"
local transbg = env.transparentbg

if not env.darkmode then
	flavour = "macchiato"
	transbg = false
end

local M = {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000, -- 确保高优先级，优先加载
	--event = "VeryLazy",
	init = function()
		if env.colorscheme == "catppuccin" then
			vim.g.catppuccin_flavour = flavour
			vim.cmd("colorscheme catppuccin")
		end
	end,
}

M.opts = function()
	local opts = {
		transparent_background = transbg,
		term_colors = true,
		dim_inactive = {
			percentage = 0.15,
			enabled = true,
			shade = "dark",
		},
		background = {
			light = "latte",
			dark = "mocha",
		},
		styles = {
			conditionals = { "italic" },
			comments = { "italic" },
		},
		integrations = {
			treesitter = true,
			coc_nvim = false,
			lsp_trouble = true,
			cmp = true,
			lsp_saga = true,
			leap = true, -- test
			gitgutter = false,
			gitsigns = true,
			telescope = true,
			which_key = true,
			dashboard = true,
			neogit = false,
			vim_sneak = false,
			fern = false,
			barbar = true,
			bufferline = true,
			markdown = true,
			lightspeed = false,
			ts_rainbow = true,
			hop = true,
			notify = true,
			telekasten = false,
			symbols_outline = true,
			mini = true,
			navic = false,
			neotree = true,
			noice = true,
			fidget = true,
			nvimtree = {
				enabled = true,
				show_root = false,
				transparent_panel = transbg,
			},
			dap = {
				enabled = false,
				enable_ui = false,
			},
			indent_blankline = {
				colored_indent_levels = false,
				enabled = true,
			},
			native_lsp = {
				enabled = true,
				virtual_text = {
					information = { "italic" },
					warnings = { "italic" },
					errors = { "italic" },
					hints = { "italic" },
				},
				underlines = {
					information = { "underline" },
					warnings = { "underline" },
					errors = { "underline" },
					hints = { "underline" },
				},
			},
		},
	}

	local colors = require("catppuccin.palettes").get_palette()
		local user_colors = require("tools.colors").palette
		colors.none = "NONE"

		-- 方案八：完整综合配色
		opts.custom_highlights = {
			-- === 基础编辑器 ===
			CursorLine = { bg = "#313244" },
			Visual = { bg = "#45475A" },
			Search = { fg = "#1E1E2E", bg = "#F9E2AF" },
			IncSearch = { fg = "#1E1E2E", bg = "#F38BA8" },
			Comment = { fg = "#6C7086", style = { "italic" } },
			LineNr = { fg = "#6C7086" },
			CursorLineNr = { fg = "#F9E2AF", style = { "bold" } },

			-- === Treesitter 语法高亮 ===
			["@keyword"] = { fg = "#CBA6F7", style = { "italic" } },
			["@function"] = { fg = "#89B4FA" },
			["@method"] = { fg = "#89B4FA" },
			["@string"] = { fg = "#A6E3A1" },
			["@number"] = { fg = "#FAB387" },
			["@type"] = { fg = "#F5C2E7" },
			["@variable"] = { fg = "#CDD6F4" },
			["@parameter"] = { fg = "#F9E2AF" },
			["@property"] = { fg = "#94E2D5" },
	
			-- === LSP 诊断 ===
			DiagnosticError = { fg = "#F38BA8" },
			DiagnosticWarn = { fg = "#F9E2AF" },
			DiagnosticInfo = { fg = "#89B4FA" },
			DiagnosticHint = { fg = "#94E2D5" },
			DiagnosticVirtualTextError = { bg = colors.none, fg = "#F38BA8" },
			DiagnosticVirtualTextWarn = { bg = colors.none, fg = "#F9E2AF" },
			DiagnosticVirtualTextInfo = { bg = colors.none, fg = "#89B4FA" },
			DiagnosticVirtualTextHint = { bg = colors.none, fg = "#94E2D5" },
	
			-- === Git ===
			DiffAdd = { bg = "#1E3A2F" },
			DiffDelete = { bg = "#3A1E2F" },
			DiffChange = { bg = "#2F2F3A" },
			GitSignsAdd = { fg = "#A6E3A1" },
			GitSignsChange = { fg = "#F9E2AF" },
			GitSignsDelete = { fg = "#F38BA8" },
	
			-- === NvimTree ===
			NvimTreeFolderIcon = { fg = "#89B4FA" },
			NvimTreeFolderName = { fg = "#CDD6F4" },
			NvimTreeGitDirty = { fg = "#F9E2AF" },
			NvimTreeGitNew = { fg = "#A6E3A1" },
			NvimTreeGitDeleted = { fg = "#F38BA8" },
	
			-- === Telescope ===
			TelescopeBorder = { fg = "#89B4FA" },
			TelescopeMatching = { fg = "#F9E2AF", style = { "bold" } },
			TelescopeSelection = { bg = "#313244" },
	
			-- === BufferLine ===
			BufferLineErrorSelected = { fg = user_colors.red, bold = true },
			BufferLineWarningSelected = { fg = user_colors.yellow, bold = true },
			BufferLineInfoSelected = { fg = user_colors.cyan, bold = true },
		}
	
		-- 透明背景额外配置
		if transbg then
			opts.custom_highlights = vim.tbl_extend("force", opts.custom_highlights, {
				Normal = { bg = colors.none },
				NormalFloat = { bg = colors.none },
				NormalNC = { bg = colors.none },
				SignColumn = { bg = colors.none },
				StatusLine = { bg = colors.none },
				StatusLineNC = { bg = colors.none },
				NvimTreeNormal = { bg = colors.none },
				NvimTreeNormalNC = { bg = colors.none },
			})
	end

	return opts
end

return M
