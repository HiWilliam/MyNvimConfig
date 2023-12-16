local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()
-- 自动执行命令组
-- plugin-setup.lua文件保存是自动执行PackerSync命令
vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
    augroup end
]])

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' --packer

  --colorscheme
  use {
     'Mofiqul/dracula.nvim',
     'folke/tokyonight.nvim',
     'marko-cerovac/material.nvim'
  }
  -- statusline
  use {
      'nvim-lualine/lualine.nvim', --statusline
      requires = { 'nvim-tree/nvim-web-devicons', opt = true } --icon
  }
  -- filetree
  use {
      'nvim-tree/nvim-tree.lua', --filetree
      requires = { 'nvim-tree/nvim-web-devicons',}, --icon
  }
  -- file sytax highlight support
  use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate'
  }
  use 'p00f/nvim-ts-rainbow' --extension treesitter

  -- filesearch and floatwindow support
  use {
      'nvim-telescope/telescope.nvim', tag = '0.1.5',
      requires = { {'nvim-lua/plenary.nvim'} },
  }
  --lsp config
  use {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'neovim/nvim-lspconfig',
  }
  --autocomplete
  use {
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip', -- snippets引擎，不装这个自动补全会出问题
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
      'hrsh7th/cmp-path', -- 文件路径
      'windwp/nvim-autopairs' --符号补全

  }

  use 'numToStr/Comment.nvim' -- gcc和gc注释
  use 'akinsho/bufferline.nvim' -- buffer分割线
  use 'lewis6991/gitsigns.nvim' -- 左则git提示
  use 'lukas-reineke/indent-blankline.nvim' -- 缩进提示
  --golang plugins
  use {
      'ray-x/go.nvim',
      'ray-x/guihua.lua'
  }

  -- terminal in nvim
  use "NvChad/nvterm"

  if packer_bootstrap then
    require('packer').sync()
  end
end)
