return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = true,
	cmd = { "NvimTreeToggle" },
	keys = {
		{ "tt", ":NvimTreeToggle<CR>", "n", silent = true },
	},
	config = function()
		require("nvim-tree").setup({
			sync_root_with_cwd = true,
			update_focused_file = {
				enable = true,
				update_root = true,
			},
			view = {
				float = {
					enable = true,
				},
			},
			renderer = {
				root_folder_label = false,
				highlight_opened_files = "none",
				indent_markers = {
					enable = false,
				},
				icons = {
					show = {
						file = true,
						folder = true,
						folder_arrow = true,
						git = true,
					},
				},
			},
		})
	end,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
}
