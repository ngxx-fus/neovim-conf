--- @file tree.lua
--- @brief File explorer plugin configuration.
--- @details Configures the file explorer sidebar for navigating the project structure.
--- @author ngxxfus
--- @date 2025-11-30

return {
  {
    --- @brief A file explorer tree for neovim written in lua.
    "nvim-tree/nvim-tree.lua",

    --- @brief Dependencies required for icons.
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    --- @brief Setup function.
    config = function()
      --- @brief Disable netrw (vim's default explorer) to avoid conflicts.
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        --- @brief Sort files/folders.
        sort = {
          sorter = "case_sensitive",
        },

        --- @brief View configuration.
        view = {
          width = 30,
        },

        --- @brief Renderer options.
        renderer = {
          group_empty = true,
        },

        --- @brief Filtering options.
        filters = {
          dotfiles = true,
        },
      })
    end,
  },
}