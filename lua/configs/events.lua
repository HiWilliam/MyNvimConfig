-- 确保插件已加载
local diffview_loaded = false
-- 只打开一次
local diffview_opened = false
vim.api.nvim_create_autocmd("User", {
	pattern = "DiffviewLoaded",
	callback = function()
		diffview_loaded = true
	end,
	once = true,
})

-- 检查合并冲突并打开Diffview的函数
local function check_and_open_diffview()
	-- 检查是否在Git仓库中
	local is_git = vim.fn.systemlist("git rev-parse --is-inside-work-tree")[1]
	if is_git ~= "true" then
		return
	end

	local conflicts = vim.fn.systemlist("git diff --name-only --diff-filter=U")
	-- 检查是否有未解决的合并冲突
	if #conflicts > 0 then
		if diffview_loaded == false then
			require("lazy").load({ plugins = "diffview.nvim" })
			diffview_loaded = true
		end

		if diffview_loaded and diffview_opened == false then
			-- 延迟执行以确保插件完全加载
			vim.defer_fn(function()
				vim.cmd("DiffviewOpen")
			end, 100)
			diffview_opened = true
		end
	end
end

-- 设置自动命令
vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter" }, {
	callback = check_and_open_diffview,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "DiffviewViewClosed", -- 当 diffview 窗口关闭时触发
	callback = function()
		vim.fn.system("echo 1111 > text")
		-- 检查当前文件是否有冲突标记
		local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
		if not content:match("<<<<<<<") then -- 如果没有冲突标记（已解决）
			vim.cmd("write") -- 保存文件
			-- 或者使用系统 git 命令：
			local file = vim.fn.expand("%")
			print(file)

			vim.fn.system("echo " .. file .. " > text")
			vim.fn.system("git add " .. file)
		end
	end,
})
