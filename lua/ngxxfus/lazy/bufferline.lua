--[[
  @file bufferline.lua
  @brief Buffer line UI plugin configuration
  @details Configures the akinsho/bufferline.nvim plugin for displaying
           open buffers as a tab-like bar at the top of the editor.
  @author ngxxfus
  @date 2025-11-30
  @see https://github.com/akinsho/bufferline.nvim
]]

--! @section Plugin Specification
--! @brief Bufferline plugin table for lazy.nvim

return {
  {
    --! @brief akinsho/bufferline.nvim plugin
    "akinsho/bufferline.nvim",
    --! @brief Version constraint (latest)
    version = "*", 
    --! @section Plugin Dependencies
    --! @brief Required dependencies for bufferline
    dependencies = {
      --! @brief Provides icons for file types in buffers
      "nvim-tree/nvim-web-devicons"
    },
    --! @brief Load event - VeryLazy to defer loading until UI is ready
    event = "VeryLazy", 
    --! @section Configuration
    --! @brief Setup function for bufferline
    config = function()
      --! @brief Load and setup bufferline with options
      require("bufferline").setup({
        --! @section Display Options
        options = {
          --! @brief Mode: "buffers" (show open buffers) or "tabs" (show tabs)
          mode = "buffers",  
          --! @brief Show diagnostics from nvim_lsp
          diagnostics = "nvim_lsp",
          --! @brief Use slant separators between buffers
          separator_style = "slant",
          --! @brief Hide the close icon for each buffer
          show_buffer_close_icons = false,
          --! @brief Hide the close icon at the end
          show_close_icon = false,
          --! @brief Enable colored icons for file types
          color_icons = true,
        },
      })
    end,
  },
}
