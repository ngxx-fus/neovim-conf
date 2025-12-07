--- @file folding.lua
--- @brief Code folding configuration using nvim-ufo.
--- @details Provides LSP-aware code folding.
--- @author ngxxfus
--- @date 2025-12-05

return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "neovim/nvim-lspconfig", -- Ensure LSP is available for folding provider
      "kevinhwang91/promise-async",
    },
    config = function()
      -- Set folding options for a better experience
      vim.o.foldcolumn = "1" -- Show a fold column
      vim.o.foldlevel = 99 -- Start with all folds open
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- Configure nvim-ufo to use LSP as the primary folding provider
      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { "lsp", "indent" }
        end,
      })

      -- Set keymaps for folding commands
      vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "UFO: Open All Folds" })
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "UFO: Close All Folds" })
    end,
  },
}