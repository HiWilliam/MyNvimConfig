require("nvim-treesitter.configs").setup({
	ensure_installed = { "c", "lua", "vim", "vimdoc", "bash", "query", "go", "json", "make" },

	sync_install = false,

	auto_install = true,

	ignore_install = { "javascript" },

	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
		use_languagetree = true,
	},

	rainbow = {
		enable = true,
		extended_mode = true,
		max_file_lines = nil,
	},
})
