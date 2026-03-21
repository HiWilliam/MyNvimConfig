return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = true,
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "gopls", "vimls" },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "folke/neodev.nvim",
        },
        config = function()
            require("neodev").setup({})
            -- lsp common settings
            local on_attach = function(client)
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
            end
            local capabilities = {
                textDocument = {
                    foldingRange = {
                        dynamicRegistration = false,
                        lineFoldingOnly = true,
                    },
                },
                completion = {
                    completionItem = {
                        commitCharactersSupport = true,
                        tagSupport = { valueSet = { "deprecated" } },
                        resolveSupport = {
                            properties = {
                                "documentation",
                                "detail",
                                "additionalTextEdits",
                            },
                        },
                    },
                },
            }
            capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

            vim.lsp.config("lua_ls", {
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime = {
                            version = "Lua 5.1",
                            path = {
                                "lua/?.lua",
                                "lua/?/init.lua",
                                "~/.config/nvim/lua/plugins/?.lua",
                            },
                        },
                        diagnostics = { globals = { "vim" } },
                        workspace = {
                            library = { vim.api.nvim_get_runtime_file("", true), vim.env.VIMRUNTIME .. "/lua" },
                            checkThirdParty = false,
                            maxPreload = 2000,
                            preloadFileSize = 1000,
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })
            vim.lsp.enable("lua_ls")

            vim.lsp.config("vimls", {
                on_attach = on_attach,
                capabilities = capabilities,
            })

            vim.lsp.config("pyright", {
                on_attach = on_attach,
                capabilities = capabilities,
            })

            vim.lsp.config("helm_ls", {
                settings = {
                    ["helm-ls"] = {
                        yamlls = {
                            path = "yaml-language-server",
                        },
                    },
                },
            })

            vim.lsp.config("gopls", {
                on_attach = on_attach,
                capabilities = capabilities,
                cmd = { "gopls" },
                filetypes = { "go", "gomod", "gowork", "gotmpl" },
                settings = {
                    gopls = {
                        semanticTokens = true,
                        usePlaceholders = true,
                        completeUnimported = true,
                        experimentalPostfixCompletions = true,
                        analyses = {
                            bools = true,
                            printf = true,
                            unusedparams = true,
                            shadow = true,
                            analysisProgressReporting = false,
                        },
                        telemetry = {
                            enabled = false, -- 关键！禁用遥测
                        },
                    },
                },
            })
            vim.lsp.enable("gopls")

            vim.lsp.config("buf_ls", {
                cmd = { "buf", "beta", "lsp" },
                filetypes = { "proto" },
                settings = {
                    include_path = {
                        "./proto",
                        "./third-party/google/api",
                    },
                },
            })
        end,
    },
}
