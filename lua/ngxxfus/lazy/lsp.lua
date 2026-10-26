--- @file lsp.lua
--- @brief Language Server Protocol (LSP) configuration
--- @details Configures Language Server Protocol (LSP) clients for Neovim:
---          - C/C++: clangd (with support for scanning .clangd/compile_commands.json)
---          - Lua: lua_ls
---          - Python: pyright
---          Integrated with:
---          - `williamboman/mason.nvim`: Portable package manager for LSP servers
---          - `williamboman/mason-lspconfig.nvim`: Bridge between Mason and nvim-lspconfig
---          - `neovim/nvim-lspconfig`: Quickstart configs for Nvim LSP client
---          - `hrsh7th/cmp-nvim-lsp`: LSP source for nvim-cmp
--- @author ngxxfus
--- @date 2026-10-26

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            -- 1. Initialize Mason package manager
            require("mason").setup()

            local lspconfig = require("lspconfig")
            local util = require("lspconfig.util")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- 2. Configure UI borders and diagnostics display
            vim.o.winborder = "rounded"
            vim.diagnostic.config({
                float = { border = "single" },
            })

            -- 3. Define buffer-local keymaps when LSP attaches to a buffer
            local on_attach = function(client, bufnr)
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, {
                        buffer = bufnr,
                        noremap = true,
                        silent = true,
                        desc = "LSP: " .. desc,
                    })
                end

                -- Navigation keybindings
                map("gd", vim.lsp.buf.definition, "Go to Definition")
                map("gD", vim.lsp.buf.declaration, "Go to Declaration")
                map("gi", vim.lsp.buf.implementation, "Go to Implementation")
                map("gr", vim.lsp.buf.references, "Go to References")

                -- Documentation & Information
                map("K", vim.lsp.buf.hover, "Hover Documentation")
                map("<leader>k", vim.lsp.buf.signature_help, "Signature Help")

                -- Code Refactoring & Actions
                map("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
                map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
                map("<leader>f", function()
                    vim.lsp.buf.format({ async = true })
                end, "Format Document")
            end

            -- 4. Server-specific configurations
            local servers = {
                --- @section Lua LSP Configuration (lua_ls)
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = {
                                version = "LuaJIT",
                            },
                            diagnostics = {
                                globals = { "vim" },
                            },
                            workspace = {
                                checkThirdParty = false,
                                library = {
                                    vim.env.VIMRUNTIME,
                                },
                            },
                            telemetry = {
                                enable = false,
                            },
                        },
                    },
                },

                --- @section Python LSP Configuration (pyright)
                pyright = {
                    settings = {
                        python = {
                            analysis = {
                                autoSearchPaths = true,
                                useLibraryCodeForTypes = true,
                                diagnosticMode = "openFilesOnly",
                            },
                        },
                    },
                },

                --- @section C/C++ LSP Configuration (clangd)
                --- Configured to detect compilation databases including .clangd/compile_commands.json
                clangd = {
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--completion-style=detailed",
                        "--header-insertion=never",
                        "--function-arg-placeholders",
                        "--clang-tidy",
                        "--query-driver=/**/*gcc*,/**/*g++*,/**/*clang*",
                    },
                    capabilities = {
                        -- Avoid encoding conflict warnings between clangd and other plugins
                        offsetEncoding = { "utf-16" },
                    },
                    root_dir = function(fname)
                        -- Detect project root by common markers including .clangd folder and compile_commands.json
                        return util.root_pattern(
                            ".clangd",
                            "compile_commands.json",
                            "compile_flags.txt",
                            ".clang-tidy",
                            ".clang-format",
                            "build",
                            ".git"
                        )(fname) or util.find_git_ancestor(fname) or vim.fs.dirname(fname)
                    end,
                    on_new_config = function(new_config, new_root_dir)
                        -- Chain default handler if available in lspconfig
                        local default_on_new_config = lspconfig.clangd.default_config
                            and lspconfig.clangd.default_config.on_new_config
                        if default_on_new_config then
                            default_on_new_config(new_config, new_root_dir)
                        end

                        if not new_root_dir then
                            return
                        end

                        local stat = (vim.uv or vim.loop).fs_stat

                        -- Check if compile_commands.json exists inside .clangd/ or build/
                        local compile_commands_path = nil
                        if stat(new_root_dir .. "/.clangd/compile_commands.json") then
                            compile_commands_path = new_root_dir .. "/.clangd"
                        elseif stat(new_root_dir .. "/build/compile_commands.json") then
                            compile_commands_path = new_root_dir .. "/build"
                        end

                        if compile_commands_path then
                            -- Clone command table to avoid mutating the shared base configuration
                            new_config.cmd = vim.list_extend({}, new_config.cmd)

                            -- Check if --compile-commands-dir is already present
                            local has_dir_flag = false
                            for _, arg in ipairs(new_config.cmd) do
                                if type(arg) == "string" and arg:match("^%-%-compile%-commands%-dir") then
                                    has_dir_flag = true
                                    break
                                end
                            end

                            if not has_dir_flag then
                                table.insert(
                                    new_config.cmd,
                                    "--compile-commands-dir=" .. compile_commands_path
                                )
                            end
                        end
                    end,
                },
            }

            -- 5. Mason-LSPConfig integration and automatic setup
            require("mason-lspconfig").setup({
                ensure_installed = { "clangd", "lua_ls", "pyright" },
                handlers = {
                    function(server_name)
                        local server_opts = servers[server_name] or {}
                        server_opts.on_attach = on_attach
                        -- Merge server capabilities with cmp-nvim-lsp defaults
                        server_opts.capabilities = vim.tbl_deep_extend(
                            "force",
                            capabilities,
                            server_opts.capabilities or {}
                        )
                        lspconfig[server_name].setup(server_opts)
                    end,
                },
            })
        end,
    },
}
