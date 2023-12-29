vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

--clear search highlight
keymap.set("n", "<leader>nh", ":nohl<CR>")
--copy current line
keymap.set("n", "<leader>d", "<Esc>0v$yPj")

-- PLUGINS
-- nvimtree
keymap.set("n", "tt", ":NvimTreeToggle<CR>")

-- telescope
local builtin = require("telescope.builtin")
keymap.set("n", "<leader>a", ":Telescope<CR>", {})
keymap.set("n", "<leader>f", builtin.find_files, {})
keymap.set("n", "<leader>r", builtin.live_grep, {})
keymap.set("n", "<leader>b", builtin.buffers, {})
keymap.set("n", "<leader>o", builtin.oldfiles, {})
keymap.set("n", "<leader>h", builtin.help_tags, {})
keymap.set("n", "<leader>gc", builtin.git_commits, {})
keymap.set("n", "<leader>gs", builtin.git_status, {})

-- show the change blocks
keymap.set("n", "<leader>gu", "<Esc><cmd> Gitsigns setqflist all open=false <CR> | :Telescope quickfix<CR>", {})
keymap.set("n", "<leader>l", "<Esc><cmd>lua vim.diagnostic.setloclist({open = false})<CR> | :Telescope loclist<CR>", {})
keymap.set("n", "<leader>q", "<Esc><cmd>lua vim.diagnostic.setqflist({open = false})<CR> | :Telescope quickfix<CR>", {})

keymap.set(
	"n",
	"gi",
	"<cmd>lua require('telescope.builtin').lsp_implementations(require('telescope.themes').get_dropdown())<cr>",
	{}
)
keymap.set(
	"n",
	"gr",
	"<cmd>lua require('telescope.builtin').lsp_references(require('telescope.themes').get_dropdown())<cr>",
	{}
)
keymap.set(
	"n",
	"<leader>t",
	"<cmd>lua require('telescope.builtin').lsp_document_symbols({ bufnr = CURRENT_BUFFER_NUMBER })<CR>",
	{}
)
keymap.set(
	"n",
	"<leader>c",
	"<cmd>lua require('telescope.builtin').commands(require('telescope.themes').get_dropdown())<cr>",
	{}
)

-- comment
local comment = require("Comment.api")
keymap.set("n", "<leader>/", comment.toggle.linewise.current, {})
keymap.set("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>")

-- nvterm
keymap.set({ "n", "t" }, "<A-i>", function()
	require("nvterm.terminal").toggle("float")
end, {})
