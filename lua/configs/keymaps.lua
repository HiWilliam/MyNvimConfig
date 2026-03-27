local km = vim.keymap

km.set({ "n", "v" }, "<C-c>", '"*yy')
--clear search highlight
km.set("n", "<leader>nh", ":nohl<CR>")
--copy current line
km.set("n", "<leader>d", "<Esc>0v$yPj")

km.set("n", "<leader>td", "<Esc><cmd>TodoList<Cr>", { silent = true, noremap = true, desc = "任务清单" })

-- comment
km.set({ "n", "v" }, "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>")

-- telescope (lazy loaded via keymaps)
km.set("n", "<leader>a", "<cmd>Telescope<CR>", { desc = "Telescope" })
km.set("n", "<leader>f", function() require("telescope.builtin").find_files() end, { desc = "Find files" })
km.set("n", "<leader>r", function() require("telescope.builtin").live_grep() end, { desc = "Live grep" })
km.set("n", "<leader>b", function() require("telescope.builtin").buffers() end, { desc = "Buffers" })
km.set("n", "<leader>o", function() require("telescope.builtin").oldfiles() end, { desc = "Old files" })

-- show the change blocks
km.set("n", "<leader>gu", "<Esc><cmd> Gitsigns setqflist all open=false <CR> | <cmd>Telescope quickfix<CR>", {})
km.set("n", "<leader>l", function() require("telescope.builtin").loclist() end, { desc = "Location list" })
km.set("n", "<leader>q", function() require("telescope.builtin").diagnostics() end, { desc = "Diagnostics" })

km.set(
	"n",
	"gi",
	"<cmd>lua require('telescope.builtin').lsp_implementations(require('telescope.themes').get_dropdown())<cr>",
	{ desc = "LSP implementations" }
)
km.set(
	"n",
	"gr",
	"<cmd>lua require('telescope.builtin').lsp_references(require('telescope.themes').get_dropdown())<cr>",
	{ desc = "LSP references" }
)

km.set(
	"n",
	"<leader>c",
	"<cmd>lua require('telescope.builtin').commands(require('telescope.themes').get_dropdown())<cr>",
	{ desc = "Commands" }
)
--km.set("n", "hn", "<Esc>:lua vim.opt.number=false vim.opt.relativenumber=false<CR>", { silent = true })
--km.set("n", "sn", "<Esc>:lua vim.opt.number=true vim.opt.relativenumber=true<CR>", { silent = true })
-- 语法信息弹窗显示，解决错误信息过长，显示不完整的问题
km.set("n", "se", "<Esc>:lua vim.diagnostic.open_float(0, {scope='line'})<CR>", { silent = true, desc = "Show diagnostic float" })

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

km.set({ "n" }, "<leader>lt", "<cmd>LLMSessionToggle<cr>", { desc = "toggleAi会话", silent = true, noremap = true })
