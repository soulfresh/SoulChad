-- TODO Find a better way to organize these?
return {
  ---@type Base46HLGroupsList
  override = {
    Comment = {
      italic = true,
    },

    -- New lines
    DiffAdd = {
      fg = "green",
      bg = { "green", "black", 90 },
    },

    -- Line that has a change in it
    DiffChange = {
      fg = { "green", "black", 30 },
      bg = { "green", "black", 97 },
    },

    -- The change in a line containing changes
    DiffText = {
      fg = { "green", "white", 5 },
      bg = { "green", "black", 85 },
    },

    -- Removed lines
    DiffDelete = {
      fg = "red",
      bg = { "red", "black", 90 },
    },

    -- Change autocomplete border color
    CmpBorder = { fg = { "blue", "black", 50 }, bg = "black" },
    CmpDocBorder = { fg = { "blue", "black", 50 }, bg = "black" },
    -- Default floating window background
    NormalFloat = { bg = "black" },
  },

  ---@type HLTable
  add = {
    -- Debug Signs
    DapBreakpoint = { fg = "red" },
    DapBreakpointCondition = { fg = "orange" },
    DapBreakpointRejected = { fg = "light_grey" },
    DapLogPoint = { fg = "orange" },
    DapStopped = { fg = "green" },

    -- NvimTreeOpenedFolderName = { fg = "#green", bold = true },

    -- Make the current HEAD stand out in the Flog (git log) viewer.
    flogRefHead = {
      bold = true,
      bg = "yellow",
      fg = "darker_black",
    },

    -- The color of the active window separator
    ColorfulWinSep = { fg = "blue" },

    -- terminal focused color
    Cursor = { bg = "blue" },
    TermCursor = { bg = "green" },
    -- non-focused terminal status line
    StatusLineTermNC = { bg = { "pink", "black", 30 } },
  },
}
