--- @file dashboard.lua
--- @brief Startup dashboard configuration.
--- @details Configures nvimdev/dashboard-nvim with dynamic vertical centering.
--- @author ngxxfus
--- @date 2025-12-09

return {
  {
    --- @brief The dashboard plugin repository.
    "nvimdev/dashboard-nvim",

    --- @brief Load only when entering Vim (startup).
    event = "VimEnter",

    --- @brief Dependencies for icons.
    dependencies = { "nvim-tree/nvim-web-devicons" },

    --- @brief Configuration function.
    config = function()
      --- @brief Define the logo art.
      local logo = {
        " __ _   ___  _  _  _  _     ____  _  _  ____ ",
        "(  ( \\ / __)( \\/ )( \\/ )   (  __)/ )( \\/ ___)",
        "/    /( (_ \\ )  (  )  (  _  ) _) ) \\/ (\\___ \\",
        "\\_)__) \\___/(_/\\_)(_/\\_)(_)(__)  \\____/(____/",
        "",
        "          [ ngxx.fus @ " .. os.date("%H:%M") .. " ]          ",
        "",
      }

      --- @brief Algorithm to vertically center the dashboard.
      --- @details Calculates window height and prepends empty lines to header.
      local function get_centered_header()
        local height = vim.api.nvim_win_get_height(0)
        -- Estimated content height (Logo + Buttons + Footer + Gaps) ~ 18 lines
        local content_height = 18 
        -- Calculate top padding lines needed
        local pad_lines = math.max(0, math.floor((height - content_height) / 2))
        
        local padded_logo = {}
        -- Insert empty lines for padding
        for _ = 1, pad_lines do
          table.insert(padded_logo, "")
        end
        -- Insert actual logo
        for _, line in ipairs(logo) do
          table.insert(padded_logo, line)
        end
        return padded_logo
      end

      require('dashboard').setup({
        --- @brief Use 'doom' theme for a clean list style.
        theme = 'doom',

        --- @brief Configuration for the 'doom' theme.
        config = {
          --- @brief Apply the centered header.
          header = get_centered_header(),

          --- @brief Center buttons (Quick actions).
          center = {
            {
              icon = "  ",
              desc = "Find File          ",
              key = "f",
              action = "Telescope find_files",
            },
            {
              icon = "  ",
              desc = "Recent Files       ",
              key = "r",
              action = "Telescope oldfiles",
            },
            {
              icon = "  ",
              desc = "Find Text          ",
              key = "g",
              action = "Telescope live_grep",
            },
            {
              icon = "  ",
              desc = "Configuration      ",
              key = "c",
              action = "edit $MYVIMRC",
            },
            {
              icon = "  ",
              desc = "Quit               ",
              key = "q",
              action = "qa",
            },
          },

          --- @brief Footer information (Startup stats).
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      })
    end,
  },
}
