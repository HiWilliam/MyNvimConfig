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
--km.set("n", "<leader>a", "<cmd>Telescope<CR>", { desc = "Telescope" })
km.set("n", "<leader>f", function()
	require("telescope.builtin").find_files()
end, { desc = "Find files" })
km.set("n", "<leader>r", function()
	require("telescope.builtin").live_grep({
		attach_mappings = function(prompt_bufnr, map)
			-- <M-q>: 全部命中写入 quickfix，并用 trouble 面板常驻展示
			map({ "i", "n" }, "<M-q>", function()
				require("telescope.actions").send_to_qflist(prompt_bufnr)
				vim.schedule(function()
					-- 走 :Trouble 命令，确保 lazy.nvim 的 trouble 能被正确加载
					vim.cmd("Trouble qflist")
				end)
			end)
			return true
		end,
	})
end, { desc = "Live grep" })
-- 历史搜索结果：每次 <leader>r + <M-q> 都是一份独立的 quickfix 列表
-- 面板里再用 <C-p>/<C-n> 在这份 quickfix 栈里前后翻
km.set("n", "<leader>R", function()
	require("tools.qf").picker()
end, { desc = "搜索结果历史" })
km.set("n", "<leader>b", function()
	require("telescope.builtin").buffers()
end, { desc = "Buffers" })
km.set("n", "<leader>o", function()
	require("telescope.builtin").oldfiles()
end, { desc = "Old files" })

-- show the change blocks
km.set("n", "<leader>gu", "<Esc><cmd> Gitsigns setqflist all open=false <CR> | <cmd>Telescope quickfix<CR>", {})
km.set("n", "<leader>gs", function()
	require("telescope.builtin").git_status()
end, { desc = "Git status" })
km.set("n", "<leader>l", function()
	require("telescope.builtin").loclist()
end, { desc = "Location list" })
km.set("n", "<leader>q", function()
	require("telescope.builtin").diagnostics()
end, { desc = "Diagnostics" })

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
km.set(
	"n",
	"se",
	"<Esc>:lua vim.diagnostic.open_float(0, {scope='line'})<CR>",
	{ silent = true, desc = "Show diagnostic float" }
)

km.set("t", "<esc>", "<C-\\><C-n>", { noremap = true })
km.set("t", "<C-h>", [[<C-\\><C-N><C-W>h]], { noremap = true, silent = true })
km.set("t", "<C-j>", [[<C-\><C-n><C-W>j]], { noremap = true, silent = true })
km.set("t", "<C-k>", [[<C-\><C-n><C-W>k]], { noremap = true, silent = true })
km.set("t", "<C-l>", [[<C-\><C-n><C-W>l]], { noremap = true, silent = true })

km.set(
	{ "n", "i", "v" },
	"<C-h>",
	"<cmd>TmuxNavigateLeft<cr>",
	{ noremap = true, silent = true, desc = "Move to Left Window" }
)
km.set(
	{ "n", "i", "v" },
	"<C-j>",
	"<cmd>TmuxNavigateDown<cr>",
	{ noremap = true, silent = true, desc = "Move to Lower Window" }
)
km.set(
	{ "n", "i", "v" },
	"<C-k>",
	"<cmd>TmuxNavigateUp<cr>",
	{ noremap = true, silent = true, desc = "Move to Upper Window" }
)
km.set(
	{ "n", "i", "v" },
	"<C-l>",
	"<cmd>TmuxNavigateRight<cr>",
	{ noremap = true, silent = true, desc = "Move to Right Window" }
)

-- dst（dsh-tui）浮动终端，再次按下收起
km.set("n", "<leader>ad", function()
	require("tools.dst").toggle()
end, { silent = true, desc = "Open dst (float)" })
