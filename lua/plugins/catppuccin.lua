return {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    opts = {
        flavour = "macchiato",
        background = "mocha",
        term_colors = true,
        transparent_background = true,
        no_italic = true,
        integrations = {
            cmp = true,
            blink_cmp = true,
            gitsigns = true,
            nvimtree = true,
            treesitter = true,
            mason = true,
            noice = true,
            telescope = {
                enabled = true,
            },
            indent_blankline = {
                enabled = true,
                scope_color = "",
                colored_indent_levels = false,
            },
            styles = {
                comments = { "italic" },
            },
            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = { "italic" },
                    hints = { "italic" },
                    warnings = { "italic" },
                    information = { "italic" },
                },
                underlines = {
                    errors = { "underline" },
                    hints = { "underline" },
                    warnings = { "underline" },
                    information = { "underline" },
                },
                inlay_hints = {
                    background = true,
                },
            },
        },
        custom_highlights = function(colors)
            return {
                CmpBorder = { fg = "#3e4145" },
                Cursor = { fg = "#cc9900", bg = "#339966" },
                CursorLine = { bg = "#252525" },
            }
        end,
        color_overrides = {
            macchiato = {
                rosewater = "#F5B8AB",
                flamingo = "#F29D9D",
                pink = "#AD6FF7",
                mauve = "#FF8F40",
                red = "#E66767",
                maroon = "#EB788B",
                peach = "#FAB770",
                yellow = "#FACA64",
                green = "#70CF67",
                teal = "#4CD4BD",
                sky = "#61BDFF",
                sapphire = "#4BA8FA",
                blue = "#00BFFF",
                lavender = "#00BBCC",
                text = "#C1C9E6",
                subtext1 = "#A3AAC2",
                subtext0 = "#8E94AB",
                overlay2 = "#7D8296",
                overlay1 = "#676B80",
                overlay0 = "#464957",
                surface2 = "#3A3D4A",
                surface1 = "#2F313D",
                surface0 = "#1D1E29",
                base = "#0b0b12",
                mantle = "#11111a",
                crust = "#191926",
            },
        },
    },
    config = function(_, opts)
        require("catppuccin").setup(opts)
        vim.api.nvim_command("colorscheme catppuccin-macchiato")
    end,
}
