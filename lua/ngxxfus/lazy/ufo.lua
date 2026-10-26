--- @file folding.lua
--- @brief Code folding configuration using nvim-ufo.
--- @details Provides LSP and Treesitter-aware code folding integrated with
---          `ngxxfus.c_cmt` for smart C/C++ banner comment fold previews.
--- @author ngxxfus
--- @date 2026-10-26

return {
    {
        "kevinhwang91/nvim-ufo",
        dependencies = {
            "neovim/nvim-lspconfig",
            "kevinhwang91/promise-async",
        },
        config = function()
            vim.o.foldcolumn = "1"
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            vim.api.nvim_set_hl(0, "FoldColumn", { fg = "#B8DB80", bg = "NONE" })

            local c_cmt = require("ngxxfus.c_cmt")

            -- Configure nvim-ufo
            require("ufo").setup({
                open_fold_hl_timeout = 150,
                close_fold_kinds_for_ft = {
                    default = { "imports", "comment" },
                    json = { "array" },
                    c = { "comment", "region" },
                    cpp = { "comment", "region" },
                },
                close_fold_current_line_for_ft = {
                    default = true,
                    c = false,
                    cpp = false,
                },
                preview = {
                    win_config = {
                        border = { "", "─", "", "", "", "─", "", "" },
                        winhighlight = "Normal:Folded",
                        winblend = 0,
                    },
                    mappings = {
                        scrollU = "<C-u>",
                        scrollD = "<C-d>",
                        jumpTop = "[",
                        jumpBot = "]",
                    },
                },
                provider_selector = function(bufnr, filetype, buftype)
                    return { "treesitter", "indent" }
                end,
                -- Uses custom smart comment banner formatter
                fold_virt_text_handler = c_cmt.fold_virt_text_handler,
            })

            -- Keymaps
            vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "UFO: Open All Folds" })
            vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "UFO: Close All Folds" })
        end,
    },
}
