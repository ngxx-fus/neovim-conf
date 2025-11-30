--- @file init.lua
--- @brief Core Neovim configuration bootstrap module
--- @details Orchestrates the initialization of all configuration modules including:
---          - Base settings and options
---          - Keybindings
---          - Lazy plugin manager
---          - Individual plugin configurations
--- @author ngxxfus
--- @date 2025-11-30
--- @note Load order is critical: set -> remap -> lazy_init -> plugin configs

--- @brief Set global map leader to Space
--- @details This must be defined before any keymaps or plugins are loaded to ensure
---          mappings using <leader> work correctly.
vim.g.mapleader = " "

--- @section Core Configuration

--- @brief Load base editor settings (options, booleans)
require("ngxxfus.set")

--- @brief Load global keybindings and remappings
require("ngxxfus.remap")

--- @section Plugin Management

--- @brief Bootstrap and initialize Lazy.nvim plugin manager
require("ngxxfus.lazy_init")

--- @section Plugin Configurations

--- @brief Load UI icons configuration
require("ngxxfus.lazy.icons")

--- @brief Configure auto-completion engine (nvim-cmp)
--- @note Depends on snippet engine and LSP sources
require("ngxxfus.lazy.cmp")

--- @brief Configure Language Server Protocol (LSP) settings
--- @note Should be loaded before components that depend on LSP (like pickers)
require("ngxxfus.lazy.lsp")

--- @brief Configure Telescope fuzzy finder
require("ngxxfus.lazy.telescope")