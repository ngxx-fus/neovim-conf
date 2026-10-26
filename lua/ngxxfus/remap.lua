--- @file remap.lua
--- @brief Keybinding and remapping configuration for Neovim.
--- @details Defines grouped custom keybindings for navigation, editing, mouse actions,
---          LSP, commenting, buffer management, and plugin integration.
--- @author ngxxfus
--- @date 2026-10-26
--- @note Global leader key is mapped to <Space> (set in init.lua).

--- @brief Local alias for vim.keymap.set to keep mappings clean and concise.
local map = vim.keymap.set

-- =============================================================================
--  SECTION 1: LINE & BLOCK MOVEMENT (VS Code Style)
-- =============================================================================

--- @brief Move current line up / down in Normal mode using Alt + j/k or Alt + Arrow keys.
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down", silent = true })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up", silent = true })
map("n", "<A-Down>", ":m .+1<CR>==", { desc = "Move line down", silent = true })
map("n", "<A-Up>", ":m .-2<CR>==", { desc = "Move line up", silent = true })

--- @brief Move selected text block up / down in Visual mode.
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })

-- =============================================================================
--  SECTION 2: CURSOR & WORD NAVIGATION
-- =============================================================================

--- @brief Move cursor by word using Ctrl + Left/Right Arrow keys in Normal and Insert modes.
map("n", "<C-Right>", "w", { desc = "Jump to next word" })
map("n", "<C-Left>", "b", { desc = "Jump to prev word" })
map("i", "<C-Right>", "<C-o>w", { desc = "Jump to next word (Insert)" })
map("i", "<C-Left>", "<C-o>b", { desc = "Jump to prev word (Insert)" })

--- @brief Quick jump to Start of line in Insert mode.
map("i", "<C-a>", "<Esc>I", { desc = "Go to beginning of line" })

--- @brief Smart End-of-Line navigation in Insert mode:
---        - If completion popup is visible: closes completion popup with <C-e>.
---        - Otherwise: jumps to end of line (<Esc>A).
--- @note Resolves previous duplicate mapping conflict between navigation and completion.
map("i", "<C-e>", function()
    if vim.fn.pumvisible() == 1 then
        return "<C-e>"
    end
    return "<Esc>A"
end, { expr = true, desc = "Close completion or Go to EOL" })

-- =============================================================================
--  SECTION 3: MOUSE & HORIZONTAL SCROLLING (Migrated from set.lua)
-- =============================================================================

--- @brief Horizontal scroll using Alt + Mouse Wheel (5 columns left/right).
--- @details Supports Normal, Visual, Select, and Operation-pending modes.
map({ "n", "v", "s", "x" }, "<M-ScrollWheelUp>", "5zh", { desc = "Scroll view left" })
map({ "n", "v", "s", "x" }, "<M-ScrollWheelDown>", "5zl", { desc = "Scroll view right" })

--- @brief Horizontal scroll in Insert mode without leaving insert state.
map("i", "<M-ScrollWheelUp>", "<C-o>5zh", { desc = "Scroll view left (Insert)" })
map("i", "<M-ScrollWheelDown>", "<C-o>5zl", { desc = "Scroll view right (Insert)" })

-- =============================================================================
--  SECTION 4: INDENTATION
-- =============================================================================

--- @brief Indent / Unindent lines while staying in Visual mode.
map("v", "<Tab>", ">gv", { desc = "Indent right and reselect" })
map("v", "<S-Tab>", "<gv", { desc = "Indent left and reselect" })

--- @brief Indent / Unindent current line in Normal mode.
map("n", "<Tab>", ">>", { desc = "Indent line right" })
map("n", "<S-Tab>", "<<", { desc = "Indent line left" })

-- =============================================================================
--  SECTION 5: SEARCH & WINDOW MANAGEMENT
-- =============================================================================

