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
		-- Default configuration for telescope goes here:
		color_devicons = true,
		-- config_key = value,
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
