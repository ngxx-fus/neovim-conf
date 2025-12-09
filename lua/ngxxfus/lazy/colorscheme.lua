--- @file colorscheme.lua
--- @brief Colorscheme plugin configuration.
--- @details Configures the Mofiqul/vscode.nvim colorscheme.
--- @author ngxxfus
--- @date 2025-12-09
--- @see https://github.com/Mofiqul/vscode.nvim

return {
  {
    --- @brief VSCode Dark Plus theme for Neovim.
    "Mofiqul/vscode.nvim",

    --- @brief Disable lazy loading to prevent startup flash.
    lazy = false,

    --- @brief Set maximum load priority.
    priority = 1000,

    --- @brief Configure and activate the colorscheme.
    config = function()
      --- @brief Enable 24-bit RGB color support.
      vim.opt.termguicolors = true

      --- @brief Optional: Customize the theme before applying.
      -- local c = require('vscode.colors').get_colors()
      -- require('vscode').setup({
      --     transparent = true,
      --     italic_comments = true,
      --     disable_nvimtree_bg = true,
      -- })

      --- @brief Apply the 'vscode' colorscheme.
      vim.cmd("colorscheme vscode")
    end,
  },
}
