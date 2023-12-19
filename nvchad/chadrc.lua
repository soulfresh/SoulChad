-- Font customizations: 
-- Download fronts via: https://github.com/ronniedroid/getnf
-- Preview fonts via: https://www.programmingfonts.org/
vim.opt.guifont = "FiraCode_Nerd_Font:h10"
-- vim.opt.guifont = "FuraMono_Nerd_Font:h10"
-- vim.opt.guifont = "Lilex_Nerd_Font:h10"
-- vim.opt.guifont = "MesloGL_Nerd_Font:h10"

-- Set the root directory to use if no directory is specified
vim.g.soulvim_root_dir = "~/Development/"

---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

-- Replace the tab list logic with a version that uses Taboo to set tab
-- names. You can use `TabooOpen {name}` or `TabooRename {new_name}` to
-- name your tabs.
local tablist = function()
  local result, number_of_tabs = "", vim.fn.tabpagenr "$"

  if number_of_tabs > 1 then
    for i = 1, number_of_tabs, 1 do
      local tab_hl = ((i == vim.fn.tabpagenr()) and "%#TbLineTabOn# ") or "%#TbLineTabOff# "
      -- Ask Taboo for the name of the tab at index i
      local success, taboo_name = pcall(vim.fn["TabooTabName"], i)
      local tab_name = i
      -- If we received a name, update the tab_name variable
      if success and taboo_name ~= '' then tab_name = taboo_name end

      -- Continue building the tab list the way NvChad usually does
      result = result .. ("%" .. i .. "@TbGotoTab@" .. tab_hl .. tab_name .. " ")
      result = (i == vim.fn.tabpagenr() and result .. "%#TbLineTabCloseBtn#" .. "%@TbTabClose@󰅙 %X") or result
    end

    local new_tabtn = "%#TblineTabNewBtn#" .. "%@TbNewTab@  %X"
    local tabstoggleBtn = "%@TbToggleTabs@ %#TBTabTitle# TABS %X"

    return vim.g.TbTabsToggled == 1 and tabstoggleBtn:gsub("()", { [36] = " " })
      or new_tabtn .. tabstoggleBtn .. result
  end
  return ""
end

M.ui = {
  theme = "bearded-arc",
  theme_toggle = { "bearded-arc", "ayu_light" },

  hl_override = highlights.override,
  hl_add = highlights.add,

  -- better highlighting of variables
  lsp_semantic_tokens = true,

  nvdash = {
    load_on_startup = false,
    -- Generated from https://fsymbols.com/generators/carty/
    header = {

      "█▀ █▀█ █░█ █░░ █░█ █ █▀▄▀█",
      "▄█ █▄█ █▄█ █▄▄ ▀▄▀ █ █░▀░█",


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

    }
  },

  tabufline = {
    overriden_modules = function(modules)
      -- Generate a tab list that includes custom tab names
      local tabs = tablist()
      -- If it worked, then replace the tab module with our updated tab
      -- definitions.
      if tabs ~= nil or tabs ~= "" then
        -- Current modules are [empty, buffer list, tab list]
        modules[3] = tabs
      end
    end
  },

  cmp = {
    -- sources = {
    --   { name = "copilot", group_index = 2 },
    -- },
  }
}

M.lazy_nvim = {
  -- directory where plugins will be installed
  -- root = vim.fn.stdpath("data") .. "/lazy",
  -- Save the lock file next to our NvChad configs
  lockfile = vim.fn.fnamemodify(vim.fn.resolve(vim.fn.stdpath("config") .. "/lua/custom"), ':h') .. "/nvchad/lazy-lock.json",
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
