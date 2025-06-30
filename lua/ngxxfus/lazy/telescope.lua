-- ~/.config/nvim/lua/ngxxfus/lazy/telescope.lua

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    config = function()
      require("telescope").setup({
        defaults = {
          layout_config = {
            horizontal = { width = 0.9 },
          },
        },
      })
    end,
    cmd = "Telescope", -- lazy load when :Telescope is called
  },
}