--- @brief Search for selected text in Visual mode using '/s'.
map("v", "/s", [[y/\V<C-r>=escape(@",'/\')<CR><CR>]], {
    noremap = true,
    silent = true,
    desc = "Search for selected text",
})

--- @brief Normal Mode <Esc>: Safely closes floating preview/hover windows AND clears search highlights.
--- @note Avoids defining <Esc><Esc> in normal mode to prevent keycode timeout latency on single <Esc>.
map("n", "<Esc>", function()
    -- Iterate through all open windows in the current tab page
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local config = vim.api.nvim_win_get_config(win)

        -- Filter for focusable floating windows
        if config.relative ~= "" and config.focusable then
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype

            -- Keep persistent sidebars and interactive UI popups open
            if ft ~= "TelescopePrompt" and ft ~= "neo-tree" and ft ~= "which-key" then
                pcall(vim.api.nvim_win_close, win, false)
            end
        end
    end

    -- Clear search highlight
    vim.cmd("nohlsearch")
end, { desc = "Close preview floating windows and clear search highlights" })

-- =============================================================================
--  SECTION 6: BUFFER & TAB MANAGEMENT (BufferLine)
-- =============================================================================

--- @brief Cycle through open buffers (Left / Right).
map("n", "<leader>h", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer", silent = true })
map("n", "<leader>l", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer", silent = true })
map("n", "<leader><Left>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer", silent = true })
map("n", "<leader><Right>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer", silent = true })

--- @brief Reorder buffers in the buffer line.
map("n", "<leader>H", "<Cmd>BufferLineMovePrev<CR>", { desc = "Move buffer left" })
map("n", "<leader>L", "<Cmd>BufferLineMoveNext<CR>", { desc = "Move buffer right" })

--- @brief Tab creation and buffer deletion.
map("n", "<leader>n", "<Cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader>q", "<Cmd>bdelete<CR>", { desc = "Close buffer" })
map("n", "<leader>Q", "<Cmd>bdelete!<CR>", { desc = "Close buffer (force)" })

--- @brief Direct jump to buffer 1-9 using Alt + Number across all modes.
for i = 1, 9 do
    map({ "n", "i", "v", "t" }, "<A-" .. i .. ">", "<Cmd>BufferLineGoToBuffer " .. i .. "<CR>", {
        desc = "Go to buffer " .. i,
        silent = true,
    })
end

-- =============================================================================
--  SECTION 7: LSP & CODE INTELLIGENCE
-- =============================================================================

--- @brief Definition and Declaration navigation.
map("n", "<F12>", vim.lsp.buf.definition, { desc = "LSP: Go to definition" })
map("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: Go to declaration" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "LSP: Go to implementation" })
map("n", "gI", vim.lsp.buf.implementation, { desc = "LSP: Go to implementation" })

--- @brief Go to definition using Ctrl + Left Click (Mouse navigation).
map("n", "<C-LeftMouse>", "<LeftMouse><Cmd>lua vim.lsp.buf.definition()<CR>", {
    desc = "LSP: Go to definition (Mouse)",
})

--- @brief Diagnostics & Documentation.
--- @note Overrides default Vim half-page scroll (<C-d>) to inspect diagnostics.
map("n", "<C-d>", vim.diagnostic.open_float, { desc = "LSP: Float diagnostic" })
map("n", "K", vim.lsp.buf.hover, { desc = "LSP: Hover documentation" })

-- =============================================================================
--  SECTION 8: CODE COMMENTING (Comment.nvim)
-- =============================================================================

--- @brief Toggle linewise comment in Normal mode.
--- @note Maps both <C-/> and <C-_> to support different terminal escape codes.
map("n", "<C-/>", function()
    require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment (linewise)" })
map("n", "<C-_>", function()
    require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment (linewise)" })
map("n", "<C-k>", function()
    require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment (linewise)" })

--- @brief Toggle comment in Visual mode.
map("v", "<C-/>", function()
    require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle comment (visual)", silent = true })
map("v", "<C-_>", function()
    require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle comment (visual)", silent = true })
map("v", "<C-k>", function()
    require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle comment (visual)", silent = true })

-- =============================================================================
--  SECTION 9: TERMINAL MANAGEMENT
-- =============================================================================

--- @brief Exit terminal insert mode using Double Esc.
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

--- @brief Open horizontal terminal split (1/4 height).
map("n", "<leader>t", function()
    local total_height = vim.api.nvim_win_get_height(0)
    local split_height = math.floor(total_height / 4)
    vim.cmd("belowright split")
    vim.cmd(split_height .. "wincmd _")
    vim.cmd("terminal")
    vim.cmd("startinsert")
end, { desc = "Open terminal split" })

--- @brief Hide terminal buffer.
map("n", "<leader>th", function()
    if vim.bo.buftype == "terminal" then
        vim.cmd("hide")
    else
        vim.notify("Not in terminal buffer", vim.log.levels.WARN)
    end
end, { desc = "Hide terminal" })

--- @brief Close terminal buffer.
map("n", "<leader>tq", function()
    if vim.bo.buftype == "terminal" then
        vim.cmd("quit")
    else
        vim.notify("Not in terminal buffer", vim.log.levels.WARN)
    end
end, { desc = "Close terminal" })

-- =============================================================================
--  SECTION 10: PLUGINS (Persistence & Telescope)
-- =============================================================================

--- @brief Persistence: Session restoration keymaps.
map("n", "<leader>sr", function()
    require("persistence").load()
end, { desc = "Restore session (cwd)" })
map("n", "<leader>sl", function()
    require("persistence").load({ last = true })
end, { desc = "Restore last session" })

--- @brief Telescope: Fuzzy finding keymaps.
map("n", "<leader>ff", "<Cmd>Telescope find_files<CR>", { desc = "Find Files" })
map("n", "<leader>fg", "<Cmd>Telescope live_grep<CR>", { desc = "Live Grep" })
map("n", "<leader>fb", "<Cmd>Telescope buffers<CR>", { desc = "Buffers" })
map("n", "<leader>fh", "<Cmd>Telescope help_tags<CR>", { desc = "Help Tags" })

-- =============================================================================
--  SECTION 11: AUTOCOMMANDS
-- =============================================================================

--- @brief Auto-save files before writing git commit messages.
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        if vim.bo.filetype == "gitcommit" then
            vim.cmd("silent! wa")
        end
    end,
})
