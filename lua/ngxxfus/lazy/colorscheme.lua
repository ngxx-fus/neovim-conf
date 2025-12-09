--- @file colorscheme.lua
--- @brief Colorscheme configuration for VSCode theme.
--- @author ngxxfus
--- @date 2025-12-09

return {
  {
    --- @brief The VSCode theme plugin.
    "Mofiqul/vscode.nvim",
    
    --- @brief Load immediately.
    lazy = false,
    
    --- @brief High priority to ensure UI loads correctly.
    priority = 1000,
    
    --- @brief Configure and activate the theme.
    config = function()
      --- @brief Set background to dark (or light).
      vim.o.background = 'dark'

      --- @brief Get color palette if needed for overrides.
      local c = require('vscode.colors').get_colors()

      --- @brief Setup theme options.
      require('vscode').setup({
        -- Enable transparent background
        transparent = true,

        -- Enable italic comment
        italic_comments = true,

        -- Enable italic inlay type hints
        italic_inlayhints = true,

        -- Disable nvim-tree background color
        disable_nvimtree_bg = true,

        -- Apply theme colors to terminal
        terminal_colors = true,

        -- Override highlight groups
        group_overrides = {
            Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
        }
      })

      --- @brief Enable 24-bit RGB color support.
      vim.opt.termguicolors = true

      --- @brief Apply the 'vscode' colorscheme.
      vim.cmd.colorscheme("vscode")
    end,
  },
}
