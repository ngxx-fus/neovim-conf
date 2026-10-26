--- @file c_cmt.lua
--- @brief Smart comment banner fold formatter for C/C++ in Neovim.
--- @details Automatically detects C/C++ banner comments:
---          /*****************************************************************
---           * Macro definitions
---           *****************************************************************/
---          And renders clean, readable fold previews:
---          /* Macro definitions ***************************************** */
---          Prioritizes `@brief` / `\brief` keywords, falling back to the first
---          meaningful comment line.
--- @author ngxxfus
--- @date 2026-10-26

local M = {}

--- @brief Checks if a string consists only of border/banner decorative characters.
--- @param str string
--- @return boolean
local function is_banner_line(str)
    if not str or str == "" then
        return true
    end
    -- Check if string has no alphanumeric characters and is only comment/banner symbols
    return not str:match("%w")
end

--- @brief Cleans trailing and leading comment tokens from a text string.
--- @param text string
--- @return string
local function clean_text(text)
    if not text then
        return ""
    end
    return text
        :gsub("^%s*/%*+/?%s*", "") -- Leading /* or /**
        :gsub("^%s*%*+/?%s*", "")   -- Leading * or */
        :gsub("^%s*//+/?%s*", "")   -- Leading //
        :gsub("%s*%*+/%s*$", "")   -- Trailing */
        :gsub("%s*//+%s*$", "")     -- Trailing //
        :gsub("%s*%*+%s*$", "")     -- Trailing *
        :gsub("^%s*[%-%=_~]+%s*", "") -- Leading decorative dashes/equals
        :gsub("%s*[%-%=_~]+%s*$", "") -- Trailing decorative dashes/equals
        :gsub("^%s+", "")           -- Trim left
        :gsub("%s+$", "")           -- Trim right
end

--- @brief Extracts a meaningful summary/title from folded comment lines.
--- @param lines table List of strings from the folded buffer range.
--- @return string|nil title Extracted title, or nil if none found.
--- @return boolean is_brief Whether the title was extracted from a brief tag.
function M.extract_comment_title(lines)
    if not lines or #lines == 0 then
        return nil, false
    end

    -- 1. First Pass: Look specifically for @brief or \brief or brief:
    for _, line in ipairs(lines) do
        local brief_match = line:match("[@\\]brief%s*:?%s*(.+)")
            or line:match("^%s*%*+%s*brief%s*:?%s*(.+)")
            or line:match("^%s*//+%s*brief%s*:?%s*(.+)")

        if brief_match then
            local cleaned = clean_text(brief_match)
            if #cleaned > 0 and not is_banner_line(cleaned) then
                return cleaned, true
            end
        end
    end

    -- 2. Second Pass: Find the first non-empty, non-banner comment line
    for i = 1, #lines do
        local line = lines[i]
        local cleaned = clean_text(line)

        -- Must contain alphanumeric text and not be purely decorative symbols
        if #cleaned > 0 and not is_banner_line(cleaned) then
            return cleaned, false
        end
    end

    return nil, false
end

--- @brief Checks whether the first line of a fold is a C/C++ style comment banner.
--- @param line string
--- @return boolean is_banner
--- @return string style "block" for /* ... */ or "line" for //
function M.detect_comment_style(line)
    if not line then
        return false, ""
    end

    -- Block comment banner: starts with /*
    if line:match("^%s*/%*") then
        return true, "block"
    end

    -- Line comment banner: starts with // followed by repetitive banner symbols
    if line:match("^%s*//[%*=%-%#]{3,}") then
        return true, "line"
    end

    return false, ""
end

--- @brief Fallback default UFO handler for non-comment folds (functions, structs, etc.).
local function default_ufo_handler(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (" 󰁂 %d "):format(endLnum - lnum + 1)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0

    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, "MoreMsg" })
    return newVirtText
end

--- @brief UFO Virtual Text Handler with smart C comment banner formatting.
--- @param virtText table
--- @param lnum number 1-indexed start line
--- @param endLnum number 1-indexed end line
--- @param width number Available window width
--- @param truncate function Truncate helper
--- @return table virtText Formatted chunks
function M.fold_virt_text_handler(virtText, lnum, endLnum, width, truncate)
    local bufnr = vim.api.nvim_get_current_buf()
    local ok, lines = pcall(vim.api.nvim_buf_get_lines, bufnr, lnum - 1, endLnum, false)

    if not ok or not lines or #lines < 2 then
        return default_ufo_handler(virtText, lnum, endLnum, width, truncate)
    end

    local first_line = lines[1]
    local is_comment, comment_style = M.detect_comment_style(first_line)

    if not is_comment then
        -- Normal code fold (functions, loops, classes)
        return default_ufo_handler(virtText, lnum, endLnum, width, truncate)
    end

    -- Extract brief or first meaningful line
    local title, is_brief = M.extract_comment_title(lines)
    if not title or title == "" then
        return default_ufo_handler(virtText, lnum, endLnum, width, truncate)
    end

    -- Calculate fold counter badge
    local suffix = (" 󰁂 %d "):format(endLnum - lnum + 1)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = math.max(20, width - sufWidth)

    local prefix, fill_char, close_suffix
    if comment_style == "block" then
        prefix = "/* "
        fill_char = "*"
        close_suffix = " */"
    else
        prefix = "// "
        fill_char = "="
        close_suffix = ""
    end

    local title_display = title .. " "
    local prefix_width = vim.fn.strdisplaywidth(prefix)
    local title_width = vim.fn.strdisplaywidth(title_display)
    local close_width = vim.fn.strdisplaywidth(close_suffix)

    -- If title is too long to fit in target width, truncate it
    local max_title_width = targetWidth - prefix_width - close_width - 5
    if title_width > max_title_width and max_title_width > 10 then
        title_display = truncate(title_display, max_title_width - 3) .. "... "
        title_width = vim.fn.strdisplaywidth(title_display)
    end

    local fill_width = math.max(3, targetWidth - (prefix_width + title_width + close_width))
    local fill_str = string.rep(fill_char, fill_width)

    local title_hl = is_brief and "SpecialComment" or "Title"

    -- Return syntax-highlighted chunks
    return {
        { prefix, "Comment" },
        { title_display, title_hl },
        { fill_str .. close_suffix, "Comment" },
        { suffix, "MoreMsg" },
    }
end

return M

