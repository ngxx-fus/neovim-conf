--- @file lualine.lua
--- @brief Status line UI plugin configuration.
--- @details Configures lualine to match VSCode style (flat, global status).
--- @author ngxxfus
--- @date 2025-12-09

return {
  {
    --- @brief The main repository for the status line plugin.
    "nvim-lualine/lualine.nvim",

    --- @brief Dependencies required for rendering icons.
    dependencies = { "nvim-tree/nvim-web-devicons" },

    --- @brief Load the plugin lazily.
    event = "VeryLazy",

    --- @brief Initialize and configure the status line.
    config = function()
      require("lualine").setup({
        options = {
          --- @brief Auto-detect theme (will match vscode-light).
          theme = "auto",

          --- @brief ENABLE GLOBAL STATUS (Single bar at the bottom like VSCode).
          globalstatus = true,

          --- @brief Enable icons.
          icons_enabled = true,

          --- @brief Component separators (using a thin pipe or empty for clean look).
          component_separators = { left = '|', right = '|' },

          --- @brief Section separators (empty for flat VSCode style).
          section_separators = { left = '', right = '' },
          
          --- @brief Disable status line for specific file types.
          disabled_filetypes = {
             statusline = { 'dashboard', 'alpha', 'starter' },
          },
        },
        
        --- @brief Customize sections to show useful info.
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 
            { 
              'filename', 
              path = 1 -- Show relative path (e.g., lua/lazy/lualine.lua) 
            } 
          },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
      })
    end,
  },
}
