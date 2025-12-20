--- @file set.lua
--- @brief Neovim editor settings and options configuration.
--- @details Configures global options for interface, indentation, and behavior.
--- @author ngxxfus
--- @date 2025-11-30

--- @brief Uncomment to use tokyonight colorscheme.
-- vim.cmd.colorscheme("tokyonight")

--- @brief Enable 24-bit RGB color in the terminal.
vim.opt.termguicolors = true

--- @brief Enable line numbers.
vim.opt.nu = true

--- @brief Show relative line numbers.
vim.opt.relativenumber = true

--- @brief Sync with system clipboard (requires xclip or similar).
vim.opt.clipboard = 'unnamedplus'

--- @brief Number of spaces that a <Tab> in the file counts for.
vim.opt.tabstop = 4

--- @brief Number of spaces that a <Tab> counts for while editing.
vim.opt.softtabstop = 4

--- @brief Number of spaces to use for each step of (auto)indent.
vim.opt.shiftwidth = 4

--- @brief Use spaces instead of tabs.
vim.opt.expandtab = true

--- @brief Do smart autoindenting when starting a new line.
vim.opt.smartindent = true

--- @brief Disable line wrapping.
vim.opt.wrap = false

--- @brief Show search matches as you type.
vim.opt.incsearch = true

vim.opt.termguicolors = true

-- /// Create an autocommand to override cursor color on ColorScheme event
-- vim.api.nvim_create_autocmd("ColorScheme", {
--     pattern = "*",
--     callback = function()
--         -- /// Set cursor background to Red (#FF0000) and text to White (#FFFFFF)
--         vim.api.nvim_set_hl(0, "Cursor", { bg = "#9CC6DB", fg = "#234C6A" })
-- 
--         -- /// Force Neovim to use the 'Cursor' highlight group for Normal, Visual, and Command modes
--         -- vim.opt.guicursor = "n-v-c-i-t:block-Cursor"
--         vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25"
--     end,
-- })

