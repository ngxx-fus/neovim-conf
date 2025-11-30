--- @file colorscheme.lua
--- @brief Colorscheme plugin configuration.
--- @details Configures the folke/tokyonight.nvim colorscheme for the editor.
--- @author ngxxfus
--- @date 2025-11-30
--- @see https://github.com/folke/tokyonight.nvim

return {
  {
    --- @brief A clean, dark Neovim theme written in Lua.
    "folke/tokyonight.nvim",

    --- @brief Disable lazy loading.
    --- @details Colorschemes must load immediately to prevent visual flashing during startup.
    lazy = false,

    --- @brief Set load priority to maximum.
    --- @details Ensures the colorscheme is loaded before other UI plugins.
    priority = 1000,

    --- @brief Configure and activate the colorscheme.
    config = function()
      --- @brief Enable 24-bit RGB color support in the terminal.
      vim.opt.termguicolors = true

      --- @brief Apply the 'tokyonight' colorscheme.
      vim.cmd("colorscheme tokyonight")
    end,
  },
}