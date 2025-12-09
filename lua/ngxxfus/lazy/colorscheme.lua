--- @file colorscheme.lua
--- @brief VSCode theme configuration.
--- @details Configures the Mofiqul/vscode.nvim colorscheme.
--- @author ngxxfus
--- @date 2025-12-09

return {
  {
    --- @brief The VSCode theme plugin.
    "Mofiqul/vscode.nvim",

    --- @brief Load immediately.
    lazy = false,

    --- @brief High priority to ensure UI looks right on startup.
    priority = 1000,

    --- @brief Configure the theme options.
    config = function()
      --- @brief Set background to dark (can be 'light').
      vim.o.background = 'light'

      --- @brief Get color palette for overrides (optional).
      local c = require('vscode.colors').get_colors()

      --- @brief Setup theme options.
      require('vscode').setup({
        --- @brief Enable transparent background.
        transparent = true,

        --- @brief Enable italic comments.
        italic_comments = true,

        --- @brief Underline links.
        underline_links = true,

        --- @brief Disable nvim-tree background to match transparency.
        disable_nvimtree_bg = true,

        --- @brief Apply colors to the internal terminal.
        terminal_colors = true,

        --- @brief Override specific highlight groups.
        group_overrides = {
          -- Example: Make cursor bold with specific colors
          Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
        },
      })

      --- @brief Activate the colorscheme.
      vim.cmd.colorscheme "vscode"
    end,
  },
}
