-- mason's settings
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})

require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "gopls" },
})

-- lsp common settings
local on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    },
}

local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
        },
    },
})

lspconfig.gopls.setup({
    on_attach = on_attach,
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
