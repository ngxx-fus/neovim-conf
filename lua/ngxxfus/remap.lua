-- Move lines up/down with Alt + j/k or Alt + Up/Down arrows
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down", silent = true })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up", silent = true })
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==", { desc = "Move line down", silent = true })
vim.keymap.set("n", "<A-Up>", ":m .-2<CR>==", { desc = "Move line up", silent = true })

vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })

vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move line(s) down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move line(s) up" })

-- Tab navigation using <leader>
vim.keymap.set("n", "<leader><Right>" , ":bnext<CR>"      , { desc = "Next buffer", silent = true })
vim.keymap.set("n", "<leader><Left>"  , ":bprevious<CR>"  , { desc = "Previous buffer", silent = true })
vim.keymap.set("n", "<leader>h"       , ":bnext<CR>"      , { desc = "Next tab", silent = true })
vim.keymap.set("n", "<leader>l"       , ":bprevious<CR>"  , { desc = "Previous tab", silent = true })
vim.keymap.set("n", "<leader>n"       , ":tabnew<CR>"       , { desc = "Previous tab", silent = true })
vim.keymap.set("n", "<leader>H"       , "<Cmd>BufferLineMovePrev<CR>", { desc = "Move tab left" })
vim.keymap.set("n", "<leader>L"       , "<Cmd>BufferLineMoveNext<CR>", { desc = "Move tab right" })

-- Terminal
vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>", { desc = "Terminal: exit to normal mode" })


-- Toggle comment with Ctrl+/
-- Requires 'numToStr/Comment.nvim' plugin installed and set up
vim.keymap.set("n", "<C-/>", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment (linewise)" })

vim.keymap.set("v", "<C-/>", function()
  require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle comment (visual)", silent = true })

-- New Terminal at the bottom
vim.keymap.set("n", "<leader>t", function()
  -- Get total height of current window
  local total_height = vim.api.nvim_win_get_height(0)
  local split_height = math.floor(total_height / 4)

  -- Create horizontal split and resize it
  vim.cmd("belowright split")
  vim.cmd(split_height .. "wincmd _")  -- Set height of the split
  vim.cmd("terminal")
  vim.cmd("startinsert")
end, { desc = "Open horizontal split (1/4 height)", silent = false })



-- Search
vim.keymap.set("v", "//", [[y/\V<C-r>=escape(@",'/\')<CR><CR>]], { noremap = true, silent = true, desc = "Search for selected text" })

