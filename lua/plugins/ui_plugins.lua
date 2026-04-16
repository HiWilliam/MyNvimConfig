return {
	-- lazy.nvim
	{
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {},
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	keys = {
		{
			"<Leader>nl",
			"<cmd>Noice history<cr>",
			"查看 noice 通知历史",
		},
		{
			"<Leader>nd",
			"<cmd>Noice dismiss<cr>",
			"关闭 noice 通知",
		},
	},
	config = function()
			require("noice").setup({
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = true, -- add a border to hover docs and signature help
				},
			})
		end,
	},
	{
		"rcarriga/nvim-notify",
		opts = {
			background_colour = "#000000",
			max_width = 100,
			max_height = 50,
		},
		keys = {
			{
				"<Leader>un",
				function()
					local notify = require("notify")
					notify.dismiss({ silent = true, pending = true })
				end,
				"",
			},
			{
				"<Leader>uh",
				function()
					local notify = require("notify")
					notify.history()
				end,
				"查看通知历史",
			},
		},
		config = function()
			local notify = require("notify")
			notify.setup({
				render = "minimal", -- 或 "default"、"wrapped"
				stages = "fade_in_slide_out",
				timeout = 3000,
			})
			-- 设置全局变量保留历史通知
			vim.g.notify_history = true
		end,
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			bigfile = { enabled = true },
			dashboard = { enabled = true },
			explorer = { enabled = true },
			indent = { enabled = true },
			input = { enabled = true },
			picker = { enabled = true },
			notifier = { enabled = true },
			quickfile = { enabled = true },
			scope = { enabled = true },
			scroll = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
		},
		configs = function()
			require("snacks").setup({})
		end,
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function() end,
			})
		end,
	},
}
