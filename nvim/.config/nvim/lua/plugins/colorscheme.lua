return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                transparent_background = false,
                term_colors = true,
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    treesitter = true,
                    telescope = { enabled = true },
                    which_key = true,
                    mason = true,
                    native_lsp = {
                        enabled = true,
                        underlines = {
                            errors = { "undercurl" },
                            hints = { "undercurl" },
                            warnings = { "undercurl" },
                            information = { "undercurl" },
                        },
                    },
                },
            })
            vim.cmd.colorscheme("catppuccin-mocha")
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {},
    },
}
