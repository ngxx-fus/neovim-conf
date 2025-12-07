--- @file lsp.lua
--- @brief Consolidated LSP configuration (Nuclear Option)
--- @author ngxxfus
--- @date 2025-12-07

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp", 
    },
    config = function()
      -- 1. Setup Mason
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd", "pyright", "lua_ls", "bashls" },
        handlers = { function() end }, -- Tắt auto-setup để ta nắm quyền kiểm soát
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Hàm setup tương thích mọi phiên bản
      local function setup_server(server_name, config)
        config = config or {}
        config.capabilities = capabilities
        
        -- Cấu hình mặc định quan trọng: Chấp nhận file lẻ
        config.single_file_support = true 

        -- Setup theo kiểu cũ (An toàn nhất, ít lỗi version nhất)
        local lspconfig = require("lspconfig")
        if lspconfig[server_name] then
            lspconfig[server_name].setup(config)
        end
      end

      -- =========================================
      -- CẤU HÌNH CLANGD (ESP-IDF)
      -- =========================================
      setup_server("clangd", {
        cmd = { 
          "clangd", 
          "--background-index", 
          "--clang-tidy", 
          "--header-insertion=never",
          -- Nếu dòng dưới gây lỗi, hãy thử comment nó lại để test
          "--query-driver=**/*xtensa-esp32*-elf-gcc*" 
        },
        -- Root dir siêu dễ tính: Lấy root hoặc lấy luôn thư mục chứa file
        root_dir = function(fname)
            return vim.fs.root(fname, {
                "compile_commands.json", 
                "build/compile_commands.json", 
                ".git"
            }) or vim.fn.getcwd()
        end,
      })

      -- =========================================
      -- CÁC SERVER KHÁC
      -- =========================================
      setup_server("lua_ls", {
        settings = { Lua = { diagnostics = { globals = { "vim" } } } }
      })
      setup_server("pyright", {})
      setup_server("bashls", {})

      -- =========================================
      -- KEYMAPS (Phím tắt)
      -- =========================================
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }
          -- Debug: Báo một câu nhỏ khi LSP dính thành công
          print("LSP Attached: " .. vim.bo[ev.buf].filetype)
          
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        end,
      })
    end,
  },
}