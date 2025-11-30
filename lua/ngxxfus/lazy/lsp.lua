--- @file lsp.lua
--- @brief Language Server Protocol (LSP) configuration
--- @details Configures LSP servers using:
---          - williamboman/mason.nvim: LSP server installer
---          - williamboman/mason-lspconfig.nvim: Mason integration with lspconfig
---          - neovim/nvim-lspconfig: LSP client configuration
--- @author ngxxfus
--- @date 2025-11-30
--- @see https://github.com/williamboman/mason.nvim
--- @see https://github.com/neovim/nvim-lspconfig

return {
  --- @section Mason Plugin
  --- @brief Package manager for LSP servers, linters, and formatters
  {
    --- @brief williamboman/mason.nvim - Portable package manager
    "williamboman/mason.nvim",
    --- @brief Use default configuration
    config = true,
  },

  --- @section Mason-LSPConfig Integration
  --- @brief Integration between mason and lspconfig
  {
    --- @brief williamboman/mason-lspconfig.nvim - mason/lspconfig bridge
    "williamboman/mason-lspconfig.nvim",
    
    --- @section Plugin Dependencies
    --- @brief Requires mason.nvim to be loaded first
    dependencies = { "mason.nvim" },

    --- @section Configuration
    --- @brief Setup mason-lspconfig
    config = function()
      --- @brief Load and setup mason-lspconfig with automatic installer
      require("mason-lspconfig").setup({
        --- @section Ensure Installed Servers
        --- @brief LSP servers to automatically ensure are installed
        ensure_installed = { "lua_ls" },
      })
    end,
  },

  --- @section LSPConfig
  --- @brief Neovim LSP client configuration
  {
    --- @brief neovim/nvim-lspconfig - Configure LSP servers
    "neovim/nvim-lspconfig",

    --- @section Configuration
    --- @brief Setup Lua language server
    config = function()
      --- @brief Get lspconfig module
      local lspconfig = require("lspconfig")
      
      --- @section Lua LS Configuration
      --- @brief Configure Lua language server with custom settings
      --- @note Ensure you have a wrapper or alias for vim.lsp.config, 
      ---       otherwise use lspconfig.lua_ls.setup({})
      vim.lsp.config('lua_ls', {
        --- @section Lua LS Settings
        --- @brief Custom settings for Lua language server
        settings = {
          --- @section Lua Configuration
          Lua = {
            --- @section Diagnostics
            --- @brief Allow 'vim' global variable to prevent warnings
            diagnostics = { globals = { "vim" } },
            
            --- @section Workspace Configuration
            workspace = { 
              --- @brief Disable third-party library check for faster loading
              checkThirdParty = false 
            },
          },
        },
      })

      --- @brief Enable the lua_ls language server
      vim.lsp.enable('lua_ls') 
    end,
  },
}