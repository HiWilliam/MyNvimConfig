require("nvim-treesitter.configs").setup({
	ensure_installed = { "c", "lua", "vim", "vimdoc", "bash", "query", "go", "json", "make" },

	sync_install = false,

	auto_install = true,

	ignore_install = { "javascript" },

	highlight = {
		enable = true,
		use_languagetree = true,
	},
	textobjects = {
		enable = true,
		lsp_interop = {
			enable = true,
			peek_definition_code = {
				["DF"] = "@function.outer",
			},
		},
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
				["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
				["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
				["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

				["aa"] = { query = "@parameter.outer", desc = "Select outer part of a part/argument" },
				["ia"] = { query = "@parameter.inner", desc = "Select inner part of a part/argument" },

				["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
				["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

				["al"] = { query = "@loop.inner", desc = "Select outer part of a loop" },
				["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

				["af"] = { query = "@call.inner", desc = "Select outer part of a call" },
				["if"] = { query = "@call.inner", desc = "Select inner part of a call" },

				["am"] = { query = "@function.inner", desc = "Select outer part of a function" },
				["im"] = { query = "@function.inner", desc = "Select inner part of a function" },

				["ac"] = { query = "@class.inner", desc = "Select outer part of a class" },
				["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
			},
		},
		move = {
			enable = true,
			set_jump = true,
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
	},
})
