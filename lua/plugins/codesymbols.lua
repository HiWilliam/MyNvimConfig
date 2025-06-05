return {
	"hedyhli/outline.nvim",
	event = "VeryLazy",
	dependencies = {
		"epheien/outline-treesitter-provider.nvim",
	},
	lazy = true,
	cmd = { "Outline", "OutlineOpen" },
	keys = {
		{ "<leader>m", "<cmd>Outline<CR>", desc = "Toggle outline" },
	},
	config = function()
		require("outline").setup({
			providers = {
				priority = { "lsp", "markdown", "treesitter" },
			},
		})
	end,
}
