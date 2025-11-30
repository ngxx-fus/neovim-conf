--- @file remap.lua
--- @brief Keybinding and remapping configuration for Neovim
--- @details Defines all custom keybindings including:
---          - Line movement (Alt+j/k)
---          - Buffer navigation (Space+h/l)
---          - Terminal management (Space+t, Space+th, Space+tq)
---          - Indentation (Tab/Shift-Tab)
---          - Session management (Space+sr/sl)
---          - Telescope integration (Space+f*)
---          - LSP diagnostics and search
--- @author ngxxfus
--- @date 2025-11-30
--- @note All keybindings use <leader> mapped to Space

--- @brief Local alias for vim.keymap.set function
local map = vim.keymap.set

--- @section Line Movement (Normal Mode)

--- @brief Move current line down (Alt+j)
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down", silent = true })

--- @brief Move current line up (Alt+k)
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up", silent = true })

--- @brief Move current line down (Alt+Down arrow)
map("n", "<A-Down>", ":m .+1<CR>==", { desc = "Move line down", silent = true })

--- @brief Move current line up (Alt+Up arrow)
map("n", "<A-Up>", ":m .-2<CR>==", { desc = "Move line up", silent = true })

--- @section Line Movement (Visual Mode)

--- @brief Move selected lines down (Alt+j)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })

--- @brief Move selected lines up (Alt+k)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })

--- @brief Move selected lines down (Alt+Down arrow)
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })

--- @brief Move selected lines up (Alt+Up arrow)
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })

--- @section Buffer Navigation

--- @brief Cycle to previous buffer (Space+h)
map("n", "<leader>h", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer", silent = true })

--- @brief Cycle to next buffer (Space+l)
map("n", "<leader>l", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer", silent = true })

--- @brief Cycle to next buffer (Space+Right arrow)
map("n", "<leader><Right>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer", silent = true })

--- @brief Cycle to previous buffer (Space+Left arrow)
map("n", "<leader><Left>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer", silent = true })

--- @section Buffer Management

--- @brief Create new tab at far-right (Space+n)
map('n', '<leader>n', "<cmd>tabnew<cr>", { desc = 'New Tab (far-right)' })

--- @brief Move current buffer left in bufferline (Space+H)
map("n", "<leader>H", "<Cmd>BufferLineMovePrev<CR>", { desc = "Move buffer left" })

--- @brief Move current buffer right in bufferline (Space+L)
map("n", "<leader>L", "<Cmd>BufferLineMoveNext<CR>", { desc = "Move buffer right" })

--- @brief Delete/close the current buffer (Space+q)
map("n", "<leader>q", "<Cmd>bdelete<CR>", { desc = "Close buffer" })

--- @brief Jump to buffer 1-9 using Space+number
for i = 1, 9 do
  map("n", "<Space>" .. i, "<Cmd>BufferLineGoToBuffer " .. i .. "<CR>", {
    desc = "Go to buffer " .. i,
    silent = true,
  })
end

--- @section Commenting

--- @brief Toggle comment for current line (Ctrl+/)
map("n", "<C-/>", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment (linewise)" })

--- @brief Alternative keybinding for linewise comment toggle (Ctrl+k)
map("n", "<C-k>", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment (linewise)" })

--- @brief Comment/uncomment selected lines in visual mode (Ctrl+_)
map("v", "<C-_>", function()
  require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle comment (visual)", silent = true })

--- @brief Alternative keybinding for visual comment toggle (Ctrl+k)
map("v", "<C-k>", function()
  require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle comment (visual)", silent = true })

--- @section Terminal Management

--- @brief Return from terminal mode to normal mode (Double Esc)
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Double Esc: Exit terminal mode" })

--- @brief Open new terminal split (Space+t)
--- @details Creates a new horizontal split window below the current one,
---          resizes it to 1/4 of the total window height, opens a terminal in it,
---          and enters insert mode automatically.
map("n", "<leader>t", function()
  --- @brief Get the total height of the current window
  local total_height = vim.api.nvim_win_get_height(0)
  --- @brief Calculate 1/4 of the total height for the new split
  local split_height = math.floor(total_height / 4)
  --- @brief Create a new horizontal split window below the current one
  vim.cmd("belowright split")
  --- @brief Set the height of the newly created split window
  vim.cmd(split_height .. "wincmd _")
  --- @brief Open a terminal in the new split window
  vim.cmd("terminal")
  --- @brief Enter insert mode automatically in the terminal
  vim.cmd("startinsert")
end, { desc = "Open new horizontal terminal split (1/4 height)" })

--- @brief Hide current terminal window (Space+th)
--- @details If the current window is a terminal, hides it but keeps process running.
map("n", "<leader>th", function()
  if vim.bo.buftype == "terminal" then
    vim.cmd("hide")
    print("Terminal hidden. Use :ls to see buffers or :b <number> to switch back.")
  else
    print("Not in a terminal window to hide.")
  end
end, { desc = "Hide current terminal window" })

--- @brief Close and terminate the current terminal (Space+tq)
--- @details Permanently closes the terminal and kills the process.
map("n", "<leader>tq", function()
  if vim.bo.buftype == "terminal" then
    vim.cmd("quit")
    print("Terminal closed.")
  else
    print("Not in a terminal window to close.")
  end
end, { desc = "Close current terminal" })

--- @section Indentation

--- @brief Indent right in visual mode and reselect (Tab)
map("v", "<Tab>", ">gv", { desc = "Indent right and reselect" })

--- @brief Indent left in visual mode and reselect (Shift-Tab)
map("v", "<S-Tab>", "<gv", { desc = "Indent left and reselect" })

--- @brief Indent current line right in normal mode (Tab)
map("n", "<Tab>", ">>", { desc = "Indent current line right" })

--- @brief Indent current line left in normal mode (Shift-Tab)
map("n", "<S-Tab>", "<<", { desc = "Indent current line left" })

--- @section Session Management

--- @brief Restore session for current directory (Space+sr)
map("n", "<leader>sr", function()
  require("persistence").load()
end, { desc = "Restore session for current dir" })

--- @brief Restore last session regardless of directory (Space+sl)
map("n", "<leader>sl", function()
  require("persistence").load({ last = true })
end, { desc = "Restore last session" })

--- @brief Prevent session saving when in gitcommit filetype
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "gitcommit" then
      vim.cmd("silent! wa")
    end
  end,
})

--- @section Telescope Integration

--- @brief Find files (Space+ff)
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find Files" })

--- @brief Live grep (Space+fg)
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>",  { desc = "Live Grep" })

--- @brief List buffers (Space+fb)
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>",    { desc = "Buffers" })

--- @brief Help tags (Space+fh)
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>",  { desc = "Help Tags" })

--- @section LSP & Diagnostics

--- @brief Open float diagnostic (Ctrl+d)
map("n", "<C-d>", vim.diagnostic.open_float, { desc = "LSP float diagnostic" })

--- @section Search & Misc

--- @brief Search for selected text in visual mode
--- @details Copies selection and searches for it using regex escape
map("v", "/s", [[y/\V<C-r>=escape(@",'/\')<CR><CR>]], { noremap = true, silent = true, desc = "Search for selected text" })

--- @brief Clear search highlight (Escape twice)
map("n", "<Esc><Esc>", ":noh<CR>", { noremap = true, silent = true })

--- @brief Close completion popup (Ctrl+e)
vim.keymap.set("i", "<C-e>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-e>"
  end
  return "<Esc>"
end, { expr = true, desc = "Close completion popup" })