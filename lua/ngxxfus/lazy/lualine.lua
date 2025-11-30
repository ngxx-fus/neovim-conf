--- @file lualine.lua
--- @brief Status line UI plugin configuration.
--- @details Configures the nvim-lualine status line to show editor mode, 
---          filename, line numbers, and git status.
--- @author ngxxfus
--- @date 2025-11-30
--- @see https://github.com/nvim-lualine/lualine.nvim

return {
  {
    --- @brief The main repository for the status line plugin.
    "nvim-lualine/lualine.nvim",

    --- @brief Dependencies required for rendering icons.
    dependencies = {
      --- @brief Provides file type icons for the status line.
      "nvim-tree/nvim-web-devicons"
    },

    --- @brief Load the plugin lazily after startup to improve launch time.
    event = "VeryLazy",

    --- @brief Initialize and configure the status line.
    config = function()
      require("lualine").setup({
        options = {
          --- @brief Automatically select a theme based on the active colorscheme.
          theme = "auto",

          --- @brief Enable the use of Nerd Font icons in the status line.
          icons_enabled = true,

          --- @brief Define visual separators between major sections.
          --- @details Set to empty strings for a flat, modern look without arrows.
          section_separators = { left = "", right = "" },

          --- @brief Define visual separators between components within a section.
          component_separators = { left = "", right = "" },
        },
      })
    end,
  },
}