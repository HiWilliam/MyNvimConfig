return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        opts = {
            ensure_installed = {
                "lua-language-server",
                "shellcheck",
            },
        },
        config = function(_, opts)
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })

            local mr = require("mason-registry")
            local function ensure_installed()
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end
            if mr.refresh then
                mr.refresh(ensure_installed)
            else
                ensure_installed()
            end
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "saghen/blink.cmp",
        },
        config = function()
            vim.diagnostic.config({
                underline = false,
                signs = false,
                update_in_insert = false,
                virtual_text = { spacing = 2, prefix = "●" },
                severity_sort = true,
                float = {
                    border = "rounded",
                },
            })

            local capabilities = require("blink.cmp").get_lsp_capabilities()
            local lspconfig = require("lspconfig")

            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                workspace = {
                    library = {
                        ["/usr/local/lib/lua"] = true,
                        [vim.fn.expand("$LUA_CPATH")] = true,
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                        [vim.fn.expand(vim.fn.stdpath("data") .. "/site/pack/packer/start/?")] = true,
                    },
                    maxPreload = 100000,
                    preloadFileSize = 10000,
                },
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })

            lspconfig.vimls.setup({
                capabilities = capabilities,
            })
            lspconfig.shellcheck.setup({
                capabilities = capabilities,
            })
            lspconfig.helm_ls.setup({
                settings = {
                    ["helm-ls"] = {
                        yamlls = {
                            path = "yaml-language-server",
                        },
                    },
                },
            })

            lspconfig.intelephense.setup({
                capabilities = capabilities,
                cmd = { "intelephense", "--stdio" },
                filetypes = { "php" },
                settings = {},
            })

            lspconfig.gopls.setup({
                capabilities = capabilities,
                cmd = { "gopls" },
                filetypes = { "go", "gomod", "gowork", "gotmpl" },
                settings = {
                    gopls = {
                        usePlaceholders = true,
                        completeUnimported = true,
                        experimentalPostfixCompletions = true,
                        analyses = {
                            bools = true,
                            printf = true,
                            unusedparams = true,
                            shadow = true,
                        },
                        staticcheck = true,
                    },
                },
            })
        end,
    },
    { "towolf/vim-helm", ft = "helm" },
}
