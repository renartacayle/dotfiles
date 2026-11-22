-- ==============================================================================
-- Neovim Modular Configuration Entrypoint
-- ==============================================================================

-- Map leader key sebelum load plugins
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load konfigurasi core
require("config.options")
require("config.keymaps")
require("config.lazy")
