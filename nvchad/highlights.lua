-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

local M = {}

---@type Base46HLGroupsList
M.override = {
  Comment = {
    italic = true,
  },

  -- terminal focused cursor color
  TermCursor = {
    bg = "sun",
  },
  -- terminal unfocused cursor color
  TermCursorNC = {
    bg = "pink",
  },
}

--     DiffAdd = {
--       fg = "#afbdaa",
--       bg = "#1c2c31",
--     },

---@type HLTable
M.add = {
  NvimTreeOpenedFolderName = { fg = "#ff00ff", bold = true },
  MyCustomHi = { bg = "#ff00ff" },

-- -  hi! TermCursor guifg=NONE guibg=yellow gui=NONE cterm=NONE
-- -  hi! TermCursorNC guifg=yellow guibg=#3c3836 gui=NONE cterm=NONE
  --
  -- terminal focused cursor color
  TermCursor = { bg = "#ff00ff" },
}

-- vim.api.nvim_set_hl(0, "TermCursor", {
--   bg = "#9bdead",
-- })
-- vim.api.nvim_set_hl(0, "TermCursorNc", {
--   bg = "pink",
-- })

return M
