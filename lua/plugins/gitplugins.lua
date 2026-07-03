return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "+" },
					change = { text = "c" },
					delete = { text = "-" },
					topdelete = { text = "-" },
					changedelete = { text = "-" },
					untracked = { text = "u" },
				},
				current_line_blame = false,
				on_attach = function(bufnr)
					local function map(mode, lhs, rhs, opts)
						opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
						vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
					end

					-- Navigation
					map("n", "]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
					map("n", "[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

					-- Actions
					map("n", "<leader>hs", ":Gitsigns stage_hunk<CR>")
					map("v", "<leader>hs", ":Gitsigns stage_hunk<CR>")
					map("n", "<leader>hr", ":Gitsigns reset_hunk<CR>")
					map("v", "<leader>hr", ":Gitsigns reset_hunk<CR>")
					map("n", "<leader>hS", "<cmd>Gitsigns stage_buffer<CR>")
					map("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<CR>")
					map("n", "<leader>hR", "<cmd>Gitsigns reset_buffer<CR>")
					map("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>")
					map("n", "<leader>hb", '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
					map("n", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<CR>")
					map("n", "<leader>hd", "<cmd>Gitsigns diffthis<CR>")
					map("n", "<leader>hD", '<cmd>lua require"gitsigns".diffthis("~")<CR>')
					---					map("n", "<leader>td", "<cmd>Gitsigns toggle_deleted<CR>")

					-- Text object
					map("o", "ih", ":<C-U>Gitsigns select_hunk<CR>")
					map("x", "ih", ":<C-U>Gitsigns select_hunk<CR>")
				end,
			})
		end,
	},
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{
				"<leader>g",
				function()
					vim.cmd("LazyGit")
					-- 锁定浮窗 buffer 为不可修改，防止 vim.schedule 延迟期间按键污染 buffer
					-- 导致 jobstart({term=true}) 报 "requires unmodified buffer"
					if vim.bo.filetype == "lazygit" then
						vim.bo.buflisted = false
						vim.bo.modifiable = false
						-- 延迟解锁: jobstart 执行后会自动接管 buffer
						vim.defer_fn(function()
							if vim.api.nvim_buf_is_valid(0) then
								vim.bo.modifiable = true
							end
						end, 100)
					end
				end,
				desc = "LazyGit",
			},
		},
		config = function() end,
	},
	{
		"sindrets/diffview.nvim",
		lazy = true,
		cmd = {
			"DiffviewOpen",
		},
		config = function()
			local actions = require("diffview.actions")
			require("diffview").setup({
				view = {
					merge_tool = {
						layout = "diff3_mixed",
					},
				},
				keymaps = {
					view = {
						-- The `view` bindings are active in the diff buffers, only when the current
						-- tabpage is a Diffview.
						{
							"n",
							"<tab>",
							actions.select_next_entry,
							{ desc = "Open the diff for the next file" },
						},
						{
							"n",
							"<s-tab>",
							actions.select_prev_entry,
							{ desc = "Open the diff for the previous file" },
						},
						{
							"n",
							"[F",
							actions.select_first_entry,
							{ desc = "Open the diff for the first file" },
						},
						{
							"n",
							"]F",
							actions.select_last_entry,
							{ desc = "Open the diff for the last file" },
						},
						{
							"n",
							"gf",
							actions.goto_file_edit,
							{ desc = "Open the file in the previous tabpage" },
						},
						{
							"n",
							"<C-w><C-f>",
							actions.goto_file_split,
							{ desc = "Open the file in a new split" },
						},
						{
							"n",
							"<C-w>gf",
							actions.goto_file_tab,
							{ desc = "Open the file in a new tabpage" },
						},
						{
							"n",
							"<leader>e",
							actions.focus_files,
							{ desc = "Bring focus to the file panel" },
						},
						{
							"n",
							"<leader>b",
							actions.toggle_files,
							{ desc = "Toggle the file panel." },
						},
						{
							"n",
							"g<C-x>",
							actions.cycle_layout,
							{ desc = "Cycle through available layouts." },
						},
						{
							"n",
							"[x",
							actions.prev_conflict,
							{ desc = "In the merge-tool: jump to the previous conflict" },
						},
						{
							"n",
							"]x",
							actions.next_conflict,
							{ desc = "In the merge-tool: jump to the next conflict" },
						},
						{
							"n",
							"co",
							actions.conflict_choose("ours"),
							{ desc = "Choose the OURS version of a conflict" },
						},
						{
							"n",
							"ct",
							actions.conflict_choose("theirs"),
							{ desc = "Choose the THEIRS version of a conflict" },
						},
						{
							"n",
							"cb",
							actions.conflict_choose("base"),
							{ desc = "Choose the BASE version of a conflict" },
						},
						{
							"n",
							"ca",
							actions.conflict_choose("all"),
							{ desc = "Choose all the versions of a conflict" },
						},
						{
							"n",
							"dx",
							actions.conflict_choose("none"),
							{ desc = "Delete the conflict region" },
						},
						{
							"n",
							"cO",
							actions.conflict_choose_all("ours"),
							{ desc = "Choose the OURS version of a conflict for the whole file" },
						},
						{
							"n",
							"cT",
							actions.conflict_choose_all("theirs"),
							{ desc = "Choose the THEIRS version of a conflict for the whole file" },
						},
						{
							"n",
							"cB",
							actions.conflict_choose_all("base"),
							{ desc = "Choose the BASE version of a conflict for the whole file" },
						},
						{
							"n",
							"cA",
							actions.conflict_choose_all("all"),
							{ desc = "Choose all the versions of a conflict for the whole file" },
						},
						{
							"n",
							"dX",
							actions.conflict_choose_all("none"),
							{ desc = "Delete the conflict region for the whole file" },
						},
					},
				},
			})
		end,
	},
}
