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
  },
}

-- local bbq_bg = {"teal", "black", 30}
-- local bbq_bg = {"nord_blue", "black", 30}
local bbq_bg = {"blue", "black", 30}
-- local bbq_bg = {"orange", "black", 30}
-- local bbq_bg = {"yellow", "black", 30}

---@type HLTable
M.add = {
  -- Debug Signs
  DapBreakpoint = { fg = 'red' },
  DapBreakpointCondition = { fg = 'orange' },
  DapBreakpointRejected = { fg = "light_grey" },
  DapLogPoint = { fg = 'orange' },
  DapStopped = { fg = 'green' },

  -- NvimTreeOpenedFolderName = { fg = "#green", bold = true },

  -- Make the current HEAD stand out in the Flog (git log) viewer.
  flogRefHead = {
    bold = true,
    bg = "yellow",
    fg = "darker_black",
  },

  -- terminal unfocused cursor color
  TermCursorNC = { bg = { "pink", "black", 30 } },
  -- terminal focused color
  TermCursor = { bg = "green" },

  -- TODO How to keep this in sync with bbq config?
  -- TODO Fix the icon background colors when switching themes
  barbecue_normal                 = {
    bg = bbq_bg,
    fg = "one_bg",
  },
  -- barbecue_ellipsis               = { bg = "lightbg" },
  -- barbecue_separator              = { bg = "lightbg" },
  -- barbecue_modified               = { bg = "lightbg" },
  -- barbecue_dirname                = { bg = "lightbg" },
  barbecue_basename               = {
    fg = "darker_black",
    bg = bbq_bg,
    bold = true,
  },
  -- barbecue_context                = { bg = "lightbg" },
  -- barbecue_context_file           = { bg = "lightbg" },
  -- barbecue_context_module         = { bg = "lightbg" },
  -- barbecue_context_namespace      = { bg = "lightbg" },
  -- barbecue_context_package        = { bg = "lightbg" },
  -- barbecue_context_class          = { bg = "lightbg" },
  -- barbecue_context_method         = { bg = "lightbg" },
  -- barbecue_context_property       = { bg = "lightbg" },
  -- barbecue_context_field          = { bg = "lightbg" },
  -- barbecue_context_constructor    = { bg = "lightbg" },
  -- barbecue_context_enum           = { bg = "lightbg" },
  -- barbecue_context_interface      = { bg = "lightbg" },
  -- barbecue_context_function       = { bg = "lightbg" },
  -- barbecue_context_variable       = { bg = "lightbg" },
  -- barbecue_context_constant       = { bg = "lightbg" },
  -- barbecue_context_string         = { bg = "lightbg" },
  -- barbecue_context_number         = { bg = "lightbg" },
  -- barbecue_context_boolean        = { bg = "lightbg" },
  -- barbecue_context_array          = { bg = "lightbg" },
  -- barbecue_context_object         = { bg = "lightbg" },
  -- barbecue_context_key            = { bg = "lightbg" },
  -- barbecue_context_null           = { bg = "lightbg" },
  -- barbecue_context_enum_member    = { bg = "lightbg" },
  -- barbecue_context_struct         = { bg = "lightbg" },
  -- barbecue_context_event          = { bg = "lightbg" },
  -- barbecue_context_operator       = { bg = "lightbg" },
  -- barbecue_context_type_parameter = { bg = "lightbg" },
}

return M
