--- @file bufferline.lua
--- @brief Buffer line UI plugin configuration
--- @details Configures the akinsho/bufferline.nvim plugin compatible with VSCode theme.
--- @author ngxxfus
--- @date 2025-12-09

return {
  {
    --- @brief akinsho/bufferline.nvim plugin
    "akinsho/bufferline.nvim",
    
    --- @brief Version constraint (latest)
    version = "*", 
    
    --- @brief Required dependencies for bufferline
    dependencies = { "nvim-tree/nvim-web-devicons" },
    
    --- @brief Load event - VeryLazy
    event = "VeryLazy", 
    
    --- @brief Setup function for bufferline
    config = function()
      require("bufferline").setup({
        --- @section Display Options (Giữ nguyên cấu hình cũ của bạn)
        options = {
          mode = "buffers",
          diagnostics = "nvim_lsp",
          separator_style = "slant",
          show_buffer_close_icons = false,
          show_close_icon = false,
          color_icons = true,
        },

        --- @section Theme Integration (Thêm phần này từ document của vscode.nvim)
        highlights = {
            fill = {
                fg = { attribute = "fg", highlight = "Normal" },
                bg = { attribute = "bg", highlight = "StatusLineNC" },
            },
            background = {
                fg = { attribute = "fg", highlight = "Normal" },
                bg = { attribute = "bg", highlight = "StatusLine" },
            },
            buffer_visible = {
                fg = { attribute = "fg", highlight = "Normal" },
                bg = { attribute = "bg", highlight = "Normal" },
            },
            buffer_selected = {
                fg = { attribute = "fg", highlight = "Normal" },
                bg = { attribute = "bg", highlight = "Normal" },
            },
            separator = {
                fg = { attribute = "bg", highlight = "Normal" },
                bg = { attribute = "bg", highlight = "StatusLine" },
            },
            separator_selected = {
                fg = { attribute = "fg", highlight = "Special" },
                bg = { attribute = "bg", highlight = "Normal" },
            },
            separator_visible = {
                fg = { attribute = "fg", highlight = "Normal" },
                bg = { attribute = "bg", highlight = "StatusLineNC" },
            },
            close_button = {
                fg = { attribute = "fg", highlight = "Normal" },
                bg = { attribute = "bg", highlight = "StatusLine" },
            },
            close_button_selected = {
                fg = { attribute = "fg", highlight = "Normal" },
                bg = { attribute = "bg", highlight = "Normal" },
            },
            close_button_visible = {
                fg = { attribute = "fg", highlight = "Normal" },
                bg = { attribute = "bg", highlight = "Normal" },
            },
        },
      })
    end,
  },
}
