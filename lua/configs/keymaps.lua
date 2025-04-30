local km = vim.keymap

km.set({ "n", "v" }, "<C-c>", '"*yy')
--clear search highlight
km.set("n", "<leader>nh", ":nohl<CR>")
--copy current line
km.set("n", "<leader>d", "<Esc>0v$yPj")

-- comment
km.set({ "n", "v" }, "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>")

-- telescope
local builtin = require("telescope.builtin")
km.set("n", "<leader>a", ":Telescope<CR>", {})
km.set("n", "<leader>f", builtin.find_files, {})
km.set("n", "<leader>r", builtin.live_grep, {})
km.set("n", "<leader>b", builtin.buffers, {})
km.set("n", "<leader>o", builtin.oldfiles, {})
km.set("n", "<leader>gc", builtin.git_commits, {})
km.set("n", "<leader>gs", builtin.git_status, {})

-- show the change blocks
km.set("n", "<leader>gu", "<Esc><cmd> Gitsigns setqflist all open=false <CR> | <cmd>Telescope quickfix<CR>", {})
km.set("n", "<leader>l", "<Esc><cmd>lua vim.diagnostic.setloclist({open = false})<CR> | <cmd>Telescope loclist<CR>", {})
km.set("n", "<leader>q", "<Esc><cmd>lua vim.diagnostic.setqflist({open = false})<CR> | <cmd>Telescope quickfix<CR>", {})

km.set(
	"n",
	"gi",
	"<cmd>lua require('telescope.builtin').lsp_implementations(require('telescope.themes').get_dropdown())<cr>",
	{}
)
km.set(
	"n",
	"gr",
	"<cmd>lua require('telescope.builtin').lsp_references(require('telescope.themes').get_dropdown())<cr>",
	{}
)

km.set(
	"n",
	"<leader>c",
	"<cmd>lua require('telescope.builtin').commands(require('telescope.themes').get_dropdown())<cr>",
	{}
)
--km.set("n", "hn", "<Esc>:lua vim.opt.number=false vim.opt.relativenumber=false<CR>", { silent = true })
--km.set("n", "sn", "<Esc>:lua vim.opt.number=true vim.opt.relativenumber=true<CR>", { silent = true })
-- 语法信息弹窗显示，解决错误信息过长，显示不完整的问题
km.set("n", "se", "<Esc>:lua vim.diagnostic.open_float(0, {scope='line'})<CR>", { silent = true })

km.set("t", "<esc>", "<C-\\><C-n>", { noremap = true })
km.set("t", "<C-h>", [[<C-\\><C-N><C-W>h]], { noremap = true, silent = true })
km.set("t", "<C-j>", [[<C-\><C-n><C-W>j]], { noremap = true, silent = true })
km.set("t", "<C-k>", [[<C-\><C-n><C-W>k]], { noremap = true, silent = true })
km.set("t", "<C-l>", [[<C-\><C-n><C-W>l]], { noremap = true, silent = true })

km.set(
	{ "n", "i", "v" },
	"<C-h>",
	"<cmd>TmuxNavigateLeft<cr>",
	{ remap = true, silent = true, desc = "Move to Left Window" }
)
km.set(
	{ "n", "i", "v" },
	"<C-j>",
	"<cmd>TmuxNavigateDown<cr>",
	{ remap = true, silent = true, desc = "Move to Lower Window" }
)
km.set(
	{ "n", "i", "v" },
	"<C-k>",
	"<cmd>TmuxNavigateUp<cr>",
	{ remap = true, silent = true, desc = "Move to Upper Window" }
)
km.set(
	{ "n", "i", "v" },
	"<C-l>",
	"<Esc><cmd>TmuxNavigateRight<cr>",
	{ remap = true, silent = true, desc = "Move to Right Window" }
)
