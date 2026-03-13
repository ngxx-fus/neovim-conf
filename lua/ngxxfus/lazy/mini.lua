---
--- @brief Plugin specification for mini.map in lazy.nvim.
--- @details This module returns a table that lazy.nvim uses to install and configure the minimap.
---

return {
    'echasnovski/mini.map',
    branch = 'stable',
    config = function()
        local minimap = require('mini.map')

        -- Define the minimap setup with builtin search and git signs
        minimap.setup({
            integrations = {
                minimap.gen_integration.builtin_search(),
                minimap.gen_integration.gitsigns(),
            },
            symbols = {
                scroll_bar = ' ',
            },
        })

        -- Set keybindings for quick access
        vim.keymap.set('n', '<leader>mc', minimap.close, { desc = "Close Minimap" })
        vim.keymap.set('n', '<leader>mo', minimap.open, { desc = "Open Minimap" })
    end,
}
