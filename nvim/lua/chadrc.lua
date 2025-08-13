-- This file  needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

-- Font customizations: 
-- Download fronts via: https://github.com/ronniedroid/getnf
-- Preview fonts via: https://www.programmingfonts.org/
vim.opt.guifont = "FiraCode_Nerd_Font:h10"
-- vim.opt.guifont = "FuraMono_Nerd_Font:h10"
-- vim.opt.guifont = "Lilex_Nerd_Font:h10"
-- vim.opt.guifont = "MesloGL_Nerd_Font:h10"

-- Set the root directory to use if no directory is specified
vim.g.soulvim_root_dir = "~/Development/"

local highlights = require "highlights"

---@type ChadrcConfig
local options = {
  base46 = {
    theme = "bearded-arc",
    theme_toggle = { "bearded-arc", "ayu_light" },
    hl_add = highlights.add,
    hl_override = highlights.override,
    -- changed_themes = {},
    transparency = false,
  },

  ui = {
    -- better highlighting of variables
    lsp_semantic_tokens = true,

    cmp = {
      icons = true,
      lspkind_text = true,
      style = "flat_light", -- default/flat_light/flat_dark/atom/atom_colored
    },

    telescope = { style = "borderless" }, -- borderless / bordered

    statusline = {
      theme = "default", -- default/vscode/vscode_colored/minimal
      -- default/round/block/arrow separators work only for default statusline theme
      -- round and block will work for minimal theme only
      separator_style = "default",
      -- customize the status line to include a CodeCompanion loading status
      -- order = { "mode", "f", "git", "%=", "lsp_msg", "%=", "lsp", "cwd" },
      order = nil,
      modules = nil,
    },

    -- lazyload it when there are 1+ buffers
    tabufline = {
      enabled = true,
      lazyload = true,
      order = { "treeOffset", "buffers", "tabs", "btns" },
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
              if success and taboo_name ~= '' then tab_name = taboo_name end

              -- Continue building the tab list the way NvChad usually does
              result = result .. btn(" " .. tab_name .. " ", tab_hl, "GotoTab", i)
            end

            local new_tabtn = btn("  ", "TabNewBtn", "NewTab")
            local tabstoggleBtn = btn(" 󰅂 ", "TabTitle", "ToggleTabs")
            local small_btn = btn(" 󰅁 ", "TabTitle", "ToggleTabs")

            return vim.g.TbTabsToggled == 1 and small_btn or new_tabtn .. tabstoggleBtn .. result
          end
          return ""
        end
      },
    },

    nvdash = {
      load_on_startup = true,

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
      },

      buttons = {
        { "  Find File", "Spc f f", "Telescope find_files" },
        { "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
        { "󰈭  Find Word", "Spc f w", "Telescope live_grep" },
        { "  Bookmarks", "Spc m a", "Telescope marks" },
        { "  Themes", "Spc t h", "Telescope themes" },
        { "  Mappings", "Spc c h", "NvCheatsheet" },
      },
    },
  },

  term = {
    winopts = { number = false, relativenumber = false },
    sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
    float = {
      relative = "editor",
      row = 0.3,
      col = 0.25,
      width = 0.5,
      height = 0.4,
      border = "single",
    },
  },

  lsp = { signature = true },

  cheatsheet = {
    theme = "grid", -- simple/grid
    -- excluded_groups = { "terminal (t)", "autopairs", "Nvim", "Opens" }, -- can add group name or with mode
  },

  mason = { cmd = true, pkgs = {} },
}

local status, chadrc = pcall(require, "chadrc")
return vim.tbl_deep_extend("force", options, status and chadrc or {})
