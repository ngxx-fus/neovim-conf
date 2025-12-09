--- --- @file tree.lua
--- --- @brief File explorer plugin configuration.
--- --- @details Configures NvimTree as a floating sidebar to prevent layout shifts.
--- --- @author ngxxfus
--- --- @date 2025-11-30
--- 
--- return {
---   {
---     --- @brief A file explorer tree for neovim written in lua.
---     "nvim-tree/nvim-tree.lua",
--- 
---     --- @brief Dependencies required for icons.
---     dependencies = {
---       "nvim-tree/nvim-web-devicons",
---     },
--- 
---     --- @brief Setup function.
---     config = function()
---       --- @brief Disable netrw (vim's default explorer) to avoid conflicts.
---       vim.g.loaded_netrw = 1
---       vim.g.loaded_netrwPlugin = 1
--- 
---       require("nvim-tree").setup({
---         --- @brief Sort files/folders.
---         sort = {
---           sorter = "case_sensitive",
---         },
--- 
---         --- @section View Configuration (Centered Floating)
---         view = {
---           float = {
---             enable = true,
---             quit_on_focus_loss = true,
---             
---             open_win_config = function()
---               -- 1. Get the screen size
---               local screen_w = vim.o.columns
---               local screen_h = vim.o.lines
--- 
---               -- 2. Compute size for NvimTree (Ví dụ: W 50%, H 80%)
---               local window_w = math.floor(screen_w * 0.5)
---               local window_h = math.floor(screen_h * 0.8)
--- 
---               -- 3. Tính toạ độ để căn giữa
---               -- Công thức: (Màn hình - Cửa sổ) / 2
---               local center_col = math.floor((screen_w - window_w) / 2)
---               local center_row = math.floor((screen_h - window_h) / 2)
--- 
---               return {
---                 relative = "editor",
---                 border = "rounded",
---                 width = window_w,
---                 height = window_h,
---                 row = center_row,
---                 col = center_col,
---               }
---             end,
---           },
---         },
--- 
---         --- @brief Renderer options.
---         renderer = {
---           group_empty = true,
---         },
--- 
---         --- @brief Filtering options.
---         filters = {
---           dotfiles = true,
---         },
---       })
---     end,
---   },
--- }


--- @file tree.lua
--- @brief File explorer configuration with Dual Mode (Dock vs Float)
--- @author ngxxfus
--- @date 2025-12-09

return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    
    -- Cấu hình mặc định khi khởi động (chọn Dock hay Float tuỳ bạn)
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        sort = { sorter = "case_sensitive" },
        renderer = { group_empty = true },
        filters = { dotfiles = true },
        -- Mặc định để view thường (Dock) cho nhẹ
        view = {
          width = 30,
          float = { enable = false },
        },
      })
    end,

    -- Định nghĩa phím tắt thông minh
    keys = {
      -- MODE 1: DOCK (Space + e) -> Cột bên trái
      {
        "<leader>e",
        function()
          local api = require("nvim-tree.api")
          -- 1. Cấu hình lại thành dạng Dock
          require("nvim-tree").setup({
            view = {
              width = 30,
              float = { enable = false }, -- Tắt float
            }
          })
          -- 2. Mở tree
          api.tree.toggle({ find_file = true, focus = true })
        end,
        desc = "Explorer (Dock)",
      },

      -- MODE 2: FLOAT CENTER (Space + Shift + e) -> Nổi giữa màn hình
      {
        "<leader>E",
        function()
          local api = require("nvim-tree.api")
          -- 1. Cấu hình lại thành dạng Float
          require("nvim-tree").setup({
            view = {
              float = {
                enable = true, -- Bật float
                quit_on_focus_loss = true,
                open_win_config = function()
                  -- Công thức căn giữa màn hình
                  local screen_w = vim.o.columns
                  local screen_h = vim.o.lines
                  local window_w = math.floor(screen_w * 0.5)
                  local window_h = math.floor(screen_h * 0.8)
                  local center_col = math.floor((screen_w - window_w) / 2)
                  local center_row = math.floor((screen_h - window_h) / 2)
                  
                  return {
                    relative = "editor",
                    border = "rounded",
                    width = window_w,
                    height = window_h,
                    row = center_row,
                    col = center_col,
                  }
                end,
              }
            }
          })
          -- 2. Mở tree
          api.tree.toggle({ find_file = true, focus = true })
        end,
        desc = "Explorer (Float Center)",
      },
    },
  },
}
