--- @file mason.lua
--- @brief LSP Installer and Manager configuration.
--- @details Manages external editor tooling.
---          NOTE: Config split into two blocks to ensure correct load order.
--- @author ngxxfus
--- @date 2025-11-30

return {
  -- Block 1: Mason Core (Must setup first)
  {
    --- @brief The core Mason plugin (Package Manager).
    "williamboman/mason.nvim",
    
    --- @brief Load immediately to prevent ordering issues.
    lazy = false,
    
    --- @brief Setup function for Mason core.
    config = function()
      require("mason").setup()
    end,
  },

  -- Block 2: Mason LSP Config (Depends on Mason)
  {
    --- @brief Extension to bridge Mason with nvim-lspconfig.
    "williamboman/mason-lspconfig.nvim",
    
    --- @brief Explicitly declare dependencies to ensure load order.
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },

    --- @brief Main configuration for LSP servers.
    config = function()
      --- @brief Configure the bridge.
      --- @details Only runs after Mason is fully set up.
      require("mason-lspconfig").setup({
        --- @brief List of servers to automatically install.
        ensure_installed = {
          "clangd",       -- C/C++
          "pyright",      -- Python
          "lua_ls",       -- Lua
          "bashls",       -- Bash
        },

        --- @brief Automatic setup handler.
        --- @details Applies default config to all installed servers.
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({})
          end,
        },
      })
    end,
  }
}