-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

local M = {}

---@type Base46HLGroupsList
M.override = {
  Comment = {
    italic = true,
  },

  -- New lines
  DiffAdd = {
    fg = "green",
    bg = {"green", "black", 90 },
  },

  -- Line that has a change in it
  DiffChange = {
    fg = {"green", "black", 30},
    bg = { "green", "black", 97 },
  },

  -- The change in a line containing changes
  DiffText = {
    fg = {"green", "white", 5},
    bg = {"green", "black", 85}
  },

  -- Removed lines
  DiffDelete = {
    fg = "red",
    bg = { "red", "black", 90 },
  }
}


---@type HLTable
M.add = {
  -- NvimTreeOpenedFolderName = { fg = "#green", bold = true },

  -- terminal unfocused cursor color
  TermCursorNC = { bg = "pink" },
  -- terminal focused color
  TermCursor = { bg = "green" },
}

return M
