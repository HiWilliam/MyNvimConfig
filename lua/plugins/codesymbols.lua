return {
	"hedyhli/outline.nvim",
	lazy = true,
	cmd = { "Outline", "OutlineOpen" },
	keys = { { "<leader>m", "<cmd>Outline<CR>", desc = "Toggle outline" } },
	config = function()
		require("outline").setup({})
	end,
}
