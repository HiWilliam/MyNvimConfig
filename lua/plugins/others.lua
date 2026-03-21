return {
	{
		"windwp/nvim-autopairs", --符号补全
		event = "InsertEnter",
		config = true,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		tag = "v3.5.4",
		main = "ibl",
		opts = {},
		config = function()
			require("ibl").setup()
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "catppuccin",
				},
			})
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"goolord/alpha-nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("alpha").setup(require("alpha.themes.theta").config)
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		keys = {
			{
				"tv",
				"<cmd>ToggleTerm direction=vertical size=50<CR>",
				"n",
			},
			{
				"th",
				"<cmd>ToggleTerm direction=horizontal size=20<CR>",
				"n",
			},
			{
				"tf",
				"<cmd>ToggleTerm direction=float size=20<CR>",
				"n",
			},
			{
				"tn",
				"<cmd>ToggleTerm direction=tab size=50<CR>",
				"n",
			},
			{
				"t1",
				"<cmd>1ToggleTerm direction=float size=50<CR>",
				"n",
			},
			{
				"t3",
				"<cmd>3ToggleTerm direction=float size=50<CR>",
				"n",
			},
		},

		version = "*",
		config = function()
			require("toggleterm").setup({
				float_tops = {
					border = "curved",
				},
				on_open = function(term)
					vim.cmd("startinsert!")
					vim.api.nvim_buf_set_keymap(
						term.bufnr,
						"n",
						"q",
						"<cmd>close<CR>",
						{ noremap = true, silent = true }
					)
				end,
			})
		end,
	},
	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
	},
	{
		"OXY2DEV/markview.nvim",
		lazy = true,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "helix",
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	-- {
	-- 	"dense-analysis/ale",
	-- 	config = function()
	-- 		-- Configuration goes here.
	-- 		local g = vim.g
	-- 		g.ale_enabled = 1
	-- 		g.ale_completion_enabled = 1
	-- 		g.ale_fix_on_save = 1
	-- 		g.ale_lint_on_text_changed = "normal"
	-- 		g.ale_lint_on_insert_leave = 1
	-- 		g.ale_lint_on_enter = 1
	--
	-- 		g.ale_linters = {
	-- 			go = { "gopls" },
	-- 		}
	-- 		g.ale_go_gopls_options = "-remote=auto"
	-- 		g.ale_go_gopls_init_options = {
	-- 			["ui.diagnostic.staticcheck"] = true,
	-- 			analyses = {
	-- 				unusedparams = true,
	-- 				unusedwrite = true,
	-- 				fieldalignment = false,
	-- 			},
	-- 		}
	-- 	end,
	-- },
	{ "towolf/vim-helm", ft = "helm" },
}
