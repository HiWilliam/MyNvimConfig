return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		-- dont preview binary file
		local previewers = require("telescope.previewers")
		local Job = require("plenary.job")
		local new_maker = function(filepath, bufnr, opts)
			filepath = vim.fn.expand(filepath)
			Job:new({
				command = "file",
				args = { "--mime-type", "-b", filepath },
				on_exit = function(j)
					local mime_type = vim.split(j:result()[1], "/")[1]
					if mime_type == "text" then
						previewers.buffer_previewer_maker(filepath, bufnr, opts)
					else
						-- maybe we want to write something to the buffer here
						vim.schedule(function()
							vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
						end)
					end
				end,
			}):sync()
		end
		-- press esc exit prewview directly
		require("telescope").setup({
			defaults = {
				sorting_strategy = "ascending",
				layout_strategy = "flex",
				layout_config = {
					horizontal = { preview_cutoff = 80, preview_width = 0.55 },
					vertical = { mirror = true, preview_cutoff = 25 },
					prompt_position = "top",
					width = 0.87,
					height = 0.80,
				},
				color_devicons = true,
				mappings = {
					i = {
						["<C-h>"] = "which_key",
					},
					n = {
						["q"] = require("telescope.actions").close,
					},
				},
				buffer_previewer_maker = new_maker,
			},
		})
	end,
}
