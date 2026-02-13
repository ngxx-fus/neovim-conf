--- @file colorscheme.lua
--- @brief Colorscheme configuration with Dark/Light mode toggle.
--- @author ngxxfus
--- @date 2026-02-06

-- Toggle this variable: 1 for Dark Mode, 0 for Light Mode
local EnableDarkMode = 0 

return {
    {
        "Mofiqul/vscode.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            -- 1. Setup Theme Parameters based on the flag
            local theme_style = "dark"
            local bg_mode = "dark"
            --- local comment_fg = "#6A9955" -- VSCode Dark Green
            local comment_fg = "#374045"
            if EnableDarkMode == 0 then
                theme_style = "light"
                bg_mode = "light"
                --- comment_fg = "#008000" -- Standard Light Green (or use your preferred #E0E0E0)
                comment_fg = "#E0E0E0"
            end

            -- 2. Basic configuration
            vim.o.background = bg_mode
            
            require('vscode').setup({
                style = theme_style,
                transparent = false,
                italic_comments = true,
                disable_nvimtree_bg = true,
                terminal_colors = true,
            })

            -- 3. Load the theme
            vim.cmd.colorscheme("vscode")

            -- 4. === FORCE OVERRIDE (POST-LOAD ENFORCEMENT) ===
            local groups = {
                "Comment", 
                "SpecialComment",
                "@comment", 
                "@comment.documentation",
                "@lsp.type.comment",
            }

            for _, group in ipairs(groups) do
                vim.api.nvim_set_hl(0, group, { fg = comment_fg, italic = true, bold = false })
            end

            -- 5. Cursor Configuration
            vim.api.nvim_create_autocmd("ColorScheme", {
                pattern = "*",
                callback = function()
                    -- Set cursor to reverse color for better visibility in both modes
                    vim.api.nvim_set_hl(0, "Cursor", { reverse = true })
                    vim.opt.guicursor = "n-v-c:block-Cursor,i-ci-ve:ver25-Cursor"
                end,
            })
        end,
    },
}
