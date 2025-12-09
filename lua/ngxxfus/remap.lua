--- @file remap.lua
--- @brief Keybinding and remapping configuration for Neovim
--- @details Defines all custom keybindings including:
---          - Buffer navigation (Alt + Number 1-9)
---          - LSP Navigation (F12, gD, gI)
---          - Line movement (Alt+j/k)
---          - Terminal management (Space+t)
--- @author ngxxfus
--- @date 2025-12-09
--- @note All keybindings use <leader> mapped to Space

--- @brief Local alias for vim.keymap.set function
local map = vim.keymap.set

--- @section Line Movement (Normal Mode)
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down", silent = true })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up", silent = true })
map("n", "<A-Down>", ":m .+1<CR>==", { desc = "Move line down", silent = true })
map("n", "<A-Up>", ":m .-2<CR>==", { desc = "Move line up", silent = true })

--- @section Line Movement (Visual Mode)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })

--- @section Buffer Navigation (Left/Right)
map("n", "<leader>h", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer", silent = true })
map("n", "<leader>l", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer", silent = true })
map("n", "<leader><Right>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer", silent = true })
map("n", "<leader><Left>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer", silent = true })

--- @section Buffer Management
map('n', '<leader>n', "<cmd>tabnew<cr>", { desc = 'New Tab (far-right)' })
map("n", "<leader>H", "<Cmd>BufferLineMovePrev<CR>", { desc = "Move buffer left" })
map("n", "<leader>L", "<Cmd>BufferLineMoveNext<CR>", { desc = "Move buffer right" })
map("n", "<leader>q", "<Cmd>bdelete<CR>", { desc = "Close buffer" })

--- @section Buffer Jump (Alt + Number)
--- @brief Jump to buffer 1-9 using Alt + Number (Preserves Vim count feature)
for i = 1, 9 do
  map("n", "<A-" .. i .. ">", "<Cmd>BufferLineGoToBuffer " .. i .. "<CR>", {
    desc = "Go to buffer " .. i,
    silent = true,
  })
end

--- @section LSP Navigation & Diagnostics
--- @brief Go to definition (F12)
map("n", "<F12>", vim.lsp.buf.definition, { desc = "LSP: Go to definition" })

--- @brief Go to definition (standard gd)
map("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Go to definition" })

--- @brief Go to declaration (gD)
map("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: Go to declaration" })

--- @brief Go to implementation (gI)
map("n", "gI", vim.lsp.buf.implementation, { desc = "LSP: Go to implementation" })

--- @brief Open float diagnostic (Ctrl+d)
map("n", "<C-d>", vim.diagnostic.open_float, { desc = "LSP: Float diagnostic" })


--- @section Commenting
map("n", "<C-/>", function() require("Comment.api").toggle.linewise.current() end, { desc = "Toggle comment (linewise)" })
map("n", "<C-k>", function() require("Comment.api").toggle.linewise.current() end, { desc = "Toggle comment (linewise)" })
map("v", "<C-_>", function() require("Comment.api").toggle.linewise(vim.fn.visualmode()) end, { desc = "Toggle comment (visual)", silent = true })
map("v", "<C-k>", function() require("Comment.api").toggle.linewise(vim.fn.visualmode()) end, { desc = "Toggle comment (visual)", silent = true })

--- @section Terminal Management
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Double Esc: Exit terminal mode" })

map("n", "<leader>t", function()
  local total_height = vim.api.nvim_win_get_height(0)
  local split_height = math.floor(total_height / 4)
  vim.cmd("belowright split")
  vim.cmd(split_height .. "wincmd _")
  vim.cmd("terminal")
  vim.cmd("startinsert")
end, { desc = "Open new horizontal terminal split (1/4 height)" })

map("n", "<leader>th", function()
  if vim.bo.buftype == "terminal" then vim.cmd("hide") else print("Not in terminal") end
end, { desc = "Hide current terminal window" })

map("n", "<leader>tq", function()
  if vim.bo.buftype == "terminal" then vim.cmd("quit") else print("Not in terminal") end
end, { desc = "Close current terminal" })

--- @section Indentation
map("v", "<Tab>", ">gv", { desc = "Indent right and reselect" })
map("v", "<S-Tab>", "<gv", { desc = "Indent left and reselect" })
map("n", "<Tab>", ">>", { desc = "Indent current line right" })
map("n", "<S-Tab>", "<<", { desc = "Indent current line left" })

--- @section Session Management
map("n", "<leader>sr", function() require("persistence").load() end, { desc = "Restore session for current dir" })
map("n", "<leader>sl", function() require("persistence").load({ last = true }) end, { desc = "Restore last session" })

--- @brief Prevent session saving when in gitcommit filetype
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "gitcommit" then vim.cmd("silent! wa") end
  end,
})

--- @section Telescope Integration
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find Files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>",  { desc = "Live Grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>",    { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>",  { desc = "Help Tags" })

--- @section Search & Misc
map("v", "/s", [[y/\V<C-r>=escape(@",'/\')<CR><CR>]], { noremap = true, silent = true, desc = "Search for selected text" })
map("n", "<Esc><Esc>", ":noh<CR>", { noremap = true, silent = true })

vim.keymap.set("i", "<C-e>", function()
  if vim.fn.pumvisible() == 1 then return "<C-e>" end
  return "<Esc>"
end, { expr = true, desc = "Close completion popup" })

--- @section File Explorer
map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle Explorer" })
map("n", "<leader>o", ":NvimTreeFocus<CR>", { desc = "Focus Explorer" })
