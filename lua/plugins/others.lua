-- nvterm
local nvterm_opt = {
  terminals = {
    shell = vim.o.shell,
    list = {},
    type_opts = {
      float = {
        relative = 'editor',
        row = 0.3,
        col = 0.25,
        width = 0.5,
        height = 0.4,
        border = "single",
      },
      horizontal = { location = "rightbelow", split_ratio = .3, },
      vertical = { location = "rightbelow", split_ratio = .5 },
    }
  },
  behavior = {
    autoclose_on_quit = {
      enabled = false,
      confirm = true,
    },
    close_on_exit = true,
    auto_insert = true,
  },
}

require("nvterm").setup(nvterm_opt)

-- lualine
require('lualine').setup({
    options = {
        theme = 'tokyonight'
    }
})

-- comment
require("Comment").setup()

-- blankline
require("ibl").setup()

-- autopairs
local autopairs = require("nvim-autopairs")
autopairs.setup({ fast_wrap = false, disable_filetype = { "TelescopePrompt", "vim" }})
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())

