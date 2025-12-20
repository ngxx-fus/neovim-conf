--- @file colorscheme.lua
--- @brief Colorscheme configuration for VSCode Light theme.
--- @author ngxxfus
--- @date 2025-12-09

return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- 1. Basic configuration for the plugin
      vim.o.background = 'light'
      local c = require('vscode.colors').get_colors()

      require('vscode').setup({
        style = 'light',
        transparent = false,
        italic_comments = true,
        disable_nvimtree_bg = true,
        terminal_colors = true,
        -- Tip: Skip group_overrides here; we handle it manually below to ensure precedence.
      })

      -- 2. Load the theme
      vim.cmd.colorscheme("vscode")

      -- 3. === FORCE OVERRIDE (POST-LOAD ENFORCEMENT) ===
      -- Apply colors directly after the theme loads to ensure they are not overwritten.
      
      -- List of highlight groups to override (Covers both standard and TreeSitter groups)
      local groups = {
        -- Basic groups
        "Comment", 
        "SpecialComment", -- Doxygen comments (///) often fall here
        
        -- TreeSitter groups (Crucial for C/C++)
        "@comment", 
        "@comment.documentation", -- Specific for Doxygen documentation
        "@lsp.type.comment",
      }

      -- Iterate over groups and apply the custom style
      for _, group in ipairs(groups) do
        vim.api.nvim_set_hl(0, group, { fg = "#B7E5CD", italic = true, bold = false })
      end

      -- Override Visual mode (Selection) & Cursor colors
      vim.api.nvim_set_hl(0, "Visual", { bg = "#264F78", fg = "#ffffff" })
      vim.api.nvim_set_hl(0, "Cursor", { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true })

    end,
  },
}
