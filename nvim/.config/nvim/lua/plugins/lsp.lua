return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local lspconfig = require("lspconfig")
            local mason = require("mason")
            local mason_lspconfig = require("mason-lspconfig")
            local cmp_nvim_lsp = require("cmp_nvim_lsp")

            mason.setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })

            local capabilities = cmp_nvim_lsp.default_capabilities()

            local on_attach = function(_, bufnr)
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
                end

                map("gd", vim.lsp.buf.definition, "Go to Definition")
                map("gD", vim.lsp.buf.declaration, "Go to Declaration")
                map("gr", vim.lsp.buf.references, "Go to References")
                map("gi", vim.lsp.buf.implementation, "Go to Implementation")
                map("K", vim.lsp.buf.hover, "Hover Documentation")
                map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
                map("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
                map("<leader>cf", function()
                    vim.lsp.buf.format({ async = true })
                end, "Format Document")
                map("[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
                map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
            end

            -- Setup diagnostic visual icons
            local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            vim.diagnostic.config({
                virtual_text = { prefix = "●" },
                update_in_insert = false,
                underline = true,
                severity_sort = true,
                float = { border = "rounded" },
            })

            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = { globals = { "vim" } },
                            workspace = { checkThirdParty = false },
                            telemetry = { enable = false },
                        },
                    },
                },
                bashls = {},
                pyright = {},
                ts_ls = {},
                gopls = {},
                rust_analyzer = {},
            }

            mason_lspconfig.setup({
                ensure_installed = vim.tbl_keys(servers),
                automatic_installation = true,
            })

            mason_lspconfig.setup_handlers({
                function(server_name)
                    local server_opts = servers[server_name] or {}
                    server_opts.capabilities = capabilities
                    server_opts.on_attach = on_attach
                    lspconfig[server_name].setup(server_opts)
                end,
            })
        end,
    },
}
