/// @file markdown.lua
/// @brief Markdown configuration: Browser preview & In-buffer rendering
/// @author ngxxfus
/// @date 2025-12-09

return {
  --- @section Browser Preview
  {
    /// @brief Markdown Preview for (Browser)
    /// @details Requires Node.js and Yarn/NPM installed
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
    /// @brief Keymap: <leader>mp to toggle preview
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview (Browser)", ft = "markdown" },
    },
  },

  --- @section In-Buffer Rendering
  {
    /// @brief Render Markdown nicely inside Neovim
    /// @details Hides syntax noise, renders tables, checkboxes, latex, etc.
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    config = function()
      require("render-markdown").setup({
        /// @brief Disable rendering for large files to avoid lag
        file_types = { "markdown" },
        render_modes = { "n", "c" }, -- Normal & Command mode
        anti_conceal = { enabled = true }, -- Show syntax when cursor is on the line
      })
    end,
  },
}
