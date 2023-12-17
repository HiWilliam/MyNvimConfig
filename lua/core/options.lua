local opt = vim.opt

-- 设置缩进长度
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.autoindent = true

-- 显示行数/相对行数
opt.number = true
opt.relativenumber = true

-- 防止包裹
opt.wrap = false

-- 光标行
opt.cursorline = true

-- 开启鼠标

opt.mouse = ""
-- 启用系统粘贴板
opt.clipboard = ""

--opt.splitright = true
--opt.splitbelow = true
--
-- 搜索
opt.ignorecase = true
opt.smartcase = true

-- 颜色
opt.termguicolors = true
vim.cmd([[colorscheme tokyonight-moon]])
-- vim.g.material_style = "deep ocean"
