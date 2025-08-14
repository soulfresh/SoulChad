-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

-- Font customizations:
-- Download fronts via: https://github.com/ronniedroid/getnf
-- Preview fonts via: https://www.programmingfonts.org/
vim.opt.guifont = "FiraCode_Nerd_Font:h10"
-- vim.opt.guifont = "FuraMono_Nerd_Font:h10"
-- vim.opt.guifont = "Lilex_Nerd_Font:h10"
-- vim.opt.guifont = "MesloGL_Nerd_Font:h10"

---@type ChadrcConfig
local M = {}

local highlights = require "highlights"

M.base46 = {
  theme = "bearded-arc",
  theme_toggle = { "bearded-arc", "ayu_light" },
  hl_add = highlights.add,
  hl_override = highlights.override,
  -- changed_themes = {},
  -- transparency = false,
}

M.lsp = { signature = true }

M.ui = {
  -- better highlighting of variables
  lsp_semantic_tokens = true,

  tabufline = {
    lazyload = true,
    modules = {
      -- Replace the tab list logic with a version that uses Taboo to set tab
      -- names. You can use `TabooOpen {name}` or `TabooRename {new_name}` to
      -- name your tabs.
      tabs = function()
        local btn = require("nvchad.tabufline.utils").btn

        local result, number_of_tabs = "", vim.fn.tabpagenr "$"

        if number_of_tabs > 1 then
          for i = 1, number_of_tabs, 1 do
            local tab_hl = ((i == vim.fn.tabpagenr()) and "TabOn") or "TabOff"
            -- Ask Taboo for the name of the tab at index i
            local success, taboo_name = pcall(vim.fn["TabooTabName"], i)
            local tab_name = i
            -- If we received a name, update the tab_name variable
            if success and taboo_name ~= "" then
              tab_name = taboo_name
            end

            -- Continue building the tab list the way NvChad usually does
            result = result .. btn(" " .. tab_name .. " ", tab_hl, "GotoTab", i)
          end

          local new_tabtn = btn("  ", "TabNewBtn", "NewTab")
          local tabstoggleBtn = btn(" 󰅂 ", "TabTitle", "ToggleTabs")
          local small_btn = btn(" 󰅁 ", "TabTitle", "ToggleTabs")

          return vim.g.TbTabsToggled == 1 and small_btn or new_tabtn .. tabstoggleBtn .. result
        end
        return ""
      end,
    },
  },
}

M.nvdash = {
  load_on_startup = true,

  header = {
    "█▀ █▀█ █░█ █░░ █░█ █ █▀▄▀█",
    "▄█ █▄█ █▄█ █▄▄ ▀▄▀ █ █░▀░█",
    "                          ",
    "                          ",

    -- "▟▛ ██ ▙▟ ▙▄ ▚▞ █ ▛▚▞▜ ",
    --
    --
    -- "█─▄▄▄▄█─▄▄─█▄─██─▄█▄─▄███▄─█─▄█▄─▄█▄─▀█▀─▄█",
    -- "█▄▄▄▄─█─██─██─██─███─██▀██▄▀▄███─███─█▄█─██",
    -- "▀▄▄▄▄▄▀▄▄▄▄▀▀▄▄▄▄▀▀▄▄▄▄▄▀▀▀▄▀▀▀▄▄▄▀▄▄▄▀▄▄▄▀",
    --
    --
    -- "█▀▀ █▀▀█ █░░█ █░░ ▀█░█▀ ░▀░ █▀▄▀█",
    -- "▀▀█ █░░█ █░░█ █░░ ░█▄█░ ▀█▀ █░▀░█",
    -- "▀▀▀ ▀▀▀▀ ░▀▀▀ ▀▀▀ ░░▀░░ ▀▀▀ ▀░░░▀",
    --
    --
    -- "█▀▀ █▀▀█ █░░█ █░░",
    -- "▀▀█ █░░█ █░░█ █░░",
    -- "▀▀▀ ▀▀▀▀ ░▀▀▀ ▀▀▀",
    -- " █░░█ ▀█▀ █▀▄▀█░ ",
    -- " ██ █  █░░█░█░█░ ",
    -- "  ▀█▀ ███░█░▀░█  ",
  },

  -- buttons = {
  --   { "  Find File", "Spc f f", "Telescope find_files" },
  --   { "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
  --   { "󰈭  Find Word", "Spc f w", "Telescope live_grep" },
  --   { "  Bookmarks", "Spc m a", "Telescope marks" },
  --   { "  Themes", "Spc t h", "Telescope themes" },
  --   { "  Mappings", "Spc c h", "NvCheatsheet" },
  -- },
}

return M
