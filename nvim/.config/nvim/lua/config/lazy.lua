-- ==============================================================================
-- Bootstrap & Setup lazy.nvim Plugin Manager
-- ==============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        -- Starter Plugins
        { "folke/which-key.nvim", event = "VeryLazy" },
        {
            "catppuccin/nvim",
            name = "catppuccin",
            priority = 1000,
            config = function()
                vim.cmd.colorscheme("catppuccin-mocha")
            end,
        },
    },
    defaults = {
        lazy = false,
        version = false,
    },
    install = { colorscheme = { "catppuccin-mocha", "habamax" } },
    checker = { enabled = false },
    change_detection = { notify = false },
})
