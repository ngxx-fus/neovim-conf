--- @file set.lua
--- @brief Neovim editor settings and options configuration.
--- @details Configures global options for interface, indentation, search, and clipboard.
---          Keybindings have been extracted and migrated to `remap.lua`.
--- @author ngxxfus
--- @date 2026-10-26

-- Ensure user site directory is included in runtimepath
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/site")

--- @section Colors & Theme
--- @brief Uncomment to use tokyonight colorscheme.
-- vim.cmd.colorscheme("tokyonight")

--- @brief Enable 24-bit RGB colors in the terminal.
vim.opt.termguicolors = true

--- @section Interface & Line Numbers
--- @brief Enable line numbers.
vim.opt.nu = true

--- @brief Disable relative line numbers (set to true if relative numbers are preferred).
vim.opt.relativenumber = false

--- @brief Disable line wrapping for cleaner code view.
vim.opt.wrap = false

--- @section Search Options
--- @brief Show search matches incrementally as you type.
vim.opt.incsearch = true

--- @section Clipboard Integration
--- @brief Sync with system clipboard (requires xclip, wl-clipboard, or equivalent).
vim.opt.clipboard = "unnamedplus"

--- @section Indentation Options
--- @brief Number of spaces that a <Tab> in the file counts for.
vim.opt.tabstop = 4

--- @brief Number of spaces that a <Tab> counts for while editing.
vim.opt.softtabstop = 4

--- @brief Number of spaces to use for each step of auto-indentation.
vim.opt.shiftwidth = 4

--- @brief Convert tabs to spaces.
vim.opt.expandtab = true

--- @brief Enable smart autoindenting when starting a new line.
vim.opt.smartindent = true
