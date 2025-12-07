--[[
  @file cmp.lua
  @brief Auto-completion plugin configuration
  @details Configures the hrsh7th/nvim-cmp completion engine with:
           - Snippet support via LuaSnip
           - LSP completions
           - Buffer and path completions
           - Lua API completions
  @author ngxxfus
  @date 2025-11-30
  @see https://github.com/hrsh7th/nvim-cmp
]]

-- return {
--   {
--     --! @brief hrsh7th/nvim-cmp - main completion plugin
--     "hrsh7th/nvim-cmp",
--     --! @brief Load on InsertEnter event when entering insert mode
--     event = "InsertEnter",
--     --! @section Plugin Dependencies
--     --! @brief Required completion sources and engines
--     dependencies = {
--       --! @brief L3MON4D3/LuaSnip - Snippet engine for snippet expansion
--       "L3MON4D3/LuaSnip",
--       --! @brief saadparwaiz1/cmp_luasnip - Integration between cmp and LuaSnip
--       "saadparwaiz1/cmp_luasnip",
--       --! @brief hrsh7th/cmp-buffer - Completion source for words in current buffer
--       "hrsh7th/cmp-buffer",
--       --! @brief hrsh7th/cmp-path - Completion source for filesystem paths
--       "hrsh7th/cmp-path",
--       --! @brief hrsh7th/cmp-nvim-lsp - Completion source for LSP suggestions
--       "hrsh7th/cmp-nvim-lsp",
--       --! @brief hrsh7th/cmp-nvim-lua - Completion source for Neovim Lua API
--       "hrsh7th/cmp-nvim-lua",
--     },
--     --! @section Configuration
--     --! @brief Setup function for completion engine
--     config = function()
--       --! @brief Load cmp module
--       local cmp = require("cmp")
--       --! @brief Load luasnip snippet engine
--       local luasnip = require("luasnip")
--       --! @brief Load lspconfig for LSP integration
--       local lspconfig = require("lspconfig")
--       --! @brief Get default LSP capabilities enhanced by cmp
--       local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- 
--       --! @brief Load snippets from vscode snippet format
--       require("luasnip.loaders.from_vscode").lazy_load()
-- 
--       --! @section LSP Server Configuration
--       --! @brief Configure Lua language server with cmp capabilities
--       lspconfig.lua_ls.setup({
--         --! @brief Pass cmp capabilities to lua_ls
--         capabilities = capabilities,
--         --! @section Lua LS Settings
--         settings = {
--           --! @section Lua Diagnostics
--           Lua = {
--             --! @brief Allow vim global variable in diagnostics
--             diagnostics = { globals = { "vim" } },
--             --! @section Workspace Configuration
--             workspace = {
--               --! @brief Don't check third-party libraries
--               checkThirdParty = false,
--               --! @brief Include Neovim runtime files in workspace
--               library = vim.api.nvim_get_runtime_file("", true),
--             },
--           },
--         },
--       })
-- 
--       --! @brief Configure Clang language server with cmp capabilities
--       lspconfig.clangd.setup({
--         --! @brief Pass cmp capabilities to clangd
--         capabilities = capabilities,
--         --! @section Clangd Command Options
--         cmd = { "clangd", "--header-insertion=never", "--clang-tidy" },
--       })
-- 
--       --! @section Cmp Setup
--       --! @brief Configure completion engine
--       cmp.setup({
--         --! @section Snippet Configuration
--         --! @brief Enable snippet expansion via LuaSnip
--         snippet = {
--           expand = function(args)
--             --! @brief Expand snippet body with LuaSnip
--             luasnip.lsp_expand(args.body)
--           end,
--         },
--         --! @section Keybinding Configuration
--         --! @brief Configure completion navigation and selection
--         mapping = cmp.mapping.preset.insert({
--           --! @brief Trigger completion menu (Ctrl+Space)
--           ["<C-Space>"] = cmp.mapping.complete(),
--           --! @brief Confirm selection and replace text (Enter)
--           ["<CR>"] = cmp.mapping.confirm({ select = true }),
--           --! @brief Move to next completion item or expand snippet (Tab)
--           ["<Tab>"] = cmp.mapping(function(fallback)
--             if cmp.visible() then
--               --! @brief Move to next completion
--               cmp.select_next_item()
--             elseif luasnip.expand_or_jumpable() then
--               --! @brief Expand or jump in snippet
--               luasnip.expand_or_jump()
--             else
--               --! @brief Fallback to default behavior
--               fallback()
--             end
--           end, { "i", "s" }),
--           --! @brief Move to previous completion item or jump back (Shift+Tab)
--           ["<S-Tab>"] = cmp.mapping(function(fallback)
--             if cmp.visible() then
--               --! @brief Move to previous completion
--               cmp.select_prev_item()
--             elseif luasnip.jumpable(-1) then
--               --! @brief Jump backwards in snippet
--               luasnip.jump(-1)
--             else
--               --! @brief Fallback to default behavior
--               fallback()
--             end
--           end, { "i", "s" }),
--         }),
--         --! @section Completion Sources
--         --! @brief Configure sources and their priority order
--         sources = cmp.config.sources({
--           --! @brief LSP completions (highest priority)
--           { name = "nvim_lsp" },
--           --! @brief Snippet completions
--           { name = "luasnip" },
--           --! @brief Current buffer completions
--           { name = "buffer" },
--           --! @brief File path completions
--           { name = "path" },
--           --! @brief Neovim Lua API completions
--           { name = "nvim_lua" },
--         }),
--       })
--     end,
--   }
-- }


--- @file cmp.lua
--- @brief Auto-completion plugin configuration
--- @details Configures the hrsh7th/nvim-cmp completion engine ONLY.
---          LSP setup logic has been moved to lsp.lua.
--- @author ngxxfus
--- @date 2025-12-05

return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Load snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, -- Gợi ý từ Clangd/LSP
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
          { name = "nvim_lua" },
        }),
      })
    end,
  },
}
