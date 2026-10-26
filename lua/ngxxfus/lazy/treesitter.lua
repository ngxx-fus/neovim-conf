--- @file treesitter.lua
--- @brief Configuration for Nvim Treesitter.
--- @details Provides advanced syntax highlighting and code parsing based on the tree-sitter library.
---          Essential for accurate highlighting in C, C++, and Python.
--- @author ngxxfus
--- @date 2026-10-26

-- Return the Lazy plugin configuration table
return {
    {
        --- @brief The main Treesitter plugin repository.
        "nvim-treesitter/nvim-treesitter",

        --- @brief Update parsers when the plugin is updated.
        build = ":TSUpdate",

        --- @brief Main configuration function.
        config = function()
            local status_ok, configs = pcall(require, "nvim-treesitter.configs")
            
            -- Check if module loaded successfully
            if not status_ok then
                -- Exit configuration to prevent crash
                return
            end

            require("nvim-treesitter.install").prefer_git = true

            configs.setup({
                --- @brief List of parsers to install.
                --- @details Includes languages for C/C++, Python, Lua, and configuration formats.
                ensure_installed = {
                    "c",               -- C support
                    "cpp",             -- C++ support
                    "python",          -- Python support
                    "lua",             -- Lua support (Neovim configs)
                    "json",            -- compile_commands.json support
                    "yaml",            -- .clangd and YAML config support
                    "cmake",           -- CMake build system support
                    "vim",             -- Vimscript legacy support
                    "vimdoc",          -- Help documentation
                    "query",           -- Treesitter query language
                    "bash",            -- Shell scripting
                    "markdown",        -- Documentation
                    "markdown_inline", -- Inline markdown
                },

                --- @brief Install parsers synchronously.
                --- @details Set to false to avoid blocking the editor startup.
                sync_install = false,

                --- @brief Automatically install missing parsers when entering a buffer.
                auto_install = true,

                --- @brief Configuration for syntax highlighting.
                highlight = {
                    --- @brief Enable Treesitter-based highlighting.
                    enable = true,
                    --- @brief Disable for large files to prevent performance issues.
                    disable = function(lang, buf)
                        local max_filesize = 100 * 1024 -- 100 KB
                        local stat = (vim.uv or vim.loop).fs_stat
                        local ok, stats = pcall(stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            return true
                        end
                    end,
                    additional_vim_regex_highlighting = false,
                },

                --- @brief Configuration for indentation.
                indent = {
                    --- @brief Enable experimental indentation module.
                    enable = true,
                },
            })
        end,
    },
}
