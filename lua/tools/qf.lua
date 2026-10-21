-- quickfix 列表历史（搜索结果回溯）
--
-- 每次 <leader>r 搜索后按 <M-q>，telescope 都会用 setqflist() 生成一份新的
-- quickfix 列表（标题形如 "Live Grep (关键字)"），旧列表被压进 quickfix 栈，
-- 最多保留 10 份。这里提供在这些历史列表之间来回切换的入口：
--   等价于 :colder / :cnewer，但会在 Trouble 打开时同步刷新面板
--   （:colder / :cnewer 不会触发 QuickFixCmdPost，Trouble 不会自动刷新）。
local M = {}

--- 当前 quickfix 列表的标题
---@return string
function M.title()
	local info = vim.fn.getqflist({ nr = 0, title = 1 })
	if info and info.title and info.title ~= "" then
		return info.title
	end
	return ("quickfix #%d"):format(info and info.nr or 0)
end

--- 只刷新已经打开着的 Trouble 面板。
--- 用 package.loaded 判断，避免为了刷新反而把 lazy 的 trouble 拉起来。
local function refresh_trouble()
	local trouble = package.loaded["trouble"]
	if not trouble then
		return
	end
	pcall(function()
		if trouble.is_open({ mode = "qflist" }) then
			trouble.refresh({ mode = "qflist" })
		end
	end)
end

---@param dir "older"|"newer"
---@return boolean ok
local function switch(dir)
	return pcall(vim.cmd, "silent " .. (dir == "older" and "colder" or "cnewer"))
end

---@param dir "older"|"newer"
local function warn(dir)
	vim.notify(
		dir == "older" and "已经是最早的一份搜索结果了" or "已经是最新的一份搜索结果了",
		vim.log.levels.WARN
	)
end

---@param dir "older"|"newer"
local function switch_and_notify(dir)
	if not switch(dir) then
		return warn(dir)
	end
	refresh_trouble()
	vim.notify("quickfix 历史 → " .. M.title(), vim.log.levels.INFO)
end

--- 切到上一份（更早的）搜索结果列表
function M.older()
	switch_and_notify("older")
end

--- 切到下一份（更新的）搜索结果列表
function M.newer()
	switch_and_notify("newer")
end

--- Trouble 面板内的按键：切完顺手刷新当前视图
---@param view table trouble.View
---@param dir "older"|"newer"
function M.switch_view(view, dir)
	if not switch(dir) then
		return warn(dir)
	end
	pcall(function()
		view:refresh()
	end)
	vim.notify("quickfix 历史 → " .. M.title(), vim.log.levels.INFO)
end

--- Telescope 浏览：列出所有历史搜索结果，回车看该次搜索的命中项，
--- <M-q> 把选中的列表设为当前列表并直接在 Trouble 里打开。
function M.picker()
	local ok, builtin = pcall(require, "telescope.builtin")
	if not ok then
		vim.notify("Telescope 未安装", vim.log.levels.ERROR)
		return
	end
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	builtin.quickfixhistory({
		prompt_title = "Quickfix 历史（搜索结果）",
		attach_mappings = function(prompt_bufnr, map)
			local function use_list(pb)
				local entry = action_state.get_selected_entry()
				actions.close(pb)
				if not entry or not entry.nr then
					return
				end
				-- {nr}chistory 切到该历史列表；之后打开 Trouble 会读取当前列表
				pcall(vim.cmd, "silent " .. entry.nr .. "chistory")
				vim.cmd("Trouble qflist")
				vim.notify("当前 quickfix → " .. M.title(), vim.log.levels.INFO)
			end

			map({ "i", "n" }, "<M-q>", use_list)
			return true
		end,
	})
end

return M
