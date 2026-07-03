local opt = vim.opt

vim.deprecated = function() end

opt.syntax = "on"

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.autoindent = true

opt.number = true
opt.relativenumber = true

-- 光标
opt.cursorline = true

-- 开启鼠标
opt.mouse = ""
-- 启用系统粘贴板 with ssh remote
vim.g.clipboard = {
	name = "OSC 52",
	copy = {
		["+"] = require("vim.ui.clipboard.osc52").copy("+"),
		["*"] = require("vim.ui.clipboard.osc52").copy("*"),
	},
	paste = {
		["+"] = require("vim.ui.clipboard.osc52").paste("+"),
		["*"] = require("vim.ui.clipboard.osc52").paste("*"),
	},
}

-- 搜索 忽略大小写
opt.ignorecase = true
opt.smartcase = true

-- 颜色
opt.termguicolors = true

-- NvimTree Loaded
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.tmux_navigator_no_mappings = 1

-- 折叠
opt.foldenable = true
opt.foldmethod = "manual"

vim.api.nvim_set_hl(0, "@foo.bar", { link = "Identifier" })
