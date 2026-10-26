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
    -- [REGEX: DECORATIVE / BANNER LINE CHECK]:
    -- "%w" matches alphanumeric characters (letters and digits).
    -- If the line does NOT contain any letter or digit (e.g. only *, /, -, =, spaces...),
    -- it is considered a decorative border line and skipped.
    return not str:match("%w")
end

--- @brief Cleans trailing and leading comment tokens from a text string.
--- @param text string
--- @return string
local function clean_text(text)
    if not text then
        return ""
    end
    -- [REGEX: STRIP COMMENT TOKENS & TRAILING/LEADING BORDERS]:
    -- Lua pattern syntax:
    --   ^ : line start, $ : line end, %s : whitespace, + : 1 or more, * : 0 or more
    return text
        :gsub("^%s*/%*+/?%s*", "")     -- Remove leading: /*, /**, /*/
        :gsub("^%s*%*+/?%s*", "")       -- Remove leading: *, **, */
        :gsub("^%s*//+/?%s*", "")       -- Remove leading: //, ///
        :gsub("%s*%*+/%s*$", "")       -- Remove trailing: */, **/
        :gsub("%s*//+%s*$", "")         -- Remove trailing: //
        :gsub("%s*%*+%s*$", "")         -- Remove trailing: *, ***
        :gsub("^%s*[%-%=_~]+%s*", "")   -- Remove leading decorative borders: -, =, _, ~
        :gsub("%s*[%-%=_~]+%s*$", "")   -- Remove trailing decorative borders: -, =, _, ~
        -- [TIP]: To strip any custom border symbol from ends, add another rule:
        -- :gsub("^%s*[#]+%s*", "")      -- Example: strip leading #
        :gsub("^%s+", "")               -- Trim leading whitespace
        :gsub("%s+$", "")               -- Trim trailing whitespace
end

--- @brief Extracts a meaningful summary/title from folded comment lines.
--- @param lines table List of strings from the folded buffer range.
--- @return string|nil title Extracted title, or nil if none found.
--- @return boolean is_brief Whether the title was extracted from a brief tag.
function M.extract_comment_title(lines)
    if not lines or #lines == 0 then
        return nil, false
    end

    -- =========================================================================
    -- [REGEX: KEYWORD / TAG EXTRACTION (Pass 1)]
    -- =========================================================================
    -- Priority pass: Search for @brief, \brief, or brief: to use as title.
    -- To support additional doc tags (such as @summary, @details, @note...),
    -- simply add more patterns below:
    for _, line in ipairs(lines) do
        local brief_match = line:match("[@\\]brief%s*:?%s*(.+)")        -- Matches "@brief ..." or "\brief ..."
            or line:match("^%s*%*+%s*brief%s*:?%s*(.+)")               -- Matches "* brief: ..."
            or line:match("^%s*//+%s*brief%s*:?%s*(.+)")               -- Matches "// brief: ..."
            -- [EXAMPLES FOR ADDING MORE TAGS]:
            -- or line:match("[@\\]summary%s*:?%s*(.+)")                -- Matches "@summary ..."
            -- or line:match("[@\\]details%s*:?%s*(.+)")                -- Matches "@details ..."
            -- or line:match("[@\\]note%s*:?%s*(.+)")                   -- Matches "@note ..."

        if brief_match then
            local cleaned = clean_text(brief_match)
            if #cleaned > 0 and not is_banner_line(cleaned) then
                return cleaned, true
            end
        end
    end

    -- =========================================================================
    -- [Pass 2: First meaningful comment line]
    -- =========================================================================
    -- If no @brief tag is found, fallback to the first line with real content.
    for i = 1, #lines do
        local line = lines[i]
        local cleaned = clean_text(line)

        -- Must contain alphanumeric characters (%w) and not be purely decorative
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

    -- =========================================================================
    -- [REGEX: DETECT COMMENT BANNER STYLE]
    -- =========================================================================
    -- Block comment banner: Starts with /* (e.g., /*, /**, /****************)
    if line:match("^%s*/%*") then
        return true, "block"
    end

    -- Line comment banner: Starts with // followed by at least 3 repeating border symbols (*, =, -, #)
    -- E.g.: //**************** or //---------------- or //================
    -- To allow other border symbols, add them inside the character set [%*=%-%#...]{3,}
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
    -- =========================================================================
    -- [FOLD COUNTER BADGE COLOR FOR NORMAL CODE (functions, structs, etc.)]
    -- =========================================================================
    -- Use "Comment" (or "NonText") to blend in without "MoreMsg" background.
    table.insert(newVirtText, { suffix, "Comment" })
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

    -- =========================================================================
    -- [COLOR / HIGHLIGHT GROUP CONFIGURATION]
    -- =========================================================================
    -- Customize colors by changing the highlight group names:
    --   - "Comment"        : Matches colorscheme comment color (recommended)
    --   - "SpecialComment" : Highlighted / Doxygen doc tag color
    --   - "NonText"        : Dimmed text without background
    --   - "Title"          : Bold / accent title color
    --   - "MoreMsg"        : Notice / badge color (often has a prominent background)
    -- =========================================================================
    local hl_prefix = "Comment"
    local hl_title  = "Comment"  -- Change to: (is_brief and "SpecialComment" or "Title") to accent title text
    local hl_fill   = "Comment"
    local hl_suffix = "Comment"  -- Changed to "Comment" to blend in and remove the gray background box

    -- Return syntax-highlighted chunks
    return {
        { prefix, hl_prefix },
        { title_display, hl_title },
        { fill_str .. close_suffix, hl_fill },
        { suffix, hl_suffix },
    }
end

return M

